import 'my_reservations_page.dart';
import 'package:flutter/material.dart';
import 'reservation_store.dart';

class MyReservationsPage extends StatelessWidget {
  const MyReservationsPage({super.key});

  static const Color bg = Color(0xFF020706);
  static const Color emerald = Color(0xFF063D30);
  static const Color gold = Color(0xFFD5AD57);
  static const Color goldLight = Color(0xFFF0D58C);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          centerTitle: true,
          foregroundColor: goldLight,
          title: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'MY RESERVATIONS',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: goldLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'رزروهای من',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        body: ValueListenableBuilder<List<ReservationRecord>>(
          valueListenable: ReservationStore.instance.reservations,
          builder: (context, reservations, _) {
            if (reservations.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: emerald.withOpacity(.35),
                          border: Border.all(
                            color: gold,
                            width: 1.2,
                          ),
                        ),
                        child: const Icon(
                          Icons.calendar_month_outlined,
                          color: goldLight,
                          size: 46,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'هنوز رزروی ثبت نشده',
                        style: TextStyle(
                          color: goldLight,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 9),
                      const Text(
                        'رزروهای Royal Village شما در این بخش نمایش داده می‌شوند.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 35),
              itemCount: reservations.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = reservations[index];

                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF07100D),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: gold.withOpacity(.65),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.30),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: emerald,
                              border: Border.all(
                                color: gold,
                              ),
                            ),
                            child: const Icon(
                              Icons.workspace_premium_outlined,
                              color: goldLight,
                              size: 29,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.salonName,
                                  textDirection: TextDirection.ltr,
                                  style: const TextStyle(
                                    color: goldLight,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  item.customerName,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ReservationStore.instance.removeAt(index);
                            },
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.white38,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      _info(
                        Icons.calendar_today_outlined,
                        'تاریخ',
                        item.date,
                      ),
                      _info(
                        Icons.schedule_outlined,
                        'ساعت',
                        item.time,
                      ),
                      _info(
                        Icons.groups_outlined,
                        'مهمان',
                        '${item.guests} نفر',
                      ),
                      _info(
                        Icons.auto_awesome_outlined,
                        'دیزاین',
                        item.design,
                      ),
                      _info(
                        Icons.cake_outlined,
                        'کیک',
                        item.cake,
                      ),
                      _info(
                        Icons.phone_outlined,
                        'تماس',
                        item.phone,
                      ),

                      if (item.note.trim().isNotEmpty)
                        _info(
                          Icons.notes_outlined,
                          'توضیحات',
                          item.note,
                        ),

                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 14,
                        ),
                        decoration: BoxDecoration(
                          color: emerald.withOpacity(.35),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: gold.withOpacity(.40),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              color: goldLight,
                              size: 19,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'درخواست رزرو ثبت شده',
                              style: TextStyle(
                                color: goldLight,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _info(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        children: [
          Icon(
            icon,
            color: gold,
            size: 19,
          ),
          const SizedBox(width: 9),
          Text(
            '$title: ',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
