// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Sahm';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navMyTrips => 'My Trips';

  @override
  String get navProfile => 'Profile';

  @override
  String get orders => 'Orders';

  @override
  String get welcomeTitle => 'Welcome to Sahm';

  @override
  String get enterPhoneSubtitle => 'Enter your phone number to get started';

  @override
  String get phoneHint => '7X XXXX XXX';

  @override
  String get phoneLabel => 'Phone Number';

  @override
  String get sendOtp => 'Send Verification Code';

  @override
  String get willSendSms => 'We\'ll send you an SMS verification code';

  @override
  String get termsAgreement =>
      'By continuing, you agree to the Terms of Service and Privacy Policy';

  @override
  String get devLogin => 'Dev Login (Dev)';

  @override
  String get devLoginDriver => 'Login as Driver';

  @override
  String get devLoginRestaurant => 'Login as Restaurant';

  @override
  String get enterOtp => 'Enter Verification Code';

  @override
  String otpSentTo(String phone) {
    return 'Verification code sent to\n$phone';
  }

  @override
  String resendIn(int seconds) {
    return 'Resend in $seconds seconds';
  }

  @override
  String get resendCode => 'Resend Code';

  @override
  String get verify => 'Verify';

  @override
  String get howToUseAutostrad => 'How would you like to use Sahm?';

  @override
  String get chooseRegistration =>
      'Choose the registration type that suits you';

  @override
  String get passenger => 'Passenger';

  @override
  @override
  String get restaurant => 'Restaurant';

  @override
  String get driver => 'Driver';

  @override
  String get passengerSubtitle => 'Search for trips and book your seat';

  @override
  String get restaurantSubtitle => 'Create delivery orders for your restaurant';

  @override
  String get driverSubtitle => 'Deliver orders and earn extra income';

  @override
  String get switchRoleLater =>
      'You can switch between modes later from Settings';

  @override
  String get registerAsPassenger => 'Register as Passenger';

  @override
  String get registerAsRestaurant => 'Register as Restaurant';

  @override
  String get enterNameToStart => 'Enter your name to get started';

  @override
  String get firstName => 'First Name';

  @override
  String get firstNameHint => 'John';

  @override
  String get lastName => 'Last Name';

  @override
  String get lastNameHint => 'Doe';

  @override
  String get firstNameRequired => 'First name is required';

  @override
  String get lastNameRequired => 'Last name is required';

  @override
  String get emailOptional => 'Email (optional)';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get account => 'Account';

  @override
  String get settingsAndHelp => 'Settings & Help';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get createAccount => 'Create Account';

  @override
  String get registerAsDriver => 'Register as Driver';

  @override
  String get completeDocsToStart =>
      'Complete your details and documents to start';

  @override
  String get requiredDocs => 'Required Documents';

  @override
  String get nationalId => 'National ID Photo';

  @override
  String get driverLicense => 'Driver\'s License Photo';

  @override
  String get carImage => 'Vehicle Photo';

  @override
  String get carNumber => 'License Plate Number';

  @override
  String get carNumberHint => '00-00000';

  @override
  String get imageSelected => 'Selected';

  @override
  String get tapToSelect => 'Tap to select';

  @override
  String get pleaseAttachAllImages => 'Please attach all required photos';

  @override
  String get hello => 'Hello 👋';

  @override
  String get whereToGo => 'Where do you want to go?';

  @override
  String get searchForTrip => 'Search for a trip...';

  @override
  String get popularDestinations => 'Popular Destinations';

  @override
  String fromPrice(String price) {
    return 'From $price JOD';
  }

  @override
  String get howItWorks => 'How It Works';

  @override
  String get step1Title => 'Search for a trip';

  @override
  String get step1Subtitle => 'Choose your destination and preferred date';

  @override
  String get step2Title => 'Book your seat';

  @override
  String get step2Subtitle => 'Select the number of seats and complete booking';

  @override
  String get step3Title => 'Enjoy the ride';

  @override
  String get step3Subtitle => 'Contact the driver and go';

  @override
  String get verifyDriverAccount => 'Verify your driver account';

  @override
  String get verifyDriverDescription =>
      'To start posting trips and accepting passengers, you must verify your account first';

  @override
  String get startVerification => 'Start Verification';

  @override
  String get docsUnderReview => 'Documents Under Review';

  @override
  String get docsUnderReviewDesc =>
      'Your documents have been submitted and are being reviewed. You will be notified once approved.';

  @override
  String get docsRejected => 'Documents Rejected';

  @override
  String get docsRejectedDesc =>
      'Your documents were rejected. Please resubmit them with clear images.';

  @override
  String get resubmitDocs => 'Resubmit Documents';

  @override
  String get wallet => 'Wallet';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String balanceAmount(String amount) {
    return '$amount JOD';
  }

  @override
  String get topUp => 'Top Up';

  @override
  String get createNewTrip => 'Create New Trip';

  @override
  String get publishTripDescription => 'Share your route with riders';

  @override
  String get recentBookingRequests => 'Recent Booking Requests';

  @override
  String get noBookingRequests => 'No booking requests at the moment';

  @override
  String get searchForTripTitle => 'Search for a Trip';

  @override
  String get fromWhere => 'From where?';

  @override
  String get toWhere => 'To where?';

  @override
  String get search => 'Search';

  @override
  String noTripsFound(String from, String to) {
    return 'No trips from $from to $to';
  }

  @override
  String get tryChangingFilters => 'Try changing the date or number of seats';

  @override
  String get searchNextTrip => 'Search for your next trip';

  @override
  String tripCount(int count) {
    return '$count trips';
  }

  @override
  String get cheapest => 'Cheapest';

  @override
  String get earliest => 'Earliest';

  @override
  String get topRated => 'Top Rated';

  @override
  String get perSeat => 'per seat';

  @override
  String get tripDetails => 'Trip Details';

  @override
  String get departurePoint => 'Departure Point';

  @override
  String get destination => 'Destination';

  @override
  String get loading => 'Loading...';

  @override
  String get date => 'Date';

  @override
  String get departureTime => 'Departure Time';

  @override
  String get availableSeats => 'Available Seats';

  @override
  String get pricePerSeat => 'Price per Seat';

  @override
  String get tripRules => 'Trip Rules';

  @override
  String get noSmoking => 'No Smoking';

  @override
  String get smokingAllowed => 'Smoking Allowed';

  @override
  String get verified => 'Verified';

  @override
  String get pets => 'Pets';

  @override
  String get music => 'Music';

  @override
  String get luggage => 'Luggage';

  @override
  String get pickupOptions => 'Pickup Options';

  @override
  String get meetingPoint => 'Fixed Meeting Point';

  @override
  String get doorToDoor => 'Door to Door';

  @override
  String get bookNow => 'Book Now';

  @override
  String get driverName => 'Driver Name';

  @override
  String get femaleOnly => 'Female Only';

  @override
  String get createTripTitle => 'Create New Trip';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String selectFrom(String label) {
    return 'Select $label';
  }

  @override
  String get time => 'Time';

  @override
  String get priceCurrency => 'Price (JOD)';

  @override
  String get seatCount => 'Number of Seats';

  @override
  String get notesOptional => 'Notes (Optional)';

  @override
  String get notesHint => 'Example: Meet at the city roundabout...';

  @override
  String get publishTrip => 'Publish Trip';

  @override
  String get tripCreatedSuccess => 'Trip created successfully';

  @override
  String get tripCreateFailed => 'Failed to create trip';

  @override
  String get selectStartAndEnd => 'Please select departure and arrival points';

  @override
  String get enterValidPrice => 'Please enter a valid price';

  @override
  String get seatsBetween1And7 => 'Number of seats must be between 1 and 7';

  @override
  String get selectStartPoint => 'Select departure point';

  @override
  String get selectEndPoint => 'Select arrival point';

  @override
  String get poolingPoint => 'Pooling Point';

  @override
  String get pickupFromHome => 'Pickup from home';

  @override
  String get pickupFromHomeDesc => 'Pick up the rider from their home';

  @override
  String get optional => 'Optional';

  @override
  String get bookSeats => 'Book Seats';

  @override
  String get tripSummary => 'Trip Summary';

  @override
  String get numberOfSeats => 'Number of Seats';

  @override
  String get additionalPassengerNames => 'Additional Passenger Names';

  @override
  String get enterPassengerNames =>
      'Enter the names of people you\'re booking for';

  @override
  String passengerN(int n) {
    return 'Passenger $n';
  }

  @override
  String get fullName => 'Full Name';

  @override
  String get enterPassengerName => 'Please enter passenger name';

  @override
  String get anyNotesForDriver => 'Any notes for the driver...';

  @override
  String seatPriceMultiplied(int count) {
    return 'Seat price × $count';
  }

  @override
  String get total => 'Total';

  @override
  String get bookingTerms =>
      'I agree to the Terms of Service and booking policy. Payment is made directly to the driver (cash or CliQ).';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String perSeatPrice(String price) {
    return '$price / seat';
  }

  @override
  String get myBookings => 'My Bookings';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get past => 'Past';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get noUpcomingBookings => 'No upcoming bookings';

  @override
  String get noPastBookings => 'No past bookings';

  @override
  String get noCancelledBookings => 'No cancelled bookings';

  @override
  String get searchAndBook => 'Search for a trip and start booking';

  @override
  String get pastTripsAppearHere => 'Your past trips will appear here';

  @override
  String get cancelledBookingsAppearHere =>
      'Cancelled bookings will appear here';

  @override
  String get searchForTripButton => 'Search for a trip';

  @override
  String get myTripsAsDriver => 'My Trips (Driver)';

  @override
  String get noDriverTripsYet => 'You haven\'t created any trips yet';

  @override
  String get noPassengerBookingsYet => 'You haven\'t booked any trips yet';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get retry => 'Retry';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get verifyDriverAccountMenu => 'Verify Driver Account';

  @override
  String get notVerified => 'Not Verified';

  @override
  String get savedAddresses => 'Saved Addresses';

  @override
  String get emergencyContacts => 'Emergency Contacts';

  @override
  String get language => 'Language';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get logout => 'Log Out';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get user => 'User';

  @override
  String tripsCount(int count) {
    return '$count trips';
  }

  @override
  String appVersion(String version) {
    return 'Sahm v$version';
  }

  @override
  String get lowBalanceWarning =>
      'Your balance is low. Top up to be able to accept bookings.';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get noTransactions => 'No transactions yet';

  @override
  String get topUpBalance => 'Top Up Balance';

  @override
  String get chooseTopUpAmount => 'Choose the amount to top up';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get paymentStep1 => 'Transfer via CliQ to: sahm@cliq';

  @override
  String get paymentStep2 => 'Send us the receipt photo';

  @override
  String get paymentStep3 => 'Balance will be added within minutes';

  @override
  String get contactViaWhatsapp => 'Contact us via WhatsApp';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get newNotificationsAppearHere => 'New notifications will appear here';

  @override
  String get now => 'Now';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String daysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get rating => 'Rating';

  @override
  String get howWasExperience => 'How was your experience with';

  @override
  String get pleaseSelectRating => 'Please select a rating';

  @override
  String get thankYouForRating => 'Thank you for your rating!';

  @override
  String get ratingFailed => 'Failed to submit rating';

  @override
  String get submitRating => 'Submit Rating';

  @override
  String get addCommentOptional => 'Add a comment (optional)...';

  @override
  String get ratingBad => 'Bad';

  @override
  String get ratingAcceptable => 'Acceptable';

  @override
  String get ratingGood => 'Good';

  @override
  String get ratingVeryGood => 'Very Good';

  @override
  String get ratingExcellent => 'Excellent';

  @override
  String get confirmLocation => 'Confirm Location';

  @override
  String get oneSeat => '1 seat';

  @override
  String get twoSeats => '2 seats';

  @override
  String nSeats(int count) {
    return '$count seats';
  }

  @override
  String nSeat(int count) {
    return '$count seats';
  }

  @override
  String get phoneRequired => 'Please enter your phone number';

  @override
  String get phoneInvalid => 'Invalid phone number';

  @override
  String fieldRequired(String field) {
    return '$field is required';
  }

  @override
  String get thisFieldRequired => 'This field is required';

  @override
  String get emailInvalid => 'Invalid email address';

  @override
  String minLengthError(String field, int min) {
    return '$field must be at least $min characters';
  }

  @override
  String get browseSubscriptions => 'Browse Lines';

  @override
  String get mySubscriptions => 'My Subscriptions';

  @override
  String get myLines => 'My Lines';

  @override
  String get createLine => 'Create New Line';

  @override
  String get lineDetails => 'Line Details';

  @override
  String get lineCreatedSuccess => 'Line created successfully';

  @override
  String get publishLine => 'Publish Line';

  @override
  String get daysOfWeek => 'Days of Week';

  @override
  String get selectAtLeastOneDay => 'Select at least one day';

  @override
  String get monthlyPriceJod => 'Monthly Price (JOD)';

  @override
  String get returnTime => 'Return Time';

  @override
  String get femaleOnlyLineDesc => 'This line is for females only';

  @override
  String get noSubscriptionsFound => 'No lines available';

  @override
  String get subscribedSuccess => 'Subscribed successfully';

  @override
  String get subscribeNow => 'Subscribe Now';

  @override
  String get noActiveSubscriptions => 'No active subscriptions';

  @override
  String get subscriptionCancelled => 'Subscription cancelled';

  @override
  String get cancelSubscriptionConfirm =>
      'Are you sure you want to cancel this subscription?';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancelSubscriptionBtn => 'Cancel Subscription';

  @override
  String get jodPerMonth => 'JOD/month';

  @override
  String get active => 'Active';

  @override
  String get paused => 'Paused';

  @override
  String get closed => 'Closed';

  @override
  String get seatsAvailable => 'seats available';

  @override
  String get noLinesYet => 'No lines yet';

  @override
  String get pauseLine => 'Pause';

  @override
  String get resumeLine => 'Resume';

  @override
  String get closeLine => 'Close Line';

  @override
  String get closeLineConfirm =>
      'Are you sure you want to close this line? All subscriptions will be cancelled.';

  @override
  String get driverCard => 'Driver Card';

  @override
  String get remainingRides => 'Remaining Rides';

  @override
  String get ride => 'ride';

  @override
  String get purchased => 'Purchased';

  @override
  String get used => 'Used';

  @override
  String get topUpCard => 'Top Up Card';

  @override
  String get topupSuccess => 'Card topped up successfully';

  @override
  String get confirmTopup => 'Confirm Top Up';

  @override
  String get jod => 'JOD';

  @override
  String get bonus => 'bonus';

  @override
  String get jodPerRide => 'JOD/ride';

  @override
  String get viewTransactions => 'View Transactions';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get monthly => 'Monthly';

  @override
  String get weekly => 'Weekly';

  @override
  String get daily => 'Daily';

  @override
  String get serviceFeeLabel => 'Service Fee';

  @override
  String get basePrice => 'Base Price';

  @override
  String get todayTripsTitle => 'Today\'s Trips';

  @override
  String get noTripsToday => 'No trips today';

  @override
  String get driverConfirmation => 'Driver Confirmation';

  @override
  String get yourConfirmation => 'Your Confirmation';

  @override
  String get confirmPresent => 'Present';

  @override
  String get confirmAbsent => 'Absent';

  @override
  String get attendanceConfirmed => 'Attendance confirmed';

  @override
  String get attendanceDisputed => 'Attendance disputed - will be reviewed';

  @override
  String get present => 'Present';

  @override
  String get absent => 'Absent';

  @override
  String get pendingConfirmation => 'Pending confirmation';

  @override
  String get inProgress => 'In Progress';

  @override
  String get completed => 'Completed';

  @override
  String get tripCancelled => 'Cancelled';

  @override
  String get scheduled => 'Scheduled';

  @override
  String get paymentHistory => 'Payment History';

  @override
  String get noPayments => 'No payments yet';

  @override
  String get paid => 'Paid';

  @override
  String get overdue => 'Overdue';

  @override
  String get pendingPayment => 'Pending';

  @override
  String get renewSubscription => 'Renew Subscription';

  @override
  String get subscriptionRenewed => 'Subscription renewed successfully';

  @override
  String get billingPeriod => 'Billing Period';

  @override
  String get autoRenewLabel => 'Auto Renew';

  @override
  String get searchPlaceHint => 'Search for a place...';

  @override
  String get upcomingTrips => 'Your Upcoming Trips';

  @override
  String get availableTripsSoon => 'Available Trips Soon';

  @override
  String get noUpcomingTripsYet => 'No upcoming trips yet';

  @override
  String get bookYourFirstTrip => 'Search for a trip and book your seat';

  @override
  String get viewAll => 'View All';

  @override
  String departsIn(String time) {
    return 'Departs in $time';
  }

  @override
  String get noAvailableTrips => 'No available trips right now';

  @override
  String get pendingBookingRequests => 'Requests Awaiting Approval';

  @override
  String get yourUpcomingTrips => 'Your Upcoming Trips';

  @override
  String get noUpcomingDriverTrips => 'No upcoming trips';

  @override
  String get postTripToStart => 'Post a trip so riders can find you';

  @override
  String get noPendingRequests => 'No pending booking requests';

  @override
  String get acceptRequest => 'Accept';

  @override
  String get rejectRequest => 'Reject';

  @override
  String seatsRequested(int count) {
    return '$count seats requested';
  }

  @override
  String get requestAccepted => 'Booking accepted';

  @override
  String get requestRejected => 'Booking rejected';

  @override
  String get hours => 'hours';

  @override
  String get minutes => 'min';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get yourDailyCommute => 'Your Daily Commute';

  @override
  String get setYourDailyRoute => 'Set your daily route';

  @override
  String get setDailyRouteDesc =>
      'Set where you go every day and we\'ll find drivers on the same route';

  @override
  String get setRoute => 'Set Route';

  @override
  String get driversOnYourRoute => 'Drivers on Your Route';

  @override
  String get changeRoute => 'Change';

  @override
  String get noDriversOnRoute => 'No drivers on your route right now';

  @override
  String get checkBackLater => 'Check back later, new drivers join daily';

  @override
  String get commuteFrom => 'Where do you start?';

  @override
  String get commuteTo => 'Where do you go?';

  @override
  String get saveCommute => 'Save Route';

  @override
  String get deleteRoute => 'Delete Route';

  @override
  String seatsRemaining(int count) {
    return '$count seats remaining';
  }

  @override
  String get trackingRoute => 'Tracking route';

  @override
  String get carColor => 'Silver';

  @override
  String get plateNumber => '45-2342';

  @override
  String get ac => 'AC';

  @override
  String get seat => 'Seat';

  @override
  String get rechargeCard => 'Recharge Card';

  @override
  String get rechargeCardDesc =>
      'Enter your prepaid card number to recharge your wallet balance';

  @override
  String get cardNumber => 'Card Number';

  @override
  String get cardNumberHint => 'XXXX-XXXX-XXXX';

  @override
  String get rechargeNow => 'Recharge Now';

  @override
  String get rechargeSuccess => 'Balance recharged successfully!';

  @override
  String rechargedAmount(String amount) {
    return 'JOD $amount added to your wallet';
  }

  @override
  String get invalidCardCode => 'Invalid recharge card code';

  @override
  String get cardAlreadyUsed => 'This recharge card has already been used';

  @override
  String get enterCardNumber => 'Please enter a card number';

  @override
  String get orRechargeWithCard => 'Or recharge with a prepaid card';

  @override
  String get done => 'Done';

  @override
  String get driverOnline => 'Online - Receiving orders';

  @override
  String get driverOffline => 'Offline';

  @override
  String get goOnline => 'Go Online';

  @override
  String get goOffline => 'Go Offline';

  @override
  String get createNewOrder => 'Create New Order';

  @override
  String get createOrderDesc => 'Create a delivery order for your restaurant';

  @override
  String get myRecentOrders => 'My Recent Orders';

  @override
  String get noOrdersYet => 'No orders yet';

  @override
  String get availableOrdersTitle => 'Available Orders';

  @override
  String get noAvailableOrders => 'No available orders right now';
}
