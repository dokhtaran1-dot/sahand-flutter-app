import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'royal_leaderboard_page.dart';
import 'royal_score_store.dart';

/// Three photographic salon rounds. Each pair shares the same base photo;
/// five small decorative details are changed programmatically in image B.
/// All hit zones use the same normalized coordinates for both images.
class RoyalFindDifferencePage extends StatefulWidget {
  const RoyalFindDifferencePage({super.key});

  @override
  State<RoyalFindDifferencePage> createState() =>
      _RoyalFindDifferencePageState();
}

class _Spot {
  const _Spot(this.position, this.original, this.changed,
      this.originalColor, this.changedColor);

  final Offset position;
  final IconData original;
  final IconData changed;
  final Color originalColor;
  final Color changedColor;
}

class _Level {
  const _Level(this.title, this.image, this.spots);

  final String title;
  final String image;
  final List<_Spot> spots;
}

const _gold = Color(0xFFE8C36A);
const _ruby = Color(0xFFA92038);
const _ivory = Color(0xFFFFF1DB);
const _jade = Color(0xFF78C9A3);

const List<_Level> _levels = [
  _Level('SALON JARDIN', 'assets/image/salon_jardin.png', [
    _Spot(Offset(.18, .20), Icons.local_florist, Icons.favorite,
        _ruby, _ruby),
    _Spot(Offset(.79, .21), Icons.park, Icons.local_florist,
        _jade, _ivory),
    _Spot(Offset(.47, .40), Icons.auto_awesome, Icons.diamond,
        _gold, _jade),
    _Spot(Offset(.23, .76), Icons.local_cafe, Icons.wine_bar_outlined,
        _ivory, _gold),
    _Spot(Offset(.79, .76), Icons.spa, Icons.star,
        _ruby, _gold),
  ]),
  _Level('SALON LUMIÈRE', 'assets/image/Salon_lumiere.png', [
    _Spot(Offset(.22, .23), Icons.lightbulb, Icons.auto_awesome,
        _gold, _ivory),
    _Spot(Offset(.78, .26), Icons.local_florist, Icons.spa,
        _ivory, _jade),
    _Spot(Offset(.51, .49), Icons.star, Icons.diamond,
        _gold, _ruby),
    _Spot(Offset(.20, .78), Icons.chair, Icons.table_restaurant,
        _jade, _gold),
    _Spot(Offset(.78, .77), Icons.cake, Icons.local_cafe,
        _ruby, _ivory),
  ]),
  _Level('SALON NOIR', 'assets/image/Salon_noir.png', [
    _Spot(Offset(.18, .24), Icons.favorite, Icons.local_florist,
        _ruby, _ivory),
    _Spot(Offset(.79, .18), Icons.nightlight_round, Icons.star,
        _gold, _ivory),
    _Spot(Offset(.53, .44), Icons.diamond, Icons.auto_awesome,
        _gold, _ruby),
    _Spot(Offset(.27, .77), Icons.local_cafe, Icons.cake,
        _ivory, _gold),
    _Spot(Offset(.79, .76), Icons.celebration, Icons.spa,
        _jade, _ruby),
  ]),
];

