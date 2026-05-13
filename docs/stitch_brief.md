# Autostrad (أوتوستراد) — Complete App Design Brief

## App Overview
Autostrad is an intercity carpooling app for Jordan. It connects everyday commuters — a doctor driving Zarqa→Amman for work, a student going Irbid→Amman for university, an employee heading Salt→Amman daily — so they can share rides and split costs. It's NOT a taxi app. Both drivers and riders are regular people commuting on the same routes.

## Target Market
- Country: Jordan
- Language: Arabic-first (RTL), with English support
- Users: Employees, university students, doctors, engineers, teachers — anyone who commutes between cities daily
- Age range: 18-45
- Key corridors: Amman↔Irbid, Amman↔Zarqa, Amman↔Salt, Amman↔Mafraq, Amman↔Karak, Amman↔Aqaba

## Brand Identity
- Name: أوتوستراد (Autostrad)
- Personality: Trustworthy, modern, community-driven, affordable
- Primary color: #1B7FD4 (blue)
- Accent color: #F5A623 (warm amber)
- Success: #4CAF50, Danger: #E53935, Warning: #FF9800
- Font: Clean sans-serif (supports Arabic beautifully)
- Style: Minimal, card-based, generous whitespace, soft shadows, rounded corners (14-16px)

## Platform
- Mobile app (iOS + Android) built with Flutter
- Arabic (RTL) is the default language
- Bottom navigation bar with 4 tabs

---

## User Roles
Every user has ONE account but can switch between two modes:

### 1. Rider (Passenger) Mode
The rider is someone who needs to go somewhere daily (work, university, hospital) and wants to find a driver going the same way.

### 2. Driver Mode  
The driver is someone who already drives their daily commute and wants to offer empty seats to riders going the same direction. NOT a taxi — just sharing the ride.

---

## SCREENS AND FLOWS

### Authentication Flow (3 screens)

#### Screen 1: Phone Entry
- App logo at top
- Title: "مرحباً بك في أوتوستراد"
- Subtitle: "أدخل رقم موبايلك للبدء"
- Jordan flag + country code (+962) prefix
- Phone input field (placeholder: 7X XXXX XXX)
- "إرسال رمز التحقق" button
- Footer: "بالمتابعة، أنت توافق على شروط الاستخدام وسياسة الخصوصية"
- Dev login button at bottom (small, for testing)

#### Screen 2: OTP Verification
- Back button
- Title: "أدخل رمز التحقق"
- Subtitle: "تم إرسال رمز التحقق إلى [phone number]"
- 6-digit code input (individual boxes)
- Countdown timer: "إعادة الإرسال بعد 30 ثانية"
- "تحقق" button

#### Screen 3: Profile Setup (for new users)
- Title: "كيف تريد استخدام أوتوستراد؟"
- Two large selection cards:
  - Passenger card: icon + "راكب" + "ابحث عن رحلات واحجز مقعدك"
  - Driver card: icon + "سائق" + "أنشئ رحلات واكسب دخلاً إضافياً"
- Note: "يمكنك التبديل بين الوضعين لاحقاً"
- After selection: Name form (first name, last name)
- "إنشاء الحساب" button

---

### Main Navigation (Bottom Tab Bar — 4 tabs)
1. الرئيسية (Home) — icon: home
2. البحث (Search) — icon: search
3. رحلاتي (My Trips) — icon: directions_car
4. حسابي (Profile) — icon: person

---

### HOME PAGE — Rider Mode

#### Header
- Greeting: "أهلاً بك 👋"
- Title: "إلى أين تريد الذهاب؟"
- Notification bell icon (with red dot for unread)

#### Role Toggle
- Segmented control: "راكب" | "سائق"
- Selected tab has primary color background with white text
- Unselected is gray

#### Quick Search Card
- Tappable card that opens the search page
- Search icon + "ابحث عن رحلة..." placeholder text
- Right arrow icon
- Subtle gradient background

#### Your Upcoming Trips Section (if any booked trips exist)
- Section title: "رحلاتك القادمة" with "عرض الكل" link
- Trip cards showing:
  - Car icon in colored circle
  - Route: "الزرقاء → عمان"
  - Countdown: "اليوم - تغادر خلال 3 ساعة"
  - Time and date on the right

