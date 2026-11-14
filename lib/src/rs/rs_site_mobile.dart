import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RsSiteView extends StatefulWidget {
  const RsSiteView({super.key});
  @override
  State<RsSiteView> createState() => _RsSiteViewState();
}
class _RsSiteViewState extends State<RsSiteView> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _failed = false;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF090C0A))
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) {
          if (mounted) setState(() => _loading = false);
        },
        onWebResourceError: (error) {
          if (mounted && error.isForMainFrame == true) {
            setState(() { _failed = true; _loading = false; });
          }
        },
        onNavigationRequest: (request) {
          final uri = Uri.tryParse(request.url);
          if (uri == null) return NavigationDecision.prevent;
          if (const ['file', 'about', 'data'].contains(uri.scheme) ||
              (uri.scheme == 'https' &&
                  uri.host == 'appassets.androidplatform.net')) {
            return NavigationDecision.navigate;
          }
          if (uri.scheme == 'https' && uri.host == 'wa.me') {
            launchUrl(uri, mode: LaunchMode.externalApplication);
          }
          return NavigationDecision.prevent;
        },
      ))
      ..loadFlutterAsset('assets/rs/index.html');
  }
  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return Center(child: TextButton(
        onPressed: () => _controller.loadFlutterAsset('assets/rs/index.html'),
        child: const Text('بارگذاری دوباره RS'),
      ));
    }
    return Stack(children: [
      WebViewWidget(controller: _controller),
      if (_loading) const Positioned(top: 0, left: 0, right: 0,
        child: LinearProgressIndicator(color: Color(0xFFDFC189))),
    ]);
  }
}
