import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'royal_village_page.dart';
import 'royal_club_page.dart';
import 'royal_mall_page.dart';
import 'point_of_return_page.dart';

/// New entry screen: RM | RC | RV. All navigation is native and tappable.
class HomePage extends StatelessWidget {
 const HomePage({super.key});
 static const gold=Color(0xffe7c47d);
 static const dark=Color(0xff100c0a);
 void open(BuildContext context,Widget page)=>Navigator.of(context).push(MaterialPageRoute(builder:(_)=>page));

 Widget portal(BuildContext context,{required String initials,required String name,required String fa,required String description,required IconData icon,required Widget page}){
 return Expanded(child:InkWell(onTap:()=>open(context,page),borderRadius:BorderRadius.circular(17),child:Container(
 decoration:BoxDecoration(border:Border.all(color:gold,width:1.4),borderRadius:BorderRadius.circular(17),gradient:const LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[Color(0xff45301c),Color(0xff130e0c),Color(0xff332012)]),boxShadow:const [BoxShadow(color:Color(0x665b3915),blurRadius:14)]),
 padding:const EdgeInsets.symmetric(horizontal:5,vertical:14),child:Column(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
 Icon(icon,color:gold,size:29),
 Column(children:[Text(initials,style:const TextStyle(color:gold,fontSize:36,fontWeight:FontWeight.bold,fontFamily:'serif')),const SizedBox(height:9),FittedBox(fit:BoxFit.scaleDown,child:Text(name,style:const TextStyle(color:gold,fontSize:13,fontWeight:FontWeight.bold,letterSpacing:1))),const SizedBox(height:9),Text(fa,textAlign:TextAlign.center,style:const TextStyle(color:Colors.white,fontSize:12,fontWeight:FontWeight.bold)),const SizedBox(height:8),Text(description,textAlign:TextAlign.center,maxLines:3,style:const TextStyle(color:Colors.white70,fontSize:10,height:1.5))]),
 Container(width:double.infinity,padding:const EdgeInsets.symmetric(vertical:10),decoration:BoxDecoration(border:Border.all(color:gold),borderRadius:BorderRadius.circular(30)),child:const Text('ENTER  ›',textAlign:TextAlign.center,style:TextStyle(color:gold,fontSize:12,fontWeight:FontWeight.bold,letterSpacing:1)))
 ]))));
 }
 Widget nav(BuildContext context,IconData icon,String label,VoidCallback tap)=>Expanded(child:InkWell(onTap:tap,child:Column(mainAxisSize:MainAxisSize.min,children:[Icon(icon,color:gold,size:24),const SizedBox(height:4),Text(label,style:const TextStyle(color:Colors.white70,fontSize:10))])));
 Widget approvedPoster(BuildContext context)=>Scaffold(backgroundColor:dark,body:SafeArea(child:LayoutBuilder(builder:(context,c){const w=941.0,h=1672.0;final scale=(c.maxWidth/w<c.maxHeight/h)?c.maxWidth/w:c.maxHeight/h;return Center(child:SizedBox(width:w*scale,height:h*scale,child:FittedBox(fit:BoxFit.fill,child:SizedBox(width:w,height:h,child:Stack(children:[Image.asset('assets/image/ROYAL_ONE_Home_RC.png',width:w,height:h,fit:BoxFit.fill),
 hotspot(context,const Rect.fromLTWH(0,525,303,935),const RoyalMallPage()),
 hotspot(context,const Rect.fromLTWH(314,525,307,935),const RoyalClubPage()),
 hotspot(context,const Rect.fromLTWH(634,525,307,935),const RoyalVillagePage()),
 hotspot(context,const Rect.fromLTWH(223,1490,170,155),const RoyalMallPage()),
 hotspot(context,const Rect.fromLTWH(405,1490,145,155),const RoyalClubPage()),
 hotspot(context,const Rect.fromLTWH(570,1490,155,155),const RoyalVillagePage()),
 Positioned.fromRect(rect:const Rect.fromLTWH(824,5,112,108),child:GestureDetector(onTap:()=>open(context,const PointOfReturnPage()),behavior:HitTestBehavior.opaque,child:const SizedBox.expand())),
 ])))));})));
 Widget hotspot(BuildContext context,Rect rect,Widget page)=>Positioned.fromRect(rect:rect,child:GestureDetector(behavior:HitTestBehavior.opaque,onTap:()=>open(context,page),child:const SizedBox.expand()));
 @override Widget build(BuildContext context)=>FutureBuilder<bool>(future:rootBundle.load('assets/image/ROYAL_ONE_Home_RC.png').then((_)=>true).catchError((_)=>false),builder:(context,s)=>s.data==true?approvedPoster(context):fallbackHome(context));
 Widget fallbackHome(BuildContext context)=>Scaffold(backgroundColor:dark,body:SafeArea(child:LayoutBuilder(builder:(context,c)=>SingleChildScrollView(child:ConstrainedBox(constraints:BoxConstraints(minHeight:c.maxHeight),child:Container(
 decoration:const BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Color(0xff100b09),Color(0xff332012),Color(0xff080706)])),
 padding:const EdgeInsets.fromLTRB(14,14,14,16),child:Column(children:[
 Row(children:[const Text('SC',style:TextStyle(color:gold,fontSize:26,fontWeight:FontWeight.bold,fontFamily:'serif')),const SizedBox(width:8),const Expanded(child:Text('SAHAND CONSORTIUM\nSINCE 1971',style:TextStyle(color:gold,fontSize:9,letterSpacing:1.1))),TextButton.icon(onPressed:()=>open(context,const PointOfReturnPage()),icon:const Icon(Icons.menu_book,color:gold,size:18),label:const Text('آموزش مدیریت',style:TextStyle(color:gold,fontSize:11)))]),
 const SizedBox(height:30),
 Container(width:94,height:94,alignment:Alignment.center,decoration:BoxDecoration(shape:BoxShape.circle,border:Border.all(color:gold,width:2),gradient:const RadialGradient(colors:[Color(0xff61411d),Color(0xff0b0807)])),child:const Text('R¹',style:TextStyle(color:gold,fontSize:57,fontWeight:FontWeight.bold,fontFamily:'serif'))),
 const SizedBox(height:12),
 const FittedBox(child:Text('ROYAL ONE',style:TextStyle(color:gold,fontSize:35,fontFamily:'serif',letterSpacing:4))),
 const SizedBox(height:6),
 const Text('ONE ENTRANCE. A WHOLE ROYAL WORLD.',textAlign:TextAlign.center,style:TextStyle(color:gold,fontSize:10,letterSpacing:2)),
 const SizedBox(height:8),
 const Text('یک ورود، یک دنیای کامل رویال',style:TextStyle(color:Colors.white70,fontSize:13)),
 const SizedBox(height:27),
 SizedBox(height:c.maxHeight>690?360:300,child:Row(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
 portal(context,initials:'RM',name:'ROYAL MALL',fa:'رویال مال',description:'پاساژ و فروشگاه\nخرید و خدمات',icon:Icons.storefront_outlined,page:const RoyalMallPage()),
 const SizedBox(width:8),
 portal(context,initials:'RC',name:'ROYAL CLUB',fa:'رویال کلاب',description:'عضویت ویژه\nجوایز و بازی‌ها',icon:Icons.workspace_premium_outlined,page:const RoyalClubPage()),
 const SizedBox(width:8),
 portal(context,initials:'RV',name:'ROYAL VILLAGE',fa:'رویال ویلیج',description:'رستوران و کافه\nاتاق‌های اختصاصی',icon:Icons.restaurant_outlined,page:const RoyalVillagePage())
 ])),
 const SizedBox(height:28),
 const Text('MORE THAN AN APP',style:TextStyle(color:gold,fontSize:13,letterSpacing:3)),
 const Text('A ROYAL LIFESTYLE',style:TextStyle(color:gold,fontSize:12,letterSpacing:3)),
 const SizedBox(height:23),
 Container(padding:const EdgeInsets.symmetric(vertical:12,horizontal:4),decoration:BoxDecoration(color:const Color(0xff1b110c),border:Border.all(color:gold),borderRadius:BorderRadius.circular(40)),child:Row(children:[
 nav(context,Icons.home_outlined,'Home',()=>{}),
 nav(context,Icons.workspace_premium_outlined,'Royal Club',()=>open(context,const RoyalClubPage())),
 nav(context,Icons.diamond_outlined,'R1',()=>open(context,const RoyalClubPage())),
 nav(context,Icons.calendar_month_outlined,'Reservations',()=>open(context,const RoyalVillagePage())),
 nav(context,Icons.person_outline,'Profile',()=>open(context,const RoyalClubPage()))
 ]))
 ])))))));
}