#### Daily Commute Section (THE CORE FEATURE)

**State A: No commute saved**
- Card with route icon, gradient background
- Title: "حدد مسار تنقلك اليومي"
- Subtitle: "حدد من أين تنطلق وإلى أين تذهب يومياً، وسنجد لك سائقين على نفس المسار"
- "حدد المسار" button

**State B: Commute saved**
- Section title: "مسارك اليومي" with "تغيير" link
- Route card showing:
  - Green dot → dotted line → Orange dot (vertical route indicator)
  - From name (e.g., "حي نزال، الزرقاء")
  - To name (e.g., "شارع الجامعة، عمان")
  - Search button (primary color, icon)
- Below: "سائقين على مسارك" section title
- List of matched driver cards:
  - Driver avatar (initials in circle)
  - Driver name + verified badge
  - Rating (star icon + number) + trip count
  - Price per seat (primary color, bold)
  - Departure time and date
  - Seat indicator (icons: green=reserved, gray=available)
- "حذف المسار" link at bottom

---

### HOME PAGE — Driver Mode

#### Unverified Driver State
- Large centered card:
  - Icon (hourglass if pending, error if rejected, shield if not started)
  - Title: "وثّق حسابك كسائق" / "الوثائق قيد المراجعة" / "تم رفض الوثائق"
  - Description text
  - "بدء التوثيق" button (if not pending)

#### Verified Driver State

**Wallet Card**
- Gradient card (primary color)
- "المحفظة" label + wallet icon
- Balance: "0.00 د.أ" (large, white)
- "شحن الرصيد" outlined button

**Create Trip CTA**
- Full-width primary button: "أنشئ رحلة جديدة" with + icon

**Your Upcoming Trips Section**
- Section title: "رحلاتك القادمة" with "عرض الكل" link
- Trip cards: route + time + seat indicator (shows fill status)
- Empty state: car icon + "لا توجد رحلات قادمة لك" + "أنشئ رحلة" button

**Pending Booking Requests Section**
- Section title: "طلبات بانتظار موافقتك"
- Request cards:
  - Passenger avatar + name
  - Rating + seats requested
  - Route (from → to)
  - Two action buttons: "رفض" (outlined red) | "قبول" (filled green)
- Empty state: inbox icon + "لا توجد طلبات حجز حالياً"

---

### SEARCH PAGE

#### Search Form
- "من أين؟" — Location picker field (opens map)
- "إلى أين؟" — Location picker field (opens map)
- "بحث" button

#### Results
- Filter chips: "الأقرب" | "الأرخص" | "الأعلى تقييماً"
- Trip cards list (same as matched driver cards):
  - Driver info (avatar, name, verified, rating, trip count)
  - Price per seat
  - Route dots (green→orange) with city names
  - Departure time/date
  - Seat indicator
  - Info chips: "ممنوع التدخين", "نساء فقط"

#### Empty State
- Illustration/icon
- "لا توجد رحلات من [from] إلى [to]"
- "جرّب تغيير التاريخ أو عدد المقاعد"

---

### TRIP DETAILS PAGE

#### Map Area (top, expandable app bar)
- Map placeholder showing route
- Gradient overlay at bottom

#### Route Timeline
- Card with vertical dots and line:
  - Green dot: "نقطة الانطلاق" → city name
  - Orange dot: "الوجهة" → city name

#### Driver Card
- Avatar + name + verified badge
- Rating + trip count
- Chat button (message icon)

#### Trip Details Section
- Date row: calendar icon + "التاريخ" + value
- Time row: clock icon + "وقت المغادرة" + value
- Seats row: seat icon + "المقاعد المتاحة" + seat indicators (visual icons)
- Price row: money icon + "السعر للمقعد" + value

#### Trip Rules Section
- List with check/cross icons:
  - ✓ or ✗ Smoking
  - ✓ or ✗ Pets
  - ✓ or ✗ Luggage

#### Pickup Options Section
- "نقطة التقاء محددة" — highlighted if available
- "من الباب إلى الباب" — highlighted if available

