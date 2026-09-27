import 'package:flutter/material.dart';

/// Independent educational section. Only verified surviving excerpts are
/// included; missing original chapter text is never invented.
class PointOfReturnPage extends StatelessWidget {
 const PointOfReturnPage({super.key});
 static const gold=Color(0xffdfbc76);
 static const bg=Color(0xff100d0c);
 @override Widget build(BuildContext context)=>Directionality(
 textDirection:TextDirection.rtl,
 child:Scaffold(backgroundColor:bg,appBar:AppBar(backgroundColor:bg,foregroundColor:gold,title:const Text('نقطه بازگشت')),
 body:ListView(padding:const EdgeInsets.all(20),children:[
 const SizedBox(height:16),
 const Icon(Icons.auto_stories,color:gold,size:58),
 const SizedBox(height:12),
 const Text('POINT OF RETURN',textAlign:TextAlign.center,style:TextStyle(color:gold,letterSpacing:3,fontSize:16)),
 const SizedBox(height:14),
 const Text('فلسفه مدیریت مرگ؛ از فروپاشی تا احیا',textAlign:TextAlign.center,style:TextStyle(color:gold,fontSize:23,fontWeight:FontWeight.bold)),
 const SizedBox(height:8),
 const Text('نظریه شخصی حامد قنبری درویش در تجارت و زندگی',textAlign:TextAlign.center,style:TextStyle(color:Colors.white70,fontSize:13)),
 const SizedBox(height:26),
 Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(border:Border.all(color:gold),borderRadius:BorderRadius.circular(18),color:const Color(0xff211915)),child:const Column(children:[
 Text('از نوشته‌های نویسنده',style:TextStyle(color:gold,fontSize:17,fontWeight:FontWeight.bold)),
 SizedBox(height:14),
 Text('آدم‌های معمولی مسئله حل می‌کنند… من مرگ را به بحران، بحران را به مشکل، مشکل را به مسئله، و مسئله را به فرصت تبدیل می‌کنم… بسیاری موفقیت را از نقطه شروع می‌سازند؛ من از نقطه پایان.',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,height:1.9,fontSize:16)),
 SizedBox(height:14),
 Text('مسئله ← مشکل ← بحران ← فروپاشی ← مرگ ← مدیریت ← احیا',textAlign:TextAlign.center,style:TextStyle(color:gold,height:1.8,fontSize:13))
 ])),
 const SizedBox(height:24),
 const Text('فهرست کتاب • ۹ فصل',style:TextStyle(color:gold,fontWeight:FontWeight.bold,fontSize:20)),
 const SizedBox(height:8),
 const Text('متن کامل و عناوین اصلی فصل‌ها هنوز در فایل‌های قابل دسترس پروژه موجود نیستند. برای حفظ اصالت اثر، متن تازه‌ای به نام نویسنده ساخته نشده است.',style:TextStyle(color:Colors.white70,height:1.7,fontSize:13)),
 const SizedBox(height:14),
 ...List.generate(9,(i)=>Card(color:const Color(0xff261b17),shape:RoundedRectangleBorder(side:BorderSide(color:gold.withOpacity(.55)),borderRadius:BorderRadius.circular(12)),child:ListTile(leading:CircleAvatar(backgroundColor:gold,child:Text('${i+1}',style:const TextStyle(color:Colors.black))),title:Text('فصل ${i+1}',style:const TextStyle(color:gold)),subtitle:const Text('متن اصلی در انتظار بازیابی',style:TextStyle(color:Colors.white60)),trailing:const Icon(Icons.lock_outline,color:gold)))),
 const SizedBox(height:18),
 const Text('حامد قنبری درویش',textAlign:TextAlign.center,style:TextStyle(color:gold,fontSize:17))
 ])));
}
