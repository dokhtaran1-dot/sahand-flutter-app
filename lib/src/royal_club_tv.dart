import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// The RC home-screen television.
/// Add assets/videos/rc_tv.mp4 when the club's film is ready.
/// Until then, this displays a branded, polished standby screen.
class RoyalClubTv extends StatefulWidget {
  const RoyalClubTv({super.key});

  @override
  State<RoyalClubTv> createState() => _RoyalClubTvState();
}

class _RoyalClubTvState extends State<RoyalClubTv>
    with WidgetsBindingObserver {
  static const _gold = Color(0xFFE8C36A);
  static const _videoAsset = 'assets/videos/rc_tv.mp4';

  VideoPlayerController? _video;
  bool _ready = false;
  bool _pausedByUser = false;
  bool _muted = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _prepareVideo();
  }

  Future<void> _prepareVideo() async {
    final candidate = VideoPlayerController.asset(_videoAsset);
    _video = candidate;

    try {
      await candidate.initialize();
      await candidate.setLooping(true);
      await candidate.setVolume(0);
      if (!mounted || _video != candidate) {
        await candidate.dispose();
        return;
      }
      setState(() => _ready = true);
      await candidate.play();
    } catch (_) {
      // The video is optional. Do not crash or show the broken video icon.
      if (mounted && _video == candidate) {
        setState(() {
          _ready = false;
          _video = null;
        });
      }
      await candidate.dispose();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _video;
    if (!_ready || controller == null) return;
    if (state == AppLifecycleState.resumed) {
      if (!_pausedByUser) controller.play();
    } else {
      controller.pause();
    }
  }

  void _togglePlayback() {
    final controller = _video;
    if (!_ready || controller == null) return;
    setState(() => _pausedByUser = controller.value.isPlaying);
    if (_pausedByUser) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  void _toggleMute() {
    final controller = _video;
    if (!_ready || controller == null) return;
    setState(() => _muted = !_muted);
    controller.setVolume(_muted ? 0 : 1);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _video?.dispose();
    super.dispose();
  }

  Widget _screen() {
    final controller = _video;
    if (_ready && controller != null && controller.value.isInitialized) {
      final size = controller.value.size;
      return ClipRect(
        child: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: size.width > 0 ? size.width : 1920,
              height: size.height > 0 ? size.height : 1080,
              child: VideoPlayer(controller),
            ),
          ),
        ),
      );
    }

    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -.3),
          radius: 1.2,
          colors: [
            Color(0xFF3B2515),
            Color(0xFF1B0E12),
            Color(0xFF040404),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.workspace_premium_rounded, color: _gold, size: 74),
            SizedBox(height: 8),
            Text(
              'ROYAL CLUB TV',
              style: TextStyle(
                color: _gold,
                fontSize: 33,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'EXCLUSIVE • ENTERTAINMENT • REWARDS',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openFullscreen() async {
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: _gold, width: 1.8),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 6, 8, 6),
                child: Row(
                  children: [
                    const Icon(Icons.live_tv_outlined,
                        color: _gold, size: 23),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'ROYAL CLUB TV',
                        style: TextStyle(
                          color: _gold,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.3,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'بستن',
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      icon: const Icon(Icons.close_rounded,
                          color: _gold, size: 27),
                    ),
                  ],
                ),
              ),
              AspectRatio(aspectRatio: 16 / 9, child: _screen()),
              if (!_ready)
                const Padding(
                  padding: EdgeInsets.all(14),
                  child: Text(
                    'ویدیوی اختصاصی رویال کلاب به‌زودی اضافه می‌شود.',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (_ready)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        tooltip: _pausedByUser ? 'پخش' : 'توقف',
                        onPressed: _togglePlayback,
                        icon: Icon(
                          _pausedByUser
                              ? Icons.play_arrow_rounded
                              : Icons.pause_rounded,
                          color: _gold,
                          size: 31,
                        ),
                      ),
                      const SizedBox(width: 18),
                      IconButton(
                        tooltip: _muted ? 'روشن کردن صدا' : 'قطع صدا',
                        onPressed: _toggleMute,
                        icon: Icon(
                          _muted
                              ? Icons.volume_off_rounded
                              : Icons.volume_up_rounded,
                          color: _gold,
                          size: 28,
                        ),
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _openFullscreen,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: _gold, width: 4),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF9D7D44),
                Color(0xFF241810),
                Color(0xFFE8C36A),
                Color(0xFF3A2818),
              ],
            ),
            boxShadow: const [
              BoxShadow(color: Color(0x558F682A), blurRadius: 28),
            ],
          ),
          padding: const EdgeInsets.all(11),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              children: [
                Expanded(child: _screen()),
                Container(
                  height: 45,
                  color: const Color(0xFF090807),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.live_tv_outlined, color: _gold, size: 23),
                      SizedBox(width: 12),
                      Text('RC TV',
                          style: TextStyle(
                            color: _gold,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3,
                          )),
                      SizedBox(width: 12),
                      Icon(Icons.open_in_full_rounded,
                          color: _gold, size: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
