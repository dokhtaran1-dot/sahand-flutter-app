import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'royal_games_page.dart';
import 'royal_club_membership_page.dart';

const _gold=Color(0xffe8c478),_red=Color(0xff420b19),_bg=Color(0xff120b0b);
class RoyalClubPage extends StatefulWidget {
 const RoyalClubPage({super.key});
 @override State<RoyalClubPage> createState()=>_RoyalClubPageState();
}
class _RoyalClubPageState extends State<RoyalClubPage>{
 int slide=0; Timer? timer; Timer? refreshTimer; int refresh=0;
 static const tvPrizes=<({String name, String subtitle, IconData icon})>[
 (name:'iPhone 18 Pro Max',subtitle:'آیفون ۱۸ پرو مکس',icon:Icons.phone_iphone),
 (name:'Galaxy Z Fold8',subtitle:'گوشی تاشوی سامسونگ',icon:Icons.tablet_android),
 (name:'Galaxy Z Flip8',subtitle:'گوشی تاشوی سامسونگ',icon:Icons.flip),
 (name:'Galaxy Z Flip7',subtitle:'گوشی تاشوی سامسونگ',icon:Icons.flip),
 (name:'PlayStation 5',subtitle:'کنسول پلی‌استیشن ۵',icon:Icons.videogame_asset),
 (name:'DualSense PS5',subtitle:'یک عدد دسته اصلی پلی‌استیشن',icon:Icons.sports_esports),
 (name:'DJI Avata 2',subtitle:'پهپاد با کنترل و عینک',icon:Icons.flight),
 (name:'iPhone 17',subtitle:'آیفون ۱۷',icon:Icons.phone_iphone),
 (name:'iPhone 17 Pro Max',subtitle:'آیفون ۱۷ پرو مکس',icon:Icons.phone_iphone),
 (name:'۸۰٪ تخفیف خرید',subtitle:'مغازه‌های مشارکت‌کننده رویال مال',icon:Icons.shopping_bag),
 (name:'PlayStation Portal',subtitle:'دستگاه بازی از راه دور',icon:Icons.sports_esports),
 (name:'PlayStation VR2',subtitle:'عینک واقعیت مجازی',icon:Icons.visibility),
 (name:'DualSense Edge',subtitle:'دسته حرفه‌ای پلی‌استیشن',icon:Icons.sports_esports),
 (name:'Nintendo Switch 2',subtitle:'کنسول نینتندو',icon:Icons.videogame_asset),
 (name:'Xbox Series X',subtitle:'کنسول ایکس‌باکس',icon:Icons.sports_esports),
 (name:'Steam Deck OLED',subtitle:'کنسول دستی',icon:Icons.tablet_android),
 (name:'Logitech G29',subtitle:'فرمان و پدال مسابقه',icon:Icons.sports_motorsports),
 (name:'PULSE Elite',subtitle:'هدست بی‌سیم پلی‌استیشن',icon:Icons.headphones),
 ];
 final prizes=const [
  ('PlayStation 5','700,000','sports_esports'),
  ('تلویزیون ۶۵ اینچ','1,000,000','tv'),
  ('گوشی پرچم‌دار','2,500,000','phone_iphone'),
  ('هدیه اختصاصی کلاب','100,000','card_giftcard')
 ];
 SupabaseClient? get db=>Supabase.instance.isInitialized?Supabase.instance.client:null;
 @override void initState(){super.initState();timer=Timer.periodic(const Duration(milliseconds:2500),(_){if(mounted)setState(()=>slide=(slide+1)%tvPrizes.length);});refreshTimer=Timer.periodic(const Duration(seconds:15),(_){if(mounted)setState(()=>refresh++);});}
 @override void dispose(){timer?.cancel();refreshTimer?.cancel();super.dispose();}
 void open(Widget page)=>Navigator.push(context,MaterialPageRoute(builder:(_)=>page));
 void info(String title,String detail)=>showDialog(context:context,builder:(_)=>AlertDialog(title:Text(title),content:Text(detail),actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('بستن'))]));
 Widget panel({required Widget child})=>Container(padding:const EdgeInsets.all(13),decoration:BoxDecoration(color:const Color(0xff271719),borderRadius:BorderRadius.circular(18),border:Border.all(color:_gold.withOpacity(.7))),child:child);
 Widget prizePanel(){return panel(child:Column(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
 const Text('جوایز کلاب',style:TextStyle(color:_gold,fontWeight:FontWeight.bold)),
 Icon(tvPrizes[slide].icon,size:48,color:_gold),
 Text(tvPrizes[slide].name,textAlign:TextAlign.center,style:const TextStyle(fontSize:14,fontWeight:FontWeight.bold)),
 const Text('فعال‌سازی پس از تأمین موجودی',textAlign:TextAlign.center,style:TextStyle(fontSize:10,color:Colors.white60))
 ]));}
 Widget _tvPrizeCard(int index,{bool compact=false}){final p=tvPrizes[index];final discount=index==9;return Container(decoration:BoxDecoration(gradient:const LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[Color(0xff100c09),Color(0xff48301a),Color(0xff100b0a)]),borderRadius:BorderRadius.circular(16),border:Border.all(color:_gold,width:2)),padding:EdgeInsets.all(compact?12:24),child:Column(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[
 Text('♛  ROYAL CLUB',textAlign:TextAlign.center,style:TextStyle(color:_gold,fontSize:compact?15:23,fontWeight:FontWeight.bold,letterSpacing:2)),
 if(discount)Text('۸۰٪',style:TextStyle(color:_gold,fontSize:compact?75:140,fontWeight:FontWeight.w900)) else Icon(p.icon,color:_gold,size:compact?80:150),
 Text(p.name,textAlign:TextAlign.center,style:TextStyle(color:_gold,fontSize:compact?22:38,fontWeight:FontWeight.bold)),
 Text(p.subtitle,textAlign:TextAlign.center,style:TextStyle(color:Colors.white,fontSize:compact?15:24)),
 const Text('نمایش جوایز • ارائه پس از تأیید موجودی',textAlign:TextAlign.center,style:TextStyle(color:Colors.white70,fontSize:12)),
 ]));}
 void _openTvGallery(){Navigator.push(context,MaterialPageRoute(builder:(_)=>Scaffold(backgroundColor:_bg,appBar:AppBar(title:const Text('جوایز ROYAL CLUB'),backgroundColor:_bg,foregroundColor:_gold),body:PageView.builder(itemCount:tvPrizes.length,itemBuilder:(context,i)=>Padding(padding:const EdgeInsets.all(18),child:_tvPrizeCard(i))))));}
 Widget leaderboard(){final client=db; final tick=refresh;if(client==null)return panel(child:const Center(child:Text('LIVE TOP 10\nاتصال سرور هنوز فعال نیست',textAlign:TextAlign.center,style:TextStyle(color:_gold))));
 return FutureBuilder<List<Map<String,dynamic>>>(key:ValueKey(tick),future:client.from('rc_leaderboard').select('user_id,display_name,weekly_xp').order('weekly_xp',ascending:false).limit(10),builder:(context,s){
 final rows=s.data??[];return panel(child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
 const Text('LIVE • TOP 10',textAlign:TextAlign.center,style:TextStyle(color:_gold,fontWeight:FontWeight.bold)),
 const SizedBox(height:8),
 if(s.hasError)const Text('جدول پس از راه‌اندازی سرور نمایش داده می‌شود',style:TextStyle(fontSize:11)),
 if(rows.isEmpty&&!s.hasError)const Text('هنوز امتیاز تأییدشده‌ای ثبت نشده',style:TextStyle(fontSize:11)),
 ...rows.take(10).toList().asMap().entries.map((e)=>Padding(padding:const EdgeInsets.symmetric(vertical:2),child:Text('${e.key+1}. ${e.value['display_name']??'عضو کلاب'}  •  ${e.value['weekly_xp']??0} XP',overflow:TextOverflow.ellipsis,style:TextStyle(fontSize:11,color:e.key==0?_gold:Colors.white))))
 ]));});}
 Widget tile(IconData icon,String title,VoidCallback tap)=>InkWell(onTap:tap,child:panel(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(icon,color:_gold,size:30),const SizedBox(height:9),Text(title,textAlign:TextAlign.center,style:const TextStyle(fontSize:12,fontWeight:FontWeight.bold))])));
 Widget _posterHotspot(Rect rect, VoidCallback tap)=>Positioned.fromRect(rect:rect,child:GestureDetector(behavior:HitTestBehavior.opaque,onTap:tap,child:const SizedBox.expand()));
 Widget _approvedPoster(BuildContext context)=>Scaffold(backgroundColor:_bg,body:SafeArea(child:LayoutBuilder(builder:(context,c){
 const w=864.0,h=1536.0;
 final scale=(c.maxWidth/w<c.maxHeight/h)?c.maxWidth/w:c.maxHeight/h;
 return Center(child:SizedBox(width:w*scale,height:h*scale,child:FittedBox(fit:BoxFit.fill,child:SizedBox(width:w,height:h,child:Stack(children:[
 Image.asset('assets/image/RoyalClub_Approved_Final.png',width:w,height:h,fit:BoxFit.fill,errorBuilder:(context,error,stack)=>const ColoredBox(color:_bg,child:Center(child:Text('تصویر نهایی کلاب هنوز به پروژه اضافه نشده',style:TextStyle(color:_gold))))),
 _posterHotspot(const Rect.fromLTWH(16,1060,208,255),()=>open(const RoyalClubMembershipPage())),
 _posterHotspot(const Rect.fromLTWH(230,1060,205,255),()=>open(const RoyalGamesPage())),
 _posterHotspot(const Rect.fromLTWH(440,1060,203,255),()=>info('امتیازات کلاب','XP مسابقه هفتگی مستقل از تیکت‌های دریافت جوایز است. دریافت تیکت واقعی پس از اتصال سرور فعال می‌شود.')),
 _posterHotspot(const Rect.fromLTWH(647,1060,206,255),()=>info('آلبوم عکس','آلبوم پس از تأیید و بارگذاری تصاویر مدیریت فعال می‌شود.')),
 Positioned.fromRect(rect:const Rect.fromLTWH(18,600,410,447),child:GestureDetector(onTap:_openTvGallery,child:AnimatedSwitcher(duration:const Duration(milliseconds:550),child:KeyedSubtree(key:ValueKey(slide),child:_tvPrizeCard(slide,compact:true))))),
 _posterHotspot(const Rect.fromLTWH(445,600,405,447),()=>info('جدول زنده','رتبه‌بندی بر اساس XP تأییدشده است؛ هر هفته فقط نفر اول برنده پذیرایی امپریال برای شش نفر می‌شود.')),
 _posterHotspot(const Rect.fromLTWH(30,1360,255,145),()=>Navigator.of(context).pop()),
 _posterHotspot(const Rect.fromLTWH(325,1330,215,190),()=>open(const RoyalGamesPage())),
 _posterHotspot(const Rect.fromLTWH(620,1360,220,145),()=>open(const RoyalClubMembershipPage())),
 ])))));
 })));

 @override Widget build(BuildContext context)=>FutureBuilder<bool>(future:rootBundle.load('assets/image/RoyalClub_Approved_Final.png').then((_)=>true).catchError((_)=>false),builder:(context,s)=>s.data==true?_approvedPoster(context):_fallbackBuild(context));
 Widget _fallbackBuild(BuildContext context)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(backgroundColor:_bg,appBar:AppBar(backgroundColor:_bg,centerTitle:true,title:const Text('♛  ROYAL CLUB',style:TextStyle(color:_gold,letterSpacing:2)),),body:SafeArea(child:LayoutBuilder(builder:(context,c)=>SingleChildScrollView(padding:const EdgeInsets.all(16),child:Column(children:[
 const Text('WEEKLY CHAMPION',style:TextStyle(color:_gold,letterSpacing:3)),
 const SizedBox(height:8),
 panel(child:const Column(children:[Text('جایزه نفر اول هر هفته',style:TextStyle(color:_gold,fontWeight:FontWeight.bold,fontSize:17)),SizedBox(height:7),Text('RV LOUNGE IMPERIAL',style:TextStyle(fontWeight:FontWeight.bold)),SizedBox(height:4),Text('سلف‌سرویس اختصاصی برای ۶ نفر\nبرنده به همراه ۵ مهمان',textAlign:TextAlign.center),SizedBox(height:5),Text('رتبه‌بندی بر اساس XP؛ تیکت جوایز مستقل است',textAlign:TextAlign.center,style:TextStyle(fontSize:11,color:Colors.white70))])),
 const SizedBox(height:16),
 SizedBox(height:220,child:Row(children:[Expanded(child:prizePanel()),const SizedBox(width:10),Expanded(child:leaderboard())])),
 const SizedBox(height:16),
 GridView.count(crossAxisCount:4,shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),mainAxisSpacing:7,crossAxisSpacing:7,childAspectRatio:.72,children:[
 tile(Icons.person_add_alt_1,'عضویت',()=>open(const RoyalClubMembershipPage())),
 tile(Icons.sports_esports,'بازی‌ها',()=>open(const RoyalGamesPage())),
 tile(Icons.workspace_premium,'امتیازات',()=>info('امتیازات کلاب','دریافت تیکت از بازی، معرفی دوست و خرید قطعی. دریافت جایزه فقط پس از تأمین موجودی و فعال‌سازی سرور امکان‌پذیر است.')),
 tile(Icons.photo_library,'آلبوم عکس',()=>info('آلبوم کلاب','آلبوم پس از بارگذاری عکس‌های تأییدشده مدیریت نمایش داده می‌شود.'))
 ]),
 const SizedBox(height:16),
 panel(child:const Text('سقف برنامه: ۵۰۰ میلیون تومان در ماه\n۳۰۰ میلیون خرید • ۱۰۰ میلیون بازی • ۵۰ میلیون معرفی • ۵۰ میلیون ذخیره\nاین ارقام بودجه برنامه‌اند و تا زمان راه‌اندازی سرور، تیکتی صادر نمی‌شود.',textAlign:TextAlign.center,style:TextStyle(fontSize:12,height:1.8))),
 ])))),bottomNavigationBar:BottomNavigationBar(backgroundColor:_red,selectedItemColor:_gold,unselectedItemColor:Colors.white70,currentIndex:1,onTap:(i){if(i==0)Navigator.pop(context);if(i==2)open(const RoyalClubMembershipPage());},items:const [BottomNavigationBarItem(icon:Icon(Icons.home),label:'Home'),BottomNavigationBarItem(icon:Icon(Icons.explore,size:32),label:'Explore'),BottomNavigationBarItem(icon:Icon(Icons.person),label:'Profile')]))); }
