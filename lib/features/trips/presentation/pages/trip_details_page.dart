import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';

class TripDetailsPage extends StatelessWidget {
  final String tripId;

  const TripDetailsPage({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    // TODO: Load from BLoC - using placeholder for now
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Map area placeholder
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primaryLight.withValues(alpha: 0.2),
                child: const Center(
                  child: Icon(Icons.map_rounded,
                      size: 64, color: AppColors.primary),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Route timeline
                _buildRouteTimeline(),
                const SizedBox(height: 24),

                // Driver card
                _buildDriverCard(),
                const SizedBox(height: 24),

                // Trip details
                Text('تفاصيل الرحلة', style: AppTextStyles.headingSmall),
                const SizedBox(height: 16),
                _buildDetailRow(Icons.calendar_today_rounded, 'التاريخ',
                    'سيتم التحميل...'),
                _buildDetailRow(Icons.access_time_rounded, 'وقت المغادرة',
                    'سيتم التحميل...'),
                _buildDetailRow(Icons.event_seat_rounded, 'المقاعد المتاحة',
                    'سيتم التحميل...'),
                _buildDetailRow(Icons.attach_money_rounded, 'السعر للمقعد',
                    'سيتم التحميل...'),
                const SizedBox(height: 24),

                // Trip rules
                Text('قواعد الرحلة', style: AppTextStyles.headingSmall),
                const SizedBox(height: 16),
                _buildRulesList(),
                const SizedBox(height: 24),

                // Pickup options
                Text('خيارات الالتقاء', style: AppTextStyles.headingSmall),
                const SizedBox(height: 16),
                _buildPickupOptions(),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('السعر للمقعد',
                        style: AppTextStyles.caption),
                    Text('-- د.أ',
                        style: AppTextStyles.headingSmall
                            .copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: CustomButton(
                  text: 'احجز الآن',
                  onPressed: () {
                    // Navigate to booking page
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteTimeline() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              Container(
                width: 2,
                height: 40,
                color: AppColors.border,
              ),
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('نقطة الانطلاق', style: AppTextStyles.caption),
                Text('سيتم التحميل...', style: AppTextStyles.bodyLarge),
                const SizedBox(height: 24),
                Text('الوجهة', style: AppTextStyles.caption),
                Text('سيتم التحميل...', style: AppTextStyles.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
            child: const Icon(Icons.person_rounded,
                size: 28, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('اسم السائق',
                    style: AppTextStyles.bodyLarge
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 16, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Text('5.0', style: AppTextStyles.bodySmall),
                    const SizedBox(width: 12),
                    Text('0 رحلة', style: AppTextStyles.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline_rounded,
                color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(label, style: AppTextStyles.bodyMedium),
          const Spacer(),
          Text(value,
              style: AppTextStyles.bodyMedium
                  .copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildRulesList() {
    return Column(
      children: [
        _buildRuleItem(Icons.smoke_free_rounded, 'ممنوع التدخين', true),
        _buildRuleItem(Icons.pets_rounded, 'حيوانات أليفة', false),
        _buildRuleItem(Icons.music_note_rounded, 'موسيقى', true),
        _buildRuleItem(Icons.luggage_rounded, 'أمتعة', true),
      ],
    );
  }

  Widget _buildRuleItem(IconData icon, String label, bool allowed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            allowed ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 20,
            color: allowed ? AppColors.success : AppColors.danger,
          ),
          const SizedBox(width: 12),
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildPickupOptions() {
    return Column(
      children: [
        _buildPickupOption(
            Icons.location_on_rounded, 'نقطة التقاء محددة', true),
        _buildPickupOption(Icons.home_rounded, 'من الباب إلى الباب', false),
      ],
    );
  }

  Widget _buildPickupOption(IconData icon, String label, bool available) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: available
              ? AppColors.primaryLight.withValues(alpha: 0.05)
              : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: available ? AppColors.primary.withValues(alpha: 0.3) : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: available ? AppColors.primary : AppColors.textLight),
            const SizedBox(width: 12),
            Text(label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: available ? AppColors.textPrimary : AppColors.textLight,
                )),
            const Spacer(),
            if (available)
              const Icon(Icons.check_rounded,
                  size: 18, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
