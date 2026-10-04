import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'royal_deal_audio.dart';
import 'royal_deal_page.dart';

class RoyalDealIntroPage extends StatefulWidget {
  const RoyalDealIntroPage({super.key});

  @override
  State<RoyalDealIntroPage> createState() => _RoyalDealIntroPageState();
}

class _RoyalDealIntroPageState extends State<RoyalDealIntroPage>
    with TickerProviderStateMixin {
  static const double _artWidth = 941;
  static const double _artHeight = 1672;
  static const String _art = 'assets/image/royal_deal_anime_intro.png';
  static const Color _gold = Color(0xFFE8C36A);

  late final AnimationController _intro;
  late final AnimationController _pulse;
  late final AnimationController _exit;

  final AudioPlayer _music = AudioPlayer();
  final AudioPlayer _sfx = AudioPlayer();

  bool _muted = false;
  bool _ready = false;
  bool _leaving = false;

  @override
  void initState() {
    super.initState();

    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4600),
    );
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );
    _exit = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _runIntro());
  }

  Future<void> _runIntro() async {
    if (!mounted) return;

    unawaited(_startMusic());
    unawaited(_intro.forward());

    Future<void>.delayed(const Duration(milliseconds: 520), () {
      if (mounted && !_muted) unawaited(_playFx('case_big', volume: .48));
    });
    Future<void>.delayed(const Duration(milliseconds: 1750), () {
      if (mounted && !_muted) {
        unawaited(_playFx('final_reveal', volume: .58));
      }
    });
    Future<void>.delayed(const Duration(milliseconds: 2920), () {
      if (!mounted || _leaving) return;
      setState(() => _ready = true);
      _pulse.repeat(reverse: true);
      HapticFeedback.lightImpact();
      if (!_muted) unawaited(_playFx('ui_on', volume: .42));
    });
  }

  Future<void> _startMusic() async {
    if (_muted) return;
    try {
      await _music.stop();
      await _music.setReleaseMode(ReleaseMode.loop);
      await _music.setVolume(.22);
      await _music.play(BytesSource(RoyalDealAudio.theme()));
    } catch (_) {}
  }

  Future<void> _playFx(String name, {double volume = .65}) async {
    if (_muted) return;
    try {
      await _sfx.stop();
      await _sfx.setReleaseMode(ReleaseMode.release);
      await _sfx.setVolume(volume);
      await _sfx.play(BytesSource(RoyalDealAudio.effect(name)));
    } catch (_) {}
  }

  Future<void> _toggleMute() async {
    if (_leaving) return;
    final next = !_muted;
    setState(() => _muted = next);

    if (next) {
      await _music.stop();
      await _sfx.stop();
    } else {
      await _startMusic();
      await _playFx('ui_on', volume: .4);
    }
  }

  Future<void> _skip() async {
    if (_leaving) return;
    if (!_ready) {
      setState(() => _ready = true);
      _pulse.repeat(reverse: true);
    }
    if (_intro.value < .88) {
      await _intro.animateTo(
        .88,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _startGame() async {
    if (_leaving) return;

    if (!_ready) {
      await _skip();
      return;
    }

    setState(() => _leaving = true);
    HapticFeedback.mediumImpact();

    if (!_muted) {
      unawaited(_playFx('case_select', volume: .65));
    }

    _pulse.stop();
    await _exit.forward();
    await _music.stop();

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 580),
        pageBuilder: (_, animation, __) => const RoyalDealPage(),
        transitionsBuilder: (_, animation, __, child) {
          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          final scale = Tween<double>(begin: 1.025, end: 1.0).animate(fade);
          return FadeTransition(
            opacity: fade,
            child: ScaleTransition(scale: scale, child: child),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _intro.dispose();
    _pulse.dispose();
    _exit.dispose();
    _music.dispose();
    _sfx.dispose();
    super.dispose();
  }

  double _ease(double start, double end, {Curve curve = Curves.easeOutCubic}) {
    final raw = ((_intro.value - start) / (end - start))
        .clamp(0.0, 1.0)
        .toDouble();
    return curve.transform(raw);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: Listenable.merge([_intro, _pulse, _exit]),
        builder: (context, _) {
          final fadeIn = _ease(0, .15);
          final zoom = 1.075 - (.075 * _ease(0, .86));
          final reveal = _ease(.23, .67, curve: Curves.easeInOutCubic);
          final sweep = _ease(.28, .75, curve: Curves.easeInOut);
          final glow = .22 + (_pulse.value * .32);

          return Stack(
            fit: StackFit.expand,
            children: [
              ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(.44),
                    BlendMode.darken,
                  ),
                  child: Image.asset(_art, fit: BoxFit.cover),
                ),
              ),
              Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: _artWidth,
                    height: _artHeight,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Opacity(
                          opacity: fadeIn,
                          child: Transform.scale(
                            scale: zoom,
                            alignment: const Alignment(0, -.05),
                            child: Image.asset(
                              _art,
                              width: _artWidth,
                              height: _artHeight,
                              fit: BoxFit.fill,
                              filterQuality: FilterQuality.high,
                              isAntiAlias: true,
                              gaplessPlayback: true,
                            ),
                          ),
                        ),

                        // Slow cinematic vignette.
                        IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: const Alignment(0, -.12),
                                radius: 1.05,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(.04),
                                  Colors.black.withOpacity(.30),
                                ],
                                stops: const [.35, .72, 1],
                              ),
                            ),
                          ),
                        ),

                        // Soft gold particle drift.
                        IgnorePointer(
                          child: Opacity(
                            opacity: reveal,
                            child: CustomPaint(
                              painter: _RoyalParticlePainter(
                                progress: _intro.value,
                              ),
                            ),
                          ),
                        ),

                        // Moving light sweep over title/cases.
                        if (sweep > 0 && sweep < 1)
                          Positioned(
                            left: -220 + (1320 * sweep),
                            top: 105,
                            width: 180,
                            height: 1120,
                            child: IgnorePointer(
                              child: Transform.rotate(
                                angle: -.17,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        _gold.withOpacity(.02),
                                        Colors.white.withOpacity(.13),
                                        _gold.withOpacity(.04),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Hero-case golden reveal halo.
                        Positioned(
                          left: 150,
                          right: 150,
                          top: 850,
                          height: 430,
                          child: IgnorePointer(
                            child: Opacity(
                              opacity: reveal * .78,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [
                                      const Color(0xFFFFE08A)
                                          .withOpacity(.19),
                                      const Color(0xFFFFAA28)
                                          .withOpacity(.07),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Pulsing frame over the START GAME artwork button.
                        Positioned(
                          left: 190,
                          top: 1410,
                          width: 562,
                          height: 145,
                          child: IgnorePointer(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 220),
                              opacity: _ready ? 1 : 0,
                              child: Transform.scale(
                                scale: 1 + (_pulse.value * .018),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(64),
                                    border: Border.all(
                                      color: _gold.withOpacity(
                                        .55 + (_pulse.value * .35),
                                      ),
                                      width: 2.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFFC84B)
                                            .withOpacity(glow),
                                        blurRadius: 34 + (_pulse.value * 20),
                                        spreadRadius: 2 + (_pulse.value * 4),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Exact hit area for the rendered START GAME button.
                        Positioned(
                          left: 165,
                          top: 1385,
                          width: 610,
                          height: 195,
                          child: Semantics(
                            button: true,
                            label: 'Start Royal Deal game',
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _startGame,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Top controls stay readable across phone aspect ratios.
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _GlassButton(
                        icon: Icons.fast_forward_rounded,
                        label: 'SKIP',
                        onTap: _skip,
                      ),
                      _GlassButton(
                        icon: _muted
                            ? Icons.volume_off_rounded
                            : Icons.volume_up_rounded,
                        label: _muted ? 'MUTE' : 'SOUND',
                        onTap: _toggleMute,
                      ),
                    ],
                  ),
                ),
              ),

              // Final cinematic fade into gameplay.
              IgnorePointer(
                child: Container(
                  color: Colors.black.withOpacity(_exit.value),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _GlassButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(.48),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0x99E8C36A)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xFFE8C36A), size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFE8C36A),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoyalParticlePainter extends CustomPainter {
  final double progress;
  const _RoyalParticlePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < 34; i++) {
      final sx = ((i * 73) % 100) / 100;
      final sy = ((i * 47 + 13) % 100) / 100;
      final speed = .28 + ((i % 7) * .045);
      final wave = math.sin((progress * 5.4) + i) * .018;
      final x = (sx + wave) * size.width;
      final y = ((sy - progress * speed) % 1.0) * size.height;
      final pulse =
          .35 + .65 * (math.sin((progress * 9) + i * .7).abs());
      final radius = 1.1 + (i % 4) * .65;

      paint.color = const Color(0xFFFFD66B).withOpacity(.10 + .30 * pulse);
      canvas.drawCircle(Offset(x, y), radius, paint);

      if (i % 6 == 0) {
        paint.color = Colors.white.withOpacity(.08 + .16 * pulse);
        canvas.drawCircle(Offset(x, y), radius * 2.4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RoyalParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
