import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'royal_deal_audio.dart';
import 'royal_score_store.dart';

class RoyalDealPage extends StatefulWidget {
  const RoyalDealPage({super.key});

  @override
  State<RoyalDealPage> createState() => _RoyalDealPageState();
}

class _RoyalDealPageState extends State<RoyalDealPage> {
  static const _gold = Color(0xFFE8C36A);
  static const _goldBright = Color(0xFFFFE49A);
  static const _burgundy = Color(0xFF7C0D18);
  static const _deepBurgundy = Color(0xFF2D0710);

  final _rnd = Random();
  final _music = AudioPlayer();
  final _sfx = AudioPlayer();

  final List<int> _rewards = [
    10, 25, 50, 75, 100,
    150, 200, 250, 300, 400,
    500, 650, 800, 1000, 1250,
    1500, 2000, 3000, 5000, 10000,
  ];

  late List<int> _caseValues;
  final Set<int> _opened = {};

  int? _myCase;
  int round = 1;
  int openedThisRound = 0;
  int? bankerOffer;
  bool ended = false;
  bool soundOn = true;

  Timer? _bankerTimer;
  int _offerSeconds = 20;

  int get _toOpen =>
      round == 1 ? 5 : round == 2 ? 4 : round == 3 ? 3 : round == 4 ? 2 : 1;

  int get _remainingToOpen => max(0, _toOpen - openedThisRound);

  @override
  void initState() {
    super.initState();
    _caseValues = [..._rewards]..shuffle(_rnd);
    _startMusic();
  }

  Future<void> _startMusic() async {
    if (!soundOn) return;
    try {
      await _music.stop();
      await _music.setReleaseMode(ReleaseMode.loop);
      await _music.setVolume(.28);
      await _music.play(BytesSource(RoyalDealAudio.theme()));
    } catch (_) {}
  }

  Future<void> _fx(String name, {double volume = .8}) async {
    if (!soundOn) return;
    try {
      await _sfx.stop();
      await _sfx.setReleaseMode(ReleaseMode.release);
      await _sfx.setVolume(volume);
      await _sfx.play(BytesSource(RoyalDealAudio.effect(name)));
    } catch (_) {}
  }

  Future<void> _toggleSound() async {
    setState(() => soundOn = !soundOn);
    if (soundOn) {
      await _startMusic();
      await _fx('ui_on', volume: .55);
    } else {
      await _music.stop();
      await _sfx.stop();
    }
  }

