import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'royal_village_page.dart';
import 'royal_club_page.dart';
import 'royal_mall_page.dart';
import 'point_of_return_page.dart';

class HomePage extends StatelessWidget {
 const HomePage({super.key});
 static const double artWidth=941,artHeight=1672;
 static const artwork='assets/image/royal1_home_ultra.webp';
 void _push(BuildContext c,Widget p)=>Navigator.of(c).push(MaterialPageRoute(builder:(_)=>p));
 Widget _tap(BuildContext c,Rect r,Widget p)=>Positioned.fromRect(rect:r,child:GestureDetector(behavior:HitTestBehavior.opaque,onTap:()=>_push(c,p),child:const SizedBox.expand()));
 @override Widget build(BuildContext context)=>Scaffold(backgroundColor:Colors.black,body:Stack(fit:StackFit.expand,children:[
 ImageFiltered(imageFilter:ui.ImageFilter.blur(sigmaX:18,sigmaY:18),child:ColorFiltered(colorFilter:const ColorFilter.mode(Color(0x77000000),BlendMode.darken),child:Image.asset(artwork,fit:BoxFit.cover))),
 Center(child:LayoutBuilder(builder:(context,c){final scale=(c.maxWidth/artWidth<c.maxHeight/artHeight)?c.maxWidth/artWidth:c.maxHeight/artHeight;return SizedBox(width:artWidth*scale,height:artHeight*scale,child:FittedBox(fit:BoxFit.fill,child:SizedBox(width:artWidth,height:artHeight,child:Stack(children:[
 Image.asset(artwork,width:artWidth,height:artHeight,fit:BoxFit.fill,filterQuality:FilterQuality.high),
 _tap(context,const Rect.fromLTWH(18,500,286,930),const RoyalMallPage()),
 _tap(context,const Rect.fromLTWH(326,500,286,930),const RoyalClubPage()),
 _tap(context,const Rect.fromLTWH(635,500,286,930),const RoyalVillagePage()),
 _tap(context,const Rect.fromLTWH(185,1480,155,165),const RoyalClubPage()),
 _tap(context,const Rect.fromLTWH(395,1470,155,175),const RoyalClubPage()),
 _tap(context,const Rect.fromLTWH(580,1480,155,165),const RoyalVillagePage()),
 _tap(context,const Rect.fromLTWH(755,1480,155,165),const RoyalClubPage()),
 ]))))); })),
 Positioned(top:10,right:10,child:SafeArea(child:Material(color:const Color(0xCC120B09),borderRadius:BorderRadius.circular(24),child:IconButton(tooltip:'آموزش مدیریت',onPressed:()=>_push(context,const PointOfReturnPage()),icon:const Icon(Icons.menu_book,color:Color(0xffe7c47d))))))
 ]));
}
