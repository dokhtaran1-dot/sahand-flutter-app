import 'package:flutter/material.dart';
import 'royal_village_page.dart';
import 'royal_club_page.dart';
import 'royal_mall_page.dart';
import 'point_of_return_page.dart';

class HomePage extends StatelessWidget {
 const HomePage({super.key});
 static const art='assets/image/Home.png';
 static const w=1024.0,h=1536.0;
 void open(BuildContext c,Widget p)=>Navigator.of(c).push(MaterialPageRoute(builder:(_)=>p));
 Widget hit(BuildContext c,Rect r,Widget p)=>Positioned.fromRect(rect:r,child:GestureDetector(behavior:HitTestBehavior.opaque,onTap:()=>open(c,p),child:const SizedBox.expand()));
 @override Widget build(BuildContext context)=>Scaffold(backgroundColor:Colors.black,body:SafeArea(child:LayoutBuilder(builder:(context,c){
   final scale=(c.maxWidth/w<c.maxHeight/h)?c.maxWidth/w:c.maxHeight/h;
   return Stack(children:[
    Center(child:SizedBox(width:w*scale,height:h*scale,child:FittedBox(fit:BoxFit.fill,child:SizedBox(width:w,height:h,child:Stack(children:[
      Image.asset(art,width:w,height:h,fit:BoxFit.fill,filterQuality:FilterQuality.high),
      hit(context,const Rect.fromLTWH(20,450,315,760),const RoyalMallPage()),
      hit(context,const Rect.fromLTWH(355,450,315,760),const RoyalClubPage()),
      hit(context,const Rect.fromLTWH(690,450,315,760),const RoyalVillagePage()),
      hit(context,const Rect.fromLTWH(160,1350,150,150),const RoyalClubPage()),
      hit(context,const Rect.fromLTWH(435,1325,155,175),const RoyalClubPage()),
      hit(context,const Rect.fromLTWH(600,1350,175,150),const RoyalVillagePage()),
      hit(context,const Rect.fromLTWH(800,1350,190,150),const RoyalClubPage()),
    ]))))),
    Positioned(top:4,right:8,child:IconButton(icon:const Icon(Icons.menu_book,color:Color(0xffe7c47d),size:22),tooltip:'آموزش مدیریت',onPressed:()=>open(context,const PointOfReturnPage())))
   ]);
 })));
}
