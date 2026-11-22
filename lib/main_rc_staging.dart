import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'rc/rc_deal_staging_page.dart';

/// Isolated APK entry point; the published lib/main.dart is unchanged.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const url = String.fromEnvironment('SUPABASE_URL');
  const key = String.fromEnvironment('SUPABASE_ANON_KEY');
  if (url.isNotEmpty && key.isNotEmpty) {
    await Supabase.initialize(url: url, anonKey: key);
  }
  runApp(MaterialApp(
    title: 'Royal One RC TEST',
    debugShowCheckedModeBanner: true,
    theme: ThemeData.dark(useMaterial3: true),
    home: url.isEmpty || key.isEmpty
        ? const _SetupRequired()
        : const _AuthGate(),
  ));
}

class _SetupRequired extends StatelessWidget {
  const _SetupRequired();
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(child: Padding(
      padding: EdgeInsets.all(24),
      child: Text('RC TEST: Supabase test URL and anon key were not provided to the build. No wallet operations are enabled.',
        textAlign: TextAlign.center),
    )),
  );
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();
  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  final email = TextEditingController();
  final otp = TextEditingController();
  String message = 'با ایمیل حساب آزمایشی وارد شوید';
  bool busy = false;

  @override
  void dispose() {
    email.dispose();
    otp.dispose();
    super.dispose();
  }

  Future<void> run(Future<void> Function() action) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) setState(() => message = 'خطا: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF061B15),
    appBar: AppBar(title: const Text('ROYAL ONE · RC TEST')),
    body: StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (Supabase.instance.client.auth.currentUser != null) {
          return const RcDealStagingPage();
        }
        return Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: ListView(shrinkWrap: true, padding: const EdgeInsets.all(24), children: [
            const Text('نسخه آزمایشی · جوایز واقعی غیرفعال', textAlign: TextAlign.center),
            const SizedBox(height: 20),
            TextField(controller: email, keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'ایمیل حساب آزمایشی')),
            const SizedBox(height: 12),
            FilledButton(onPressed: busy ? null : () => run(() async {
              await Supabase.instance.client.auth.signInWithOtp(
                email: email.text.trim(), shouldCreateUser: false);
              if (mounted) setState(() => message = 'کد ورود ایمیل شد');
            }), child: const Text('ارسال کد')),
            const SizedBox(height: 14),
            TextField(controller: otp, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'کد ورود')),
            FilledButton(onPressed: busy ? null : () => run(() async {
              await Supabase.instance.client.auth.verifyOTP(
                email: email.text.trim(), token: otp.text.trim(),
                type: OtpType.email);
            }), child: const Text('ورود به نسخه آزمایشی')),
            Text(message, textAlign: TextAlign.center),
          ]),
        ));
      },
    ),
  );
}
