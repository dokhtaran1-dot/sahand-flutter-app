import 'dart:math' as math;
import 'package:flutter/material.dart';

class PhotoOrbit extends StatefulWidget {
  final List<String> images;
  final List<String> labels;
  final ValueChanged<int> onSelected;
  final String center;
  const PhotoOrbit({super.key, required this.images, required this.labels, required this.onSelected, this.center = 'RV'});
  @override
  State<PhotoOrbit> createState() => _PhotoOrbitState();
}
class _PhotoOrbitState extends State<PhotoOrbit> with SingleTickerProviderStateMixin {
  late final AnimationController orbit = AnimationController(vsync: this, duration: const Duration(seconds: 90));
  double dragOffset = 0;
  bool paused = false;
  @override
  void didChangeDependencies() { super.didChangeDependencies(); updateMotion(); }
  void updateMotion() {
    if (paused || MediaQuery.of(context).disableAnimations) { orbit.stop(); } else { orbit.repeat(); }
  }
  @override
  void dispose() { orbit.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Column(children: [
    SizedBox(height: 450, child: LayoutBuilder(builder: (context, box) => GestureDetector(
      onHorizontalDragStart: (_) => orbit.stop(),
      onHorizontalDragUpdate: (d) => setState(() => dragOffset += d.delta.dx * .008),
      onHorizontalDragEnd: (_) => updateMotion(),
      onHorizontalDragCancel: updateMotion,
      child: SizedBox(width: box.maxWidth, height: 450, child: AnimatedBuilder(animation: orbit, builder: (_, __) => Stack(alignment: Alignment.center, children: [
        Container(width: box.maxWidth * .74, height: 310, decoration: BoxDecoration(borderRadius: BorderRadius.circular(200), border: Border.all(color: const Color(0x557F7048)))),
        Container(width: 132, height: 132, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const RadialGradient(colors: [Color(0xFF35735B), Color(0xFF0B3C30), Color(0xFF031B15)]), border: Border.all(color: const Color(0xFFF4D58D), width: 3), boxShadow: const [BoxShadow(color: Color(0x66D6B15E), blurRadius: 30, spreadRadius: 2), BoxShadow(color: Color(0x66000000), blurRadius: 20, offset: Offset(0, 8))]), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.diamond_outlined, size: 18, color: Color(0xFFF4D58D)), Text(widget.center, style: const TextStyle(fontFamily:'serif', fontSize: 49, fontWeight: FontWeight.bold, color: Color(0xFFFFE2A3), letterSpacing: 2)), const Text('ROYAL VILLAGE', style: TextStyle(fontSize: 8, letterSpacing: 1, color: Color(0xFFE7C77D)))])),
        for (var i = 0; i < widget.images.length; i++) Positioned(
          left: box.maxWidth / 2 + math.cos(orbit.value * 2 * math.pi + dragOffset + i * 2 * math.pi / widget.images.length) * (box.maxWidth / 2 - 57) - 49,
          top: 200 + math.sin(orbit.value * 2 * math.pi + dragOffset + i * 2 * math.pi / widget.images.length) * 150 - 49,
          width: 98, height: 120,
          child: Semantics(button: true, label: widget.labels[i], child: Tooltip(message: widget.labels[i], child: InkWell(
            borderRadius: BorderRadius.circular(49), onTap: () => widget.onSelected(i),
            child: Column(children: [
              Container(width: 88, height: 88, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFE7C77D), width: 2), boxShadow: const [BoxShadow(color: Color(0x444B8C63), blurRadius: 14)]), child: ClipOval(child: Image.asset(widget.images[i], fit: BoxFit.cover, alignment: Alignment.topCenter))),
              const SizedBox(height: 3),
              Text(widget.labels[i].replaceFirst('Salon ', '').replaceFirst('RV Lounge Impérial Classique', 'RV Lounge'), maxLines: 2, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Color(0xFFE7C77D))),
            ]),
          ))),
        ),
      ]))),
    ))),
    TextButton.icon(onPressed: () { setState(() => paused = !paused); updateMotion(); }, icon: Icon(paused ? Icons.play_arrow : Icons.pause), label: Text(paused ? 'ادامهٔ چرخش' : 'توقف چرخش')),
    const Text('برای مشاهده لمس کنید · برای چرخاندن بکشید', textDirection: TextDirection.rtl, style: TextStyle(color: Color(0xFFCBBF9E), fontSize: 12)),
  ]);
}