  void _pick(int i) {
    if (ended || _opened.contains(i)) return;

    if (_myCase == null) {
      setState(() => _myCase = i);
      _fx('case_select');
      return;
    }

    if (i == _myCase || bankerOffer != null) return;

    final value = _caseValues[i];
    setState(() {
      _opened.add(i);
      openedThisRound++;
    });

    _fx(value >= 3000 ? 'case_big' : 'case_open');

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF160708),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: _gold),
          ),
          content: Text(
            'جعبه ${i + 1}  •  $value تیکت R1',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      );

    if (openedThisRound >= _toOpen) {
      Future<void>.delayed(const Duration(milliseconds: 450), _callBanker);
    }
  }

  void _callBanker() {
    if (!mounted || ended) return;

    final remaining = <int>[];
    for (var i = 0; i < 20; i++) {
      if (!_opened.contains(i)) remaining.add(_caseValues[i]);
    }

    final avg = remaining.reduce((a, b) => a + b) / remaining.length;
    final factor = 0.58 + min(round * .07, .28);
    final offer = ((avg * factor) / 10).round() * 10;

    _bankerTimer?.cancel();
    setState(() {
      bankerOffer = offer;
      _offerSeconds = 20;
    });

    _fx('banker_ring', volume: 1);

    _bankerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || bankerOffer == null || ended) {
        timer.cancel();
        return;
      }
      if (_offerSeconds <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _offerSeconds--);
    });
  }

  void _deal() {
    _bankerTimer?.cancel();
    final win = bankerOffer ?? 0;
    setState(() => ended = true);
    _fx('deal_win', volume: 1);
    _result(
      'DEAL',
      'پیشنهاد بانکدار را قبول کردی\n$win تیکت R1',
      win,
    );
  }

  void _noDeal() {
    _bankerTimer?.cancel();
    _fx('no_deal', volume: .95);

    setState(() {
      bankerOffer = null;
      round++;
      openedThisRound = 0;
    });

    final unopenedOthers = List.generate(20, (i) => i)
        .where((i) => !_opened.contains(i) && i != _myCase)
        .toList();

    if (unopenedOthers.isEmpty) {
      final win = _caseValues[_myCase!];
      setState(() => ended = true);
      _fx(win >= 3000 ? 'jackpot' : 'final_reveal', volume: 1);
      _result('FINAL CASE', 'جعبه شما: $win تیکت R1', win);
    }
  }

  String? _rewardImage(int value) {
    if (value == 10000) return 'assets/image/deal_jackpot.png';
    return null;
  }

  Future<void> _result(String title, String text, int points) async {
    await RoyalScoreStore.recordScore(
      RoyalScoreGame.deal,
      points,
      tickets: 2 + min(5, points ~/ 1000),
    );

    if (!mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.92),
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF0D0606),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: _gold, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.workspace_premium_rounded,
                color: _gold,
                size: 48,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _goldBright,
                  fontSize: 29,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                text,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  height: 1.7,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _gold,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'بازگشت به رویال کلاب',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bankerTimer?.cancel();
    _music.dispose();
    _sfx.dispose();
    super.dispose();
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _gold),
          ),
          Expanded(
            child: Column(
              children: [
                const Icon(
                  Icons.workspace_premium_rounded,
                  color: _gold,
                  size: 26,
                ),
                const SizedBox(height: 1),
                const Text(
                  'DEAL OR NO DEAL',
                  style: TextStyle(
                    color: _goldBright,
                    fontWeight: FontWeight.w900,
                    fontSize: 19,
                    letterSpacing: 1.7,
                  ),
                ),
                Text(
                  'ROYAL CLUB',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.72),
                    fontSize: 9,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _toggleSound,
            tooltip: soundOn ? 'قطع صدا' : 'پخش صدا',
            icon: Icon(
              soundOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              color: _gold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _gameHeading() {
    if (_myCase == null) {
      return const Column(
        children: [
          Text(
            'چمدان خود را انتخاب کنید',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 3),
          Text(
            'CHOOSE YOUR CASE',
            style: TextStyle(
              color: _gold,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.2,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'این چمدان تا پایان بازی با شما می‌ماند',
            textDirection: TextDirection.rtl,
            style: TextStyle(color: Colors.white60, fontSize: 11.5),
          ),
        ],
      );
    }

    return Column(
      children: [
        Text(
          'ROUND $round',
          style: const TextStyle(
            color: _gold,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '$_remainingToOpen چمدان دیگر باز کنید',
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
          decoration: BoxDecoration(
            color: _burgundy.withOpacity(.48),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _gold.withOpacity(.75)),
          ),
          child: Text(
            'چمدان شما  •  ${_myCase! + 1}',
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: _goldBright,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _caseTile(int i) {
    final isMine = i == _myCase;
    final isOpen = _opened.contains(i);

    return InkWell(
      onTap: () => _pick(i),
      borderRadius: BorderRadius.circular(13),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 210),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: isMine
                ? const Color(0xFFFF334D)
                : isOpen
                    ? _gold.withOpacity(.45)
                    : _gold,
            width: isMine ? 2.2 : 1.05,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isOpen
                ? const [Color(0xFF2F080E), Color(0xFF0B0505)]
                : const [Color(0xFF241B0E), Color(0xFF070707)],
          ),
          boxShadow: [
            BoxShadow(
              color: (isMine ? const Color(0xFFB40F25) : _gold)
                  .withOpacity(isMine ? .34 : .13),
              blurRadius: isMine ? 13 : 7,
            ),
          ],
        ),
        child: isOpen ? _openedCase(i) : _closedCase(i, isMine),
      ),
    );
  }

  Widget _closedCase(int i, bool isMine) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 5, 4, 3),
          child: Image.asset(
            'assets/image/deal_case.png',
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.78),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: _gold.withOpacity(.86)),
            ),
            child: Text(
              '${i + 1}',
              style: const TextStyle(
                color: _goldBright,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        if (isMine)
          const Positioned(
            left: 2,
            right: 2,
            bottom: 2,
            child: Text(
              'MY CASE',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFFF6C78),
                fontSize: 7.8,
                fontWeight: FontWeight.w900,
                letterSpacing: .5,
              ),
            ),
          ),
      ],
    );
  }

  Widget _openedCase(int i) {
    final rewardImage = _rewardImage(_caseValues[i]);

    return Stack(
      fit: StackFit.expand,
      children: [
        if (rewardImage != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              rewardImage,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          )
        else
          Opacity(
            opacity: .18,
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: Image.asset(
                'assets/image/deal_case.png',
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '${_caseValues[i]}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          left: 1,
          right: 1,
          bottom: 3,
          child: Text(
            'R1',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _gold,
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _bankerOverlay() {
    final seconds = _offerSeconds.toString().padLeft(2, '0');

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(.92),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 520),
            padding: const EdgeInsets.fromLTRB(17, 17, 17, 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: _gold, width: 1.5),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF310810), Color(0xFF0B0505), Colors.black],
              ),
              boxShadow: const [
                BoxShadow(color: Color(0x557C4E13), blurRadius: 34),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'THE BANKER IS CALLING...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _goldBright,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'تماس بانکدار',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 205,
                  width: double.infinity,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(color: _gold, width: 1.4),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/image/deal_banker.png',
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                        border: Border.all(color: _gold, width: 1.5),
                        boxShadow: const [
                          BoxShadow(color: Color(0x557C4E13), blurRadius: 14),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '00:$seconds',
                        style: const TextStyle(
                          color: _goldBright,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'BANKER OFFER',
                          style: TextStyle(
                            color: _gold,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.6,
                          ),
                        ),
                        Text(
                          '${bankerOffer!}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            height: 1,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Text(
                          'R1 TICKETS',
                          style: TextStyle(
                            color: _gold,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _deal,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _gold,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            'DEAL\nقبول',
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _noDeal,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _burgundy,
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: _gold, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            'NO DEAL\nادامه',
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -.35),
                    radius: 1.15,
                    colors: [
                      Color(0xFF4A0813),
                      Color(0xFF160708),
                      Color(0xFF050505),
                      Colors.black,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: -70,
              right: -70,
              top: -130,
              height: 340,
              child: IgnorePointer(
                child: Opacity(
                  opacity: .10,
                  child: Image.asset(
                    'assets/image/deal_case.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                _topBar(),
                const SizedBox(height: 6),
                _gameHeading(),
                const SizedBox(height: 13),
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(11, 2, 11, 6),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 7,
                      mainAxisSpacing: 8,
                      childAspectRatio: .86,
                    ),
                    itemCount: 20,
                    itemBuilder: (_, i) => _caseTile(i),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 5, 16, 12),
                  child: Column(
                    children: [
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              _gold,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '20 CASES  •  ONE CHOICE  •  A ROYAL MOMENT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _gold,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (bankerOffer != null) _bankerOverlay(),
          ],
        ),
      ),
    );
  }
}
