import 'package:flutter/material.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../di/injection_container.dart';
import '../../../../l10n/generated/app_localizations.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _notifications = ValueNotifier<List<dynamic>>([]);
  final _loading = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _notifications.dispose();
    _loading.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    _loading.value = true;
    try {
      final res = await sl<DioClient>().dio.get(ApiConstants.notifications);
      _notifications.value = List.from(res.data['data'] ?? []);
    } catch (_) {}
    _loading.value = false;
  }

  Future<void> _markRead(int id) async {
    try {
      await sl<DioClient>()
          .dio
          .patch('${ApiConstants.markNotificationRead}/$id/read');
      _load();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).notifications),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: _loading,
        builder: (context, loading, _) {
          if (loading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                strokeCap: StrokeCap.round,
              ),
            );
          }
          return ValueListenableBuilder<List<dynamic>>(
            valueListenable: _notifications,
            builder: (context, notifications, _) {
              if (notifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications_off_outlined,
                            size: 40, color: AppColors.primary),
                      ),
                      const SizedBox(height: 16),
                      Text(S.of(context).noNotifications,
                          style: AppTextStyles.headingSmall),
                      const SizedBox(height: 8),
                      Text(S.of(context).newNotificationsAppearHere,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: _load,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: notifications.length,
                  itemBuilder: (_, i) {
                    final n = notifications[i];
                    final isRead = n['is_read'] == 1 || n['is_read'] == true;
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: isRead ? AppColors.surface : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isRead
                              ? AppColors.border
                              : AppColors.primary.withValues(alpha: 0.2),
                        ),
                        boxShadow: isRead
                            ? null
                            : [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _colorForType(n['type'] ?? '')
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _iconForType(n['type'] ?? ''),
                            color: _colorForType(n['type'] ?? ''),
                            size: 22,
                          ),
                        ),
                        title: Text(n['title'] ?? '',
                            style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: isRead
                                    ? FontWeight.normal
                                    : FontWeight.w700)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(n['body'] ?? '',
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: AppColors.textSecondary)),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _timeAgo(n['created_at'], context),
                              style: AppTextStyles.caption,
                            ),
                            if (!isRead) ...[
                              const SizedBox(height: 6),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                        onTap: () {
                          if (!isRead) _markRead(n['id']);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _iconForType(String type) {
    return switch (type) {
      'booking_confirmed' => Icons.check_circle_rounded,
      'booking_rejected' => Icons.cancel_rounded,
      'new_booking' => Icons.book_online_rounded,
      'trip_cancelled' => Icons.route_rounded,
      'rating' => Icons.star_rounded,
      'driver_approved' => Icons.verified_rounded,
      _ => Icons.notifications_rounded,
    };
  }

  Color _colorForType(String type) {
    return switch (type) {
      'booking_confirmed' => AppColors.success,
      'booking_rejected' => AppColors.danger,
      'new_booking' => AppColors.primary,
      'trip_cancelled' => AppColors.warning,
      'rating' => AppColors.accent,
      'driver_approved' => AppColors.primary,
      _ => AppColors.textSecondary,
    };
  }

  String _timeAgo(dynamic date, BuildContext context) {
    if (date == null) return '';
    try {
      final d = DateTime.parse(date.toString());
      final diff = DateTime.now().difference(d);
      if (diff.inMinutes < 1) return S.of(context).now;
      if (diff.inMinutes < 60) return S.of(context).minutesAgo(diff.inMinutes);
      if (diff.inHours < 24) return S.of(context).hoursAgo(diff.inHours);
      return S.of(context).daysAgo(diff.inDays);
    } catch (_) {
      return '';
    }
  }
}
