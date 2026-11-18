import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';

/// Only manager-published, real source files in Supabase Storage are exposed.
/// A video is played with its original AAC track after an explicit user tap.
class RvMediaPage extends StatefulWidget {
  const RvMediaPage({super.key});
  @override
  State<RvMediaPage> createState() => _RvMediaPageState();
}

class _ApprovedMedia {
  const _ApprovedMedia(this.title, this.kind, this.url);
  final String title, kind, url;
}

class _RvMediaPageState extends State<RvMediaPage> {
  static const _bg = Color(0xFF06150F);
  static const _gold = Color(0xFFDFBD78);
  late Future<List<_ApprovedMedia>> items = _load();

  Future<List<_ApprovedMedia>> _load() async {
    const url = String.fromEnvironment('SUPABASE_URL');
    if (url.isEmpty) return const [];
    final db = Supabase.instance.client;
    final rows = await db.from('rv_media_assets')
      .select('title,kind,asset_path')
      .eq('published', true)
      .order('sort_order', ascending: true).limit(40);
    final bucket = db.storage.from('royal-one-media');
    return [
      for (final row in rows)
        _ApprovedMedia(
          row['title'] as String,
          row['kind'] as String,
          bucket.getPublicUrl(row['asset_path'] as String),
        ),
    ];
  }

  void _reload() => setState(() => items = _load());

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    appBar: AppBar(
      backgroundColor: _bg, foregroundColor: _gold,
      title: const Text('ROYAL VILLAGE / MEDIA'),
      actions: [IconButton(
        tooltip: 'به‌روزرسانی رسانه‌های رسمی',
        onPressed: _reload,
        icon: const Icon(Icons.refresh))],
    ),
    body: FutureBuilder<List<_ApprovedMedia>>(
      future: items,
      builder: (context, snapshot) {
        if (!snapshot.hasData && !snapshot.hasError) {
          return const Center(child: CircularProgressIndicator(color: _gold));
        }
        if (snapshot.hasError) {
          return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('دریافت رسانه‌های رسمی ممکن نیست.'),
            const SizedBox(height: 10),
            TextButton(onPressed: _reload, child: const Text('تلاش دوباره')),
          ]));
        }
        final media = snapshot.data ?? const [];
        if (media.isEmpty) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(25),
            child: Text('ویدیوی تأییدشده هنوز در سامانه رسانه بارگذاری نشده است. '
              'گالری سالن‌ها در بخش قبلی قابل مشاهده است.',
              textAlign: TextAlign.center, textDirection: TextDirection.rtl)));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(18), itemCount: media.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, i) {
            final item = media[i];
            return Card(
              color: const Color(0xFF12251A),
              child: ListTile(
                leading: Icon(item.kind == 'video'
                    ? Icons.play_circle_outline
                    : Icons.photo_library_outlined, color: _gold, size: 39),
                title: Text(item.title,
                  style: const TextStyle(color: _gold)),
                subtitle: Text(item.kind == 'video'
                    ? 'پخش ویدیوی رسمی با صدای اصلی'
                    : 'مشاهده عکس منتشرشده',
                  style: const TextStyle(color: Colors.white70)),
                trailing: const Icon(Icons.chevron_right, color: _gold),
                onTap: () => Navigator.push(context, MaterialPageRoute<void>(
                  builder: (_) => _MediaViewer(item: item))),
              ),
            );
          },
        );
      },
    ),
  );
}

class _MediaViewer extends StatefulWidget {
  const _MediaViewer({required this.item});
  final _ApprovedMedia item;
  @override
  State<_MediaViewer> createState() => _MediaViewerState();
}

class _MediaViewerState extends State<_MediaViewer> {
  VideoPlayerController? controller;
  bool loading = true;
  bool failed = false;

  @override
  void initState() {
    super.initState();
    if (widget.item.kind == 'video') _prepareVideo();
    else loading = false;
  }

  Future<void> _prepareVideo() async {
    final video = VideoPlayerController.networkUrl(Uri.parse(widget.item.url));
    try {
      await video.initialize();
      await video.setLooping(false);
      await video.setVolume(1.0);
      if (!mounted) { await video.dispose(); return; }
      setState(() { controller = video; loading = false; });
    } catch (_) {
      await video.dispose();
      if (mounted) setState(() { failed = true; loading = false; });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(backgroundColor: Colors.black,
      foregroundColor: const Color(0xFFDFBD78),
      title: Text(widget.item.title)),
    body: Center(child: failed
      ? const Text('پخش این رسانه ممکن نشد. اتصال اینترنت را بررسی کنید.')
      : loading
      ? const CircularProgressIndicator()
      : widget.item.kind == 'photo'
      ? InteractiveViewer(child: Image.network(widget.item.url,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Text('نمایش تصویر ممکن نشد.')))
      : controller == null
      ? const Text('ویدیو در دسترس نیست.')
      : Column(mainAxisSize: MainAxisSize.min, children: [
          AspectRatio(aspectRatio: controller!.value.aspectRatio,
            child: VideoPlayer(controller!)),
          VideoProgressIndicator(controller!, allowScrubbing: true),
          const SizedBox(height: 18),
          IconButton.filled(
            iconSize: 42,
            tooltip: controller!.value.isPlaying ? 'توقف ویدیو' : 'پخش با صدا',
            onPressed: () async {
              if (controller!.value.isPlaying) await controller!.pause();
              else {
                await controller!.setVolume(1.0);
                await controller!.play();
              }
              if (mounted) setState(() {});
            },
            icon: Icon(controller!.value.isPlaying
              ? Icons.pause_circle
              : Icons.play_circle),
          ),
          const Text('پخش با صدای اصلی؛ برای شروع لمس کنید',
            style: TextStyle(color: Colors.white70)),
        ]),
    ),
  );
}
