import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RhSiteView extends StatefulWidget {
  const RhSiteView({super.key});

  @override
  State<RhSiteView> createState() => _RhSiteViewState();
}

class _RhSiteViewState extends State<RhSiteView> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF07100E))
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
          if (uri != null &&
              (uri.scheme == 'file' || uri.scheme == 'about')) {
            return NavigationDecision.navigate;
          }
          if (uri != null &&
              const ['https', 'http', 'mailto', 'tel'].contains(uri.scheme)) {
            launchUrl(uri, mode: LaunchMode.externalApplication);
          }
          return NavigationDecision.prevent;
        },
      ));
    _load();
  }

  Future<void> _load() async {
    try {
      await _controller.loadFlutterAsset('assets/rh/index.html');
    } catch (_) {
      if (mounted) setState(() { _failed = true; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('نمایش RH بارگذاری نشد.',
              textDirection: TextDirection.rtl),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              setState(() { _failed = false; _loading = true; });
              _load();
            },
            child: const Text('تلاش دوباره'),
          ),
        ]),
      );
    }
    return Stack(children: [
      WebViewWidget(controller: _controller),
      if (_loading)
        const Positioned(
          top: 0, left: 0, right: 0,
          child: LinearProgressIndicator(
            color: Color(0xFFD9C493), backgroundColor: Color(0xFF07100E),
          ),
        ),
    ]);
  }
}