class _RoyalFindDifferencePageState
    extends State<RoyalFindDifferencePage> {
  static const int _roundSeconds = 60;
  Timer? _timer;

  int _level = 0;
  int _remaining = _roundSeconds;
  int _lives = 3;
  int _score = 0;
  int _fastRounds = 0;
  bool _playing = false;
  bool _finished = false;
  bool _hintUsed = false;
  final Set<int> _found = <int>{};

  _Level get _current => _levels[_level];

  void _startRound() {
    _timer?.cancel();
    setState(() => _playing = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || !_playing) return;
      if (_remaining <= 1) {
        timer.cancel();
        setState(() {
          _remaining = 0;
          _playing = false;
        });
        _finishGame(completed: false);
      } else {
        setState(() => _remaining--);
      }
    });
  }

  void _tapImage(TapDownDetails tap, Size imageSize) {
    if (!_playing || _finished) return;
    final point = tap.localPosition;
    final decorations = _current.spots;
    int? hit;

    for (int i = 0; i < decorations.length; i++) {
      if (_found.contains(i)) continue;
      final target = Offset(
        decorations[i].position.dx * imageSize.width,
        decorations[i].position.dy * imageSize.height,
      );
      final hitRadius = math.max(27.0, imageSize.width * .085);
      if ((target - point).distance <= hitRadius) {
        hit = i;
        break;
      }
    }

    if (hit == null) {
      HapticFeedback.mediumImpact();
      setState(() {
        _lives--;
        _score = math.max(0, _score - 25);
      });
      if (_lives == 0) _finishGame(completed: false);
      return;
    }

    HapticFeedback.selectionClick();
    setState(() {
      _found.add(hit!);
      _score += 100;
    });
    if (_found.length == decorations.length) _completeRound();
  }

  void _hint() {
    if (!_playing || _hintUsed) return;
    int? next;
    for (int i = 0; i < _current.spots.length; i++) {
      if (!_found.contains(i)) {
        next = i;
        break;
      }
    }
    if (next == null) return;
    HapticFeedback.lightImpact();
    setState(() {
      _found.add(next!);
      _hintUsed = true;
      _score = math.max(0, _score - 50);
    });
    if (_found.length == _current.spots.length) _completeRound();
  }

  void _completeRound() {
    if (!_playing) return;
    _timer?.cancel();
    setState(() {
      _playing = false;
      _score += (_remaining * 2) + (_lives * 30);
      if (_remaining >= 30) _fastRounds++;
    });

    if (_level == _levels.length - 1) {
      _finishGame(completed: true);
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _RoyalDialog(
        title: 'LEVEL COMPLETE',
        subtitle: 'تمام ۵ تفاوت پیدا شد!',
        score: _score,
        button: 'مرحله بعد',
        onPressed: () {
          Navigator.pop(dialogContext);
          setState(() {
            _level++;
            _remaining = _roundSeconds;
            _lives = 3;
            _found.clear();
            _hintUsed = false;
          });
          _startRound();
        },
      ),
    );
  }

  Future<void> _finishGame({required bool completed}) async {
    if (_finished) return;
    _timer?.cancel();
    setState(() {
      _finished = true;
      _playing = false;
    });
    final points = _score;
    final tickets = completed ? 3 + (_fastRounds == _levels.length ? 3 : 0) : 0;
    bool saved = true;
    try {
      await RoyalScoreStore.recordScore(
        RoyalScoreGame.difference,
        points,
        tickets: tickets,
      );
    } catch (_) {
      saved = false;
    }
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _RoyalDialog(
        title: completed ? 'ROYAL WINNER' : 'GAME OVER',
        subtitle: completed
            ? 'هر سه مرحله را تکمیل کردی! +$tickets تیکت آزمایشی'
            : 'امتیاز این دور: $points',
        score: points,
        footer: saved
            ? 'امتیاز و تیکت این دستگاه ثبت شد؛ جوایز واقعی پس از اتصال سرور.'
            : 'خطا در ذخیره‌سازی؛ امتیاز این دور ثبت نشد.',
        button: 'بازی مجدد',
        onPressed: () {
          Navigator.pop(dialogContext);
          _reset();
        },
        secondary: 'بازگشت به Royal Club',
        onSecondary: () {
          Navigator.pop(dialogContext);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _level = 0;
      _remaining = _roundSeconds;
      _lives = 3;
      _score = 0;
      _fastRounds = 0;
      _found.clear();
      _playing = false;
      _finished = false;
      _hintUsed = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _metric(IconData icon, String value, String caption,
      {Color color = _gold}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 21),
        const SizedBox(height: 3),
        Text(value, style: TextStyle(
          color: color,
          fontSize: 19,
          fontWeight: FontWeight.w800,
        )),
        Text(caption, style: const TextStyle(
          color: Colors.white60, fontSize: 10,
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final level = _current;
    return Scaffold(
      backgroundColor: const Color(0xFF090708),
      appBar: AppBar(
        backgroundColor: const Color(0xFF140A0D),
        foregroundColor: _gold,
        centerTitle: true,
        title: const Text('FIND THE DIFFERENCE',
            style: TextStyle(letterSpacing: 1.0,
                fontSize: 18, fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            tooltip: 'جدول امتیازات',
            onPressed: _playing ? null : () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const RoyalLeaderboardPage(),
              ),
            ),
            icon: const Icon(Icons.leaderboard_rounded),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF31121A), Color(0xFF100B0C), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(14, 8, 14, 7),
                padding: const EdgeInsets.symmetric(
                    horizontal: 17, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF160C0C),
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: _gold.withOpacity(.66)),
                ),
                child: Column(
                  children: [
                    Text(
                      '${level.title}  •  ${_level + 1}/${_levels.length}',
                      style: const TextStyle(
                        color: _gold, fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 11),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _metric(Icons.timer_outlined,
                            '${_remaining}s', 'زمان',
                            color: _remaining <= 10
                                ? const Color(0xFFFF6F85) : _gold),
                        _metric(Icons.favorite,
                            '$_lives', 'جان', color: _ruby),
                        _metric(Icons.find_replace_rounded,
                            '${_found.length}/${level.spots.length}',
                            'تفاوت'),
                        _metric(Icons.stars_rounded, '$_score', 'امتیاز'),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(14, 6, 14, 22),
                  children: [
                    const Text(
                      'در هر دو تصویر، روی ۵ تفاوت بزن',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white,
                          fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 9),
                    _DifferencePhoto(
                      image: level.image,
                      spots: level.spots,
                      altered: false,
                      found: _found,
                      onTap: _tapImage,
                      title: 'ORIGINAL',
                    ),
                    const SizedBox(height: 10),
                    _DifferencePhoto(
                      image: level.image,
                      spots: level.spots,
                      altered: true,
                      found: _found,
                      onTap: _tapImage,
                      title: 'FIND 5 DIFFERENCES',
                    ),
                    const SizedBox(height: 15),
                    if (!_playing && !_finished)
                      FilledButton.icon(
                        onPressed: _startRound,
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: Text(_remaining == _roundSeconds
                            ? 'شروع مرحله' : 'ادامه بازی'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF801429),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(52),
                          side: const BorderSide(color: _gold),
                        ),
                      )
                    else
                      OutlinedButton.icon(
                        onPressed: _playing && !_hintUsed ? _hint : null,
                        icon: const Icon(Icons.lightbulb_outline_rounded),
                        label: Text(_hintUsed
                            ? 'راهنمای این مرحله استفاده شد'
                            : 'راهنمایی (۵۰ امتیاز)'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _gold,
                          side: const BorderSide(color: _gold),
                          minimumSize: const Size.fromHeight(51),
                        ),
                      ),
                    const SizedBox(height: 11),
                    const Text(
                      'هر تفاوت +۱۰۰ امتیاز • اشتباه: یک جان و ۲۵ امتیاز • '
                      'سه سالن متفاوت • تیکت‌ها بدون سقف جمع می‌شوند',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white60,
                          fontSize: 12, height: 1.7),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifferencePhoto extends StatelessWidget {
  const _DifferencePhoto({
    required this.image,
    required this.spots,
    required this.altered,
    required this.found,
    required this.onTap,
    required this.title,
  });

  final String image;
  final List<_Spot> spots;
  final bool altered;
  final Set<int> found;
  final void Function(TapDownDetails, Size) onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = width * .67;
        final size = Size(width, height);
        final diameter = math.min(47.0, math.max(30.0, width * .1));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: _gold, letterSpacing: 1.5,
                    fontWeight: FontWeight.bold, fontSize: 11)),
            const SizedBox(height: 5),
            Container(
              height: height,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: _gold, width: 1.8),
                boxShadow: const [
                  BoxShadow(color: Color(0x332F1B0B), blurRadius: 12),
                ],
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) => onTap(details, size),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      image,
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                    for (int i = 0; i < spots.length; i++)
                      Positioned(
                        left: spots[i].position.dx * width - diameter / 2,
                        top: spots[i].position.dy * height - diameter / 2,
                        child: IgnorePointer(
                          child: Container(
                            width: diameter,
                            height: diameter,
                            decoration: BoxDecoration(
                              color: const Color(0xD1221915),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _gold.withOpacity(.9), width: 1,
                              ),
                            ),
                            child: Icon(
                              altered
                                  ? spots[i].changed
                                  : spots[i].original,
                              color: altered
                                  ? spots[i].changedColor
                                  : spots[i].originalColor,
                              size: diameter * .56,
                            ),
                          ),
                        ),
                      ),
                    for (final index in found)
                      Positioned(
                        left: spots[index].position.dx * width -
                            (diameter + 10) / 2,
                        top: spots[index].position.dy * height -
                            (diameter + 10) / 2,
                        child: IgnorePointer(
                          child: Container(
                            width: diameter + 10,
                            height: diameter + 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFF73E0A8),
                                  width: 3),
                              boxShadow: const [
                                BoxShadow(color: Color(0x9973E0A8),
                                    blurRadius: 10),
                              ],
                            ),
                            child: const Icon(
                                Icons.check_rounded, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RoyalDialog extends StatelessWidget {
  const _RoyalDialog({
    required this.title,
    required this.subtitle,
    required this.score,
    required this.button,
    required this.onPressed,
    this.footer,
    this.secondary,
    this.onSecondary,
  });

  final String title;
  final String subtitle;
  final int score;
  final String button;
  final VoidCallback onPressed;
  final String? footer;
  final String? secondary;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1B0D10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: const BorderSide(color: _gold, width: 1.5),
      ),
      title: Column(
        children: [
          const Icon(Icons.workspace_premium_rounded,
              color: _gold, size: 49),
          const SizedBox(height: 6),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: _gold, fontWeight: FontWeight.w900,
                  fontSize: 22)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(subtitle, textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: const TextStyle(color: Colors.white, height: 1.5)),
          const SizedBox(height: 14),
          Text('$score POINTS',
              textAlign: TextAlign.center,
              style: const TextStyle(color: _gold,
                  fontSize: 27, fontWeight: FontWeight.w900)),
          if (footer != null) ...[
            const SizedBox(height: 12),
            Text(footer!, textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: const TextStyle(color: Colors.white60,
                    fontSize: 12, height: 1.5)),
          ],
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF801429),
              foregroundColor: Colors.white),
          child: Text(button),
        ),
        if (secondary != null)
          TextButton(
            onPressed: onSecondary,
            child: Text(secondary!,
                style: const TextStyle(color: _gold)),
          ),
      ],
    );
  }
}
