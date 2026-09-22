import 'package:flutter/material.dart';

/// Royal Club reward catalogue.
///
/// Ticket thresholds are draft campaign targets. This screen does not claim
/// stock availability, award points, or allow redemption. High-value prizes
/// must be validated by the management and server before going live.
class RoyalRewardsPage extends StatelessWidget {
  const RoyalRewardsPage({super.key});

  static const Color gold = Color(0xFFE8C36A);
  static const Color dark = Color(0xFF090907);
  static const Color burgundy = Color(0xFF4D0D17);

  static const List<_Reward> grand = [
    _Reward('iPhone 18 Pro Max', '۹۰٬۰۰۰', Icons.phone_iphone_rounded,
        'APPLE', 'جایزه بزرگ'),
    _Reward('Galaxy Z Fold8 Ultra', '۸۰٬۰۰۰', Icons.tablet_android_rounded,
        'SAMSUNG', 'جایزه بزرگ'),
    _Reward('Galaxy S26 Ultra', '۶۵٬۰۰۰', Icons.smartphone_rounded,
        'SAMSUNG', 'جایزه ویژه'),
    _Reward('Galaxy Z Flip7', '۴۵٬۰۰۰', Icons.flip_to_front_rounded,
        'SAMSUNG', 'جایزه ویژه'),
    _Reward('PlayStation 5', '۳۰٬۰۰۰', Icons.sports_esports_rounded,
        'SONY', 'جایزه ویژه'),
  ];

  static const List<_Reward> more = [
    _Reward('آبمیوه مخصوص سالن', '۱۰۰', Icons.local_drink_outlined,
        'ROYAL VILLAGE', 'پذیرایی'),
    _Reward('دسر یا کیک کوچک', '۲۰۰', Icons.cake_outlined,
        'ROYAL VILLAGE', 'پذیرایی'),
    _Reward('سورپرایز میز', '۳۵۰', Icons.celebration_outlined,
        'ROYAL VILLAGE', 'تجربه'),
    _Reward('تردستی دونفره', '۵۰۰', Icons.auto_awesome_rounded,
        'ROYAL VILLAGE', 'تجربه'),
    _Reward('ارتقای VIP', '۷۵۰', Icons.star_border_rounded,
        'ROYAL CLUB', 'VIP'),
    _Reward('Royal Gift Box', '۱٬۰۰۰', Icons.card_giftcard_rounded,
        'ROYAL CLUB', 'هدیه'),
    _Reward('تجربه اختصاصی Royal Club', '۱٬۵۰۰',
        Icons.workspace_premium_outlined, 'ROYAL CLUB', 'VIP'),
    _Reward('دعوت اختصاصی', '۲٬۵۰۰', Icons.diamond_outlined,
        'ROYAL CLUB', 'VIP'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: dark,
        foregroundColor: gold,
        centerTitle: true,
        title: const Text('ROYAL REWARDS',
            style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w700)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF21140C), Color(0xFF110B09), Colors.black],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(18, 25, 18, 22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF35240D), Color(0xFF160B0C)]),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: gold, width: 1),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.workspace_premium_rounded, color: gold, size: 58),
                    SizedBox(height: 10),
                    Text('ROYAL CLUB',
                        style: TextStyle(color: gold, letterSpacing: 4,
                            fontSize: 16)),
                    SizedBox(height: 6),
                    Text('فروشگاه جوایز رویال',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: Colors.white,
                            fontSize: 25, fontWeight: FontWeight.w800)),
                    SizedBox(height: 12),
                    Text('جمع کن، پیشرفت کن، جایزه انتخاب کن',
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: Colors.white70, fontSize: 15)),
                    SizedBox(height: 10),
                    Text('تیکت‌ها بدون سقف روزانه جمع می‌شوند.',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: gold, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const _SectionTitle(
                english: 'GRAND PRIZES',
                persian: 'جوایز بزرگ',
                icon: Icons.diamond_outlined,
              ),
              const SizedBox(height: 8),
              const Text(
                'هدف‌های پیشنهادی تیکت؛ فعال‌سازی هر جایزه پس از تأیید مدیریت و موجودی.',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),
              const SizedBox(height: 12),
              for (final reward in grand) ...[
                _GrandPrizeCard(reward: reward),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 16),
              const _SectionTitle(
                english: 'MORE REWARDS',
                persian: 'جوایز و تجربه‌های رویال',
                icon: Icons.card_giftcard_outlined,
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: more.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 11,
                  crossAxisSpacing: 11,
                  childAspectRatio: .95,
                ),
                itemBuilder: (context, index) =>
                    _SmallPrizeCard(reward: more[index]),
              ),
              const SizedBox(height: 26),
              Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: const Color(0xFF17110D),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: gold.withOpacity(.45)),
                ),
                child: const Column(
                  children: [
                    Text('SILVER  •  GOLD  •  BLACK  •  DIAMOND',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: gold,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2, fontSize: 12)),
                    SizedBox(height: 9),
                    Text('سطح عضویت بر پایه مجموع تیکت‌های کسب‌شده است و با خرج کردن کاهش نمی‌یابد.',
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70,
                            fontSize: 13, height: 1.6)),
                    SizedBox(height: 12),
                    Text(
                      'این صفحه پیش‌نمایش کاتالوگ است. دریافت جایزه پس از فعال‌سازی کیف تیکت امن، اعلام شرایط و تأیید موجودی انجام می‌شود. تیکت ارزش نقدی ندارد.',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54,
                          fontSize: 12, height: 1.6),
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

