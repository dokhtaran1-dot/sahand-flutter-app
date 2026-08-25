import 'package:flutter/material.dart';

class EttehadPage extends StatelessWidget {
  const EttehadPage({super.key});

  static const gold = Color(0xFFD6B15E);
  static const dark = Color(0xFF05070A);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
        backgroundColor: dark,
        body: SafeArea(
        child: CustomScrollView(
        slivers: [
        SliverAppBar(
        backgroundColor: dark,
        foregroundColor: gold,
        pinned: true,
        expandedHeight: 330,
        flexibleSpace: FlexibleSpaceBar(
        background: Container(
        decoration: const BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
        Color(0xFF15181B),
    Color(0xFF05070A),
    ],
    ),
    ),
    child: Padding(
    padding: const EdgeInsets.fromLTRB(30, 45, 30, 20),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Expanded(
    child: Image.asset(
    'assets/image/ettehad_logo.png',
    fit: BoxFit.contain,
    errorBuilder: (_, __, ___) {
    return const Icon(
    Icons.architecture_rounded,
    size: 120,
    color: gold,
    );
    },
    ),
    ),
    const SizedBox(height: 12),
    const Text(
    'ETTEHAD SAZEH ROYAL',
    textDirection: TextDirection.ltr,
    style: TextStyle(
    color: gold,
    fontSize: 21,
    fontWeight: FontWeight.w700,
    letterSpacing: 2,
    ),
    ),
    const SizedBox(height: 7),
    const Text(
    'اتحاد سازه رویال',
    style: TextStyle(
    color: Colors.white,
    fontSize: 25,
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    ),

    SliverPadding(
    padding: const EdgeInsets.all(18),
    sliver: SliverList(
    delegate: SliverChildListDelegate([
    const Text(
    'طراحی، مشاوره، مدیریت و اجرای پروژه‌های ساختمانی خاص',
    textAlign: TextAlign.center,
    style: TextStyle(
    color: Colors.white70,
    fontSize: 15,
    height: 1.8,
    ),
    ),

    const SizedBox(height: 24),

    _luxuryCard(
    title: 'دکتر مسعود نژاد اتحاد',
    subtitle: 'مشاور ارشد ساخت‌وساز و مدیریت پروژه',
    icon: Icons.engineering_rounded,
    ),

    const SizedBox(height: 18),

    const Text(
    'خدمات تخصصی',
    style: TextStyle(
    color: gold,
    fontSize: 21,
    fontWeight: FontWeight.bold,
    ),
    ),

      const SizedBox(height: 12),

      _service('طراحی و بازطراحی پروژه‌ها'),
      _service('ساخت و اجرای پروژه‌های ساختمانی'),
      _service('بازسازی و احیای ساختمان'),
      _service('طراحی داخلی و طراحی نما'),
      _service('مدیریت و نظارت پروژه'),
      _service('مشاوره تخصصی ساخت‌وساز'),

      const SizedBox(height: 24),

      _luxuryCard(
        title: 'پروژه‌ها و طراحی‌ها',
        subtitle:
        'نمونه پروژه‌های اجراشده، طراحی‌ها، تصاویر قبل و بعد و معرفی جزئیات هر پروژه',
        icon: Icons.apartment_rounded,
      ),

      const SizedBox(height: 24),

      _goldButton(
        context,
        title: 'مشاهده پروژه‌ها',
        icon: Icons.photo_library_rounded,
      ),

      const SizedBox(height: 12),

      _outlineButton(
        context,
        title: 'درخواست مشاوره',
        icon: Icons.handshake_rounded,
      ),

      const SizedBox(height: 35),

      const Center(
        child: Text(
          'ETTEHAD SAZEH ROYAL',
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Colors.white38,
            fontSize: 11,
            letterSpacing: 2,
          ),
        ),
      ),

      const SizedBox(height: 20),
    ]),
    ),
    ),
        ],
        ),
        ),
        ),
    );
  }

  static Widget _service(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(
            Icons.diamond_outlined,
            color: gold,
            size: 19,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _luxuryCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
        padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
    gradient: const LinearGradient(
    colors: [
    Color(0xFF15191E),
    Color(0xFF090C10),
    ],
    ),
    borderRadius: BorderRadius.circular(22),
    border: Border.all(
    color: gold,
    width: 1,
    ),
    ),
    child: Row(
    children: [
    Container(
    width: 58,
    height: 58,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: gold),
    ),
    child: Icon(
    icon,
    color: gold,
    size: 29,
    ),
    ),
    const SizedBox(width: 15),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    title,
    style: const TextStyle(
    color: gold,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 6),
    Text(
    subtitle,
    style: const TextStyle(
    color: Colors.white70,
    fontSize: 13,
    height: 1.6,
    ),
    ),
    ],ght: FontWeight.bold,
    ),
    ),

      const SizedBox(height: 12),

      _service('طراحی و بازطراحی پروژه‌ها'),
      _service('ساخت و اجرای پروژه‌های ساختمانی'),
      _service('بازسازی و احیای ساختمان'),
      _service('طراحی داخلی و طراحی نما'),
      _service('مدیریت و نظارت پروژه'),
      _service('مشاوره تخصصی ساخت‌وساز'),

      const SizedBox(height: 24),

      _luxuryCard(
        title: 'پروژه‌ها و طراحی‌ها',
        subtitle:
        'نمونه پروژه‌های اجراشده، طراحی‌ها، تصاویر قبل و بعد و معرفی جزئیات هر پروژه',
        icon: Icons.apartment_rounded,
      ),

      const SizedBox(height: 24),

      _goldButton(
        context,
        title: 'مشاهده پروژه‌ها',
        icon: Icons.photo_library_rounded,
      ),

      const SizedBox(height: 12),

      _outlineButton(
        context,
        title: 'درخواست مشاوره',
        icon: Icons.handshake_rounded,
      ),

      const SizedBox(height: 35),

      const Center(
        child: Text(
          'ETTEHAD SAZEH ROYAL',
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Colors.white38,
            fontSize: 11,
            letterSpacing: 2,
          ),
        ),
      ),

      const SizedBox(height: 20),
    ]),
    ),
    ),
    ],
    ),
    ),
    ),
    );
  }

  static Widget _service(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(
            Icons.diamond_outlined,
            color: gold,
            size: 19,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _luxuryCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
        padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
    gradient: const LinearGradient(
    colors: [
    Color(0xFF15191E),
    Color(0xFF090C10),
    ],
    ),
    borderRadius: BorderRadius.circular(22),
    border: Border.all(
    color: gold,
    width: 1,
    ),
    ),
    child: Row(
    children: [
    Container(
    width: 58,
    height: 58,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: gold),
    ),
    child: Icon(
    icon,
    color: gold,
    size: 29,
    ),
    ),
    const SizedBox(width: 15),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    title,
    style: const TextStyle(
    color: gold,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 6),
    Text(
    subtitle,
    style: const TextStyle(
    color: Colors.white70,
    fontSize: 13,
    height: 1.6,
    ),
    ),
    ],ght: FontWeight.bold,
    ),
    ),

      const SizedBox(height: 12),

      _service('طراحی و بازطراحی پروژه‌ها'),
      _service('ساخت و اجرای پروژه‌های ساختمانی'),
      _service('بازسازی و احیای ساختمان'),
      _service('طراحی داخلی و طراحی نما'),
      _service('مدیریت و نظارت پروژه'),
      _service('مشاوره تخصصی ساخت‌وساز'),

      const SizedBox(height: 24),

      _luxuryCard(
        title: 'پروژه‌ها و طراحی‌ها',
        subtitle:
        'نمونه پروژه‌های اجراشده، طراحی‌ها، تصاویر قبل و بعد و معرفی جزئیات هر پروژه',
        icon: Icons.apartment_rounded,
      ),

      const SizedBox(height: 24),

      _goldButton(
        context,
        title: 'مشاهده پروژه‌ها',
        icon: Icons.photo_library_rounded,
      ),

      const SizedBox(height: 12),

      _outlineButton(
        context,
        title: 'درخواست مشاوره',
        icon: Icons.handshake_rounded,
      ),

      const SizedBox(height: 35),

      const Center(
        child: Text(
          'ETTEHAD SAZEH ROYAL',
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Colors.white38,
            fontSize: 11,
            letterSpacing: 2,
          ),
        ),
      ),

      const SizedBox(height: 20),
    ]),
    ),
    ),
    ],
    ),
    ),
    ),
    );
  }

  static Widget _service(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(
            Icons.diamond_outlined,
            color: gold,
            size: 19,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _luxuryCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
        padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
    gradient: const LinearGradient(
    colors: [
    Color(0xFF15191E),
    Color(0xFF090C10),
    ],
    ),
    borderRadius: BorderRadius.circular(22),
    border: Border.all(
    color: gold,
    width: 1,
    ),
    ),
    child: Row(
    children: [
    Container(
    width: 58,
    height: 58,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: gold),
    ),
    child: Icon(
    icon,
    color: gold,
    size: 29,
    ),
    ),
    const SizedBox(width: 15),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    title,
    style: const TextStyle(
    color: gold,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 6),
    Text(
    subtitle,
    style: const TextStyle(
    color: Colors.white70,
    fontSize: 13,
    height: 1.6,
    ),
    ),
    ],
      ght: FontWeight.bold,
    ),
    ),

      const SizedBox(height: 12),

      _service('طراحی و بازطراحی پروژه‌ها'),
      _service('ساخت و اجرای پروژه‌های ساختمانی'),
      _service('بازسازی و احیای ساختمان'),
      _service('طراحی داخلی و طراحی نما'),
      _service('مدیریت و نظارت پروژه'),
      _service('مشاوره تخصصی ساخت‌وساز'),

      const SizedBox(height: 24),

      _luxuryCard(
        title: 'پروژه‌ها و طراحی‌ها',
        subtitle:
        'نمونه پروژه‌های اجراشده، طراحی‌ها، تصاویر قبل و بعد و معرفی جزئیات هر پروژه',
        icon: Icons.apartment_rounded,
      ),

      const SizedBox(height: 24),

      _goldButton(
        context,
        title: 'مشاهده پروژه‌ها',
        icon: Icons.photo_library_rounded,
      ),

      const SizedBox(height: 12),

      _outlineButton(
        context,
        title: 'درخواست مشاوره',
        icon: Icons.handshake_rounded,
      ),

      const SizedBox(height: 35),

      const Center(
        child: Text(
          'ETTEHAD SAZEH ROYAL',
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Colors.white38,
            fontSize: 11,
            letterSpacing: 2,
          ),
        ),
      ),

      const SizedBox(height: 20),
    ]),
    ),
    ),
    ],
    ),
    ),
    ),
    );
  }

  static Widget _service(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(
            Icons.diamond_outlined,
            color: gold,
            size: 19,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _luxuryCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
        padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
    gradient: const LinearGradient(
    colors: [
    Color(0xFF15191E),
    Color(0xFF090C10),
    ],
    ),
    borderRadius: BorderRadius.circular(22),
    border: Border.all(
    color: gold,
    width: 1,
    ),
    ),
    child: Row(
    children: [
    Container(
    width: 58,
    height: 58,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: gold),
    ),
    child: Icon(
    icon,
    color: gold,
    size: 29,
    ),
    ),
    const SizedBox(width: 15),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    title,
    style: const TextStyle(
    color: gold,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 6),
    Text(
    subtitle,
    style: const TextStyle(
    color: Colors.white70,
    fontSize: 13,
    height: 1.6,
    ),
    ),
    ],),
    ),
    ],
    ),
    );
  }

  static Widget _goldButton(
      BuildContext context, {
        required String title,
        required IconData icon,
      }) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title به‌زودی فعال می‌شود')),
          );
        },
        icon: Icon(icon),
        label: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  static Widget _outlineButton(
      BuildContext context, {
        required String title,
        required IconData icon,
      }) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: OutlinedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title به‌زودی فعال می‌شود')),
          );
        },
        icon: Icon(icon),
        label: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: gold,
          side: const BorderSide(color: gold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}),
),
],
),
);
}

