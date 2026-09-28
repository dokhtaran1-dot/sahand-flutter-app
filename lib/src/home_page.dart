import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'royal_village_page.dart';
import 'royal_club_page.dart';
import 'royal_mall_page.dart';
import 'point_of_return_page.dart';

class HomePage extends StatelessWidget {
 const HomePage({super.key});
 static const artwork='assets/image/royal1_home_ultra.webp';
 static const artWidth=1080.0,artHeight=1920.0;
 void open(BuildContext c,Widget p)=>Navigator.of(c).push(MaterialPageRoute(builder:(_)=>p));
 Widget hit(BuildContext c,Rect r,Widget p)=>Positioned.fromRect(rect:r,child:GestureDetector(behavior:HitTestBehavior.opaque,onTap:()=>open(c,p),child:const SizedBox.expand()));
 @override Widget build(BuildContext context)=>Scaffold(backgroundColor:Colors.black,body:Stack(fit:StackFit.expand,children:[
  ImageFiltered(imageFilter:ui.ImageFilter.blur(sigmaX:18,sigmaY:18),child:Image.asset(artwork,fit:BoxFit.cover)),
  Container(color:Colors.black.withOpacity(.25)),
  Center(child:LayoutBuilder(builder:(context,c){final s=(c.maxWidth/artWidth<c.maxHeight/artHeight)?c.maxWidth/artWidth:c.maxHeight/artHeight;return SizedBox(width:artWidth*s,height:artHeight*s,child:FittedBox(fit:BoxFit.fill,child:SizedBox(width:artWidth,height:artHeight,child:Stack(children:[
   Image.asset(artwork,width:artWidth,height:artHeight,fit:BoxFit.fill,filterQuality:FilterQuality.high),
   // Approved order: RM left | RC center | RV right.
   hit(context,const Rect.fromLTWH(25,620,330,900),const RoyalMallPage()),
   hit(context,const Rect.fromLTWH(375,620,330,900),const RoyalClubPage()),
   hit(context,const Rect.fromLTWH(725,620,330,900),const RoyalVillagePage()),
   hit(context,const Rect.fromLTWH(200,1670,180,170),const RoyalClubPage()),
   hit(context,const Rect.fromLTWH(420,1640,220,200),const RoyalClubPage()),
   hit(context,const Rect.fromLTWH(680,1670,190,170),const RoyalVillagePage()),
  ]))))); })),
  Positioned(top:10,right:10,child:SafeArea(child:Material(color:const Color(0xaa080706),borderRadius:BorderRadius.circular(28),child:IconButton(icon:const Icon(Icons.menu_book,color:Color(0xffe7c47d)),tooltip:'آموزش مدیریت',onPressed:()=>open(context,const PointOfReturnPage())))))
 ]));
}
