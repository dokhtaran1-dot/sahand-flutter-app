import 'dart:math';
import 'package:flutter/material.dart';

class RoyalDealPage extends StatefulWidget {
  const RoyalDealPage({super.key});
  @override
  State<RoyalDealPage> createState() => _RoyalDealPageState();
}

class _RoyalDealPageState extends State<RoyalDealPage> {
  final _rnd = Random();
  final List<int> _rewards = [10,25,50,100,150,250,400,600,1000,1500,2000,3000,5000,10000,-1,-2,-3,-4,-5,-6];
  late List<int> _caseValues;
  final Set<int> _opened = {};
  int? _myCase;
  int round = 1;
  int openedThisRound = 0;
  int? bankerOffer;
  String? bankerOfferLabel;
  String? bankerOfferSubtitle;
  bool ended = false;

  int get _toOpen => round == 1 ? 5 : round == 2 ? 4 : round == 3 ? 3 : round == 4 ? 2 : 1;

  @override
  void initState() {
    super.initState();
    _caseValues = [..._rewards]..shuffle(_rnd);
  }

  void _pick(int i) {
    if (ended || _opened.contains(i)) return;
    if (_myCase == null) {
      setState(() => _myCase = i);
      return;
    }
    if (i == _myCase || bankerOffer != null) return;
    final value = _caseValues[i];
    setState(() {
      _opened.add(i);
      openedThisRound++;
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        backgroundColor: const Color(0xFF18090B),
        content: Text('جعبه ${i + 1}:  ${_labelFor(value)}', textAlign: TextAlign.center, textDirection: TextDirection.rtl),
      ));
    if (openedThisRound >= _toOpen) _callBanker();
  }

  void _callBanker() {
    final remaining = <int>[];
    for (var i = 0; i < 20; i++) {
      if (!_opened.contains(i)) remaining.add(_caseValues[i]);
    }

    final total = remaining.fold<int>(
      0,
      (sum, value) => sum + _bankerValue(value),
    );
    final avg = total / remaining.length;

    const factors = [0.50, 0.60, 0.70, 0.80, 0.88, 0.92, 0.95];
    final factor = factors[min(round - 1, factors.length - 1)];
    final jitter = 0.96 + (_rnd.nextDouble() * 0.08);
    var offer = ((avg * factor * jitter) / 10).round() * 10;
    offer = max(10, offer);

    var label = _formatNumber(offer) + ' R1';
    var subtitle = 'پیشنهاد نقدی بانکدار';
    final specialRoll = _rnd.nextDouble();

    if (round >= 5 && specialRoll < 0.12) {
      offer *= 2;
      label = _formatNumber(offer) + ' R1';
      subtitle = 'DOUBLE DEAL • پیشنهاد نهایی دوبرابر';
    } else if (round >= 4 && specialRoll < 0.20) {
      offer = 7000;
      label = 'VIP Night + 1,000 R1';
      subtitle = '👑 KING’S DEAL';
    } else if (round >= 3 && specialRoll < 0.32) {
      if (offer >= 3000) {
        offer = 6000;
        label = '3,000 R1 + Live Music VIP';
      } else if (offer >= 2000) {
        offer = 4500;
        label = '2,000 R1 + Dinner for Two';
      } else if (offer >= 1500) {
        offer = 2400;
        label = '1,500 R1 + VIP Parking';
      } else {
        offer = 1800;
        label = '1,000 R1 + Dessert for Two';
      }
      subtitle = 'Special Banker Offer';
    }

    setState(() {
      bankerOffer = offer;
      bankerOfferLabel = label;
      bankerOfferSubtitle = subtitle;
    });
  }

  void _deal() {
    final win = bankerOfferLabel ?? '0 R1';
    setState(() => ended = true);
    _result('DEAL 🤝', 'پیشنهاد بانکدار را قبول کردی\\n\\n' + win);
  }

