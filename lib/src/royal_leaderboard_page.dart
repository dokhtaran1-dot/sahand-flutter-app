import 'package:flutter/material.dart';

import 'royal_score_store.dart';

/// Top-ten prototype for players on this device. Do not describe this as an
/// online ranking until a secured, verified leaderboard API is connected.
class RoyalLeaderboardPage extends StatefulWidget {
  const RoyalLeaderboardPage({super.key});

  @override
  State<RoyalLeaderboardPage> createState() => _RoyalLeaderboardPageState();
}

class _RoyalLeaderboardPageState extends State<RoyalLeaderboardPage> {
  static const Color gold = Color(0xFFE8C36A);
  static const Color dark = Color(0xFF100B09);
  RoyalScoreGame? _selected;
  late Future<List<RoyalPlayerScore>> _future;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    _future = RoyalScoreStore.topTen(game: _selected);
  }

  void _filter(RoyalScoreGame? game) {
    setState(() {
      _selected = game;
      _refresh();
    });
  }

  Future<void> _register() async {
    final current = await RoyalScoreStore.displayName();
    if (!mounted) return;
    final controller = TextEditingController(text: current ?? '');
    final form = GlobalKey<FormState>();
    String? error;
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          backgroundColor: const Color(0xFF160E0D),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(23),
              side: const BorderSide(color: gold)),
          title: const Text('نام نمایشی',
              textAlign: TextAlign.center,
              style: TextStyle(color: gold, fontWeight: FontWeight.w800)),
          content: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('این نام در جدول امتیازات نمایش داده می‌شود. شماره موبایل نمایش داده نمی‌شود.',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 15),
                TextFormField(
                  controller: controller,
                  maxLength: 30,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'نام یا لقب بازیکن',
                    labelStyle: const TextStyle(color: Colors.white70),
                    errorText: error,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: gold)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: gold, width: 2)),
                  ),
                  validator: (value) => (value?.trim().length ?? 0) < 2
                      ? 'حداقل ۲ کاراکتر وارد کنید.' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('انصراف', style: TextStyle(color: gold)),
            ),
            FilledButton(
              onPressed: () async {
                if (form.currentState?.validate() != true) return;
                try {
                  await RoyalScoreStore.saveDisplayName(controller.text);
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext, true);
                  }
                } on FormatException catch (e) {
                  setLocal(() => error = e.message);
                }
              },
              style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF751021),
                  foregroundColor: Colors.white),
              child: const Text('ثبت نام نمایشی'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (saved == true && mounted) setState(_refresh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: dark,
        foregroundColor: gold,
        title: const Text('RC TOP 10',
            style: TextStyle(color: gold, letterSpacing: 2)),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'به‌روزرسانی',
            onPressed: () => setState(_refresh),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF32131A), Color(0xFF140B0A), Colors.black],
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF40301B), Color(0xFF180E0D)]),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: gold, width: 1.2),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.emoji_events_rounded,
                        color: gold, size: 57),
                    const SizedBox(height: 8),
                    const Text('ROYAL LEADERBOARD',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: gold,
                            fontSize: 21, fontWeight: FontWeight.w900,
                            letterSpacing: 1.5)),
                    const SizedBox(height: 7),
                    const Text('۱۰ بازیکن اول از نظر امتیاز کسب‌شده',
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: Colors.white, fontSize: 17)),
                    const SizedBox(height: 12),
                    const Text(
                      'نسخه آزمایشی: فعلاً فقط امتیازهای ثبت‌شده در همین دستگاه نمایش داده می‌شود.',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white60,
                          height: 1.6, fontSize: 12),
                    ),
                    const SizedBox(height: 14),
                    TextButton.icon(
                      onPressed: _register,
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('ثبت یا ویرایش نام نمایشی'),
                      style: TextButton.styleFrom(foregroundColor: gold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 7,
                children: [
                  _chip(null, 'همه بازی‌ها'),
                  _chip(RoyalScoreGame.deal, 'DEAL'),
                  _chip(RoyalScoreGame.crown, 'CROWN'),
                  _chip(RoyalScoreGame.difference, 'FIND DIFFERENCE'),
                ],
              ),
              const SizedBox(height: 19),
              FutureBuilder<List<RoyalPlayerScore>>(
                future: _future,
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: CircularProgressIndicator(color: gold),
                      ),
                    );
                  }
                  final players = snap.data!;
                  if (players.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1310),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: gold.withOpacity(.35)),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.military_tech_outlined,
                              color: gold, size: 43),
                          SizedBox(height: 15),
                          Text('هنوز امتیازی ثبت نشده است',
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold, fontSize: 17)),
                          SizedBox(height: 7),
                          Text('نام نمایشی را ثبت کن و بازی کن تا رتبه‌ات اینجا نمایش داده شود.',
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white60,
                                  height: 1.7)),
                        ],
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (var index = 0; index < players.length; index++)
                        _RankRow(
                          player: players[index],
                          rank: index + 1,
                          points: players[index].pointsFor(_selected),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'امتیاز مسابقات از موجودی تیکت قابل خرج کردن جداست. جدول سراسری و جوایز رسمی به حساب کاربری و ثبت امن امتیازات روی سرور نیاز دارند.',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54,
                    fontSize: 12, height: 1.7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(RoyalScoreGame? game, String title) {
    final selected = game == _selected;
    return ChoiceChip(
      label: Text(title),
      selected: selected,
      onSelected: (_) => _filter(game),
      showCheckmark: false,
      selectedColor: gold,
      backgroundColor: const Color(0xFF241B17),
      side: BorderSide(color: gold.withOpacity(selected ? 1 : .5)),
      labelStyle: TextStyle(
        color: selected ? Colors.black : gold,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({
    required this.player,
    required this.rank,
    required this.points,
  });
  final RoyalPlayerScore player;
  final int rank;
  final int points;

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE8C36A);
    final medal = rank == 1
        ? const Color(0xFFF0D074)
        : rank == 2
            ? const Color(0xFFD5DAE1)
            : rank == 3
                ? const Color(0xFFD7A36A)
                : const Color(0xFF9D8869);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(
          horizontal: 15, vertical: rank <= 3 ? 17 : 13),
      decoration: BoxDecoration(
        gradient: rank <= 3
            ? const LinearGradient(
                colors: [Color(0xFF322518), Color(0xFF130D0C)])
            : null,
        color: rank <= 3 ? null : const Color(0xFF171210),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: rank <= 3 ? medal : gold.withOpacity(.25),
          width: rank == 1 ? 1.5 : .8,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 47,
            child: rank <= 3
                ? Column(
                    children: [
                      Icon(Icons.emoji_events_rounded, color: medal, size: 27),
                      Text('#$rank',
                          style: TextStyle(color: medal,
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  )
                : Center(
                    child: Text('$rank',
                        style: const TextStyle(color: gold,
                            fontSize: 21, fontWeight: FontWeight.bold)),
                  ),
          ),
          const SizedBox(width: 11),
          CircleAvatar(
            backgroundColor: const Color(0xFF422A15),
            child: Text(player.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                    color: gold, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(player.name,
                textDirection: TextDirection.rtl,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: rank <= 3
                        ? FontWeight.w800 : FontWeight.w600,
                    fontSize: rank <= 3 ? 17 : 15)),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$points',
                  style: const TextStyle(
                      color: gold, fontSize: 19,
                      fontWeight: FontWeight.w900)),
              const Text('POINTS',
                  style: TextStyle(color: Colors.white54,
                      fontSize: 10, letterSpacing: 1.4)),
            ],
          ),
        ],
      ),
    );
  }
}
