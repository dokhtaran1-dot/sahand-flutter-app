import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// RE within Royal One. The original, user-approved full standalone HTML is
/// bundled locally (assets/re/index.html). It retains its 9 embedded pictures,
/// RTL typography, services, gallery, and the 3600 m² two-storey mall section.
/// No external server or live image URL is needed to render the mini-site.
class EttehadPage extends StatefulWidget {
  const EttehadPage({super.key});

  @override
  State<EttehadPage> createState() => _EttehadPageState();
}

class _EttehadPageState extends State<EttehadPage> {
  static const gold = Color(0xFFD6B15E);
  static const deep = Color(0xFF041B15);
  static const site = 'assets/re/index.html';

  WebViewController? _web;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadOriginalSite();
  }

  Future<void> _loadOriginalSite() async {
    try {
      var html = await rootBundle.loadString(site);
      if (!html.contains('مسعود اتحادنژاد') ||
          !html.contains('۳۶۰۰') ||
          !html.contains('data:image/webp;base64,')) {
        throw const FormatException('The bundled RE mini-site is incomplete');
      }

      // Android WebView's data: origin may not support navigator.clipboard.
      // Copy is therefore delegated to Flutter without changing the UI.
      html = html.replaceFirst(
        'await navigator.clipboard.writeText(request);',
        'REClipboard.postMessage(request);',
      );
      final web = WebViewController();
      await web.setJavaScriptMode(JavaScriptMode.unrestricted);
      await web.setBackgroundColor(deep);
      await web.addJavaScriptChannel('REClipboard',
        onMessageReceived: (message) async {
          await Clipboard.setData(ClipboardData(text: message.message));
        });
      await web.setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) {
          if (mounted) setState(() => _loading = false);
        },
        onNavigationRequest: (request) {
          final uri = Uri.tryParse(request.url);
          if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
            _openOfficialUrl(uri);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ));
      if (!mounted) return;
      setState(() => _web = web);
      await web.loadHtmlString(html);
    } catch (_) {
      // Keep the RE page useful if WebView isn't available on the device.
      if (!mounted) return;
      setState(() {
        _error = 'نمایشگر داخلی در دسترس نیست. اطلاعات RE در این صفحه قابل مشاهده است.';
        _loading = false;
      });
    }
  }

  Future<void> _openOfficialUrl(Uri uri) async {
    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        return;
      }
    } catch (_) {}
    if (!mounted) return;
    await Clipboard.setData(ClipboardData(text: uri.toString()));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لینک وب‌سایت رسمی کپی شد.')));
    }
  }

  void _showProjects() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: deep,
      builder: (_) => SafeArea(child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 30),
        child: Column(mainAxisSize: MainAxisSize.min, children: const [
          Text('پروژه‌های اتحاد سازه رویال',
              style: TextStyle(color: gold, fontSize: 21)),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.apartment_rounded, color: gold),
            title: Text('پروژه تجاری ۳۶۰۰ مترمربع رویال مال',
                style: TextStyle(color: Colors.white)),
            subtitle: Text('دو طبقه تجاری در رویال مال تبریز',
                style: TextStyle(color: Colors.white70)),
          ),
          SizedBox(height: 15),
          Text('وضعیت اجرا و تصاویر مستند پس از تأیید مدارک پروژه اضافه می‌شوند.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, height: 1.6)),
        ]),
      )),
    );
  }

  void _showConsultation() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: deep,
      builder: (sheet) => SafeArea(child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 30),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('درخواست مشاوره',
              style: TextStyle(color: gold, fontSize: 21)),
          const SizedBox(height: 18),
          const Text(
            'ثبت آنلاین درخواست مشاوره در این نسخه فعال نیست. برای پیگیری از مسیر رسمی کنسرسیوم سهند استفاده کنید.',
            style: TextStyle(color: Colors.white, height: 1.7),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          SizedBox(width: double.infinity, child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: gold, foregroundColor: deep),
            onPressed: () => _openOfficialUrl(
              Uri.parse('https://sahand-consortium.com/')),
            icon: const Icon(Icons.open_in_new),
            label: const Text('وب‌سایت رسمی کنسرسیوم'),
          )),
        ]),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final web = _web;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: deep,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: deep,
          foregroundColor: gold,
          title: const Text('RE | اتحاد سازه رویال',
              style: TextStyle(fontSize: 17)),
          actions: [
            IconButton(
              tooltip: 'بازخوانی مینی‌سایت',
              icon: const Icon(Icons.refresh),
              onPressed: web == null ? null : web.reload,
            ),
          ],
        ),
        body: Stack(children: [
          if (web != null)
            WebViewWidget(key: const ValueKey('re-original-minisite'), controller: web)
          else
            _localFallback(),
          if (_loading)
            const Center(
              child: Text('در حال آماده‌سازی مینی‌سایت RE…',
                textDirection: TextDirection.rtl,
                style: TextStyle(color: gold, fontSize: 15)),
            ),
        ]),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 7, 12, 12),
            child: Row(children: [
              Expanded(child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: gold, foregroundColor: deep),
                onPressed: _showProjects,
                icon: const Icon(Icons.apartment),
                label: const Text('مشاهده پروژه‌ها'),
              )),
              const SizedBox(width: 10),
              Expanded(child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: gold, side: const BorderSide(color: gold)),
                onPressed: _showConsultation,
                icon: const Icon(Icons.handshake_outlined),
                label: const Text('درخواست مشاوره'),
              )),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _localFallback() => ListView(
    padding: const EdgeInsets.all(25),
    children: [
      const SizedBox(height: 24),
      Image.asset('assets/image/monogram_re.webp', height: 150,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.architecture, size: 100, color: gold)),
      const SizedBox(height: 20),
      const Text('اتحاد سازه رویال', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 26, color: gold)),
      const Text('مسعود اتحادنژاد',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 21, color: Colors.white)),
      const SizedBox(height: 15),
      const Text('طراحی، ساخت، اجرا و مدیریت پروژه‌های ساختمانی',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white70, height: 1.8)),
      const SizedBox(height: 20),
      if (_error != null)
        Text(_error!, textAlign: TextAlign.center,
            style: const TextStyle(color: gold)),
      const SizedBox(height: 25),
      const Text('توسعه ۳۶۰۰ مترمربع فضای تجاری در دو طبقه رویال مال تبریز',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, height: 1.8)),
      const SizedBox(height: 20),
      const Text('برای مشاهده تصاویر و گالری کامل، نسخه داخلی وب را باز کنید.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white54)),
    ],
  );
}
