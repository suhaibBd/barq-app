import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'سهم'**
  String get appName;

  /// No description provided for @navHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get navHome;

  /// No description provided for @navSearch.
  ///
  /// In ar, this message translates to:
  /// **'البحث'**
  String get navSearch;

  /// No description provided for @navMyTrips.
  ///
  /// In ar, this message translates to:
  /// **'رحلاتي'**
  String get navMyTrips;

  /// No description provided for @navProfile.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get navProfile;

  /// No description provided for @orders.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات'**
  String get orders;

  /// No description provided for @welcomeTitle.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك في سهم'**
  String get welcomeTitle;

  /// No description provided for @enterPhoneSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم موبايلك للبدء'**
  String get enterPhoneSubtitle;

  /// No description provided for @phoneHint.
  ///
  /// In ar, this message translates to:
  /// **'7X XXXX XXX'**
  String get phoneHint;

  /// No description provided for @phoneLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phoneLabel;

  /// No description provided for @sendOtp.
  ///
  /// In ar, this message translates to:
  /// **'إرسال رمز التحقق'**
  String get sendOtp;

  /// No description provided for @willSendSms.
  ///
  /// In ar, this message translates to:
  /// **'سنرسل لك رمز تحقق عبر SMS'**
  String get willSendSms;

  /// No description provided for @termsAgreement.
  ///
  /// In ar, this message translates to:
  /// **'بالمتابعة، أنت توافق على شروط الاستخدام وسياسة الخصوصية'**
  String get termsAgreement;

  /// No description provided for @devLogin.
  ///
  /// In ar, this message translates to:
  /// **'دخول تجريبي (Dev)'**
  String get devLogin;

  /// No description provided for @devLoginDriver.
  ///
  /// In ar, this message translates to:
  /// **'دخول كسائق'**
  String get devLoginDriver;

  /// No description provided for @devLoginPassenger.
  ///
  /// In ar, this message translates to:
  /// **'دخول كمطعم'**
  String get devLoginRestaurant;

  /// No description provided for @enterOtp.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رمز التحقق'**
  String get enterOtp;

  /// No description provided for @otpSentTo.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال رمز التحقق إلى\n{phone}'**
  String otpSentTo(String phone);

  /// No description provided for @resendIn.
  ///
  /// In ar, this message translates to:
  /// **'إعادة الإرسال بعد {seconds} ثانية'**
  String resendIn(int seconds);

  /// No description provided for @resendCode.
  ///
  /// In ar, this message translates to:
  /// **'إعادة إرسال الرمز'**
  String get resendCode;

  /// No description provided for @verify.
  ///
  /// In ar, this message translates to:
  /// **'تحقق'**
  String get verify;

  /// No description provided for @howToUseAutostrad.
  ///
  /// In ar, this message translates to:
  /// **'كيف تريد استخدام سهم؟'**
  String get howToUseAutostrad;

  /// No description provided for @chooseRegistration.
  ///
  /// In ar, this message translates to:
  /// **'اختر طريقة التسجيل المناسبة لك'**
  String get chooseRegistration;

  /// No description provided for @passenger.
  ///
  /// In ar, this message translates to:
  /// **'راكب'**
  String get passenger;

  /// No description provided for @restaurant.
  ///
  /// In ar, this message translates to:
  /// **'مطعم'**
  String get restaurant;

  /// No description provided for @driver.
  ///
  /// In ar, this message translates to:
  /// **'سائق'**
  String get driver;

  /// No description provided for @passengerSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن رحلات واحجز مقعدك'**
  String get passengerSubtitle;

  /// No description provided for @restaurantSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ طلبات توصيل لمطعمك'**
  String get restaurantSubtitle;

  /// No description provided for @driverSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'وصّل الطلبات واكسب دخلاً إضافياً'**
  String get driverSubtitle;

  /// No description provided for @switchRoleLater.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك التبديل بين الوضعين لاحقاً من الإعدادات'**
  String get switchRoleLater;

  /// No description provided for @registerAsPassenger.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل كراكب'**
  String get registerAsPassenger;

  /// No description provided for @registerAsRestaurant.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل كمطعم'**
  String get registerAsRestaurant;

  /// No description provided for @enterNameToStart.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسمك للبدء'**
  String get enterNameToStart;

  /// No description provided for @firstName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الأول'**
  String get firstName;

  /// No description provided for @firstNameHint.
  ///
  /// In ar, this message translates to:
  /// **'أحمد'**
  String get firstNameHint;

  /// No description provided for @lastName.
  ///
  /// In ar, this message translates to:
  /// **'اسم العائلة'**
  String get lastName;

  /// No description provided for @lastNameHint.
  ///
  /// In ar, this message translates to:
  /// **'محمد'**
  String get lastNameHint;

  /// No description provided for @firstNameRequired.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الأول مطلوب'**
  String get firstNameRequired;

  /// No description provided for @lastNameRequired.
  ///
  /// In ar, this message translates to:
  /// **'اسم العائلة مطلوب'**
  String get lastNameRequired;

  /// No description provided for @emailOptional.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني (اختياري)'**
  String get emailOptional;

  /// No description provided for @saveChanges.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التغييرات'**
  String get saveChanges;

  /// No description provided for @profileUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث الملف الشخصي'**
  String get profileUpdated;

  /// No description provided for @account.
  ///
  /// In ar, this message translates to:
  /// **'الحساب'**
  String get account;

  /// No description provided for @settingsAndHelp.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات والمساعدة'**
  String get settingsAndHelp;

  /// No description provided for @comingSoon.
  ///
  /// In ar, this message translates to:
  /// **'قريباً'**
  String get comingSoon;

  /// No description provided for @createAccount.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء الحساب'**
  String get createAccount;

  /// No description provided for @registerAsDriver.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل كسائق'**
  String get registerAsDriver;

  /// No description provided for @completeDocsToStart.
  ///
  /// In ar, this message translates to:
  /// **'أكمل بياناتك ووثائقك للبدء'**
  String get completeDocsToStart;

  /// No description provided for @requiredDocs.
  ///
  /// In ar, this message translates to:
  /// **'الوثائق المطلوبة'**
  String get requiredDocs;

  /// No description provided for @nationalId.
  ///
  /// In ar, this message translates to:
  /// **'صورة الهوية الشخصية'**
  String get nationalId;

  /// No description provided for @driverLicense.
  ///
  /// In ar, this message translates to:
  /// **'صورة رخصة القيادة'**
  String get driverLicense;

  /// No description provided for @carImage.
  ///
  /// In ar, this message translates to:
  /// **'صورة المركبة'**
  String get carImage;

  /// No description provided for @carNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم لوحة المركبة'**
  String get carNumber;

  /// No description provided for @carNumberHint.
  ///
  /// In ar, this message translates to:
  /// **'00-00000'**
  String get carNumberHint;

  /// No description provided for @imageSelected.
  ///
  /// In ar, this message translates to:
  /// **'تم الاختيار'**
  String get imageSelected;

  /// No description provided for @tapToSelect.
  ///
  /// In ar, this message translates to:
  /// **'انقر للاختيار'**
  String get tapToSelect;

  /// No description provided for @pleaseAttachAllImages.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إرفاق جميع الصور المطلوبة'**
  String get pleaseAttachAllImages;

  /// No description provided for @hello.
  ///
  /// In ar, this message translates to:
  /// **'أهلاً بك 👋'**
  String get hello;

  /// No description provided for @whereToGo.
  ///
  /// In ar, this message translates to:
  /// **'إلى أين تريد الذهاب؟'**
  String get whereToGo;

  /// No description provided for @searchForTrip.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن رحلة...'**
  String get searchForTrip;

  /// No description provided for @popularDestinations.
  ///
  /// In ar, this message translates to:
  /// **'الوجهات الشائعة'**
  String get popularDestinations;

  /// No description provided for @fromPrice.
  ///
  /// In ar, this message translates to:
  /// **'من {price} د.أ'**
  String fromPrice(String price);

  /// No description provided for @howItWorks.
  ///
  /// In ar, this message translates to:
  /// **'كيف تعمل؟'**
  String get howItWorks;

  /// No description provided for @step1Title.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن رحلة'**
  String get step1Title;

  /// No description provided for @step1Subtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر وجهتك والتاريخ المناسب'**
  String get step1Subtitle;

  /// No description provided for @step2Title.
  ///
  /// In ar, this message translates to:
  /// **'احجز مقعدك'**
  String get step2Title;

  /// No description provided for @step2Subtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر عدد المقاعد وأكمل الحجز'**
  String get step2Subtitle;

  /// No description provided for @step3Title.
  ///
  /// In ar, this message translates to:
  /// **'استمتع بالرحلة'**
  String get step3Title;

  /// No description provided for @step3Subtitle.
  ///
  /// In ar, this message translates to:
  /// **'تواصل مع السائق وانطلق'**
  String get step3Subtitle;

  /// No description provided for @verifyDriverAccount.
  ///
  /// In ar, this message translates to:
  /// **'وثّق حسابك كسائق'**
  String get verifyDriverAccount;

  /// No description provided for @verifyDriverDescription.
  ///
  /// In ar, this message translates to:
  /// **'للبدء بنشر رحلات وقبول الركاب، يجب توثيق حسابك أولاً'**
  String get verifyDriverDescription;

  /// No description provided for @startVerification.
  ///
  /// In ar, this message translates to:
  /// **'بدء التوثيق'**
  String get startVerification;

  /// No description provided for @docsUnderReview.
  ///
  /// In ar, this message translates to:
  /// **'الوثائق قيد المراجعة'**
  String get docsUnderReview;

  /// No description provided for @docsUnderReviewDesc.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال وثائقك وهي قيد المراجعة من قبل الإدارة. سيتم إشعارك عند الموافقة.'**
  String get docsUnderReviewDesc;

  /// No description provided for @docsRejected.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض الوثائق'**
  String get docsRejected;

  /// No description provided for @docsRejectedDesc.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض وثائقك. يرجى إعادة رفعها مع التأكد من وضوح الصور.'**
  String get docsRejectedDesc;

  /// No description provided for @resubmitDocs.
  ///
  /// In ar, this message translates to:
  /// **'إعادة رفع الوثائق'**
  String get resubmitDocs;

  /// No description provided for @wallet.
  ///
  /// In ar, this message translates to:
  /// **'المحفظة'**
  String get wallet;

  /// No description provided for @currentBalance.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد الحالي'**
  String get currentBalance;

  /// No description provided for @balanceAmount.
  ///
  /// In ar, this message translates to:
  /// **'{amount} د.أ'**
  String balanceAmount(String amount);

  /// No description provided for @topUp.
  ///
  /// In ar, this message translates to:
  /// **'شحن الرصيد'**
  String get topUp;

  /// No description provided for @createNewTrip.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ رحلة جديدة'**
  String get createNewTrip;

  /// No description provided for @publishTripDescription.
  ///
  /// In ar, this message translates to:
  /// **'شارك مسارك مع الركاب'**
  String get publishTripDescription;

  /// No description provided for @recentBookingRequests.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الحجز الأخيرة'**
  String get recentBookingRequests;

  /// No description provided for @noBookingRequests.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات حجز حالياً'**
  String get noBookingRequests;

  /// No description provided for @searchForTripTitle.
  ///
  /// In ar, this message translates to:
  /// **'البحث عن رحلة'**
  String get searchForTripTitle;

  /// No description provided for @fromWhere.
  ///
  /// In ar, this message translates to:
  /// **'من أين؟'**
  String get fromWhere;

  /// No description provided for @toWhere.
  ///
  /// In ar, this message translates to:
  /// **'إلى أين؟'**
  String get toWhere;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get search;

  /// No description provided for @noTripsFound.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد رحلات من {from} إلى {to}'**
  String noTripsFound(String from, String to);

  /// No description provided for @tryChangingFilters.
  ///
  /// In ar, this message translates to:
  /// **'جرّب تغيير التاريخ أو عدد المقاعد'**
  String get tryChangingFilters;

  /// No description provided for @searchNextTrip.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن رحلتك القادمة'**
  String get searchNextTrip;

  /// No description provided for @tripCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} رحلة'**
  String tripCount(int count);

  /// No description provided for @cheapest.
  ///
  /// In ar, this message translates to:
  /// **'الأرخص'**
  String get cheapest;

  /// No description provided for @earliest.
  ///
  /// In ar, this message translates to:
  /// **'الأقرب'**
  String get earliest;

  /// No description provided for @topRated.
  ///
  /// In ar, this message translates to:
  /// **'الأعلى تقييماً'**
  String get topRated;

  /// No description provided for @perSeat.
  ///
  /// In ar, this message translates to:
  /// **'للمقعد'**
  String get perSeat;

  /// No description provided for @tripDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الرحلة'**
  String get tripDetails;

  /// No description provided for @departurePoint.
  ///
  /// In ar, this message translates to:
  /// **'نقطة الانطلاق'**
  String get departurePoint;

  /// No description provided for @destination.
  ///
  /// In ar, this message translates to:
  /// **'الوجهة'**
  String get destination;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'سيتم التحميل...'**
  String get loading;

  /// No description provided for @date.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ'**
  String get date;

  /// No description provided for @departureTime.
  ///
  /// In ar, this message translates to:
  /// **'وقت المغادرة'**
  String get departureTime;

  /// No description provided for @availableSeats.
  ///
  /// In ar, this message translates to:
  /// **'المقاعد المتاحة'**
  String get availableSeats;

  /// No description provided for @pricePerSeat.
  ///
  /// In ar, this message translates to:
  /// **'السعر للمقعد'**
  String get pricePerSeat;

  /// No description provided for @tripRules.
  ///
  /// In ar, this message translates to:
  /// **'قواعد الرحلة'**
  String get tripRules;

  /// No description provided for @noSmoking.
  ///
  /// In ar, this message translates to:
  /// **'ممنوع التدخين'**
  String get noSmoking;

  /// No description provided for @smokingAllowed.
  ///
  /// In ar, this message translates to:
  /// **'التدخين مسموح'**
  String get smokingAllowed;

  /// No description provided for @verified.
  ///
  /// In ar, this message translates to:
  /// **'موثّق'**
  String get verified;

  /// No description provided for @pets.
  ///
  /// In ar, this message translates to:
  /// **'حيوانات أليفة'**
  String get pets;

  /// No description provided for @music.
  ///
  /// In ar, this message translates to:
  /// **'موسيقى'**
  String get music;

  /// No description provided for @luggage.
  ///
  /// In ar, this message translates to:
  /// **'أمتعة'**
  String get luggage;

  /// No description provided for @pickupOptions.
  ///
  /// In ar, this message translates to:
  /// **'خيارات الالتقاء'**
  String get pickupOptions;

  /// No description provided for @meetingPoint.
  ///
  /// In ar, this message translates to:
  /// **'نقطة التقاء محددة'**
  String get meetingPoint;

  /// No description provided for @doorToDoor.
  ///
  /// In ar, this message translates to:
  /// **'من الباب إلى الباب'**
  String get doorToDoor;

  /// No description provided for @bookNow.
  ///
  /// In ar, this message translates to:
  /// **'احجز الآن'**
  String get bookNow;

  /// No description provided for @driverName.
  ///
  /// In ar, this message translates to:
  /// **'اسم السائق'**
  String get driverName;

  /// No description provided for @femaleOnly.
  ///
  /// In ar, this message translates to:
  /// **'نساء فقط'**
  String get femaleOnly;

  /// No description provided for @createTripTitle.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء رحلة جديدة'**
  String get createTripTitle;

  /// No description provided for @from.
  ///
  /// In ar, this message translates to:
  /// **'من'**
  String get from;

  /// No description provided for @to.
  ///
  /// In ar, this message translates to:
  /// **'إلى'**
  String get to;

  /// No description provided for @selectFrom.
  ///
  /// In ar, this message translates to:
  /// **'اختر {label}'**
  String selectFrom(String label);

  /// No description provided for @time.
  ///
  /// In ar, this message translates to:
  /// **'الوقت'**
  String get time;

  /// No description provided for @priceCurrency.
  ///
  /// In ar, this message translates to:
  /// **'السعر (د.أ)'**
  String get priceCurrency;

  /// No description provided for @seatCount.
  ///
  /// In ar, this message translates to:
  /// **'عدد المقاعد'**
  String get seatCount;

  /// No description provided for @notesOptional.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات (اختياري)'**
  String get notesOptional;

  /// No description provided for @notesHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: التجمع عند دوار المدينة...'**
  String get notesHint;

  /// No description provided for @publishTrip.
  ///
  /// In ar, this message translates to:
  /// **'نشر الرحلة'**
  String get publishTrip;

  /// No description provided for @tripCreatedSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الرحلة بنجاح'**
  String get tripCreatedSuccess;

  /// No description provided for @tripCreateFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل إنشاء الرحلة'**
  String get tripCreateFailed;

  /// No description provided for @selectStartAndEnd.
  ///
  /// In ar, this message translates to:
  /// **'يرجى تحديد نقطة الانطلاق والوصول'**
  String get selectStartAndEnd;

  /// No description provided for @enterValidPrice.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال سعر صحيح'**
  String get enterValidPrice;

  /// No description provided for @seatsBetween1And7.
  ///
  /// In ar, this message translates to:
  /// **'عدد المقاعد يجب أن يكون بين 1 و 7'**
  String get seatsBetween1And7;

  /// No description provided for @selectStartPoint.
  ///
  /// In ar, this message translates to:
  /// **'اختر نقطة الانطلاق'**
  String get selectStartPoint;

  /// No description provided for @selectEndPoint.
  ///
  /// In ar, this message translates to:
  /// **'اختر نقطة الوصول'**
  String get selectEndPoint;

  /// No description provided for @poolingPoint.
  ///
  /// In ar, this message translates to:
  /// **'نقطة التجمع'**
  String get poolingPoint;

  /// No description provided for @pickupFromHome.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل من المنزل'**
  String get pickupFromHome;

  /// No description provided for @pickupFromHomeDesc.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك استلام الراكب من منزله'**
  String get pickupFromHomeDesc;

  /// No description provided for @optional.
  ///
  /// In ar, this message translates to:
  /// **'اختياري'**
  String get optional;

  /// No description provided for @bookSeats.
  ///
  /// In ar, this message translates to:
  /// **'حجز مقاعد'**
  String get bookSeats;

  /// No description provided for @tripSummary.
  ///
  /// In ar, this message translates to:
  /// **'ملخص الرحلة'**
  String get tripSummary;

  /// No description provided for @numberOfSeats.
  ///
  /// In ar, this message translates to:
  /// **'عدد المقاعد'**
  String get numberOfSeats;

  /// No description provided for @additionalPassengerNames.
  ///
  /// In ar, this message translates to:
  /// **'أسماء الركاب الإضافيين'**
  String get additionalPassengerNames;

  /// No description provided for @enterPassengerNames.
  ///
  /// In ar, this message translates to:
  /// **'أدخل أسماء الأشخاص الذين ستحجز لهم'**
  String get enterPassengerNames;

  /// No description provided for @passengerN.
  ///
  /// In ar, this message translates to:
  /// **'الراكب {n}'**
  String passengerN(int n);

  /// No description provided for @fullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get fullName;

  /// No description provided for @enterPassengerName.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال اسم الراكب'**
  String get enterPassengerName;

  /// No description provided for @anyNotesForDriver.
  ///
  /// In ar, this message translates to:
  /// **'أي ملاحظات للسائق...'**
  String get anyNotesForDriver;

  /// No description provided for @seatPriceMultiplied.
  ///
  /// In ar, this message translates to:
  /// **'سعر المقعد × {count}'**
  String seatPriceMultiplied(int count);

  /// No description provided for @total.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get total;

  /// No description provided for @bookingTerms.
  ///
  /// In ar, this message translates to:
  /// **'أوافق على شروط الاستخدام وسياسة الحجز. الدفع يتم مباشرة للسائق (نقداً أو CliQ).'**
  String get bookingTerms;

  /// No description provided for @confirmBooking.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الحجز'**
  String get confirmBooking;

  /// No description provided for @perSeatPrice.
  ///
  /// In ar, this message translates to:
  /// **'{price} / مقعد'**
  String perSeatPrice(String price);

  /// No description provided for @myBookings.
  ///
  /// In ar, this message translates to:
  /// **'حجوزاتي'**
  String get myBookings;

  /// No description provided for @upcoming.
  ///
  /// In ar, this message translates to:
  /// **'القادمة'**
  String get upcoming;

  /// No description provided for @past.
  ///
  /// In ar, this message translates to:
  /// **'السابقة'**
  String get past;

  /// No description provided for @cancelled.
  ///
  /// In ar, this message translates to:
  /// **'الملغاة'**
  String get cancelled;

  /// No description provided for @noUpcomingBookings.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد حجوزات قادمة'**
  String get noUpcomingBookings;

  /// No description provided for @noPastBookings.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد حجوزات سابقة'**
  String get noPastBookings;

  /// No description provided for @noCancelledBookings.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد حجوزات ملغاة'**
  String get noCancelledBookings;

  /// No description provided for @searchAndBook.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن رحلة وابدأ بالحجز'**
  String get searchAndBook;

  /// No description provided for @pastTripsAppearHere.
  ///
  /// In ar, this message translates to:
  /// **'ستظهر رحلاتك السابقة هنا'**
  String get pastTripsAppearHere;

  /// No description provided for @cancelledBookingsAppearHere.
  ///
  /// In ar, this message translates to:
  /// **'الحجوزات التي تم إلغاؤها ستظهر هنا'**
  String get cancelledBookingsAppearHere;

  /// No description provided for @searchForTripButton.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن رحلة'**
  String get searchForTripButton;

  /// No description provided for @myTripsAsDriver.
  ///
  /// In ar, this message translates to:
  /// **'رحلاتي كسائق'**
  String get myTripsAsDriver;

  /// No description provided for @noDriverTripsYet.
  ///
  /// In ar, this message translates to:
  /// **'لم تنشئ أي رحلات بعد'**
  String get noDriverTripsYet;

  /// No description provided for @noPassengerBookingsYet.
  ///
  /// In ar, this message translates to:
  /// **'لم تحجز أي رحلات بعد'**
  String get noPassengerBookingsYet;

  /// No description provided for @somethingWentWrong.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ ما'**
  String get somethingWentWrong;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @editProfile.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الملف الشخصي'**
  String get editProfile;

  /// No description provided for @verifyDriverAccountMenu.
  ///
  /// In ar, this message translates to:
  /// **'توثيق حساب السائق'**
  String get verifyDriverAccountMenu;

  /// No description provided for @notVerified.
  ///
  /// In ar, this message translates to:
  /// **'غير موثق'**
  String get notVerified;

  /// No description provided for @savedAddresses.
  ///
  /// In ar, this message translates to:
  /// **'العناوين المحفوظة'**
  String get savedAddresses;

  /// No description provided for @emergencyContacts.
  ///
  /// In ar, this message translates to:
  /// **'جهات اتصال الطوارئ'**
  String get emergencyContacts;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @helpAndSupport.
  ///
  /// In ar, this message translates to:
  /// **'المساعدة والدعم'**
  String get helpAndSupport;

  /// No description provided for @privacyPolicy.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In ar, this message translates to:
  /// **'شروط الاستخدام'**
  String get termsOfService;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من تسجيل الخروج؟'**
  String get logoutConfirm;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @user.
  ///
  /// In ar, this message translates to:
  /// **'مستخدم'**
  String get user;

  /// No description provided for @tripsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} رحلة'**
  String tripsCount(int count);

  /// No description provided for @appVersion.
  ///
  /// In ar, this message translates to:
  /// **'سهم v{version}'**
  String appVersion(String version);

  /// No description provided for @lowBalanceWarning.
  ///
  /// In ar, this message translates to:
  /// **'رصيدك منخفض. اشحن رصيدك لتتمكن من قبول الحجوزات.'**
  String get lowBalanceWarning;

  /// No description provided for @recentTransactions.
  ///
  /// In ar, this message translates to:
  /// **'المعاملات الأخيرة'**
  String get recentTransactions;

  /// No description provided for @noTransactions.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد معاملات بعد'**
  String get noTransactions;

  /// No description provided for @topUpBalance.
  ///
  /// In ar, this message translates to:
  /// **'شحن الرصيد'**
  String get topUpBalance;

  /// No description provided for @chooseTopUpAmount.
  ///
  /// In ar, this message translates to:
  /// **'اختر المبلغ الذي تريد شحنه'**
  String get chooseTopUpAmount;

  /// No description provided for @paymentMethod.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الدفع'**
  String get paymentMethod;

  /// No description provided for @paymentStep1.
  ///
  /// In ar, this message translates to:
  /// **'حوّل المبلغ عبر CliQ إلى: sahm@cliq'**
  String get paymentStep1;

  /// No description provided for @paymentStep2.
  ///
  /// In ar, this message translates to:
  /// **'أرسل لنا صورة الإيصال'**
  String get paymentStep2;

  /// No description provided for @paymentStep3.
  ///
  /// In ar, this message translates to:
  /// **'سيتم إضافة الرصيد خلال دقائق'**
  String get paymentStep3;

  /// No description provided for @contactViaWhatsapp.
  ///
  /// In ar, this message translates to:
  /// **'تواصل معنا عبر واتساب'**
  String get contactViaWhatsapp;

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إشعارات'**
  String get noNotifications;

  /// No description provided for @newNotificationsAppearHere.
  ///
  /// In ar, this message translates to:
  /// **'ستظهر الإشعارات الجديدة هنا'**
  String get newNotificationsAppearHere;

  /// No description provided for @now.
  ///
  /// In ar, this message translates to:
  /// **'الآن'**
  String get now;

  /// No description provided for @minutesAgo.
  ///
  /// In ar, this message translates to:
  /// **'منذ {minutes} د'**
  String minutesAgo(int minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In ar, this message translates to:
  /// **'منذ {hours} س'**
  String hoursAgo(int hours);

  /// No description provided for @daysAgo.
  ///
  /// In ar, this message translates to:
  /// **'منذ {days} يوم'**
  String daysAgo(int days);

  /// No description provided for @rating.
  ///
  /// In ar, this message translates to:
  /// **'تقييم'**
  String get rating;

  /// No description provided for @howWasExperience.
  ///
  /// In ar, this message translates to:
  /// **'كيف كانت تجربتك مع'**
  String get howWasExperience;

  /// No description provided for @pleaseSelectRating.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار تقييم'**
  String get pleaseSelectRating;

  /// No description provided for @thankYouForRating.
  ///
  /// In ar, this message translates to:
  /// **'شكراً لتقييمك!'**
  String get thankYouForRating;

  /// No description provided for @ratingFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل إرسال التقييم'**
  String get ratingFailed;

  /// No description provided for @submitRating.
  ///
  /// In ar, this message translates to:
  /// **'إرسال التقييم'**
  String get submitRating;

  /// No description provided for @addCommentOptional.
  ///
  /// In ar, this message translates to:
  /// **'أضف تعليقاً (اختياري)...'**
  String get addCommentOptional;

  /// No description provided for @ratingBad.
  ///
  /// In ar, this message translates to:
  /// **'سيئة'**
  String get ratingBad;

  /// No description provided for @ratingAcceptable.
  ///
  /// In ar, this message translates to:
  /// **'مقبولة'**
  String get ratingAcceptable;

  /// No description provided for @ratingGood.
  ///
  /// In ar, this message translates to:
  /// **'جيدة'**
  String get ratingGood;

  /// No description provided for @ratingVeryGood.
  ///
  /// In ar, this message translates to:
  /// **'جيدة جداً'**
  String get ratingVeryGood;

  /// No description provided for @ratingExcellent.
  ///
  /// In ar, this message translates to:
  /// **'ممتازة'**
  String get ratingExcellent;

  /// No description provided for @confirmLocation.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الموقع'**
  String get confirmLocation;

  /// No description provided for @oneSeat.
  ///
  /// In ar, this message translates to:
  /// **'مقعد واحد'**
  String get oneSeat;

  /// No description provided for @twoSeats.
  ///
  /// In ar, this message translates to:
  /// **'مقعدان'**
  String get twoSeats;

  /// No description provided for @nSeats.
  ///
  /// In ar, this message translates to:
  /// **'{count} مقاعد'**
  String nSeats(int count);

  /// No description provided for @nSeat.
  ///
  /// In ar, this message translates to:
  /// **'{count} مقعد'**
  String nSeat(int count);

  /// No description provided for @phoneRequired.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال رقم الموبايل'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In ar, this message translates to:
  /// **'رقم الموبايل غير صحيح'**
  String get phoneInvalid;

  /// No description provided for @fieldRequired.
  ///
  /// In ar, this message translates to:
  /// **'{field} مطلوب'**
  String fieldRequired(String field);

  /// No description provided for @thisFieldRequired.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get thisFieldRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني غير صحيح'**
  String get emailInvalid;

  /// No description provided for @minLengthError.
  ///
  /// In ar, this message translates to:
  /// **'{field} يجب أن يكون {min} أحرف على الأقل'**
  String minLengthError(String field, int min);

  /// No description provided for @browseSubscriptions.
  ///
  /// In ar, this message translates to:
  /// **'تصفح الخطوط'**
  String get browseSubscriptions;

  /// No description provided for @mySubscriptions.
  ///
  /// In ar, this message translates to:
  /// **'اشتراكاتي'**
  String get mySubscriptions;

  /// No description provided for @myLines.
  ///
  /// In ar, this message translates to:
  /// **'خطوطي'**
  String get myLines;

  /// No description provided for @createLine.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء خط جديد'**
  String get createLine;

  /// No description provided for @lineDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الخط'**
  String get lineDetails;

  /// No description provided for @lineCreatedSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الخط بنجاح'**
  String get lineCreatedSuccess;

  /// No description provided for @publishLine.
  ///
  /// In ar, this message translates to:
  /// **'نشر الخط'**
  String get publishLine;

  /// No description provided for @daysOfWeek.
  ///
  /// In ar, this message translates to:
  /// **'أيام الأسبوع'**
  String get daysOfWeek;

  /// No description provided for @selectAtLeastOneDay.
  ///
  /// In ar, this message translates to:
  /// **'اختر يوماً واحداً على الأقل'**
  String get selectAtLeastOneDay;

  /// No description provided for @monthlyPriceJod.
  ///
  /// In ar, this message translates to:
  /// **'السعر الشهري (د.أ)'**
  String get monthlyPriceJod;

  /// No description provided for @returnTime.
  ///
  /// In ar, this message translates to:
  /// **'وقت العودة'**
  String get returnTime;

  /// No description provided for @femaleOnlyLineDesc.
  ///
  /// In ar, this message translates to:
  /// **'هذا الخط للنساء فقط'**
  String get femaleOnlyLineDesc;

  /// No description provided for @noSubscriptionsFound.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد خطوط متاحة'**
  String get noSubscriptionsFound;

  /// No description provided for @subscribedSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم الاشتراك بنجاح'**
  String get subscribedSuccess;

  /// No description provided for @subscribeNow.
  ///
  /// In ar, this message translates to:
  /// **'اشترك الآن'**
  String get subscribeNow;

  /// No description provided for @noActiveSubscriptions.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد اشتراكات حالية'**
  String get noActiveSubscriptions;

  /// No description provided for @subscriptionCancelled.
  ///
  /// In ar, this message translates to:
  /// **'تم إلغاء الاشتراك'**
  String get subscriptionCancelled;

  /// No description provided for @cancelSubscriptionConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من إلغاء هذا الاشتراك؟'**
  String get cancelSubscriptionConfirm;

  /// No description provided for @confirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get confirm;

  /// No description provided for @cancelSubscriptionBtn.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الاشتراك'**
  String get cancelSubscriptionBtn;

  /// No description provided for @jodPerMonth.
  ///
  /// In ar, this message translates to:
  /// **'د.أ/شهر'**
  String get jodPerMonth;

  /// No description provided for @active.
  ///
  /// In ar, this message translates to:
  /// **'نشط'**
  String get active;

  /// No description provided for @paused.
  ///
  /// In ar, this message translates to:
  /// **'متوقف'**
  String get paused;

  /// No description provided for @closed.
  ///
  /// In ar, this message translates to:
  /// **'مغلق'**
  String get closed;

  /// No description provided for @seatsAvailable.
  ///
  /// In ar, this message translates to:
  /// **'مقعد متاح'**
  String get seatsAvailable;

  /// No description provided for @noLinesYet.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد خطوط بعد'**
  String get noLinesYet;

  /// No description provided for @pauseLine.
  ///
  /// In ar, this message translates to:
  /// **'إيقاف مؤقت'**
  String get pauseLine;

  /// No description provided for @resumeLine.
  ///
  /// In ar, this message translates to:
  /// **'استئناف'**
  String get resumeLine;

  /// No description provided for @closeLine.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق الخط'**
  String get closeLine;

  /// No description provided for @closeLineConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من إغلاق هذا الخط؟ سيتم إلغاء جميع الاشتراكات.'**
  String get closeLineConfirm;

  /// No description provided for @driverCard.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة السائق'**
  String get driverCard;

  /// No description provided for @remainingRides.
  ///
  /// In ar, this message translates to:
  /// **'الرحلات المتبقية'**
  String get remainingRides;

  /// No description provided for @ride.
  ///
  /// In ar, this message translates to:
  /// **'رحلة'**
  String get ride;

  /// No description provided for @purchased.
  ///
  /// In ar, this message translates to:
  /// **'تم شراؤها'**
  String get purchased;

  /// No description provided for @used.
  ///
  /// In ar, this message translates to:
  /// **'تم استخدامها'**
  String get used;

  /// No description provided for @topUpCard.
  ///
  /// In ar, this message translates to:
  /// **'شحن البطاقة'**
  String get topUpCard;

  /// No description provided for @topupSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم شحن البطاقة بنجاح'**
  String get topupSuccess;

  /// No description provided for @confirmTopup.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد شحن البطاقة'**
  String get confirmTopup;

  /// No description provided for @jod.
  ///
  /// In ar, this message translates to:
  /// **'د.أ'**
  String get jod;

  /// No description provided for @bonus.
  ///
  /// In ar, this message translates to:
  /// **'مكافأة'**
  String get bonus;

  /// No description provided for @jodPerRide.
  ///
  /// In ar, this message translates to:
  /// **'د.أ/رحلة'**
  String get jodPerRide;

  /// No description provided for @viewTransactions.
  ///
  /// In ar, this message translates to:
  /// **'عرض المعاملات'**
  String get viewTransactions;

  /// No description provided for @subscriptions.
  ///
  /// In ar, this message translates to:
  /// **'الاشتراكات'**
  String get subscriptions;

  /// No description provided for @monthly.
  ///
  /// In ar, this message translates to:
  /// **'شهري'**
  String get monthly;

  /// No description provided for @weekly.
  ///
  /// In ar, this message translates to:
  /// **'أسبوعي'**
  String get weekly;

  /// No description provided for @daily.
  ///
  /// In ar, this message translates to:
  /// **'يومي'**
  String get daily;

  /// No description provided for @serviceFeeLabel.
  ///
  /// In ar, this message translates to:
  /// **'رسوم الخدمة'**
  String get serviceFeeLabel;

  /// No description provided for @basePrice.
  ///
  /// In ar, this message translates to:
  /// **'السعر الأساسي'**
  String get basePrice;

  /// No description provided for @todayTripsTitle.
  ///
  /// In ar, this message translates to:
  /// **'رحلات اليوم'**
  String get todayTripsTitle;

  /// No description provided for @noTripsToday.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد رحلات اليوم'**
  String get noTripsToday;

  /// No description provided for @driverConfirmation.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد السائق'**
  String get driverConfirmation;

  /// No description provided for @yourConfirmation.
  ///
  /// In ar, this message translates to:
  /// **'تأكيدك'**
  String get yourConfirmation;

  /// No description provided for @confirmPresent.
  ///
  /// In ar, this message translates to:
  /// **'حاضر'**
  String get confirmPresent;

  /// No description provided for @confirmAbsent.
  ///
  /// In ar, this message translates to:
  /// **'غائب'**
  String get confirmAbsent;

  /// No description provided for @attendanceConfirmed.
  ///
  /// In ar, this message translates to:
  /// **'تم تأكيد الحضور'**
  String get attendanceConfirmed;

  /// No description provided for @attendanceDisputed.
  ///
  /// In ar, this message translates to:
  /// **'تضارب في تأكيد الحضور - سيتم المراجعة'**
  String get attendanceDisputed;

  /// No description provided for @present.
  ///
  /// In ar, this message translates to:
  /// **'حاضر'**
  String get present;

  /// No description provided for @absent.
  ///
  /// In ar, this message translates to:
  /// **'غائب'**
  String get absent;

  /// No description provided for @pendingConfirmation.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار التأكيد'**
  String get pendingConfirmation;

  /// No description provided for @inProgress.
  ///
  /// In ar, this message translates to:
  /// **'جارية'**
  String get inProgress;

  /// No description provided for @completed.
  ///
  /// In ar, this message translates to:
  /// **'مكتملة'**
  String get completed;

  /// No description provided for @tripCancelled.
  ///
  /// In ar, this message translates to:
  /// **'ملغاة'**
  String get tripCancelled;

  /// No description provided for @scheduled.
  ///
  /// In ar, this message translates to:
  /// **'مجدولة'**
  String get scheduled;

  /// No description provided for @paymentHistory.
  ///
  /// In ar, this message translates to:
  /// **'سجل المدفوعات'**
  String get paymentHistory;

  /// No description provided for @noPayments.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مدفوعات بعد'**
  String get noPayments;

  /// No description provided for @paid.
  ///
  /// In ar, this message translates to:
  /// **'مدفوع'**
  String get paid;

  /// No description provided for @overdue.
  ///
  /// In ar, this message translates to:
  /// **'متأخر'**
  String get overdue;

  /// No description provided for @pendingPayment.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار الدفع'**
  String get pendingPayment;

  /// No description provided for @renewSubscription.
  ///
  /// In ar, this message translates to:
  /// **'تجديد الاشتراك'**
  String get renewSubscription;

  /// No description provided for @subscriptionRenewed.
  ///
  /// In ar, this message translates to:
  /// **'تم تجديد الاشتراك بنجاح'**
  String get subscriptionRenewed;

  /// No description provided for @billingPeriod.
  ///
  /// In ar, this message translates to:
  /// **'فترة الفوترة'**
  String get billingPeriod;

  /// No description provided for @autoRenewLabel.
  ///
  /// In ar, this message translates to:
  /// **'تجديد تلقائي'**
  String get autoRenewLabel;

  /// No description provided for @searchPlaceHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن مكان...'**
  String get searchPlaceHint;

  /// No description provided for @upcomingTrips.
  ///
  /// In ar, this message translates to:
  /// **'رحلاتك القادمة'**
  String get upcomingTrips;

  /// No description provided for @availableTripsSoon.
  ///
  /// In ar, this message translates to:
  /// **'رحلات متاحة قريباً'**
  String get availableTripsSoon;

  /// No description provided for @noUpcomingTripsYet.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد رحلات قادمة'**
  String get noUpcomingTripsYet;

  /// No description provided for @bookYourFirstTrip.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن رحلة واحجز مقعدك'**
  String get bookYourFirstTrip;

  /// No description provided for @viewAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get viewAll;

  /// No description provided for @departsIn.
  ///
  /// In ar, this message translates to:
  /// **'تغادر خلال {time}'**
  String departsIn(String time);

  /// No description provided for @noAvailableTrips.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد رحلات متاحة حالياً'**
  String get noAvailableTrips;

  /// No description provided for @pendingBookingRequests.
  ///
  /// In ar, this message translates to:
  /// **'طلبات بانتظار موافقتك'**
  String get pendingBookingRequests;

  /// No description provided for @yourUpcomingTrips.
  ///
  /// In ar, this message translates to:
  /// **'رحلاتك القادمة'**
  String get yourUpcomingTrips;

  /// No description provided for @noUpcomingDriverTrips.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد رحلات قادمة لك'**
  String get noUpcomingDriverTrips;

  /// No description provided for @postTripToStart.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ رحلة ليجدك الركاب'**
  String get postTripToStart;

  /// No description provided for @noPendingRequests.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات حجز حالياً'**
  String get noPendingRequests;

  /// No description provided for @acceptRequest.
  ///
  /// In ar, this message translates to:
  /// **'قبول'**
  String get acceptRequest;

  /// No description provided for @rejectRequest.
  ///
  /// In ar, this message translates to:
  /// **'رفض'**
  String get rejectRequest;

  /// No description provided for @seatsRequested.
  ///
  /// In ar, this message translates to:
  /// **'{count} مقاعد مطلوبة'**
  String seatsRequested(int count);

  /// No description provided for @requestAccepted.
  ///
  /// In ar, this message translates to:
  /// **'تم قبول الحجز'**
  String get requestAccepted;

  /// No description provided for @requestRejected.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض الحجز'**
  String get requestRejected;

  /// No description provided for @hours.
  ///
  /// In ar, this message translates to:
  /// **'ساعة'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In ar, this message translates to:
  /// **'دقيقة'**
  String get minutes;

  /// No description provided for @today.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In ar, this message translates to:
  /// **'غداً'**
  String get tomorrow;

  /// No description provided for @yourDailyCommute.
  ///
  /// In ar, this message translates to:
  /// **'مسارك اليومي'**
  String get yourDailyCommute;

  /// No description provided for @setYourDailyRoute.
  ///
  /// In ar, this message translates to:
  /// **'حدد مسار تنقلك اليومي'**
  String get setYourDailyRoute;

  /// No description provided for @setDailyRouteDesc.
  ///
  /// In ar, this message translates to:
  /// **'حدد من أين تنطلق وإلى أين تذهب يومياً، وسنجد لك سائقين على نفس المسار'**
  String get setDailyRouteDesc;

  /// No description provided for @setRoute.
  ///
  /// In ar, this message translates to:
  /// **'حدد المسار'**
  String get setRoute;

  /// No description provided for @driversOnYourRoute.
  ///
  /// In ar, this message translates to:
  /// **'سائقين على مسارك'**
  String get driversOnYourRoute;

  /// No description provided for @changeRoute.
  ///
  /// In ar, this message translates to:
  /// **'تغيير'**
  String get changeRoute;

  /// No description provided for @noDriversOnRoute.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد سائقين على مسارك حالياً'**
  String get noDriversOnRoute;

  /// No description provided for @checkBackLater.
  ///
  /// In ar, this message translates to:
  /// **'تحقق لاحقاً، سائقين جدد ينضمون يومياً'**
  String get checkBackLater;

  /// No description provided for @commuteFrom.
  ///
  /// In ar, this message translates to:
  /// **'من أين تنطلق؟'**
  String get commuteFrom;

  /// No description provided for @commuteTo.
  ///
  /// In ar, this message translates to:
  /// **'إلى أين تذهب؟'**
  String get commuteTo;

  /// No description provided for @saveCommute.
  ///
  /// In ar, this message translates to:
  /// **'حفظ المسار'**
  String get saveCommute;

  /// No description provided for @deleteRoute.
  ///
  /// In ar, this message translates to:
  /// **'حذف المسار'**
  String get deleteRoute;

  /// No description provided for @seatsRemaining.
  ///
  /// In ar, this message translates to:
  /// **'{count} مقاعد متبقية'**
  String seatsRemaining(int count);

  /// No description provided for @trackingRoute.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ تتبع الطريق'**
  String get trackingRoute;

  /// No description provided for @carColor.
  ///
  /// In ar, this message translates to:
  /// **'فضي'**
  String get carColor;

  /// No description provided for @plateNumber.
  ///
  /// In ar, this message translates to:
  /// **'45-2342'**
  String get plateNumber;

  /// No description provided for @ac.
  ///
  /// In ar, this message translates to:
  /// **'تكييف'**
  String get ac;

  /// No description provided for @seat.
  ///
  /// In ar, this message translates to:
  /// **'مقعد'**
  String get seat;

  /// No description provided for @rechargeCard.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة شحن'**
  String get rechargeCard;

  /// No description provided for @rechargeCardDesc.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم بطاقة الشحن المدفوعة مسبقاً لشحن رصيد محفظتك'**
  String get rechargeCardDesc;

  /// No description provided for @cardNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم البطاقة'**
  String get cardNumber;

  /// No description provided for @cardNumberHint.
  ///
  /// In ar, this message translates to:
  /// **'XXXX-XXXX-XXXX'**
  String get cardNumberHint;

  /// No description provided for @rechargeNow.
  ///
  /// In ar, this message translates to:
  /// **'شحن الآن'**
  String get rechargeNow;

  /// No description provided for @rechargeSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم شحن الرصيد بنجاح!'**
  String get rechargeSuccess;

  /// No description provided for @rechargedAmount.
  ///
  /// In ar, this message translates to:
  /// **'تمت إضافة {amount} د.أ إلى محفظتك'**
  String rechargedAmount(String amount);

  /// No description provided for @invalidCardCode.
  ///
  /// In ar, this message translates to:
  /// **'رقم بطاقة الشحن غير صالح'**
  String get invalidCardCode;

  /// No description provided for @cardAlreadyUsed.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة الشحن هذه مستخدمة بالفعل'**
  String get cardAlreadyUsed;

  /// No description provided for @enterCardNumber.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال رقم البطاقة'**
  String get enterCardNumber;

  /// No description provided for @orRechargeWithCard.
  ///
  /// In ar, this message translates to:
  /// **'أو اشحن ببطاقة مسبقة الدفع'**
  String get orRechargeWithCard;

  /// No description provided for @done.
  ///
  /// In ar, this message translates to:
  /// **'تم'**
  String get done;

  /// No description provided for @driverOnline.
  ///
  /// In ar, this message translates to:
  /// **'متصل - تستقبل الطلبات'**
  String get driverOnline;

  /// No description provided for @driverOffline.
  ///
  /// In ar, this message translates to:
  /// **'غير متصل'**
  String get driverOffline;

  /// No description provided for @goOnline.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ استقبال الطلبات'**
  String get goOnline;

  /// No description provided for @goOffline.
  ///
  /// In ar, this message translates to:
  /// **'أوقف استقبال الطلبات'**
  String get goOffline;

  /// No description provided for @createNewOrder.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء طلب جديد'**
  String get createNewOrder;

  /// No description provided for @createOrderDesc.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ طلب توصيل لمطعمك'**
  String get createOrderDesc;

  /// No description provided for @myRecentOrders.
  ///
  /// In ar, this message translates to:
  /// **'طلباتي الأخيرة'**
  String get myRecentOrders;

  /// No description provided for @noOrdersYet.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات بعد'**
  String get noOrdersYet;

  /// No description provided for @availableOrdersTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبات متاحة للتوصيل'**
  String get availableOrdersTitle;

  /// No description provided for @noAvailableOrders.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات متاحة حالياً'**
  String get noAvailableOrders;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SAr();
    case 'en':
      return SEn();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
