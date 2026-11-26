import 'dart:math' as math;
import 'package:flutter/material.dart';

class PhotoOrbit extends StatefulWidget {
  final List<String> images;
  final List<String> labels;
  final ValueChanged<int> onSelected;
  final String center;
  final String? centerImage;
  final VoidCallback? onCenterSelected;
  final List<String>? fallbackImages;
  const PhotoOrbit({super.key, required this.images, required this.labels,
    required this.onSelected, this.center = 'RV', this.centerImage,
    this.onCenterSelected, this.fallbackImages});
  @override
  State<PhotoOrbit> createState() => _PhotoOrbitState();
}

class _PhotoOrbitState extends State<PhotoOrbit> with SingleTickerProviderStateMixin {
  static const gold = Color(0xFFE7C77D);
  late final AnimationController orbit = AnimationController(vsync: this, duration: const Duration(seconds: 90));
  double dragOffset = 0;
  bool paused = false;
  @override
  void didChangeDependencies() { super.didChangeDependencies(); updateMotion(); }
  void updateMotion() {
    if (paused || MediaQuery.of(context).disableAnimations) { orbit.stop(); }
    else if (!orbit.isAnimating) { orbit.repeat(); }
  }
  @override
  void dispose() { orbit.dispose(); super.dispose(); }

  Widget photo(String path, [String? fallback]) => Image.asset(path,
    fit: BoxFit.cover, filterQuality: FilterQuality.high,
    errorBuilder: (_, __, ___) => fallback == null
      ? const ColoredBox(color: Color(0xFF10291D), child: Center(child: Icon(Icons.photo_outlined, color: gold)))
      : Image.asset(fallback, fit: BoxFit.cover, filterQuality: FilterQuality.high));

  Widget disc(double diameter, Widget child, {double border = 2}) => Container(
    width: diameter, height: diameter,
    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: gold, width: border),
      boxShadow: const [BoxShadow(color: Color(0x55D6B15E), blurRadius: 12)]),
    child: ClipOval(child: child));

  @override
  Widget build(BuildContext context) => Column(children: [
    LayoutBuilder(builder: (context, box) {
      final w = math.min(box.maxWidth, 620.0);
      final h = w * 1.22;
      final d = w * .225;
      final centerD = w * .40;
      final rx = (w - d) / 2 - 4;
      final ry = h * .37;
      return Center(child: SizedBox(width: w, height: h, child: GestureDetector(
        onHorizontalDragStart: (_) => orbit.stop(),
        onHorizontalDragUpdate: (details) => setState(() => dragOffset += details.delta.dx * .008),
        onHorizontalDragEnd: (_) => updateMotion(),
        onHorizontalDragCancel: updateMotion,
        child: AnimatedBuilder(animation: orbit, builder: (_, __) => Stack(alignment: Alignment.center, children: [
          Container(width: rx * 2, height: ry * 2, decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.elliptical(rx, ry)),
            border: Border.all(color: const Color(0x887F7048)))),
          Semantics(button: widget.onCenterSelected != null, label: widget.center,
            child: GestureDetector(onTap: widget.onCenterSelected, child: disc(centerD,
              Stack(fit: StackFit.expand, children: [
                if (widget.centerImage != null) photo(widget.centerImage!) else const ColoredBox(color: Color(0xFF0B3C30)),
                const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(
                  begin: Alignment.center, end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xEE03120E)]))),
                Align(alignment: const Alignment(0, .62), child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: FittedBox(fit: BoxFit.scaleDown, child: Text(widget.center.toUpperCase(),
                    style: TextStyle(color: gold, fontFamily: 'serif', fontSize: centerD * .105, fontWeight: FontWeight.bold))))),
              ]), border: 3))),
          for (var i = 0; i < widget.images.length; i++)
            Positioned(
              left: w / 2 + math.cos(orbit.value * 2 * math.pi + dragOffset + i * 2 * math.pi / widget.images.length - math.pi / 2) * rx - d / 2,
              top: h / 2 + math.sin(orbit.value * 2 * math.pi + dragOffset + i * 2 * math.pi / widget.images.length - math.pi / 2) * ry - d / 2,
              width: d, height: d + 30,
              child: Semantics(button: true, label: widget.labels[i], child: Tooltip(message: widget.labels[i],
                child: GestureDetector(onTap: () => widget.onSelected(i), child: Column(children: [
                  disc(d, photo(widget.images[i], widget.fallbackImages?[i])),
                  const SizedBox(height: 3),
                  Text(widget.labels[i].replaceFirst('Salon ', '').replaceFirst('RV Lounge Impérial Classique', 'RV Lounge'),
                    maxLines: 2, textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'serif', fontSize: w * .030, color: gold)),
                ])))),
            ),
        ])),
      )));
    }),
    TextButton.icon(onPressed: () { setState(() => paused = !paused); updateMotion(); },
      style: TextButton.styleFrom(foregroundColor: gold), icon: Icon(paused ? Icons.play_arrow : Icons.pause),
      label: Text(paused ? 'ادامهٔ چرخش' : 'توقف چرخش')),
    const Text('برای مشاهده لمس کنید · برای چرخاندن بکشید', textDirection: TextDirection.rtl,
      style: TextStyle(color: Color(0xFFCBBF9E), fontSize: 12)),
  ]);
}