class _Reward {
  final String name;
  final String tickets;
  final IconData icon;
  final String brand;
  final String badge;
  const _Reward(this.name, this.tickets, this.icon,
      this.brand, this.badge);
}

class _SectionTitle extends StatelessWidget {
  final String english;
  final String persian;
  final IconData icon;
  const _SectionTitle({
    required this.english,
    required this.persian,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Icon(icon, color: RoyalRewardsPage.gold, size: 29),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(english,
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: RoyalRewardsPage.gold,
                      fontWeight: FontWeight.w800, letterSpacing: 1.8,
                      fontSize: 15)),
              Text(persian,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.white70,
                      fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}

class _GrandPrizeCard extends StatelessWidget {
  final _Reward reward;
  const _GrandPrizeCard({required this.reward});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF30210E), Color(0xFF130D0A), Color(0xFF260D14)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: RoyalRewardsPage.gold.withOpacity(.65)),
      ),
      child: Row(
        children: [
          Container(
            width: 74,
            height: 82,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xFF0C0B0B),
              border: Border.all(
                  color: RoyalRewardsPage.gold.withOpacity(.40)),
            ),
            child: Icon(reward.icon, color: RoyalRewardsPage.gold, size: 43),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reward.brand,
                    style: const TextStyle(
                        color: RoyalRewardsPage.gold,
                        letterSpacing: 2, fontSize: 10)),
                const SizedBox(height: 4),
                Text(reward.name,
                    style: const TextStyle(color: Colors.white, fontSize: 17,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(reward.badge,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 11)),
                const SizedBox(height: 4),
                Text(reward.tickets + '  RC TICKETS',
                    style: const TextStyle(
                        color: RoyalRewardsPage.gold,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallPrizeCard extends StatelessWidget {
  final _Reward reward;
  const _SmallPrizeCard({required this.reward});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFF18110D),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: RoyalRewardsPage.gold.withOpacity(.45)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(reward.icon, size: 31, color: RoyalRewardsPage.gold),
          const SizedBox(height: 7),
          Text(reward.name,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white,
                  fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(reward.tickets + ' TICKETS',
              textAlign: TextAlign.center,
              style: const TextStyle(color: RoyalRewardsPage.gold,
                  fontSize: 13, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
