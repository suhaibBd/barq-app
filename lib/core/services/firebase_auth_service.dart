import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class FirebaseAuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  Future<void> verifyPhone({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(fb.PhoneAuthCredential credential) onAutoVerified,
    required void Function(String error) onError,
    int? forceResendingToken,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      forceResendingToken: forceResendingToken,
      verificationCompleted: onAutoVerified,
      verificationFailed: (fb.FirebaseAuthException e) {
        print('Firebase Phone Auth Error: code=${e.code}, message=${e.message}');
        onError(_mapErrorMessage(e.code));
      },
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<fb.UserCredential> signInWithCredential(
      fb.PhoneAuthCredential credential) {
    return _auth.signInWithCredential(credential);
  }

  Future<fb.UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) {
    final credential = fb.PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<String?> getIdToken() async {
    return await _auth.currentUser?.getIdToken();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  fb.User? get currentUser => _auth.currentUser;

  String _mapErrorMessage(String code) {
    return switch (code) {
      'invalid-phone-number' => 'رقم الهاتف غير صالح',
      'too-many-requests' => 'محاولات كثيرة، حاول لاحقاً',
      'quota-exceeded' => 'تم تجاوز الحد المسموح، حاول لاحقاً',
      'network-request-failed' => 'خطأ في الاتصال بالإنترنت',
      _ => 'حدث خطأ غير متوقع',
    };
  }
}
