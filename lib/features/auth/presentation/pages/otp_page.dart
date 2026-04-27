import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class OtpPage extends StatefulWidget {
  final String verificationId;
  final String phone;

  const OtpPage({
    super.key,
    required this.verificationId,
    required this.phone,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _otpController = TextEditingController();
  Timer? _timer;
  int _countdown = AppConstants.otpResendSeconds;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdown = AppConstants.otpResendSeconds;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _submitOtp(String code) {
    if (code.length == AppConstants.otpLength) {
      context.read<AuthBloc>().add(VerifyOtpEvent(
            verificationId: widget.verificationId,
            code: code,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (state.isNewUser) {
            context.go('/auth/profile-setup');
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
                  const SizedBox(height: 20),
                  Text(
                    'أدخل رمز التحقق',
                    style: AppTextStyles.headingMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'تم إرسال رمز التحقق إلى\n${widget.phone}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
                  if (!_canResend)
                    Text(
                      'إعادة الإرسال بعد $_countdown ثانية',
                      style: AppTextStyles.bodySmall,
                      textAlign: TextAlign.center,
                    )
                  else
                    TextButton(
                      onPressed: () {
                        context
                            .read<AuthBloc>()
                            .add(SendOtpEvent(widget.phone));
                        _startCountdown();
                      },
                      child: Text(
                        'إعادة إرسال الرمز',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  const Spacer(),
                  CustomButton(
                    text: 'تحقق',
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
