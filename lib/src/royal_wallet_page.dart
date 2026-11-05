import 'package:flutter/material.dart';

/// Royal Wallet presentation only. No local balance mutations, real-money
/// charges or prize-linked purchases are permitted on this screen.
class RoyalWalletPage extends StatelessWidget {
  const RoyalWalletPage({super.key});

  static const Color _black = Color(0xFF07110C);
  static const Color _emerald = Color(0xFF103A29);
  static const Color _gold = Color(0xFFE8C36A);
  static const Color _cream = Color(0xFFF2EDE0);
  static const Color _muted = Color(0xFFB0BCAF);

  static const _packages = <String>[
    '۱۰۰٬۰۰۰',
    '۲۵۰٬۰۰۰',
    '۵۰۰٬۰۰۰',
    '۱٬۰۰۰٬۰۰۰',
  ];

  static const _games = <_WalletGame>[
    _WalletGame('ROYAL DEAL', '۲۰٬۰۰۰'),
    _WalletGame('ROYAL CROWN', '۱۵٬۰۰۰'),
    _WalletGame('FIND THE DIFFERENCE', '۱۰٬۰۰۰'),
  ];

  void _showNotActive(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF14281C),
        title: const Text('شارژ هنوز فعال نیست',
            textDirection: TextDirection.rtl,
            style: TextStyle(color: _gold)),
        content: const Text(
          'این صفحه فعلاً پیش‌نمایش است. پس از اتصال درگاه مجاز، '
          'تأیید پرداخت در سرور و بررسی مقررات، شارژ واقعی فعال می‌شود. '
          'اکنون هیچ وجهی دریافت نمی‌شود.',
          textDirection: TextDirection.rtl,
          style: TextStyle(color: _cream, height: 1.8),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('متوجه شدم', style: TextStyle(color: _gold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      appBar: AppBar(
        backgroundColor: _black,
        foregroundColor: _gold,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text('ROYAL WALLET',
            style: TextStyle(letterSpacing: 2.2, fontSize: 16)),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, bounds) {
            final contentWidth = bounds.maxWidth > 760 ? 728.0 : bounds.maxWidth - 32;
            final packageWidth = (contentWidth - 12) / 2;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 35),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(23),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xBBE8C36A)),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [_emerald, Color(0xFF09160E), _black],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.account_balance_wallet_outlined,
                                  color: _gold, size: 28),
                              Spacer(),
                              Text('RW  /  R1',
                                  style: TextStyle(
                                      color: _gold,
                                      fontSize: 12,
                                      letterSpacing: 2)),
                            ],
                          ),
                          const SizedBox(height: 23),
                          const Text('موجودی ریالی',
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: TextStyle(color: _muted, fontSize: 13)),
                          const SizedBox(height: 6),
                          const Text('۰ تومان',
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: _cream,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 19),
                          const Text('ROYAL CLUB  ·  POWERED BY SAHAND CONSORTIUM',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: _gold,
                                  fontSize: 9,
                                  letterSpacing: 1.1)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _informationBox(
                      icon: Icons.shield_outlined,
                      text: 'پیش‌نمایش کیف پول — شارژ و کسر وجه واقعی غیرفعال است.',
                    ),
                    const SizedBox(height: 29),
                    const _SectionTitle('بسته‌های شارژ پیشنهادی', 'TOP UP'),
                    const SizedBox(height: 13),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        for (final amount in _packages)
                          SizedBox(
                            width: packageWidth,
                            child: OutlinedButton(
                              onPressed: () => _showNotActive(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _cream,
                                side: const BorderSide(color: Color(0x99765D35)),
                                padding: const EdgeInsets.symmetric(vertical: 17),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.lock_outline,
                                      color: _gold, size: 15),
                                  const SizedBox(height: 6),
                                  Text(amount,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  const Text('تومان',
                                      style: TextStyle(
                                          color: _muted, fontSize: 11)),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const _SectionTitle('تعرفه بازی‌های تفریحی', 'PLAY RATES'),
                    const SizedBox(height: 13),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF102219),
                        border: Border.all(color: const Color(0x77765D35)),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Column(
                        children: [
                          for (var i = 0; i < _games.length; i++) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 17, horizontal: 16),
                              child: Row(
                                children: [
                                  Text('${_games[i].price} تومان',
                                      style: const TextStyle(
                                          color: _gold,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13)),
                                  const Spacer(),
                                  Flexible(
                                    child: Text(_games[i].title,
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                            color: _cream,
                                            fontSize: 12,
                                            letterSpacing: .6)),
                                  ),
                                ],
                              ),
                            ),
                            if (i != _games.length - 1)
                              const Divider(height: 1, color: Color(0x445D714F)),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 17),
                    _informationBox(
                      icon: Icons.card_giftcard_outlined,
                      text: 'طرح آزمایشی: روزانه یک بازی رایگان. '
                          'پرداخت تفریحی هیچ امتیازی برای جوایز واقعی ایجاد نمی‌کند. '
                          'R1 Tickets و رقابت‌های جایزه‌دار مستقل هستند.',
                    ),
                    const SizedBox(height: 17),
                    const Text(
                      'فعالسازی شارژ، پرداخت و برداشت از کیف پول فقط پس از '
                      'تأیید حقوقی، اتصال درگاه رسمی و ثبت امن تراکنش‌ها در سرور انجام می‌شود.',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _muted, fontSize: 11, height: 1.9),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _informationBox({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF14261B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x556A7B58)),
      ),
      child: Row(
        children: [
          Icon(icon, color: _gold, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    color: _cream, fontSize: 12, height: 1.7)),
          ),
        ],
      ),
    );
  }
}

class _WalletGame {
  const _WalletGame(this.title, this.price);
  final String title;
  final String price;
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.fa, this.en);
  final String fa;
  final String en;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(en,
              style: const TextStyle(
                  color: Color(0xFFE8C36A),
                  fontSize: 10,
                  letterSpacing: 1.4)),
          const Spacer(),
          Flexible(
            child: Text(fa,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    color: Color(0xFFF2EDE0),
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          ),
        ],
      );
}
