// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class SAr extends S {
  SAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'سهم';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navSearch => 'البحث';

  @override
  String get navMyTrips => 'رحلاتي';

  @override
  String get navProfile => 'حسابي';

  @override
  String get orders => 'الطلبات';

  @override
  String get welcomeTitle => 'مرحباً بك في سهم';

  @override
  String get enterPhoneSubtitle => 'أدخل رقم موبايلك للبدء';

  @override
  String get phoneHint => '7X XXXX XXX';

  @override
  String get phoneLabel => 'رقم الهاتف';

  @override
  String get sendOtp => 'إرسال رمز التحقق';

  @override
  String get willSendSms => 'سنرسل لك رمز تحقق عبر SMS';

  @override
  String get termsAgreement =>
      'بالمتابعة، أنت توافق على شروط الاستخدام وسياسة الخصوصية';

  @override
  String get devLogin => 'دخول تجريبي (Dev)';

  @override
  String get devLoginDriver => 'دخول كسائق';

  @override
  String get devLoginRestaurant => 'دخول كمطعم';

  @override
  String get enterOtp => 'أدخل رمز التحقق';

  @override
  String otpSentTo(String phone) {
    return 'تم إرسال رمز التحقق إلى\n$phone';
  }

  @override
  String resendIn(int seconds) {
    return 'إعادة الإرسال بعد $seconds ثانية';
  }

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String get verify => 'تحقق';

  @override
  String get howToUseAutostrad => 'كيف تريد استخدام سهم؟';

  @override
  String get chooseRegistration => 'اختر طريقة التسجيل المناسبة لك';

  @override
  String get passenger => 'راكب';

  @override
  @override
  String get restaurant => 'مطعم';

  @override
  String get driver => 'سائق';

  @override
  String get passengerSubtitle => 'ابحث عن رحلات واحجز مقعدك';

  @override
  String get restaurantSubtitle => 'أنشئ طلبات توصيل لمطعمك';

  @override
  String get driverSubtitle => 'وصّل الطلبات واكسب دخلاً إضافياً';

  @override
  String get switchRoleLater => 'يمكنك التبديل بين الوضعين لاحقاً من الإعدادات';

  @override
  String get registerAsPassenger => 'تسجيل كراكب';

  @override
  String get registerAsRestaurant => 'تسجيل كمطعم';

  @override
  String get enterNameToStart => 'أدخل اسمك للبدء';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get firstNameHint => 'أحمد';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get lastNameHint => 'محمد';

  @override
  String get firstNameRequired => 'الاسم الأول مطلوب';

  @override
  String get lastNameRequired => 'اسم العائلة مطلوب';

  @override
  String get emailOptional => 'البريد الإلكتروني (اختياري)';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي';

  @override
  String get account => 'الحساب';

  @override
  String get settingsAndHelp => 'الإعدادات والمساعدة';

  @override
  String get comingSoon => 'قريباً';

  @override
  String get createAccount => 'إنشاء الحساب';

  @override
  String get registerAsDriver => 'تسجيل كسائق';

  @override
  String get completeDocsToStart => 'أكمل بياناتك ووثائقك للبدء';

  @override
  String get requiredDocs => 'الوثائق المطلوبة';

  @override
  String get nationalId => 'صورة الهوية الشخصية';

  @override
  String get driverLicense => 'صورة رخصة القيادة';

  @override
  String get carImage => 'صورة المركبة';

  @override
  String get carNumber => 'رقم لوحة المركبة';

  @override
  String get carNumberHint => '00-00000';

  @override
  String get imageSelected => 'تم الاختيار';

  @override
  String get tapToSelect => 'انقر للاختيار';

  @override
  String get pleaseAttachAllImages => 'الرجاء إرفاق جميع الصور المطلوبة';

  @override
  String get hello => 'أهلاً بك 👋';

  @override
  String get whereToGo => 'إلى أين تريد الذهاب؟';

  @override
  String get searchForTrip => 'ابحث عن رحلة...';

  @override
  String get popularDestinations => 'الوجهات الشائعة';

  @override
  String fromPrice(String price) {
    return 'من $price د.أ';
  }

  @override
  String get howItWorks => 'كيف تعمل؟';

  @override
  String get step1Title => 'ابحث عن رحلة';

  @override
  String get step1Subtitle => 'اختر وجهتك والتاريخ المناسب';

  @override
  String get step2Title => 'احجز مقعدك';

  @override
  String get step2Subtitle => 'اختر عدد المقاعد وأكمل الحجز';

  @override
  String get step3Title => 'استمتع بالرحلة';

  @override
  String get step3Subtitle => 'تواصل مع السائق وانطلق';

  @override
  String get verifyDriverAccount => 'وثّق حسابك كسائق';

  @override
  String get verifyDriverDescription =>
      'للبدء بنشر رحلات وقبول الركاب، يجب توثيق حسابك أولاً';

  @override
  String get startVerification => 'بدء التوثيق';

  @override
  String get docsUnderReview => 'الوثائق قيد المراجعة';

  @override
  String get docsUnderReviewDesc =>
      'تم إرسال وثائقك وهي قيد المراجعة من قبل الإدارة. سيتم إشعارك عند الموافقة.';

  @override
  String get docsRejected => 'تم رفض الوثائق';

  @override
  String get docsRejectedDesc =>
      'تم رفض وثائقك. يرجى إعادة رفعها مع التأكد من وضوح الصور.';

  @override
  String get resubmitDocs => 'إعادة رفع الوثائق';

  @override
  String get wallet => 'المحفظة';

  @override
  String get currentBalance => 'الرصيد الحالي';

  @override
  String balanceAmount(String amount) {
    return '$amount د.أ';
  }

  @override
  String get topUp => 'شحن الرصيد';

  @override
  String get createNewTrip => 'أنشئ رحلة جديدة';

  @override
  String get publishTripDescription => 'شارك مسارك مع الركاب';

  @override
  String get recentBookingRequests => 'طلبات الحجز الأخيرة';

  @override
  String get noBookingRequests => 'لا توجد طلبات حجز حالياً';

  @override
  String get searchForTripTitle => 'البحث عن رحلة';

  @override
  String get fromWhere => 'من أين؟';

  @override
  String get toWhere => 'إلى أين؟';

  @override
  String get search => 'بحث';

  @override
  String noTripsFound(String from, String to) {
    return 'لا توجد رحلات من $from إلى $to';
  }

  @override
  String get tryChangingFilters => 'جرّب تغيير التاريخ أو عدد المقاعد';

  @override
  String get searchNextTrip => 'ابحث عن رحلتك القادمة';

  @override
  String tripCount(int count) {
    return '$count رحلة';
  }

  @override
  String get cheapest => 'الأرخص';

  @override
  String get earliest => 'الأقرب';

  @override
  String get topRated => 'الأعلى تقييماً';

  @override
  String get perSeat => 'للمقعد';

  @override
  String get tripDetails => 'تفاصيل الرحلة';

  @override
  String get departurePoint => 'نقطة الانطلاق';

  @override
  String get destination => 'الوجهة';

  @override
  String get loading => 'سيتم التحميل...';

  @override
  String get date => 'التاريخ';

  @override
  String get departureTime => 'وقت المغادرة';

  @override
  String get availableSeats => 'المقاعد المتاحة';

  @override
  String get pricePerSeat => 'السعر للمقعد';

  @override
  String get tripRules => 'قواعد الرحلة';

  @override
  String get noSmoking => 'ممنوع التدخين';

  @override
  String get smokingAllowed => 'التدخين مسموح';

  @override
  String get verified => 'موثّق';

  @override
  String get pets => 'حيوانات أليفة';

  @override
  String get music => 'موسيقى';

  @override
  String get luggage => 'أمتعة';

  @override
  String get pickupOptions => 'خيارات الالتقاء';

  @override
  String get meetingPoint => 'نقطة التقاء محددة';

  @override
  String get doorToDoor => 'من الباب إلى الباب';

  @override
  String get bookNow => 'احجز الآن';

  @override
  String get driverName => 'اسم السائق';

  @override
  String get femaleOnly => 'نساء فقط';

  @override
  String get createTripTitle => 'إنشاء رحلة جديدة';

  @override
  String get from => 'من';

  @override
  String get to => 'إلى';

  @override
  String selectFrom(String label) {
    return 'اختر $label';
  }

  @override
  String get time => 'الوقت';

  @override
  String get priceCurrency => 'السعر (د.أ)';

  @override
  String get seatCount => 'عدد المقاعد';

  @override
  String get notesOptional => 'ملاحظات (اختياري)';

  @override
  String get notesHint => 'مثال: التجمع عند دوار المدينة...';

  @override
  String get publishTrip => 'نشر الرحلة';

  @override
  String get tripCreatedSuccess => 'تم إنشاء الرحلة بنجاح';

  @override
  String get tripCreateFailed => 'فشل إنشاء الرحلة';

  @override
  String get selectStartAndEnd => 'يرجى تحديد نقطة الانطلاق والوصول';

  @override
  String get enterValidPrice => 'يرجى إدخال سعر صحيح';

  @override
  String get seatsBetween1And7 => 'عدد المقاعد يجب أن يكون بين 1 و 7';

  @override
  String get selectStartPoint => 'اختر نقطة الانطلاق';

  @override
  String get selectEndPoint => 'اختر نقطة الوصول';

  @override
  String get poolingPoint => 'نقطة التجمع';

  @override
  String get pickupFromHome => 'التوصيل من المنزل';

  @override
  String get pickupFromHomeDesc => 'يمكنك استلام الراكب من منزله';

  @override
  String get optional => 'اختياري';

  @override
  String get bookSeats => 'حجز مقاعد';

  @override
  String get tripSummary => 'ملخص الرحلة';

  @override
  String get numberOfSeats => 'عدد المقاعد';

  @override
  String get additionalPassengerNames => 'أسماء الركاب الإضافيين';

  @override
  String get enterPassengerNames => 'أدخل أسماء الأشخاص الذين ستحجز لهم';

  @override
  String passengerN(int n) {
    return 'الراكب $n';
  }

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get enterPassengerName => 'الرجاء إدخال اسم الراكب';

  @override
  String get anyNotesForDriver => 'أي ملاحظات للسائق...';

  @override
  String seatPriceMultiplied(int count) {
    return 'سعر المقعد × $count';
  }

  @override
  String get total => 'الإجمالي';

  @override
  String get bookingTerms =>
      'أوافق على شروط الاستخدام وسياسة الحجز. الدفع يتم مباشرة للسائق (نقداً أو CliQ).';

  @override
  String get confirmBooking => 'تأكيد الحجز';

  @override
  String perSeatPrice(String price) {
    return '$price / مقعد';
  }

  @override
  String get myBookings => 'حجوزاتي';

  @override
  String get upcoming => 'القادمة';

  @override
  String get past => 'السابقة';

  @override
  String get cancelled => 'الملغاة';

  @override
  String get noUpcomingBookings => 'لا توجد حجوزات قادمة';

  @override
  String get noPastBookings => 'لا توجد حجوزات سابقة';

  @override
  String get noCancelledBookings => 'لا توجد حجوزات ملغاة';

  @override
  String get searchAndBook => 'ابحث عن رحلة وابدأ بالحجز';

  @override
  String get pastTripsAppearHere => 'ستظهر رحلاتك السابقة هنا';

  @override
  String get cancelledBookingsAppearHere =>
      'الحجوزات التي تم إلغاؤها ستظهر هنا';

  @override
  String get searchForTripButton => 'ابحث عن رحلة';

  @override
  String get myTripsAsDriver => 'رحلاتي كسائق';

  @override
  String get noDriverTripsYet => 'لم تنشئ أي رحلات بعد';

  @override
  String get noPassengerBookingsYet => 'لم تحجز أي رحلات بعد';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get verifyDriverAccountMenu => 'توثيق حساب السائق';

  @override
  String get notVerified => 'غير موثق';

  @override
  String get savedAddresses => 'العناوين المحفوظة';

  @override
  String get emergencyContacts => 'جهات اتصال الطوارئ';

  @override
  String get language => 'اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get helpAndSupport => 'المساعدة والدعم';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get termsOfService => 'شروط الاستخدام';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirm => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get user => 'مستخدم';

  @override
  String tripsCount(int count) {
    return '$count رحلة';
  }

  @override
  String appVersion(String version) {
    return 'سهم v$version';
  }

  @override
  String get lowBalanceWarning =>
      'رصيدك منخفض. اشحن رصيدك لتتمكن من قبول الحجوزات.';

  @override
  String get recentTransactions => 'المعاملات الأخيرة';

  @override
  String get noTransactions => 'لا توجد معاملات بعد';

  @override
  String get topUpBalance => 'شحن الرصيد';

  @override
  String get chooseTopUpAmount => 'اختر المبلغ الذي تريد شحنه';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get paymentStep1 => 'حوّل المبلغ عبر CliQ إلى: sahm@cliq';

  @override
  String get paymentStep2 => 'أرسل لنا صورة الإيصال';

  @override
  String get paymentStep3 => 'سيتم إضافة الرصيد خلال دقائق';

  @override
  String get contactViaWhatsapp => 'تواصل معنا عبر واتساب';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get noNotifications => 'لا توجد إشعارات';

  @override
  String get newNotificationsAppearHere => 'ستظهر الإشعارات الجديدة هنا';

  @override
  String get now => 'الآن';

  @override
  String minutesAgo(int minutes) {
    return 'منذ $minutes د';
  }

  @override
  String hoursAgo(int hours) {
    return 'منذ $hours س';
  }

  @override
  String daysAgo(int days) {
    return 'منذ $days يوم';
  }

  @override
  String get rating => 'تقييم';

  @override
  String get howWasExperience => 'كيف كانت تجربتك مع';

  @override
  String get pleaseSelectRating => 'يرجى اختيار تقييم';

  @override
  String get thankYouForRating => 'شكراً لتقييمك!';

  @override
  String get ratingFailed => 'فشل إرسال التقييم';

  @override
  String get submitRating => 'إرسال التقييم';

  @override
  String get addCommentOptional => 'أضف تعليقاً (اختياري)...';

  @override
  String get ratingBad => 'سيئة';

  @override
  String get ratingAcceptable => 'مقبولة';

  @override
  String get ratingGood => 'جيدة';

  @override
  String get ratingVeryGood => 'جيدة جداً';

  @override
  String get ratingExcellent => 'ممتازة';

  @override
  String get confirmLocation => 'تأكيد الموقع';

  @override
  String get oneSeat => 'مقعد واحد';

  @override
  String get twoSeats => 'مقعدان';

  @override
  String nSeats(int count) {
    return '$count مقاعد';
  }

  @override
  String nSeat(int count) {
    return '$count مقعد';
  }

  @override
  String get phoneRequired => 'الرجاء إدخال رقم الموبايل';

  @override
  String get phoneInvalid => 'رقم الموبايل غير صحيح';

  @override
  String fieldRequired(String field) {
    return '$field مطلوب';
  }

  @override
  String get thisFieldRequired => 'هذا الحقل مطلوب';

  @override
  String get emailInvalid => 'البريد الإلكتروني غير صحيح';

  @override
  String minLengthError(String field, int min) {
    return '$field يجب أن يكون $min أحرف على الأقل';
  }

  @override
  String get browseSubscriptions => 'تصفح الخطوط';

  @override
  String get mySubscriptions => 'اشتراكاتي';

  @override
  String get myLines => 'خطوطي';

  @override
  String get createLine => 'إنشاء خط جديد';

  @override
  String get lineDetails => 'تفاصيل الخط';

  @override
  String get lineCreatedSuccess => 'تم إنشاء الخط بنجاح';

  @override
  String get publishLine => 'نشر الخط';

  @override
  String get daysOfWeek => 'أيام الأسبوع';

  @override
  String get selectAtLeastOneDay => 'اختر يوماً واحداً على الأقل';

  @override
  String get monthlyPriceJod => 'السعر الشهري (د.أ)';

  @override
  String get returnTime => 'وقت العودة';

  @override
  String get femaleOnlyLineDesc => 'هذا الخط للنساء فقط';

  @override
  String get noSubscriptionsFound => 'لا توجد خطوط متاحة';

  @override
  String get subscribedSuccess => 'تم الاشتراك بنجاح';

  @override
  String get subscribeNow => 'اشترك الآن';

  @override
  String get noActiveSubscriptions => 'لا توجد اشتراكات حالية';

  @override
  String get subscriptionCancelled => 'تم إلغاء الاشتراك';

  @override
  String get cancelSubscriptionConfirm => 'هل أنت متأكد من إلغاء هذا الاشتراك؟';

  @override
  String get confirm => 'تأكيد';

  @override
  String get cancelSubscriptionBtn => 'إلغاء الاشتراك';

  @override
  String get jodPerMonth => 'د.أ/شهر';

  @override
  String get active => 'نشط';

  @override
  String get paused => 'متوقف';

  @override
  String get closed => 'مغلق';

  @override
  String get seatsAvailable => 'مقعد متاح';

  @override
  String get noLinesYet => 'لا توجد خطوط بعد';

  @override
  String get pauseLine => 'إيقاف مؤقت';

  @override
  String get resumeLine => 'استئناف';

  @override
  String get closeLine => 'إغلاق الخط';

  @override
  String get closeLineConfirm =>
      'هل أنت متأكد من إغلاق هذا الخط؟ سيتم إلغاء جميع الاشتراكات.';

  @override
  String get driverCard => 'بطاقة السائق';

  @override
  String get remainingRides => 'الرحلات المتبقية';

  @override
  String get ride => 'رحلة';

  @override
  String get purchased => 'تم شراؤها';

  @override
  String get used => 'تم استخدامها';

  @override
  String get topUpCard => 'شحن البطاقة';

  @override
  String get topupSuccess => 'تم شحن البطاقة بنجاح';

  @override
  String get confirmTopup => 'تأكيد شحن البطاقة';

  @override
  String get jod => 'د.أ';

  @override
  String get bonus => 'مكافأة';

  @override
  String get jodPerRide => 'د.أ/رحلة';

  @override
  String get viewTransactions => 'عرض المعاملات';

  @override
  String get subscriptions => 'الاشتراكات';

  @override
  String get monthly => 'شهري';

  @override
  String get weekly => 'أسبوعي';

  @override
  String get daily => 'يومي';

  @override
  String get serviceFeeLabel => 'رسوم الخدمة';

  @override
  String get basePrice => 'السعر الأساسي';

  @override
  String get todayTripsTitle => 'رحلات اليوم';

  @override
  String get noTripsToday => 'لا توجد رحلات اليوم';

  @override
  String get driverConfirmation => 'تأكيد السائق';

  @override
  String get yourConfirmation => 'تأكيدك';

  @override
  String get confirmPresent => 'حاضر';

  @override
  String get confirmAbsent => 'غائب';

  @override
  String get attendanceConfirmed => 'تم تأكيد الحضور';

  @override
  String get attendanceDisputed => 'تضارب في تأكيد الحضور - سيتم المراجعة';

  @override
  String get present => 'حاضر';

  @override
  String get absent => 'غائب';

  @override
  String get pendingConfirmation => 'بانتظار التأكيد';

  @override
  String get inProgress => 'جارية';

  @override
  String get completed => 'مكتملة';

  @override
  String get tripCancelled => 'ملغاة';

  @override
  String get scheduled => 'مجدولة';

  @override
  String get paymentHistory => 'سجل المدفوعات';

  @override
  String get noPayments => 'لا توجد مدفوعات بعد';

  @override
  String get paid => 'مدفوع';

  @override
  String get overdue => 'متأخر';

  @override
  String get pendingPayment => 'بانتظار الدفع';

  @override
  String get renewSubscription => 'تجديد الاشتراك';

  @override
  String get subscriptionRenewed => 'تم تجديد الاشتراك بنجاح';

  @override
  String get billingPeriod => 'فترة الفوترة';

  @override
  String get autoRenewLabel => 'تجديد تلقائي';

  @override
  String get searchPlaceHint => 'ابحث عن مكان...';

  @override
  String get upcomingTrips => 'رحلاتك القادمة';

  @override
  String get availableTripsSoon => 'رحلات متاحة قريباً';

  @override
  String get noUpcomingTripsYet => 'لا توجد رحلات قادمة';

  @override
  String get bookYourFirstTrip => 'ابحث عن رحلة واحجز مقعدك';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String departsIn(String time) {
    return 'تغادر خلال $time';
  }

  @override
  String get noAvailableTrips => 'لا توجد رحلات متاحة حالياً';

  @override
  String get pendingBookingRequests => 'طلبات بانتظار موافقتك';

  @override
  String get yourUpcomingTrips => 'رحلاتك القادمة';

  @override
  String get noUpcomingDriverTrips => 'لا توجد رحلات قادمة لك';

  @override
  String get postTripToStart => 'أنشئ رحلة ليجدك الركاب';

  @override
  String get noPendingRequests => 'لا توجد طلبات حجز حالياً';

  @override
  String get acceptRequest => 'قبول';

  @override
  String get rejectRequest => 'رفض';

  @override
  String seatsRequested(int count) {
    return '$count مقاعد مطلوبة';
  }

  @override
  String get requestAccepted => 'تم قبول الحجز';

  @override
  String get requestRejected => 'تم رفض الحجز';

  @override
  String get hours => 'ساعة';

  @override
  String get minutes => 'دقيقة';

  @override
  String get today => 'اليوم';

  @override
  String get tomorrow => 'غداً';

  @override
  String get yourDailyCommute => 'مسارك اليومي';

  @override
  String get setYourDailyRoute => 'حدد مسار تنقلك اليومي';

  @override
  String get setDailyRouteDesc =>
      'حدد من أين تنطلق وإلى أين تذهب يومياً، وسنجد لك سائقين على نفس المسار';

  @override
  String get setRoute => 'حدد المسار';

  @override
  String get driversOnYourRoute => 'سائقين على مسارك';

  @override
  String get changeRoute => 'تغيير';

  @override
  String get noDriversOnRoute => 'لا يوجد سائقين على مسارك حالياً';

  @override
  String get checkBackLater => 'تحقق لاحقاً، سائقين جدد ينضمون يومياً';

  @override
  String get commuteFrom => 'من أين تنطلق؟';

  @override
  String get commuteTo => 'إلى أين تذهب؟';

  @override
  String get saveCommute => 'حفظ المسار';

  @override
  String get deleteRoute => 'حذف المسار';

  @override
  String seatsRemaining(int count) {
    return '$count مقاعد متبقية';
  }

  @override
  String get trackingRoute => 'جارٍ تتبع الطريق';

  @override
  String get carColor => 'فضي';

  @override
  String get plateNumber => '45-2342';

  @override
  String get ac => 'تكييف';

  @override
  String get seat => 'مقعد';

  @override
  String get rechargeCard => 'بطاقة شحن';

  @override
  String get rechargeCardDesc =>
      'أدخل رقم بطاقة الشحن المدفوعة مسبقاً لشحن رصيد محفظتك';

  @override
  String get cardNumber => 'رقم البطاقة';

  @override
  String get cardNumberHint => 'XXXX-XXXX-XXXX';

  @override
  String get rechargeNow => 'شحن الآن';

  @override
  String get rechargeSuccess => 'تم شحن الرصيد بنجاح!';

  @override
  String rechargedAmount(String amount) {
    return 'تمت إضافة $amount د.أ إلى محفظتك';
  }

  @override
  String get invalidCardCode => 'رقم بطاقة الشحن غير صالح';

  @override
  String get cardAlreadyUsed => 'بطاقة الشحن هذه مستخدمة بالفعل';

  @override
  String get enterCardNumber => 'يرجى إدخال رقم البطاقة';

  @override
  String get orRechargeWithCard => 'أو اشحن ببطاقة مسبقة الدفع';

  @override
  String get done => 'تم';

  @override
  String get driverOnline => 'متصل - تستقبل الطلبات';

  @override
  String get driverOffline => 'غير متصل';

  @override
  String get goOnline => 'ابدأ استقبال الطلبات';

  @override
  String get goOffline => 'أوقف استقبال الطلبات';

  @override
  String get createNewOrder => 'إنشاء طلب جديد';

  @override
  String get createOrderDesc => 'أنشئ طلب توصيل لمطعمك';

  @override
  String get myRecentOrders => 'طلباتي الأخيرة';

  @override
  String get noOrdersYet => 'لا توجد طلبات بعد';

  @override
  String get availableOrdersTitle => 'طلبات متاحة للتوصيل';

  @override
  String get noAvailableOrders => 'لا توجد طلبات متاحة حالياً';
}
