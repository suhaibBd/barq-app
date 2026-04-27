import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/trip.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback? onTap;

  const TripCard({super.key, required this.trip, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            // Driver info row
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      AppColors.primaryLight.withValues(alpha: 0.2),
                  child: Text(
                    trip.driver.initials,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(trip.driver.fullName,
                              style: AppTextStyles.bodyMedium
                                  .copyWith(fontWeight: FontWeight.w600)),
                          if (trip.driver.isDriverVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified_rounded,
                                size: 16, color: AppColors.info),
                          ],
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 14, color: AppColors.accent),
                          const SizedBox(width: 2),
                          Text(
                            Formatters.rating(trip.driver.rating),
                            style: AppTextStyles.caption,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${trip.driver.totalTrips} رحلة',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Formatters.price(trip.pricePerSeat),
                      style: AppTextStyles.headingSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Text('للمقعد', style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Route
            Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 24,
                      color: AppColors.border,
                    ),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trip.from.name, style: AppTextStyles.bodyMedium),
                      const SizedBox(height: 16),
                      Text(trip.to.name, style: AppTextStyles.bodyMedium),
                    ],
                  ),
                ),
                // Time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Formatters.time(trip.departureTime),
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      Formatters.date(trip.departureTime),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Bottom info
            Row(
              children: [
                _buildInfoChip(
                  Icons.event_seat_rounded,
                  Formatters.seatCount(trip.availableSeats),
                  trip.isFull ? AppColors.danger : AppColors.success,
                ),
                const SizedBox(width: 8),
                if (!trip.rules.smokingAllowed)
                  _buildInfoChip(
                      Icons.smoke_free_rounded, 'ممنوع التدخين', AppColors.textSecondary),
                if (trip.rules.femaleOnly) ...[
                  const SizedBox(width: 8),
                  _buildInfoChip(
                      Icons.female_rounded, 'نساء فقط', AppColors.info),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: AppTextStyles.caption.copyWith(color: color)),
        ],
      ),
    );
  }
}
