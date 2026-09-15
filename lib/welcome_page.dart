import 'dart:async';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  final VoidCallback onEnter;
  const WelcomePage({super.key, required this.onEnter});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  static const List<String> _slides = [
    'assets/image/screen_01.png',
    'assets/image/screen_02.png',
    'assets/image/screen_03.png',
    'assets/image/screen_04.png',
    'assets/image/screen_05.png',
  ];
  Timer? _timer;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 2500), (_) {
      if (mounted) setState(() => _current = (_current + 1) % _slides.length);
    });
  }

  void _next() { setState(() => _current = (_current + 1) % _slides.length); _startTimer(); }
  void _previous() { setState(() => _current = (_current - 1 + _slides.length) % _slides.length); _startTimer(); }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE8C36A);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, c) {
          final w = c.maxWidth;
          final h = c.maxHeight;
          return Stack(fit: StackFit.expand, children: [
            const DecoratedBox(decoration: BoxDecoration(gradient: RadialGradient(center: Alignment(0,-.45), radius: 1.15, colors: [Color(0xFF351015), Color(0xFF080808), Colors.black]))),
            Positioned(top: h*.045, left: 0, right: 0, child: const Column(children: [
              Icon(Icons.workspace_premium_rounded, color: gold, size: 54),
              SizedBox(height: 4),
              Text('ROYAL 1', style: TextStyle(color: gold, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 5)),
              Text('THE ROYAL EXPERIENCE', style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 3)),
            ])),
            Positioned(left: w*.055, right: w*.055, top: h*.22, height: h*.42, child: GestureDetector(
              onHorizontalDragEnd: (d) { final v=d.primaryVelocity??0; if(v < -120) _next(); else if(v > 120) _previous(); },
              child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), border: Border.all(color: gold.withOpacity(.7)), boxShadow: [BoxShadow(color: gold.withOpacity(.14), blurRadius: 22)]), child: ClipRRect(borderRadius: BorderRadius.circular(23), child: Stack(fit: StackFit.expand, children: [
                const ColoredBox(color: Color(0xFF080808)),
                AnimatedSwitcher(duration: const Duration(milliseconds: 420), child: Image.asset(_slides[_current], key: ValueKey(_current), fit: BoxFit.contain, errorBuilder: (_,__,___)=>Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.diamond_outlined,color:gold,size:64), const SizedBox(height:12), Text('ROYAL ${_current+1}',style:const TextStyle(color:gold,fontSize:24,fontWeight:FontWeight.bold))]))),
                Positioned(left:0,right:0,bottom:14,child:Row(mainAxisAlignment:MainAxisAlignment.center,children:List.generate(_slides.length,(i)=>Container(width:i==_current?18:7,height:7,margin:const EdgeInsets.symmetric(horizontal:4),decoration:BoxDecoration(borderRadius:BorderRadius.circular(10),color:i==_current?gold:Colors.white38))))
              ]))),
            )),
            Positioned(left:w*.13,right:w*.13,bottom:h*.07,height:58,child:DecoratedBox(decoration:BoxDecoration(borderRadius:BorderRadius.circular(30),gradient:const LinearGradient(colors:[Color(0xFF8C0916),Color(0xFF3D0207)]),border:Border.all(color:gold),boxShadow:[BoxShadow(color:Color(0x55E8C36A),blurRadius:18)]),child:Material(color:Colors.transparent,child:InkWell(borderRadius:BorderRadius.circular(30),onTap:widget.onEnter,child:const Center(child:Text('ورود به ROYAL 1',textDirection:TextDirection.rtl,style:TextStyle(color:Colors.white,fontSize:18,fontWeight:FontWeight.bold))))))),
          ]);
        }),
      ),
    );
  }
}