#### Bottom Action Bar
- Fixed at bottom
- Left: Price per seat (label + amount in primary)
- Right: "احجز الآن" button

---

### CREATE TRIP PAGE (Driver)

#### App Bar
- Back button + "إنشاء رحلة جديدة"

#### Form
- **From Location** — tappable card, opens map picker
  - Green circle icon + "من" label
  - Shows city name and address when selected
- **To Location** — tappable card, opens map picker
  - Orange pin icon + "إلى" label
- **Pooling Point** (optional) — tappable card
  - Group icon + "نقطة التجمع (اختياري)"
  - Has clear (X) button when set
- **Pickup from home toggle**
  - Home icon + "التوصيل من المنزل" + subtitle
  - Switch toggle
- **Smoking allowed toggle**
  - Smoking icon + "التدخين مسموح"
  - Switch toggle
- **Date and Time** — two cards side by side
  - Calendar icon + date picker
  - Clock icon + time picker
- **Price** — text field
  - Money icon + "السعر (د.أ)"
- **Seat Count** — visual seat selector
  - 7 seat icons in a row (tappable)
  - Selected seats are green (primary), unselected are gray
  - +/- buttons on sides
- **Notes** — multiline text field (optional)
  - "ملاحظات (اختياري)"
  - Placeholder: "مثال: التجمع عند دوار المدينة..."
- **Publish Button**
  - Full-width: "نشر الرحلة" with check icon

---

### BOOKING PAGE (Rider books a trip)

#### Trip Summary Card
- Route and driver info (compact)

#### Booking Form
- Number of seats selector (1-7, visual icons)
- Additional passenger names (if >1 seat)
- Notes for driver (optional text field)

#### Price Summary
- "سعر المقعد × [count]" = total
- "الإجمالي: [amount] د.أ"

#### Terms Checkbox
- "أوافق على شروط الاستخدام وسياسة الحجز. الدفع يتم مباشرة للسائق (نقداً أو CliQ)."

#### Confirm Button
- "تأكيد الحجز"

---

### MY TRIPS PAGE (Tab Bar)

#### Tab 1: "رحلاتي كسائق"
- List of driver's posted trips
- Each card shows: route, time, seat fill status
- Empty state: "لم تنشئ أي رحلات بعد" + "أنشئ رحلة" button

#### Tab 2: "حجوزاتي"
- List of rider's booked trips
- Each card shows: route, time, price, booking status
- Empty state: "لم تحجز أي رحلات بعد" + "ابحث عن رحلة" button

---

### PROFILE PAGE

#### Header (gradient background)
- Avatar (large circle, initials or photo)
- Full name
- Phone number
- Rating (star + number) + trip count

#### Menu Sections

**Account Section**
- تعديل الملف الشخصي → Edit profile page
- توثيق حساب السائق → Shows status (verified/pending/not verified)
- العناوين المحفوظة → Coming soon
- جهات اتصال الطوارئ → Coming soon

**Settings Section**
- اللغة → Language picker (العربية / English)
- المساعدة والدعم → Coming soon
- سياسة الخصوصية → Coming soon
- شروط الاستخدام → Coming soon

**Logout**
- Red text: "تسجيل الخروج" → Confirmation dialog

**App Version**
- Centered at bottom: "أوتوستراد v1.0.0"

---

### EDIT PROFILE PAGE
- Avatar (editable)
- First name field
- Last name field
- Email field (optional)
- "حفظ التغييرات" button

---

### DRIVER VERIFICATION PAGE
- Title: "توثيق حساب السائق"
- Required documents list:
  1. صورة الهوية الشخصية — photo upload card
  2. صورة رخصة القيادة — photo upload card
  3. صورة المركبة — photo upload card
  4. رقم لوحة المركبة — text input
- Upload card states: empty (dashed border + "انقر للاختيار") / selected (checkmark + "تم الاختيار")
- Submit button

---

### WALLET PAGE

#### Balance Card
- Same gradient card as home
- Balance amount (large)
- "شحن الرصيد" button

