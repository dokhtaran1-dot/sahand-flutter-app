import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'royal_crown_audio.dart';
import 'royal_leaderboard_page.dart';
import 'royal_score_store.dart';

enum _CrownPhase { lobby, countdown, playing, result }

class RoyalCrownGamePage extends StatefulWidget {
  const RoyalCrownGamePage({super.key});

  @override
  State<RoyalCrownGamePage> createState() => _RoyalCrownGamePageState();
}

class _RoyalCrownGamePageState extends State<RoyalCrownGamePage>
    with TickerProviderStateMixin {
  static const Color gold = Color(0xFFE7C15A);
  static const Color deepRed = Color(0xFF5E0710);
  static const Color velvet = Color(0xFF8A101B);

  final math.Random _random = math.Random();
  final AudioPlayer _music = AudioPlayer();
  final AudioPlayer _sfx = AudioPlayer();

  Timer? _gameTimer;
  Timer? _moveTimer;
  Timer? _countdownTimer;
  Timer? _feedbackTimer;

  late final AnimationController _ambient;
  late final AnimationController _crownPulse;
  late final AnimationController _rushPulse;

  _CrownPhase _phase = _CrownPhase.lobby;
  int _score = 0;
  int _seconds = 60;
  int _crown = 0;
  int _combo = 0;
  int _maxCombo = 0;
  int _countdown = 3;
  int _ticketsEarned = 0;
  bool _muted = false;
  bool _showPerfect = false;
  bool _showRushBanner = false;

  bool get _playing => _phase == _CrownPhase.playing;
  bool get _rush => _playing && _seconds <= 10;

  @override
  void initState() {
    super.initState();
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
    _crownPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    )..repeat(reverse: true);
    _rushPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 430),
    );
    unawaited(_startTheme());
  }

  Future<void> _startTheme() async {
    if (_muted) return;
    try {
      await _music.stop();
      await _music.setReleaseMode(ReleaseMode.loop);
      await _music.setVolume(.20);
      await _music.play(BytesSource(RoyalCrownAudio.theme()));
    } catch (_) {}
  }

  Future<void> _fx(String name, {double volume = .65}) async {
    if (_muted) return;
    try {
      await _sfx.stop();
      await _sfx.setReleaseMode(ReleaseMode.release);
      await _sfx.setVolume(volume);
      await _sfx.play(BytesSource(RoyalCrownAudio.effect(name)));
    } catch (_) {}
  }

  Future<void> _toggleMute() async {
    setState(() => _muted = !_muted);
    if (_muted) {
      await _music.stop();
      await _sfx.stop();
    } else {
      await _startTheme();
      await _fx('ready', volume: .42);
    }
  }

  void _beginCountdown() {
    _cancelTimers();
    setState(() {
      _phase = _CrownPhase.countdown;
      _score = 0;
      _seconds = 60;
      _combo = 0;
      _maxCombo = 0;
      _countdown = 3;
      _ticketsEarned = 0;
      _showPerfect = false;
      _showRushBanner = false;
    });
    HapticFeedback.mediumImpact();
    unawaited(_fx('ready', volume: .58));

    _countdownTimer = Timer.periodic(
      const Duration(milliseconds: 880),
      (timer) {
        if (!mounted) return;
        if (_countdown <= 1) {
          timer.cancel();
          setState(() => _countdown = 0);
          unawaited(_fx('go', volume: .68));
          Future<void>.delayed(const Duration(milliseconds: 380), () {
            if (mounted) _startGame();
          });
        } else {
          setState(() => _countdown--);
          HapticFeedback.selectionClick();
          unawaited(_fx('ready', volume: .42));
        }
      },
    );
  }

  void _startGame() {
    if (!mounted) return;
    setState(() {
      _phase = _CrownPhase.playing;
      _seconds = 60;
      _crown = _random.nextInt(9);
    });
    _scheduleMovement();

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || !_playing) return;

      if (_seconds <= 1) {
        timer.cancel();
        setState(() => _seconds = 0);
        unawaited(_finish());
        return;
      }

      final before = _seconds;
      setState(() => _seconds--);

      if (before == 11) {
        _showRush();
      }

      if (_seconds == 40 || _seconds == 20 || _seconds == 10) {
        _scheduleMovement();
      }
    });
  }

  void _scheduleMovement() {
    _moveTimer?.cancel();
    if (!_playing) return;

    final ms = _seconds <= 10
        ? 420
        : _seconds <= 20
            ? 520
            : _seconds <= 40
                ? 650
                : 800;

    _moveTimer = Timer.periodic(Duration(milliseconds: ms), (_) {
      if (!mounted || !_playing) return;
      _moveCrown();
    });
  }

  void _moveCrown() {
    var next = _random.nextInt(9);
    if (next == _crown) next = (next + 1 + _random.nextInt(8)) % 9;
    setState(() => _crown = next);
  }

  void _showRush() {
    setState(() => _showRushBanner = true);
    _rushPulse.repeat(reverse: true);
    HapticFeedback.heavyImpact();
    unawaited(_fx('rush', volume: .75));
    Future<void>.delayed(const Duration(milliseconds: 1450), () {
      if (mounted) setState(() => _showRushBanner = false);
    });
  }

  void _tapPad(int index) {
    if (!_playing) return;

    if (index == _crown) {
      _feedbackTimer?.cancel();
      HapticFeedback.lightImpact();
      setState(() {
        _score += 100;
        _combo++;
        _maxCombo = math.max(_maxCombo, _combo);
        _showPerfect = true;
      });
      unawaited(_fx('hit', volume: .58));
      _moveCrown();
      _feedbackTimer = Timer(const Duration(milliseconds: 460), () {
        if (mounted) setState(() => _showPerfect = false);
      });
    } else {
      setState(() => _combo = 0);
      HapticFeedback.selectionClick();
      unawaited(_fx('miss', volume: .28));
    }
  }

  Future<void> _finish() async {
    _moveTimer?.cancel();
    _rushPulse.stop();
    final tickets = (2 + math.min(5, _score ~/ 500)).toInt();
    _ticketsEarned = tickets;

    await RoyalScoreStore.recordScore(
      RoyalScoreGame.crown,
      _score,
      tickets: tickets,
    );

    if (!mounted) return;
    setState(() {
      _phase = _CrownPhase.result;
      _showPerfect = false;
      _showRushBanner = false;
    });
    HapticFeedback.heavyImpact();
    unawaited(_fx('finish', volume: .72));
  }

  void _cancelTimers() {
    _gameTimer?.cancel();
    _moveTimer?.cancel();
    _countdownTimer?.cancel();
    _feedbackTimer?.cancel();
  }

  @override
  void dispose() {
    _cancelTimers();
    _ambient.dispose();
    _crownPulse.dispose();
    _rushPulse.dispose();
    _music.dispose();
    _sfx.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: Listenable.merge([_ambient, _crownPulse, _rushPulse]),
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              _PalaceBackground(
                progress: _ambient.value,
                rush: _rush,
                rushPulse: _rushPulse.value,
              ),
              SafeArea(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 420),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: switch (_phase) {
                    _CrownPhase.lobby => _buildLobby(),
                    _CrownPhase.countdown => _buildCountdown(),
                    _CrownPhase.playing => _buildGame(),
                    _CrownPhase.result => _buildResult(),
                  },
                ),
              ),
              if (_showPerfect)
                IgnorePointer(
                  child: Center(
                    child: Transform.translate(
                      offset: const Offset(0, -120),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.78),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: gold, width: 1.4),
                          boxShadow: [
                            BoxShadow(
                              color: gold.withOpacity(.38),
                              blurRadius: 34,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'PERFECT!',
                              style: TextStyle(
                                color: gold,
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.5,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '+100',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (_showRushBanner)
                IgnorePointer(
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 22),
                      color: const Color(0xCC7D0711),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ROYAL RUSH',
                            style: TextStyle(
                              color: gold,
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3.2,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'FINAL 10 SECONDS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _topBar({bool showBack = true}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _RoundControl(
            icon: showBack ? Icons.arrow_back_ios_new_rounded : Icons.close,
            onTap: () => Navigator.of(context).pop(),
          ),
          _RoundControl(
            icon: _muted
                ? Icons.volume_off_rounded
                : Icons.volume_up_rounded,
            onTap: _toggleMute,
          ),
        ],
      ),
    );
  }

  Widget _buildLobby() {
    return Column(
      key: const ValueKey('lobby'),
      children: [
        _topBar(),
        const Spacer(),
        const Text(
          '👑',
          style: TextStyle(fontSize: 112),
        ),
        const SizedBox(height: 2),
        ShaderMask(
          shaderCallback: (rect) => const LinearGradient(
            colors: [
              Color(0xFFFFF1B7),
              gold,
              Color(0xFFFFD468),
              Color(0xFFFFF1B7),
            ],
          ).createShader(rect),
          child: const Text(
            'THE\nROYAL CROWN',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              height: .88,
              fontSize: 42,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.8,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'FIND THE CROWN',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            letterSpacing: 4,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 28),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.55),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: gold.withOpacity(.75)),
          ),
          child: const Text(
            '۶۰ ثانیه فرصت داری تاج را پیدا کنی.\n'
            'هر تاج درست +100 امتیاز • سرعت بازی بیشتر می‌شود.',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              height: 1.8,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        _RoyalButton(
          title: 'START GAME',
          subtitle: 'شروع بازی',
          onTap: _beginCountdown,
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const RoyalLeaderboardPage(),
            ),
          ),
          icon: const Icon(Icons.leaderboard_rounded, color: gold),
          label: const Text(
            'TOP 10',
            style: TextStyle(
              color: gold,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.8,
            ),
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget _buildCountdown() {
    return Stack(
      key: const ValueKey('countdown'),
      fit: StackFit.expand,
      children: [
        Column(
          children: [
            _topBar(),
            const Spacer(),
            const Text(
              'GET READY',
              style: TextStyle(
                color: gold,
                fontSize: 34,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.8,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 190,
              height: 190,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(.58),
                border: Border.all(color: gold, width: 2.2),
                boxShadow: [
                  BoxShadow(
                    color: gold.withOpacity(.28),
                    blurRadius: 42,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Text(
                _countdown == 0 ? 'GO!' : '$_countdown',
                style: TextStyle(
                  color: _countdown == 0 ? Colors.white : gold,
                  fontSize: _countdown == 0 ? 55 : 94,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'FIND THE CROWN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 3.2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ],
    );
  }

  Widget _buildGame() {
    return Column(
      key: const ValueKey('game'),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
          child: Row(
            children: [
              _ScorePill(
                icon: Icons.timer_outlined,
                label: 'TIME',
                value: _seconds.toString().padLeft(2, '0'),
                danger: _rush,
              ),
              const Spacer(),
              _ScorePill(
                icon: Icons.workspace_premium_rounded,
                label: 'SCORE',
                value: '$_score',
                danger: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (_combo >= 2)
          Text(
            'COMBO  x$_combo',
            style: const TextStyle(
              color: gold,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.2,
              fontSize: 14,
            ),
          ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 13,
                mainAxisSpacing: 13,
              ),
              itemCount: 9,
              itemBuilder: (_, index) {
                final active = index == _crown;
                return _CrownPad(
                  active: active,
                  rush: _rush,
                  pulse: _crownPulse.value,
                  onTap: () => _tapPad(index),
                );
              },
            ),
          ),
        ),
        const Spacer(),
        Text(
          _rush ? 'ROYAL RUSH • MOVE FAST' : 'FIND THE CROWN',
          style: TextStyle(
            color: _rush ? const Color(0xFFFF7B63) : gold,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.6,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _rush
              ? '۱۰ ثانیه آخر — تاج سریع‌تر حرکت می‌کند'
              : 'روی تاج درخشان بزن',
          textDirection: TextDirection.rtl,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildResult() {
    return Column(
      key: const ValueKey('result'),
      children: [
        _topBar(),
        const Spacer(),
        const Text('👑', style: TextStyle(fontSize: 70)),
        const SizedBox(height: 4),
        const Text(
          'GAME OVER',
          style: TextStyle(
            color: gold,
            fontSize: 34,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.6,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 28),
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
          decoration: BoxDecoration(
            color: const Color(0xE811090A),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: gold, width: 1.4),
            boxShadow: [
              BoxShadow(
                color: gold.withOpacity(.22),
                blurRadius: 34,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'YOUR SCORE',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  letterSpacing: 2.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '$_score',
                style: const TextStyle(
                  color: gold,
                  fontSize: 58,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              _ResultLine(
                icon: Icons.confirmation_number_rounded,
                title: 'TICKETS EARNED',
                value: '$_ticketsEarned',
              ),
              const SizedBox(height: 10),
              _ResultLine(
                icon: Icons.local_fire_department_rounded,
                title: 'MAX COMBO',
                value: 'x$_maxCombo',
              ),
            ],
          ),
        ),
        const Spacer(),
        _RoyalButton(
          title: 'PLAY AGAIN',
          subtitle: 'دوباره بازی کن',
          onTap: _beginCountdown,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const RoyalLeaderboardPage(),
              ),
            ),
            icon: const Icon(Icons.leaderboard_rounded),
            label: const Text('TOP 10'),
            style: OutlinedButton.styleFrom(
              foregroundColor: gold,
              minimumSize: const Size.fromHeight(50),
              side: const BorderSide(color: gold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
      ],
    );
  }
}

class _RoundControl extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundControl({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(.56),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _RoyalCrownGamePageState.gold.withOpacity(.75),
            ),
          ),
          child: Icon(
            icon,
            color: _RoyalCrownGamePageState.gold,
            size: 21,
          ),
        ),
      ),
    );
  }
}

class _RoyalButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoyalButton({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const gold = _RoyalCrownGamePageState.gold;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: double.infinity,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF64060D),
                  Color(0xFFA5141F),
                  Color(0xFF64060D),
                ],
              ),
              border: Border.all(color: gold, width: 1.7),
              boxShadow: [
                BoxShadow(
                  color: gold.withOpacity(.26),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFFFE7A0),
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScorePill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool danger;

  const _ScorePill({
    required this.icon,
    required this.label,
    required this.value,
    required this.danger,
  });

  @override
  Widget build(BuildContext context) {
    const gold = _RoyalCrownGamePageState.gold;
    return Container(
      constraints: const BoxConstraints(minWidth: 112),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: danger
            ? const Color(0xE08A0C16)
            : Colors.black.withOpacity(.67),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: danger ? const Color(0xFFFF6F61) : gold,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: (danger ? const Color(0xFFFF382F) : gold).withOpacity(.18),
            blurRadius: 18,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: gold, size: 19),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 9,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CrownPad extends StatelessWidget {
  final bool active;
  final bool rush;
  final double pulse;
  final VoidCallback onTap;

  const _CrownPad({
    required this.active,
    required this.rush,
    required this.pulse,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const gold = _RoyalCrownGamePageState.gold;
    final lift = active ? 1 + pulse * .045 : 1.0;

    return Transform.scale(
      scale: lift,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                center: Alignment(-.25, -.30),
                radius: .95,
                colors: [
                  Color(0xFFF7F0DF),
                  Color(0xFFD8D0C3),
                  Color(0xFF8B8179),
                  Color(0xFF211710),
                ],
                stops: [0, .36, .67, 1],
              ),
              border: Border.all(
                color: active
                    ? (rush ? const Color(0xFFFF5A4D) : gold)
                    : gold.withOpacity(.68),
                width: active ? 3 : 1.4,
              ),
              boxShadow: [
                const BoxShadow(
                  color: Color(0x88000000),
                  blurRadius: 10,
                  offset: Offset(0, 7),
                ),
                if (active)
                  BoxShadow(
                    color: (rush ? const Color(0xFFFF3A2F) : gold)
                        .withOpacity(.40 + pulse * .32),
                    blurRadius: 28 + pulse * 20,
                    spreadRadius: 4 + pulse * 3,
                  ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: const _MarblePainter(),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 90),
                  opacity: active ? 1 : 0,
                  child: Text(
                    '👑',
                    style: TextStyle(
                      fontSize: active ? 42 : 0,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(.35),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultLine extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ResultLine({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    const gold = _RoyalCrownGamePageState.gold;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF20130F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: gold.withOpacity(.45)),
      ),
      child: Row(
        children: [
          Icon(icon, color: gold, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: gold,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _PalaceBackground extends StatelessWidget {
  final double progress;
  final bool rush;
  final double rushPulse;

  const _PalaceBackground({
    required this.progress,
    required this.rush,
    required this.rushPulse,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PalacePainter(
        progress: progress,
        rush: rush,
        rushPulse: rushPulse,
      ),
    );
  }
}

class _PalacePainter extends CustomPainter {
  final double progress;
  final bool rush;
  final double rushPulse;

  const _PalacePainter({
    required this.progress,
    required this.rush,
    required this.rushPulse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const gold = _RoyalCrownGamePageState.gold;
    final rect = Offset.zero & size;

    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF080606),
          Color(0xFF1D0A0C),
          Color(0xFF050505),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, bg);

    // Cathedral light cone.
    final cone = Path()
      ..moveTo(size.width * .38, 0)
      ..lineTo(size.width * .62, 0)
      ..lineTo(size.width * .88, size.height)
      ..lineTo(size.width * .12, size.height)
      ..close();
    final conePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          gold.withOpacity(.20),
          gold.withOpacity(.045),
          Colors.transparent,
        ],
      ).createShader(rect);
    canvas.drawPath(cone, conePaint);

    // Velvet curtains.
    final curtainPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF180306),
          Color(0xFF7A0C18),
          Color(0xFF280408),
        ],
      ).createShader(rect);

    final left = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * .23, 0)
      ..quadraticBezierTo(
        size.width * .18,
        size.height * .25,
        size.width * .10,
        size.height * .52,
      )
      ..quadraticBezierTo(
        size.width * .05,
        size.height * .72,
        0,
        size.height,
      )
      ..close();
    canvas.drawPath(left, curtainPaint);

    final right = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width * .77, 0)
      ..quadraticBezierTo(
        size.width * .82,
        size.height * .25,
        size.width * .90,
        size.height * .52,
      )
      ..quadraticBezierTo(
        size.width * .95,
        size.height * .72,
        size.width,
        size.height,
      )
      ..close();
    canvas.drawPath(right, curtainPaint);

    // Central royal staircase.
    final stairPaint = Paint()
      ..color = const Color(0xFF39070C).withOpacity(.65)
      ..style = PaintingStyle.fill;
    final edgePaint = Paint()
      ..color = gold.withOpacity(.24)
      ..strokeWidth = 1;

    for (var i = 0; i < 9; i++) {
      final y = size.height * (.36 + i * .047);
      final half = size.width * (.16 + i * .025);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(size.width / 2, y),
          width: half * 2,
          height: size.height * .036,
        ),
        stairPaint,
      );
      canvas.drawLine(
        Offset(size.width / 2 - half, y),
        Offset(size.width / 2 + half, y),
        edgePaint,
      );
    }

    // Chandelier-like sparkles.
    final sparklePaint = Paint()..color = gold.withOpacity(.52);
    for (var i = 0; i < 24; i++) {
      final x = ((i * 37) % 100) / 100 * size.width;
      final baseY = ((i * 53) % 55) / 100 * size.height;
      final y = (baseY + math.sin(progress * math.pi * 2 + i) * 7)
          .clamp(0.0, size.height);
      final r = 1.0 + (i % 4) * .65;
      canvas.drawCircle(Offset(x, y), r, sparklePaint);
    }

    if (rush) {
      final red = Paint()
        ..color = const Color(0xFFFF1F2A).withOpacity(.08 + rushPulse * .10);
      canvas.drawRect(rect, red);
    }

    // Bottom glossy floor.
    final floor = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.black.withOpacity(.05),
          Colors.black.withOpacity(.70),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, floor);
  }

  @override
  bool shouldRepaint(covariant _PalacePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.rush != rush ||
      oldDelegate.rushPulse != rushPulse;
}

class _MarblePainter extends CustomPainter {
  const _MarblePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x445B514C)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final p1 = Path()
      ..moveTo(size.width * .18, size.height * .18)
      ..quadraticBezierTo(
        size.width * .55,
        size.height * .33,
        size.width * .78,
        size.height * .18,
      )
      ..quadraticBezierTo(
        size.width * .65,
        size.height * .55,
        size.width * .82,
        size.height * .72,
      );
    canvas.drawPath(p1, paint);

    final p2 = Path()
      ..moveTo(size.width * .12, size.height * .68)
      ..quadraticBezierTo(
        size.width * .35,
        size.height * .50,
        size.width * .55,
        size.height * .73,
      )
      ..quadraticBezierTo(
        size.width * .70,
        size.height * .89,
        size.width * .90,
        size.height * .82,
      );
    canvas.drawPath(p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
