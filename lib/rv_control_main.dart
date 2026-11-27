import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

const _rvControlUrl = 'https://dokhtaran1-dot.github.io/sahand-flutter-app/';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF071913),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF071913),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const RvControlApp());
}

class RvControlApp extends StatelessWidget {
  const RvControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RV CONTROL',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF071913),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD7B777),
          brightness: Brightness.dark,
        ),
      ),
      home: const RvControlHome(),
    );
  }
}

class RvControlHome extends StatefulWidget {
  const RvControlHome({super.key});

  @override
  State<RvControlHome> createState() => _RvControlHomeState();
}

class _RvControlHomeState extends State<RvControlHome> {
  late final WebViewController _controller;
  int _progress = 0;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF071913))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) setState(() => _progress = progress);
          },
          onPageStarted: (_) {
            if (mounted) setState(() => _hasError = false);
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame == true && mounted) {
              setState(() => _hasError = true);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(_rvControlUrl));
  }

  Future<bool> _handleBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBack,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (_progress < 100)
                LinearProgressIndicator(
                  value: _progress / 100,
                  minHeight: 2,
                  color: const Color(0xFFD7B777),
                  backgroundColor: const Color(0xFF102B21),
                ),
              if (_hasError)
                ColoredBox(
                  color: const Color(0xFF071913),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'RV CONTROL',
                            style: TextStyle(
                              color: Color(0xFFD7B777),
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'اتصال به سامانه برقرار نشد. اینترنت را بررسی کنید و دوباره تلاش کنید.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, height: 1.8),
                          ),
                          const SizedBox(height: 18),
                          FilledButton(
                            onPressed: () {
                              setState(() => _hasError = false);
                              _controller.loadRequest(Uri.parse(_rvControlUrl));
                            },
                            child: const Text('تلاش دوباره'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