#### Top Up Section
- Amount options: 5, 10, 20, 50 JOD (selectable chips)
- Payment instructions:
  1. "حوّل المبلغ عبر CliQ إلى: autostrad@cliq"
  2. "أرسل لنا صورة الإيصال"
  3. "سيتم إضافة الرصيد خلال دقائق"
- "تواصل معنا عبر واتساب" button

#### Recent Transactions
- List of transactions with type, amount, date
- Empty state if none

---

### NOTIFICATIONS PAGE
- List of notifications
- Each notification: icon + title + body + time ago
- Unread items have slightly different background
- Empty state: bell icon + "لا توجد إشعارات"

---

### MAP / LOCATION PICKER PAGE
- Full-screen Google Map
- Center pin (fixed, map moves beneath it)
- Search bar at top (Google Places autocomplete, scoped to Jordan)
- "تأكيد الموقع" button at bottom
- Current location button (GPS icon)

---

### SUBSCRIPTIONS / RECURRING LINES (Advanced Feature)

#### Browse Lines Page
- List of recurring trip lines (daily/weekly routes)
- Each card: route, days of week, monthly price, available seats, driver info

#### Create Line Page (Driver)
- From/To locations
- Days of week selector (Sat-Fri, multi-select)
- Departure time + Return time
- Monthly price
- Total seats
- Female only toggle
- "نشر الخط" button

#### My Subscriptions Page (Rider)
- Active subscriptions list
- Status badges: active (green), paused (yellow), closed (gray)
- Cancel/pause options

---

## DESIGN PRINCIPLES

1. **Arabic-first RTL** — All layouts flow right-to-left. Icons and arrows respect RTL.
2. **Card-based** — Every section lives in a soft card with rounded corners and subtle border.
3. **Minimal** — No visual clutter. One primary action per screen.
4. **Trust signals** — Verified badges, ratings, trip counts visible everywhere.
5. **Seat icons** — Always show seats visually (green = taken, gray = available) instead of numbers.
6. **Route visualization** — Always show from→to with colored dots and connecting line.
7. **Action-oriented** — Every screen drives toward booking (rider) or creating trips (driver).
8. **Jordan-appropriate** — Prices in JOD (د.أ), Jordan phone format, CliQ payments, city names in Arabic.

## COLOR PALETTE
- Background: #F8F9FA
- Surface (cards): #FFFFFF
- Primary: #1B7FD4
- Primary Light: #64B5F6
- Accent: #F5A623
- Text Primary: #1A1A2E
- Text Secondary: #6B7280
- Text Light: #9CA3AF
- Border: #E5E7EB
- Success: #4CAF50
- Danger: #E53935
- Warning: #FF9800
- Info: #2196F3

## TYPOGRAPHY
- Heading Large: 28px, bold
- Heading Medium: 22px, bold
- Heading Small: 18px, semi-bold
- Body Large: 16px, regular
- Body Medium: 14px, regular
- Body Small: 12px, regular
- Caption: 11px, regular

## SPACING
- Page padding: 20px
- Card padding: 14-16px
- Section spacing: 24px
- Element spacing: 12px
- Border radius: 14-16px (cards), 10-12px (buttons/chips)

---

## USER FLOWS SUMMARY

### Rider Flow:
1. Open app → Home (rider mode)
2. Set daily commute (once) → See matched drivers daily
3. Tap a driver → Trip details → "احجز الآن" → Booking form → Confirm
4. Check "رحلاتي" tab → See upcoming booked trips
5. Receive notification when driver confirms/rejects

### Driver Flow:
1. Open app → Home (driver mode)
2. If not verified → Upload documents → Wait for approval
3. If verified → "أنشئ رحلة جديدة" → Fill form → Publish
4. See pending booking requests on home → Accept/Reject
5. Check "رحلاتي" tab → See posted trips with seat fill status
6. Repeat daily (or use recurring lines for subscription-based commutes)

### Matching Logic:
- Driver posts a trip: "الزرقاء → عمان, 7:00 صباحاً, 3 مقاعد, 2.50 د.أ"
- Rider has daily commute saved: "الزرقاء → عمان"
- App shows this driver in "سائقين على مسارك" section
- Rider books → Driver gets notification → Accepts → Both get confirmation
