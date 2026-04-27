import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('حجوزاتي'),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            labelStyle: AppTextStyles.bodyMedium
                .copyWith(fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'القادمة'),
              Tab(text: 'السابقة'),
              Tab(text: 'الملغاة'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBookingsList('upcoming'),
            _buildBookingsList('past'),
            _buildBookingsList('cancelled'),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(String type) {
    // TODO: Connect to BLoC
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type == 'upcoming'
                  ? Icons.event_rounded
                  : type == 'past'
                      ? Icons.history_rounded
                      : Icons.cancel_rounded,
              size: 64,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              type == 'upcoming'
                  ? 'لا توجد حجوزات قادمة'
                  : type == 'past'
                      ? 'لا توجد حجوزات سابقة'
                      : 'لا توجد حجوزات ملغاة',
              style: AppTextStyles.bodyLarge
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            if (type == 'upcoming')
              Text(
                'ابحث عن رحلة وابدأ بالحجز',
                style: AppTextStyles.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}
