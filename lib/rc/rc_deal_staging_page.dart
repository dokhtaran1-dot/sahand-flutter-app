import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Staging-only client. All monetary/redeemable awards are server-authoritative.
/// Do not expose this page in production until compliance approval.
class RcDealStagingPage extends StatefulWidget {
  const RcDealStagingPage({super.key});
  @override
  State<RcDealStagingPage> createState() => _RcDealStagingPageState();
}

class _RcDealStagingPageState extends State<RcDealStagingPage> {
  static const gold = Color(0xFFE8C36A);
  final client = Supabase.instance.client;
  String? roundId;
  int? selected;
  final Map<int, int> opened = {};
  String status = 'برای شروع وارد حساب آزمایشی شوید';
  bool busy = false;
  int? finalAward;
  int? bankerOffer;
  final Set<int> rejectedStages = {};
  static const offerStages = <int>{6,11,15,18,20,21,22,23,24};
  int? tickets;
  int? points;
  List<dynamic> leaderboard = [];
  String? skillRound;
  String? skillGame;
  final Set<int> skillGuesses = {};
  int? skillTarget;
  bool skillFinished = false;

  Future<void> _call(Future<void> Function() action) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await action();
    } catch (error) {
      if (mounted) { setState(() => status = 'خطا: $error'); }
    } finally {
      if (mounted) { setState(() => busy = false); }
    }
  }

  @override
  void initState() { super.initState(); Future.microtask(_refresh); }

  Future<void> _refresh() => _call(() async {
    final wallet = await client.rpc('rc_wallet');
    final top = await client.rpc('rc_weekly_top10');
    if (mounted) { setState(() {
      if (wallet is Map) {
        tickets = (wallet['tickets'] as num).toInt(); }
        points = (wallet['royal_points'] as num).toInt();
      }
      leaderboard = top is List ? top : [];
    });
  });

  Future<void> _startSkill(String game) => _call(() async {
    final id = await client.rpc('rc_start_skill',params:{'p_game':game});
    if (mounted) setState(() {
      skillRound = id as String; skillGame = game;
      skillGuesses.clear(); skillTarget = null; skillFinished = false;
      tickets = tickets == null ? null : tickets! - (game=='crown'?2:1);
      status = game=='crown' ? 'تاج را در ۹ صندوق پیدا کن' : 'نماد متفاوت را پیدا کن';
    });
  });

  Future<void> _guessSkill(int cell) => _call(() async {
    final result = await client.rpc('rc_guess_skill',params:{'p_round':skillRound,'p_cell':cell}) as Map;
    if (mounted) { setState(() {
      skillGuesses.add(cell); }
      skillFinished = result['finished']==true;
      if (skillFinished) {
        skillTarget = (result['target'] as num).toInt();
        points = (points ?? 0)+(result['award'] as num).toInt();
      }
      status = skillFinished ? 'پایان بازی · ${(result['award'] as num).toInt()} RP' : 'تلاش بعدی را انتخاب کن';
    });
  });

  Future<void> _claim() => _call(() async {
    final data = await client.rpc('rc_claim_daily') as Map;
    if (mounted) { setState(() {
      tickets = (data['tickets'] as num).toInt(); }
      points = (data['royal_points'] as num).toInt();
      status = 'کیف پول آزمایشی به‌روزرسانی شد';
    });
  });

  Future<void> _start() => _call(() async {
    final id = await client.rpc('rc_start_deal') as String;
    if (mounted) setState(() {
      roundId = id;
      selected = null;
      opened.clear();
      finalAward = null;
      bankerOffer = null;
      rejectedStages.clear();
      tickets = tickets == null ? null : tickets! - 3;
      status = 'یکی از ۲۶ چمدان را برای خودت انتخاب کن';
    });
  });

  Future<void> _tap(int number) => _call(() async {
    final id = roundId;
    if (id == null || finalAward != null) return;
    if (selected == null) {
      await client.rpc('rc_select_deal_case', params: {
        'p_round': id, 'p_case': number,
      });
      if (mounted) setState(() {
        selected = number;
        status = 'چمدان $number مال شماست؛ حالا بقیه را باز کن';
      });
    } else if (number != selected && !opened.containsKey(number)) {
      final value = await client.rpc('rc_open_deal_case', params: {
        'p_round': id, 'p_case': number,
      });
      if (mounted) { setState(() {
        opened[number] = (value as num).toInt(); }
        status = 'چمدان $number: $value RP';
      });
    }
  });

  Future<void> _offer() => _call(() async {
    if (roundId == null) return;
    final offer = await client.rpc('rc_banker_offer', params: {
      'p_round': roundId,
    });
    if (mounted) { setState(() {
      bankerOffer = (offer as num).toInt(); }
      status = 'پیشنهاد بانکدار: $bankerOffer RP';
    });
  });

  Future<void> _decision(bool accept) => _call(() async {
    if (roundId == null || bankerOffer == null) return;
    final result = await client.rpc('rc_banker_decision', params: {
      'p_round': roundId, 'p_accept': accept,
    }) as Map;
    if (mounted) { setState(() {
      if (result['settled'] == true) {
        finalAward = (result['royal_points'] as num).toInt(); }
        points = points == null ? null : points! + finalAward!;
        status = 'DEAL! $finalAward RP در کیف پول آزمایشی ثبت شد';
      } else {
        rejectedStages.add(opened.length);
        status = 'NO DEAL! بازی ادامه دارد';
      }
      bankerOffer = null;
    });
  });

  Future<void> _settle() => _call(() async {
    final id = roundId;
    if (id == null || opened.length != 25) return;
    final award = await client.rpc('rc_settle_final_case', params: {
      'p_round': id,
    });
    if (mounted) { setState(() {
      finalAward = (award as num).toInt(); }
      points = points == null ? null : points! + finalAward!;
      status = 'برنده شدی: $finalAward RP — ثبت‌شده در سرور آزمایشی';
    });
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF061B15),
    appBar: AppBar(title: const Text('ROYAL DEAL · TEST'),
      backgroundColor: const Color(0xFF061B15), foregroundColor: gold),
    body: SafeArea(child: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: ListView(padding: const EdgeInsets.all(18), children: [
        const Text('ROYAL POINTS', textAlign: TextAlign.center,
          style: TextStyle(color: gold, fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text('تیکت: ${tickets ?? "—"}     RP: ${points ?? "—"}',
          textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 10),
        const Text('نسخه آزمایشی؛ جوایز واقعی غیرفعال هستند',
          textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 12),
        Text(status, textAlign: TextAlign.center, style: const TextStyle(color: gold)),
        const SizedBox(height: 16),
        Wrap(alignment: WrapAlignment.center, spacing: 10, runSpacing: 10,
          children: [
            OutlinedButton(onPressed: busy ? null : _claim,
              child: const Text('دریافت تیکت روزانه')),
            FilledButton(onPressed: busy ? null : _start,
              child: const Text('شروع بازی · ۳ تیکت')),
          ]),
        const SizedBox(height: 20),
        GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          itemCount: 26,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, childAspectRatio: 1.12, crossAxisSpacing: 8, mainAxisSpacing: 8),
          itemBuilder: (context, index) {
            final n = index + 1;
            final isSelected = selected == n;
            final value = opened[n];
            return InkWell(
              onTap: busy || roundId == null || finalAward != null || bankerOffer != null || (selected != null && offerStages.contains(opened.length) && !rejectedStages.contains(opened.length)) || isSelected || value != null
                ? null : () => _tap(n),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: isSelected
                    ? [const Color(0xFF986C26), gold]
                    : [const Color(0xFF143C30), const Color(0xFF071B15)]),
                  border: Border.all(color: gold.withValues(alpha: .7)),
                  borderRadius: BorderRadius.circular(14)),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(value == null ? Icons.work_outline : Icons.lock_open, color: gold),
                  Text(value == null ? '$n' : '$value RP',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  if (isSelected) const Text('MY CASE', style: TextStyle(color: Colors.white, fontSize: 10)),
                ]),
              ),
            );
          }),
        const SizedBox(height: 16),
        if (selected != null && bankerOffer == null && offerStages.contains(opened.length)
            && !rejectedStages.contains(opened.length) && finalAward == null)
          FilledButton(onPressed: busy ? null : _offer,
            child: const Text('تماس بانکدار · دریافت پیشنهاد')),
        if (bankerOffer != null) ...[
          Text('BANKER OFFER: $bankerOffer RP', textAlign: TextAlign.center,
            style: const TextStyle(color: gold, fontSize: 24)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            FilledButton(onPressed: busy ? null : () => _decision(true),
              child: const Text('DEAL')),
            OutlinedButton(onPressed: busy ? null : () => _decision(false),
              child: const Text('NO DEAL')),
          ]),
        ],
        FilledButton(
          onPressed: busy || bankerOffer != null || opened.length != 25 || finalAward != null ? null : _settle,
          child: const Text('بازکردن چمدان نهایی و ثبت RP')),
        const SizedBox(height: 14),
        const SizedBox(height: 18),
        const Text('ROYAL SKILL GAMES',textAlign: TextAlign.center,style: TextStyle(color:gold,fontSize:21)),
        Wrap(alignment:WrapAlignment.center,spacing:8,children:[
          OutlinedButton(onPressed:busy || (skillRound!=null && !skillFinished) ? null : ()=>_startSkill('crown'),child:const Text('CROWN · 2 TICKETS')),
          OutlinedButton(onPressed:busy || (skillRound!=null && !skillFinished) ? null : ()=>_startSkill('difference'),child:const Text('FIND DIFFERENCE · 1 TICKET')),
        ]),
        if (skillRound!=null) ...[
          const SizedBox(height:12),
          Text(skillGame=='crown'?'تاج پنهان':'نماد متفاوت',textAlign:TextAlign.center,style:const TextStyle(color:gold)),
          GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:9,
            gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:3,mainAxisSpacing:8,crossAxisSpacing:8),
            itemBuilder:(context,i) {
              final cell=i+1;
              return OutlinedButton(onPressed:busy || skillFinished || skillGuesses.contains(cell)?null:()=>_guessSkill(cell),
                child:Icon(skillFinished && skillTarget==cell?Icons.workspace_premium:
                  skillGuesses.contains(cell)?Icons.close:Icons.inventory_2_outlined,color:gold));
            }),
        ],
        const SizedBox(height:20),
        const Text('WEEKLY TOP 10',textAlign:TextAlign.center,style:TextStyle(color:gold,fontSize:21)),
        OutlinedButton(onPressed:busy?null:_refresh,child:const Text('به‌روزرسانی امتیاز و رتبه‌بندی')),
        for (var i=0;i<leaderboard.length;i++)
          ListTile(title:Text('${i+1}. ${leaderboard[i]['display_name']}'),
            trailing:Text('${leaderboard[i]['weekly_points']} RP')),
        const Text('نسخه آزمایشی · بدون جوایز واقعی',textAlign:TextAlign.center,style:TextStyle(color:Colors.white60)),
      ]),
    ))),
  );
}
