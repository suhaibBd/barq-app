import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../domain/entities/user_role.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/role_toggle_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Scaffold(body: LoadingIndicator());
        }

        if (state is HomeLoaded) {
          return Scaffold(
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(RefreshHomeEvent());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('أهلاً بك 👋',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary)),
                                const SizedBox(height: 4),
                                Text('إلى أين تريد الذهاب؟',
                                    style: AppTextStyles.headingSmall),
                              ],
                            ),
                          ),
                          // Notification bell
                          IconButton(
                            onPressed: () {},
                            icon: Stack(
                              children: [
                                const Icon(Icons.notifications_outlined,
                                    size: 28, color: AppColors.textPrimary),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: AppColors.danger,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Role toggle
                      RoleToggleWidget(
                        currentRole: state.currentRole,
                        onRoleChanged: (role) {
                          context
                              .read<HomeBloc>()
                              .add(SwitchRoleEvent(role));
                        },
                      ),
                      const SizedBox(height: 24),

                      // Conditional content
                      if (state.currentRole == UserRole.passenger)
                        _buildPassengerContent(context)
                      else
                        _buildDriverContent(context, state),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return const Scaffold(body: LoadingIndicator());
      },
    );
  }

  Widget _buildPassengerContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick search card
        GestureDetector(
          onTap: () => context.push('/search'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.search_rounded,
                      color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'ابحث عن رحلة...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: AppColors.textLight),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),

        // Popular routes
        Text('الوجهات الشائعة', style: AppTextStyles.headingSmall),
        const SizedBox(height: 16),
        _buildPopularRoute('عمّان', 'إربد', '2.50'),
        const SizedBox(height: 12),
        _buildPopularRoute('عمّان', 'الزرقاء', '1.00'),
        const SizedBox(height: 12),
        _buildPopularRoute('عمّان', 'العقبة', '7.00'),
        const SizedBox(height: 12),
        _buildPopularRoute('إربد', 'عمّان', '2.50'),
        const SizedBox(height: 28),

        // How it works
        Text('كيف تعمل؟', style: AppTextStyles.headingSmall),
        const SizedBox(height: 16),
        _buildHowItWorksStep(
          Icons.search_rounded,
          'ابحث عن رحلة',
          'اختر وجهتك والتاريخ المناسب',
          '1',
        ),
        _buildHowItWorksStep(
          Icons.event_seat_rounded,
          'احجز مقعدك',
          'اختر عدد المقاعد وأكمل الحجز',
          '2',
        ),
        _buildHowItWorksStep(
          Icons.directions_car_rounded,
          'استمتع بالرحلة',
          'تواصل مع السائق وانطلق',
          '3',
        ),
      ],
    );
  }

  Widget _buildDriverContent(BuildContext context, HomeLoaded state) {
    if (!state.isDriverVerified) {
      return Column(
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.verified_rounded,
                      size: 48, color: AppColors.accentDark),
                ),
                const SizedBox(height: 20),
                Text('وثّق حسابك كسائق',
                    style: AppTextStyles.headingSmall,
                    textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text(
                  'للبدء بنشر رحلات وقبول الركاب، يجب توثيق حسابك أولاً',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'بدء التوثيق',
                  icon: Icons.arrow_back_rounded,
                  onPressed: () => context.push('/profile/driver-verification'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Wallet card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('المحفظة',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: Colors.white70)),
                  const Icon(Icons.account_balance_wallet_rounded,
                      color: Colors.white70),
                ],
              ),
              const SizedBox(height: 12),
              Text('0.00 د.أ',
                  style: AppTextStyles.headingLarge
                      .copyWith(color: Colors.white)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.push('/wallet'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white54),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('شحن الرصيد'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Post trip CTA
        CustomButton(
          text: 'أنشئ رحلة جديدة',
          icon: Icons.add_rounded,
          onPressed: () => context.push('/trips/create'),
        ),
        const SizedBox(height: 24),

        // Recent booking requests
        Text('طلبات الحجز الأخيرة', style: AppTextStyles.headingSmall),
        const SizedBox(height: 16),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(Icons.inbox_rounded,
                    size: 48, color: AppColors.textLight),
                const SizedBox(height: 12),
                Text('لا توجد طلبات حجز حالياً',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopularRoute(String from, String to, String price) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.route_rounded,
                color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Text(from, style: AppTextStyles.bodyMedium),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_back_rounded,
                      size: 16, color: AppColors.textLight),
                ),
                Text(to, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
          Text(
            'من $price د.أ',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksStep(
      IconData icon, String title, String subtitle, String step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(step,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.accentDark,
                    fontWeight: FontWeight.w800,
                  )),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyLarge),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
