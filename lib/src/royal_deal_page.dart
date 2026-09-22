import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'royal_deal_audio.dart';
import 'royal_score_store.dart';

class RoyalDealPage extends StatefulWidget {
  const RoyalDealPage({super.key});
  @override
  State<RoyalDealPage> createState() => _RoyalDealPageState();
}

class _RoyalDealPageState extends State<RoyalDealPage> {
  final _rnd = Random();
  final _music = AudioPlayer();
  final _sfx = AudioPlayer();
  final List<int> _rewards = [10,25,50,75,100,150,200,250,300,400,500,650,800,1000,1250,1500,2000,3000,5000,10000];
  late List<int> _caseValues;
  final Set<int> _opened = {};
  int? _myCase;
  int round = 1;
  int openedThisRound = 0;
  int? bankerOffer;
  bool ended = false;
  bool soundOn = true;

  int get _toOpen => round == 1 ? 5 : round == 2 ? 4 : round == 3 ? 3 : round == 4 ? 2 : 1;

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
      ..showSnackBar(SnackBar(
        backgroundColor: const Color(0xFF18090B),
        content: Text('جعبه ${i + 1}:  $value تیکت R1', textAlign: TextAlign.center, textDirection: TextDirection.rtl),
      ));
    if (openedThisRound >= _toOpen) _callBanker();
  }

  void _callBanker() {
    final remaining = <int>[];
    for (var i = 0; i < 20; i++) {
      if (!_opened.contains(i)) remaining.add(_caseValues[i]);
    }
    final avg = remaining.reduce((a,b)=>a+b) / remaining.length;
    final factor = 0.58 + min(round * .07, .28);
    final offer = ((avg * factor) / 10).round() * 10;
    setState(() => bankerOffer = offer);
    _fx('banker_ring', volume: 1);
  }

  void _deal() {
    final win = bankerOffer ?? 0;
    setState(() => ended = true);
    _fx('deal_win', volume: 1);
    _result('DEAL 🤝', 'پیشنهاد بانکدار را قبول کردی\n$win تیکت R1', win);
  }

  void _noDeal() {
    _fx('no_deal', volume: .95);
    setState(() {
      bankerOffer = null;
      round++;
      openedThisRound = 0;
    });
    final unopenedOthers = List.generate(20, (i) => i).where((i) => !_opened.contains(i) && i != _myCase).toList();
    if (unopenedOthers.isEmpty) {
      final win = _caseValues[_myCase!];
      setState(() => ended = true);
      _fx(win >= 3000 ? 'jackpot' : 'final_reveal', volume: 1);
      _result('FINAL CASE 👑', 'جعبه شما: $win تیکت R1', win);
    }
  }

  String? _rewardImage(int value) {
    if (value == 10000) return 'assets/image/deal_jackpot.png';
    return null;
  }

  void _result(String title, String text, int points) async {
    await RoyalScoreStore.recordScore(RoyalScoreGame.deal, points,
        tickets: 2 + min(5, points ~/ 1000));
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF100708),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFFE8C36A)),
        ),
        title: Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFFFD979), fontWeight: FontWeight.bold)),
        content: Text(text, textAlign: TextAlign.center, textDirection: TextDirection.rtl, style: const TextStyle(color: Colors.white, fontSize: 18, height: 1.6)),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () { Navigator.pop(context); Navigator.pop(context); },
            child: const Text('بازگشت به رویال', style: TextStyle(color: Color(0xFFFFD979))),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _music.dispose();
    _sfx.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE8C36A);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: gold,
        centerTitle: true,
        title: const Text('👑 ROYAL DEAL'),
        actions: [
          IconButton(
            onPressed: _toggleSound,
            tooltip: soundOn ? 'قطع صدا' : 'پخش صدا',
            icon: Icon(soundOn ? Icons.volume_up_rounded : Icons.volume_off_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.1,
                    colors: [Color(0xFF3B0710), Color(0xFF090909), Colors.black],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  _myCase == null ? 'یک جعبه را برای خودت انتخاب کن' : 'مرحله $round • ${_toOpen - openedThisRound} جعبه دیگر باز کن',
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  _myCase == null ? 'جعبه شما تا پایان بسته می‌ماند' : 'جعبه شما: ${_myCase! + 1}',
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(color: gold),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.05,
                    ),
                    itemCount: 20,
                    itemBuilder: (_, i) {
                      final isMine = i == _myCase;
                      final isOpen = _opened.contains(i);
                      return InkWell(
                        onTap: () => _pick(i),
                        borderRadius: BorderRadius.circular(14),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: isMine ? Colors.redAccent : gold, width: isMine ? 2.2 : 1.2),
                            gradient: LinearGradient(
                              colors: isOpen
                                  ? [const Color(0xFF3B0A10), const Color(0xFF170507)]
                                  : [const Color(0xFF2B2415), const Color(0xFF090909)],
                            ),
                            boxShadow: [BoxShadow(color: (isMine ? Colors.red : gold).withOpacity(.24), blurRadius: 8)],
                          ),
                          child: isOpen
                              ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    if (_rewardImage(_caseValues[i]) != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(13),
                                        child: Image.asset(
                                          _rewardImage(_caseValues[i])!,
                                          fit: BoxFit.cover,
                                          filterQuality: FilterQuality.high,
                                        ),
                                      )
                                    else
                                      Padding(
                                        padding: const EdgeInsets.all(7),
                                        child: Image.asset(
                                          'assets/image/deal_case.png',
                                          fit: BoxFit.contain,
                                          filterQuality: FilterQuality.high,
                                          color: Colors.white.withOpacity(.22),
                                          colorBlendMode: BlendMode.modulate,
                                        ),
                                      ),
                                    Positioned(
                                      left: 4,
                                      right: 4,
                                      bottom: 4,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(.80),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '${_caseValues[i]} R1',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Image.asset(
                                        'assets/image/deal_case.png',
                                        fit: BoxFit.contain,
                                        filterQuality: FilterQuality.high,
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(.68),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: gold.withOpacity(.8)),
                                        ),
                                        child: Text(
                                          '${i + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (isMine)
                                      const Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 2,
                                        child: Text(
                                          'جعبه من',
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                        ),
                      );
                    },
                  ),
                ),
                if (_myCase != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
                    child: Text(
                      'جایزه‌ها: 10 تا 10,000 تیکت R1 • خرید • رستوران • VIP • پارکینگ • رویدادها',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.white.withOpacity(.75), fontSize: 12),
                    ),
                  ),
              ],
            ),
            if (bankerOffer != null)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(.88),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: gold, width: 1.5),
                        gradient: const LinearGradient(colors: [Color(0xFF2D0710), Color(0xFF090909)]),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 260,
                            width: double.infinity,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: gold, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: gold.withOpacity(.30),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/image/deal_banker.png',
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text('بانکدار تماس گرفته است...', textAlign: TextAlign.center, textDirection: TextDirection.rtl, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 18),
                          const Text('پیشنهاد فعلی', textDirection: TextDirection.rtl, style: TextStyle(color: gold)),
                          Text('${bankerOffer!}', style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900)),
                          const Text('R1 TICKETS', style: TextStyle(color: gold, letterSpacing: 2)),
                          const SizedBox(height: 22),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _deal,
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B7A43), minimumSize: const Size.fromHeight(52)),
                                  child: const Text('DEAL\nقبول می‌کنم', textAlign: TextAlign.center),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _noDeal,
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9E0B19), minimumSize: const Size.fromHeight(52)),
                                  child: const Text('NO DEAL\nادامه می‌دهم', textAlign: TextAlign.center),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
