import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class OtpPage extends StatefulWidget {
  final String verificationId;
  final String phone;
  final String? devCode;

  const OtpPage({
    super.key,
    required this.verificationId,
    required this.phone,
    this.devCode,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _otpController = TextEditingController();
  StreamController<int>? _countdownController;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownController?.close();
    _countdownController = StreamController<int>();
    final total = AppConstants.otpResendSeconds;
    late StreamSubscription<int> sub;
    sub = Stream.periodic(const Duration(seconds: 1), (i) => total - 1 - i)
        .take(total)
        .listen(
      (remaining) {
        if (!_countdownController!.isClosed) {
          _countdownController!.add(remaining);
        }
      },
      onDone: () {
        if (!_countdownController!.isClosed) {
          // Signal completion with -1
          _countdownController!.add(-1);
        }
      },
    );
    // Store the subscription reference so we can cancel on dispose
    _countdownSubscription?.cancel();
    _countdownSubscription = sub;
  }

  StreamSubscription<int>? _countdownSubscription;

  @override
  void dispose() {
    _otpController.dispose();
    _countdownSubscription?.cancel();
    _countdownController?.close();
    super.dispose();
  }

  void _submitOtp(String code) {
    if (code.length == AppConstants.otpLength) {
      context.read<AuthBloc>().add(FirebaseOtpVerifyEvent(
            verificationId: widget.verificationId,
            smsCode: code,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (state.isNewUser) {
            context.go('/auth/role-selection');
          } else {
            context.go('/home');
          }
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.danger,
            ),
          );
          _otpController.clear();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primaryDark,
                            AppColors.primary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            right: 20,
                            bottom: 10,
                            child: Icon(
                              Icons.phone_android_rounded,
                              size: 80,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.sms_rounded,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    S.of(context).enterOtp,
                    style: AppTextStyles.headingMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    S.of(context).otpSentTo(widget.phone),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (widget.devCode != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        'Dev Code: ${widget.devCode}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: PinCodeTextField(
                      appContext: context,
                      length: AppConstants.otpLength,
                      controller: _otpController,
                      autoFocus: true,
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(12),
                        fieldHeight: 56,
                        fieldWidth: 48,
                        activeFillColor: AppColors.surface,
                        inactiveFillColor: AppColors.surface,
                        selectedFillColor: AppColors.surface,
                        activeColor: AppColors.primary,
                        inactiveColor: AppColors.border,
                        selectedColor: AppColors.primary,
                      ),
                      enableActiveFill: true,
                      onCompleted: _submitOtp,
                      onChanged: (_) {},
                    ),
                  ),
                  const SizedBox(height: 24),
                  StreamBuilder<int>(
                    stream: _countdownController?.stream,
                    initialData: AppConstants.otpResendSeconds,
                    builder: (context, snapshot) {
                      final remaining = snapshot.data ?? 0;
                      final canResend = remaining < 0;
                      if (!canResend) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.timer_outlined,
                                size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              S.of(context).resendIn(
                                  remaining < 0 ? 0 : remaining),
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        );
                      } else {
                        return TextButton(
                          onPressed: () {
                            context
                                .read<AuthBloc>()
                                .add(FirebasePhoneVerifyEvent(widget.phone));
                            _startCountdown();
                          },
                          child: Text(
                            S.of(context).resendCode,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const Spacer(),
                  CustomButton(
                    text: S.of(context).verify,
                    isLoading: state is AuthLoading,
                    onPressed: () => _submitOtp(_otpController.text),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