static Widget _goldButton(
BuildContext context, {
required String title,
required IconData icon,
}) {
return SizedBox(
width: double.infinity,
height: 58,
child: ElevatedButton.icon(
onPressed: () {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text('$title به‌زودی فعال می‌شود')),
);
},
icon: Icon(icon),
label: Text(
title,
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
style: ElevatedButton.styleFrom(
backgroundColor: gold,
foregroundColor: Colors.black,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(18),
),
),
),
);
}

static Widget _outlineButton(
BuildContext context, {
required String title,
required IconData icon,
}) {
return SizedBox(
width: double.infinity,
height: 58,
child: OutlinedButton.icon(
onPressed: () {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text('$title به‌زودی فعال می‌شود')),
);
},
icon: Icon(icon),
label: Text(
title,
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
style: OutlinedButton.styleFrom(
foregroundColor: gold,
side: const BorderSide(color: gold),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(18),
),
),
),
);
}
}import 'package:flutter/material.dart';

class EttehadPage extends StatelessWidget {
  const EttehadPage({super.key});

  static const gold = Color(0xFFD6B15E);
  static const dark = Color(0xFF05070A);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
        backgroundColor: dark,
        body: SafeArea(
        child: CustomScrollView(
        slivers: [
        SliverAppBar(
        backgroundColor: dark,
        foregroundColor: gold,
        pinned: true,
        expandedHeight: 330,
        flexibleSpace: FlexibleSpaceBar(
        background: Container(
        decoration: const BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
        Color(0xFF15181B),
    Color(0xFF05070A),
    ],
    ),
    ),
    child: Padding(
    padding: const EdgeInsets.fromLTRB(30, 45, 30, 20),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Expanded(
    child: Image.asset(
    'assets/image/ettehad_logo.png',
    fit: BoxFit.contain,
    errorBuilder: (_, __, ___) {
    return const Icon(
    Icons.architecture_rounded,
    size: 120,
    color: gold,
    );
    },
    ),
    ),
    const SizedBox(height: 12),
    const Text(
    'ETTEHAD SAZEH ROYAL',
    textDirection: TextDirection.ltr,
    style: TextStyle(
    color: gold,
    fontSize: 21,
    fontWeight: FontWeight.w700,
    letterSpacing: 2,
    ),
    ),
    const SizedBox(height: 7),
    const Text(
    'اتحاد سازه رویال',
    style: TextStyle(
    color: Colors.white,
    fontSize: 25,
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    ),

    SliverPadding(
    padding: const EdgeInsets.all(18),
    sliver: SliverList(
    delegate: SliverChildListDelegate([
    const Text(
    'طراحی، مشاوره، مدیریت و اجرای پروژه‌های ساختمانی خاص',
    textAlign: TextAlign.center,
    style: TextStyle(
    color: Colors.white70,
    fontSize: 15,
    height: 1.8,
    ),
    ),

    const SizedBox(height: 24),

    _luxuryCard(
    title: 'دکتر مسعود نژاد اتحاد',
    subtitle: 'مشاور ارشد ساخت‌وساز و مدیریت پروژه',
    icon: Icons.engineering_rounded,
    ),

    const SizedBox(height: 18),

    const Text(
    'خدمات تخصصی',
    style: TextStyle(
    color: gold,
    fontSize: 21,
    fontWeight: FontWeight.bold,
    ),
    ),

      const SizedBox(height: 12),

      _service('طراحی و بازطراحی پروژه‌ها'),
      _service('ساخت و اجرای پروژه‌های ساختمانی'),
      _service('بازسازی و احیای ساختمان'),
      _service('طراحی داخلی و طراحی نما'),
      _service('مدیریت و نظارت پروژه'),
      _service('مشاوره تخصصی ساخت‌وساز'),

      const SizedBox(height: 24),

      _luxuryCard(
        title: 'پروژه‌ها و طراحی‌ها',
        subtitle:
        'نمونه پروژه‌های اجراشده، طراحی‌ها، تصاویر قبل و بعد و معرفی جزئیات هر پروژه',
        icon: Icons.apartment_rounded,
      ),

      const SizedBox(height: 24),

      _goldButton(
        context,
        title: 'مشاهده پروژه‌ها',
        icon: Icons.photo_library_rounded,
      ),

      const SizedBox(height: 12),

      _outlineButton(
        context,
        title: 'درخواست مشاوره',
        icon: Icons.handshake_rounded,
      ),

      const SizedBox(height: 35),

      const Center(
        child: Text(
          'ETTEHAD SAZEH ROYAL',
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Colors.white38,
            fontSize: 11,
            letterSpacing: 2,
          ),
        ),
      ),

      const SizedBox(height: 20),
    ]),
    ),
    ),
        ],
        ),
        ),
        ),
    );
  }

  static Widget _service(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(
            Icons.diamond_outlined,
            color: gold,
            size: 19,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _luxuryCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
        padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
    gradient: const LinearGradient(
    colors: [
    Color(0xFF15191E),
    Color(0xFF090C10),
    ],
    ),
    borderRadius: BorderRadius.circular(22),
    border: Border.all(
    color: gold,
    width: 1,
    ),
    ),
    child: Row(
    children: [
    Container(
    width: 58,
    height: 58,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: gold),
    ),
    child: Icon(
    icon,
    color: gold,
    size: 29,
    ),
    ),
    const SizedBox(width: 15),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    title,
    style: const TextStyle(
    color: gold,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 6),
    Text(
    subtitle,
    style: const TextStyle(
    color: Colors.white70,
    fontSize: 13,
    height: 1.6,
    ),
    ),
    ],),
    ),
    ],
    ),
    );
  }

  static Widget _goldButton(
      BuildContext context, {
        required String title,
        required IconData icon,
      }) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title به‌زودی فعال می‌شود')),
          );
        },
        icon: Icon(icon),
        label: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  static Widget _outlineButton(
      BuildContext context, {
        required String title,
        required IconData icon,
      }) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: OutlinedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title به‌زودی فعال می‌شود')),
          );
        },
        icon: Icon(icon),
        label: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: gold,
          side: const BorderSide(color: gold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}