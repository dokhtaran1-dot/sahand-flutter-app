import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'pages/branches_page.dart';
import 'pages/brands_page.dart';
import 'pages/contact_page.dart';
import 'pages/consortium_page.dart';
import 'pages/governance_page.dart';
import 'pages/home_page.dart';
import 'pages/investor_page.dart';
import 'pages/packages_page.dart';
import 'pages/payment_page.dart';
import 'pages/payment_success_page.dart';
import 'pages/profile_page.dart';
import 'pages/request_form_page.dart';
import 'pages/requests_page.dart';
import 'pages/splash_page.dart';
import 'theme/app_theme.dart';

class SahandApp extends StatelessWidget {
  const SahandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'حامد قنبری | کنسرسیوم سهند',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      locale: const Locale('fa', 'IR'),
      supportedLocales: const [
        Locale('fa', 'IR'),
        Locale('en', 'US'),
        Locale('ar', 'AE'),
      ],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      initialRoute: SplashPage.routeName,
      routes: {
        SplashPage.routeName: (_) => const SplashPage(),
        HomePage.routeName: (_) => const HomePage(),
        ProfilePage.routeName: (_) => const ProfilePage(),
        ConsortiumPage.routeName: (_) => const ConsortiumPage(),
        BranchesPage.routeName: (_) => const BranchesPage(),
        BrandsPage.routeName: (_) => const BrandsPage(),
        GovernancePage.routeName: (_) => const GovernancePage(),
        PackagesPage.routeName: (_) => const PackagesPage(),
        RequestFormPage.routeName: (_) => const RequestFormPage(),
        PaymentPage.routeName: (_) => const PaymentPage(),
        PaymentSuccessPage.routeName: (_) => const PaymentSuccessPage(),
        ContactPage.routeName: (_) => const ContactPage(),
        InvestorPage.routeName: (_) => const InvestorPage(),
        RequestsPage.routeName: (_) => const RequestsPage(),
      },
    );
  }
}
