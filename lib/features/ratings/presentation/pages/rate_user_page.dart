import 'package:flutter/material.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../di/injection_container.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/custom_button.dart';

class RateUserPage extends StatefulWidget {
  final String bookingId;
  final String ratedUserId;
  final String ratedUserName;
  final bool isDriver;

  const RateUserPage({
    super.key,
    required this.bookingId,
    required this.ratedUserId,
    required this.ratedUserName,
    required this.isDriver,
  });

  @override
  State<RateUserPage> createState() => _RateUserPageState();
}

class _RateUserPageState extends State<RateUserPage> {
  final _rating = ValueNotifier<int>(0);
  final _commentController = TextEditingController();
  final _loading = ValueNotifier<bool>(false);

  Future<void> _submit() async {
    if (_rating.value == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).pleaseSelectRating)),
      );
      return;
    }
    _loading.value = true;
    try {
      await sl<DioClient>().dio.post(ApiConstants.rateUser, data: {
        'booking_id': widget.bookingId,
        'rated_user_id': widget.ratedUserId,
        'rating': _rating.value,
        'comment': _commentController.text.isNotEmpty
            ? _commentController.text
            : null,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).thankYouForRating),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).ratingFailed),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
    _loading.value = false;
  }

  @override
  void dispose() {
    _rating.dispose();
    _commentController.dispose();
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).rating),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryLight.withValues(alpha: 0.15),
                    AppColors.accentSoft,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.isDriver
                    ? Icons.directions_car_rounded
                    : Icons.person_rounded,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              S.of(context).howWasExperience,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(widget.ratedUserName, style: AppTextStyles.headingMedium),
            const SizedBox(height: 36),
            ValueListenableBuilder<int>(
              valueListenable: _rating,
              builder: (context, rating, _) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starNum = index + 1;
                        return GestureDetector(
                          onTap: () => _rating.value = starNum,
                          child: AnimatedPadding(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: AnimatedScale(
                              scale: starNum <= rating ? 1.15 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                starNum <= rating
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                size: 48,
                                color: starNum <= rating
                                    ? AppColors.accent
                                    : AppColors.border,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        _ratingLabel(rating, context),
                        key: ValueKey(rating),
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: rating > 0
                              ? AppColors.accent
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 28),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: S.of(context).addCommentOptional,
                  hintStyle:
                      AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
                  contentPadding: const EdgeInsets.all(16),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            const Spacer(),
            ValueListenableBuilder<bool>(
              valueListenable: _loading,
              builder: (context, loading, _) {
                return CustomButton(
                  text: S.of(context).submitRating,
                  icon: Icons.send_rounded,
                  isLoading: loading,
                  onPressed: _submit,
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _ratingLabel(int rating, BuildContext context) {
    return switch (rating) {
      1 => S.of(context).ratingBad,
      2 => S.of(context).ratingAcceptable,
      3 => S.of(context).ratingGood,
      4 => S.of(context).ratingVeryGood,
      5 => S.of(context).ratingExcellent,
      _ => '',
    };
  }
}
