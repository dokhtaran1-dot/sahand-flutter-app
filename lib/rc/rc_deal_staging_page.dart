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
  int? tickets;
  int? points;

  Future<void> _call(Future<void> Function() action) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await action();
    } catch (error) {
      if (mounted) setState(() => status = 'خطا: $error');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _claim() => _call(() async {
    final data = await client.rpc('rc_claim_daily') as Map;
    if (mounted) setState(() {
      tickets = (data['tickets'] as num).toInt();
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
      if (mounted) setState(() {
        opened[number] = (value as num).toInt();
        status = 'چمدان $number: $value RP';
      });
    }
  });

  Future<void> _settle() => _call(() async {
    final id = roundId;
    if (id == null || opened.length != 25) return;
    final award = await client.rpc('rc_settle_final_case', params: {
      'p_round': id,
    });
    if (mounted) setState(() {
      finalAward = (award as num).toInt();
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
              onTap: busy || roundId == null || finalAward != null || isSelected || value != null
                ? null : () => _tap(n),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: isSelected
                    ? [const Color(0xFF986C26), gold]
                    : [const Color(0xFF143C30), const Color(0xFF071B15)]),
                  border: Border.all(color: gold.withOpacity(.7)),
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
        FilledButton(
          onPressed: busy || opened.length != 25 || finalAward != null ? null : _settle,
          child: const Text('بازکردن چمدان نهایی و ثبت RP')),
        const SizedBox(height: 14),
        const Text('پیشنهاد بانکدار، چالش‌های مهارتی و سایر بازی‌ها در این صفحه آزمایشی هنوز متصل نیستند.',
          textAlign: TextAlign.center, style: TextStyle(color: Colors.white60)),
      ]),
    ))),
  );
}