  void _noDeal() {
    setState(() {
      bankerOffer = null;
      bankerOfferLabel = null;
      bankerOfferSubtitle = null;
      round++;
      openedThisRound = 0;
    });

    final unopenedOthers = List.generate(20, (i) => i)
        .where((i) => !_opened.contains(i) && i != _myCase)
        .toList();

    if (unopenedOthers.isEmpty) {
      final win = _caseValues[_myCase!];
      setState(() => ended = true);
      _result('FINAL CASE 👑', 'جعبه شما:\\n\\n' + _labelFor(win));
    }
  }

  String _labelFor(int value) {
    switch (value) {
      case -1:
        return 'Dessert for Two';
      case -2:
        return 'Dinner for Two • Royal Village';
      case -3:
        return 'VIP Parking Pass';
      case -4:
        return 'Birthday Cake Special';
      case -5:
        return 'Live Music VIP Experience';
      case -6:
        return 'Royal Village VIP Night 👑';
      case 10000:
        return '10,000 R1 • JACKPOT';
      default:
        return _formatNumber(value) + ' R1';
    }
  }

  String? _imageFor(int value) {
    switch (value) {
      case 10000:
        return 'assets/image/deal_jackpot.png';
      case -1:
        return 'assets/image/deal_dessert.png';
      case -2:
        return 'assets/image/deal_dinner.png';
      case -3:
        return 'assets/image/deal_parking.png';
      case -5:
        return 'assets/image/deal_live_music.png';
      case -6:
        return 'assets/image/deal_vip_night.png';
      default:
        return null;
    }
  }

  int _bankerValue(int value) {
    switch (value) {
      case -1:
        return 800;
      case -2:
        return 2500;
      case -3:
        return 900;
      case -4:
        return 1200;
      case -5:
        return 3000;
      case -6:
        return 6000;
      default:
        return value;
    }
  }

  String _formatNumber(int value) {
    final s = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }

  void _showRules() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF100708),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        side: BorderSide(color: Color(0xFFE8C36A)),
      ),
      builder: (_) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 30),
          child: const Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'قوانین ROYAL DEAL',
                    style: TextStyle(
                      color: Color(0xFFFFD979),
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '۱) از بین ۲۰ جعبه، یک جعبه را برای خودت انتخاب کن؛ این جعبه تا پایان بسته می‌ماند.\\n\\n'
                  '۲) دور اول ۵ جعبه، دور دوم ۴، دور سوم ۳، دور چهارم ۲ و بعد از آن هر بار ۱ جعبه باز می‌شود.\\n\\n'
                  '۳) بعد از هر دور Banker تماس می‌گیرد. DEAL یعنی دریافت قطعی پیشنهاد و پایان بازی؛ NO DEAL یعنی ادامه بازی.\\n\\n'
                  '۴) اگر تا پایان NO DEAL را انتخاب کنی، جایزه داخل جعبه خودت را می‌بری.\\n\\n'
                  '۵) Banker ممکن است آفر R1 یا آفر ترکیبی Dinner، VIP Parking، Live Music، DOUBLE DEAL یا KING’S DEAL بدهد.\\n\\n'
                  '۶) Jackpot بازی 10,000 R1 است و Royal Village VIP Night نیز از جوایز ویژه بازی است.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _result(String title, String text) {
    showDialog(context: context, barrierDismissible: false, builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFF100708),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: Color(0xFFE8C36A))),
      title: Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFFFD979), fontWeight: FontWeight.bold)),
      content: Text(text, textAlign: TextAlign.center, textDirection: TextDirection.rtl, style: const TextStyle(color: Colors.white, fontSize: 18, height: 1.6)),
      actionsAlignment: MainAxisAlignment.center,
      actions: [TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('بازگشت به رویال', style: TextStyle(color: Color(0xFFFFD979))))],
    ));
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE8C36A);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, foregroundColor: gold, centerTitle: true, title: const Text('👑 ROYAL DEAL'), actions: [IconButton(onPressed: _showRules, icon: const Icon(Icons.info_outline), tooltip: 'قوانین بازی')]),
      body: SafeArea(child: Stack(children: [
        Positioned.fill(child: Container(decoration: const BoxDecoration(gradient: RadialGradient(center: Alignment.topCenter, radius: 1.1, colors: [Color(0xFF3B0710), Color(0xFF090909), Colors.black])))),
        Column(children: [
          const SizedBox(height: 8),
          Text(_myCase == null ? 'یک جعبه را برای خودت انتخاب کن' : 'مرحله $round • ${_toOpen - openedThisRound} جعبه دیگر باز کن', textDirection: TextDirection.rtl, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(_myCase == null ? 'جعبه شما تا پایان بسته می‌ماند' : 'جعبه شما: ${_myCase! + 1}', textDirection: TextDirection.rtl, style: const TextStyle(color: gold)),
          const SizedBox(height: 14),
          Expanded(child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.05),
            itemCount: 20,
            itemBuilder: (_, i) {
              final isMine = i == _myCase;
              final isOpen = _opened.contains(i);
              return InkWell(onTap: () => _pick(i), borderRadius: BorderRadius.circular(14), child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isMine ? Colors.redAccent : gold, width: isMine ? 2.2 : 1.2),
                  gradient: LinearGradient(colors: isOpen ? [const Color(0xFF3B0A10), const Color(0xFF170507)] : [const Color(0xFF2B2415), const Color(0xFF090909)]),
                  boxShadow: [BoxShadow(color: (isMine ? Colors.red : gold).withOpacity(.24), blurRadius: 8)],
                ),
                child: isOpen
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        if (_imageFor(_caseValues[i]) != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Image.asset(
                              _imageFor(_caseValues[i])!,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              'assets/image/deal_case.png',
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                              color: Colors.white.withOpacity(.18),
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
                              color: Colors.black.withOpacity(.78),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _labelFor(_caseValues[i]),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
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
                              color: Colors.black.withOpacity(.66),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: gold.withOpacity(.75)),
                            ),
                            child: Text(
                              '${i + 1}',
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                        if (isMine)
                          const Positioned(
                            left: 0,
                            right: 0,
                            bottom: 3,
                            child: Text(
                              'جعبه من',
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
              ));
            },
          )),
          if (_myCase != null) Padding(padding: const EdgeInsets.fromLTRB(18, 8, 18, 16), child: Text('Jackpot: 10,000 R1 • Dinner • VIP Parking • Cake • Live Music • VIP Night', textAlign: TextAlign.center, textDirection: TextDirection.rtl, style: TextStyle(color: Colors.white.withOpacity(.75), fontSize: 12))),
        ]),
        if (bankerOffer != null) Positioned.fill(child: Container(
          color: Colors.black.withOpacity(.88),
          child: Center(child: Container(
            margin: const EdgeInsets.all(24), padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), border: Border.all(color: gold, width: 1.5), gradient: const LinearGradient(colors: [Color(0xFF2D0710), Color(0xFF090909)])),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/image/deal_banker.png',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
              const SizedBox(height: 12),
              const Text('THE BANKER IS CALLING…', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(bankerOfferSubtitle ?? 'پیشنهاد بانکدار', textAlign: TextAlign.center, textDirection: TextDirection.rtl, style: const TextStyle(color: gold)),
              const SizedBox(height: 8),
              Text(bankerOfferLabel ?? (_formatNumber(bankerOffer!) + ' R1'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
              const SizedBox(height: 22),
              Row(children: [
                Expanded(child: ElevatedButton(onPressed: _deal, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B7A43), minimumSize: const Size.fromHeight(52)), child: const Text('DEAL\nقبول می‌کنم', textAlign: TextAlign.center))),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton(onPressed: _noDeal, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9E0B19), minimumSize: const Size.fromHeight(52)), child: const Text('NO DEAL\nادامه می‌دهم', textAlign: TextAlign.center))),
              ])
            ]),
          )),
        )),
      ])),
    );
  }
}
