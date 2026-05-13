import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../di/injection_container.dart';

class ShipmentAssignmentDialog extends StatefulWidget {
  final int shipmentId;
  final String fromCity;
  final String toCity;
  final String price;
  final String description;
  final DateTime expiresAt;

  const ShipmentAssignmentDialog({
    super.key,
    required this.shipmentId,
    required this.fromCity,
    required this.toCity,
    required this.price,
    required this.description,
    required this.expiresAt,
  });

  @override
  State<ShipmentAssignmentDialog> createState() =>
      _ShipmentAssignmentDialogState();
}

class _ShipmentAssignmentDialogState extends State<ShipmentAssignmentDialog> {
  late Timer _timer;
  final _remaining = ValueNotifier<int>(0);
  final _loading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining();
      if (_remaining.value <= 0) {
        _timer.cancel();
        _onTimeout();
      }
    });
  }

  void _updateRemaining() {
    final diff = widget.expiresAt.difference(DateTime.now()).inSeconds;
    _remaining.value = diff > 0 ? diff : 0;
  }

  @override
  void dispose() {
    _timer.cancel();
    _remaining.dispose();
    _loading.dispose();
    super.dispose();
  }

  Future<void> _accept() async {
    _loading.value = true;
    try {
      await sl<DioClient>()
          .dio
          .patch(ApiConstants.acceptShipment(widget.shipmentId));
      if (mounted) Navigator.pop(context, 'accepted');
    } catch (_) {
      _loading.value = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء قبول الطلب'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  Future<void> _reject() async {
    _loading.value = true;
    try {
      await sl<DioClient>()
          .dio
          .patch(ApiConstants.rejectShipment(widget.shipmentId));
      if (mounted) Navigator.pop(context, 'rejected');
    } catch (_) {
      _loading.value = false;
    }
  }

  void _onTimeout() {
    if (mounted) Navigator.pop(context, 'timeout');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Timer
              ValueListenableBuilder<int>(
                valueListenable: _remaining,
                builder: (_, secs, __) {
                  final mins = secs ~/ 60;
                  final s = secs % 60;
                  return Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 64,
                            height: 64,
                            child: CircularProgressIndicator(
                              value: secs / 120,
                              strokeWidth: 4,
                              backgroundColor:
                                  AppColors.border.withValues(alpha: 0.3),
                              color: secs < 30
                                  ? AppColors.danger
                                  : AppColors.primary,
                            ),
                          ),
                          Text(
                            '$mins:${s.toString().padLeft(2, '0')}',
                            style: AppTextStyles.headingSmall.copyWith(
                              color: secs < 30
                                  ? AppColors.danger
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              // Title
              Text('طلب توصيل جديد!',
                  style: AppTextStyles.headingSmall
                      .copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),

              // Route
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.circle,
                            size: 10, color: AppColors.primary),
                        Container(
                          width: 2,
                          height: 24,
                          color: AppColors.border,
                        ),
                        const Icon(Icons.location_on_rounded,
                            size: 16, color: AppColors.danger),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.fromCity,
                              style: AppTextStyles.bodyMedium
                                  .copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 16),
                          Text(widget.toCity,
                              style: AppTextStyles.bodyMedium
                                  .copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Details row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text('السعر',
                              style: AppTextStyles.caption
                                  .copyWith(color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Text('${widget.price} د.أ',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.success,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(widget.description,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center),
              ],
              const SizedBox(height: 24),

              // Buttons
              ValueListenableBuilder<bool>(
                valueListenable: _loading,
                builder: (_, loading, __) {
                  return Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: loading ? null : _reject,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.danger,
                            side: const BorderSide(color: AppColors.danger),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('رفض',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: loading ? null : _accept,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('قبول',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
