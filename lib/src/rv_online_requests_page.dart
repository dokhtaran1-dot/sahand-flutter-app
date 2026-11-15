import 'package:flutter/material.dart';
import 'royal_club_membership_page.dart';
import 'rv_online_booking_service.dart';

/// Displays server-owned request statuses. No offline or client-only booking
/// is ever labelled confirmed. Staff confirmation happens out of band.
class RvOnlineRequestsPage extends StatefulWidget {
  const RvOnlineRequestsPage({super.key});
  @override
  State<RvOnlineRequestsPage> createState() => _RvOnlineRequestsPageState();
}

class _RvOnlineRequestsPageState extends State<RvOnlineRequestsPage> {
  static const emerald = Color(0xFF061A13);
  static const gold = Color(0xFFE2C27A);
  late Future<List<RvOnlineReservationStatus>> _future = _load();
  Future<List<RvOnlineReservationStatus>> _load() =>
      RvOnlineBookingService.myRequests();

  void _refresh() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      backgroundColor: emerald,
      appBar: AppBar(
        backgroundColor: emerald, foregroundColor: gold,
        title: const Text('پیگیری آنلاین درخواست‌های RV'),
        actions: [IconButton(
          tooltip: 'به‌روزرسانی وضعیت',
          icon: const Icon(Icons.refresh),
          onPressed: _refresh)],
      ),
      body: !RvOnlineBookingService.configured
        ? const Center(child: Padding(
            padding: EdgeInsets.all(30),
            child: Text('اتصال سامانه در این نسخه فعال نشده است.',
              textAlign: TextAlign.center)))
        : !RvOnlineBookingService.isVerified
        ? Center(child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.lock_outline, color: gold, size: 54),
              const SizedBox(height: 20),
              const Text('برای مشاهده درخواست‌های خود، '
                'با شماره پیامکی تأییدشده وارد شوید.',
                textAlign: TextAlign.center),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (_) => const RoyalClubMembershipPage()));
                  if (mounted) _refresh();
                },
                child: const Text('ورود با شماره تأییدشده')),
            ])))
        : FutureBuilder<List<RvOnlineReservationStatus>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator(color: gold));
              }
              if (snapshot.hasError) {
                return Center(child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Text('دریافت وضعیت درخواست‌ها ممکن نشد.',
                      textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    TextButton(onPressed: _refresh,
                      child: const Text('تلاش دوباره')),
                  ])));
              }
              final items = snapshot.data ?? const [];
              if (items.isEmpty) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('هنوز درخواست آنلاینی با این حساب ثبت نشده است. '
                    'پیش‌نویس‌های محلی در این فهرست نمایش داده نمی‌شوند.',
                    textAlign: TextAlign.center)));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(17),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    color: const Color(0xFF10291C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: const BorderSide(color: gold)),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.salon, textDirection: TextDirection.ltr,
                            style: const TextStyle(color: gold, fontSize: 18,
                              fontWeight: FontWeight.w700)),
                          const SizedBox(height: 9),
                          Text('${item.date}  ·  ${item.time.substring(0, 5)}'
                            '  ·  ${item.guests} نفر'),
                          const SizedBox(height: 8),
                          Text(item.statusFa,
                            style: const TextStyle(color: gold,
                              fontWeight: FontWeight.w800)),
                          if (item.managementNote?.trim().isNotEmpty == true)
                            Padding(padding: const EdgeInsets.only(top: 7),
                              child: Text(item.managementNote!)),
                          const SizedBox(height: 5),
                          Text('شماره پیگیری: ${item.id.substring(0, 8).toUpperCase()}',
                            style: const TextStyle(
                              color: Colors.white54, fontSize: 12)),
                        ]),
                    ),
                  );
                });
            }),
    ),
  );
}
