import '../models/app_models.dart';

final List<ConsultationPlan> consultationPlans = [
  ConsultationPlan(
    id: 'bronze',
    title: 'ارزیابی راهبردی',
    subtitle: 'پلن برنزی',
    price: '۱۰ میلیون تومان',
    level: 'برنزی',
    features: [
      'یک جلسه مشاوره تخصصی',
      'بررسی اولیه موضوع یا کسب‌وکار',
      'جمع‌بندی راهبردی اولیه',
      'مناسب برای ارزیابی فرصت‌ها',
    ],
  ),
  ConsultationPlan(
    id: 'silver',
    title: 'مشاوره اجرایی',
    subtitle: 'پلن نقره‌ای',
    price: '۲۰ میلیون تومان',
    level: 'نقره‌ای',
    features: [
      'جلسه یا جلسات عمیق‌تر',
      'تحلیل راهبردی موضوع',
      'ارائه چارچوب یا نقشه مسیر اولیه',
      'مناسب برای توسعه کسب‌وکار و مشارکت',
    ],
  ),
  ConsultationPlan(
    id: 'gold',
    title: 'همراهی اختصاصی راهبردی',
    subtitle: 'پلن طلایی',
    price: '۷۰ میلیون تومان',
    level: 'طلایی',
    features: [
      'مشاوره ویژه و اختصاصی',
      'تحلیل عمیق و چندمرحله‌ای',
      'بررسی مستندات و شرایط اختصاصی',
      'اولویت ارتباط و پیگیری',
    ],
  ),
];

final List<RequestStatusItem> sampleRequests = [
  RequestStatusItem(
    code: 'HG-3015',
    title: 'درخواست مشاوره',
    subtitle: 'ثبت شد و در حال بررسی اولیه است',
    status: 'ثبت شد',
    progress: 20,
  ),
  RequestStatusItem(
    code: 'HG-3021',
    title: 'پرداخت تایید شده',
    subtitle: 'در حال آماده‌سازی برنامه ارتباطی رسمی',
    status: 'پرداخت انجام شد',
    progress: 55,
  ),
  RequestStatusItem(
    code: 'HG-3047',
    title: 'زمان‌بندی جلسه',
    subtitle: 'در حال هماهنگی برای ارتباط رسمی',
    status: 'در حال بررسی',
    progress: 75,
  ),
];

final List<StrategicBranch> strategicBranches = [
  StrategicBranch(
    title: 'ساخت‌وساز و توسعه پروژه‌ها',
    description: 'آفرینش پروژه‌های تجاری و سرمایه‌گذاری با مدیریت حرفه‌ای و کیفیت نهادی.',
    icon: 'domain',
  ),
  StrategicBranch(
    title: 'تولید محصولات غذایی پرمیوم',
    description: 'طراحی زنجیره ارزش برای محصولات غذایی با استانداردهای لوکس و باکیفیت.',
    icon: 'restaurant',
  ),
  StrategicBranch(
    title: 'کشاورزی، تولید و صادرات',
    description: 'فرایندهای پایدار کشاورزی و صادرات مسئولانه در بازارهای هدف.',
    icon: 'agriculture',
  ),
  StrategicBranch(
    title: 'املاک و دارایی‌های تجاری',
    description: 'مدیریت دارایی‌های تجاری با تمرکز بر توسعه ارزش بلندمدت.',
    icon: 'apartment',
  ),
  StrategicBranch(
    title: 'رستوران و مهمان‌داری',
    description: 'تجربه‌های مهمان‌داری سطح بالا و برندهای شاخص در فضای لوکس.',
    icon: 'wine_bar',
  ),
  StrategicBranch(
    title: 'واردات، صادرات و نمایندگی‌ها',
    description: 'شبکه تجاری گسترده برای تامین و توزیع کالاهای ویژه.',
    icon: 'local_shipping',
  ),
];

final List<BrandAsset> brandPortfolio = [
  BrandAsset(
    title: 'Sahand',
    subtitle: 'برند پریمیوم محصولات غذایی با تمرکز بر کیفیت ممتاز، اصالت و تجربه‌ای متفاوت از طعم. Sahand نماد نوآوری، اعتماد و خلق ارزش در زنجیره تأمین محصولات غذایی است.',
    status: 'فعال',
    imagePath: 'assets/images/3.png',
  ),
  BrandAsset(
    title: 'LOVA',
    subtitle: 'تجربه‌ای فراتر از یک کافه؛ ترکیبی از طراحی مدرن، فضای صمیمی و طعمی ماندگار. LOVA جایی‌ست برای مکث، گفتگو و لذت بردن از لحظاتی که تکرار نمی‌شوند.',
    status: 'در حال توسعه',
    imagePath: 'assets/images/5.png',
  ),
  BrandAsset(
    title: 'Royal Mall',
    subtitle: 'یک مجموعه تجاری شاخص با موقعیت ممتاز شهری، میزبان برندهای برتر و بستری برای سرمایه‌گذاری. Royal Mall نماد پویایی اقتصادی و فرصت‌های پایدار در قلب شهر است.',
    status: 'پروژه کلیدی',
    imagePath: 'assets/images/4.jpg',
  ),
];
