import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المحفظة')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
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
                  Text('الرصيد الحالي',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text('0.00 د.أ',
                      style: AppTextStyles.headingLarge
                          .copyWith(color: Colors.white, fontSize: 36)),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'شحن الرصيد',
                    backgroundColor: AppColors.accent,
                    icon: Icons.add_rounded,
                    onPressed: () => _showTopupSheet(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Low balance warning
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: AppColors.warning),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'رصيدك منخفض. اشحن رصيدك لتتمكن من قبول الحجوزات.',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.warning),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Transactions
            Text('المعاملات الأخيرة', style: AppTextStyles.headingSmall),
            const SizedBox(height: 16),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.receipt_long_rounded,
                        size: 48, color: AppColors.textLight),
                    const SizedBox(height: 12),
                    Text('لا توجد معاملات بعد',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTopupSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('شحن الرصيد', style: AppTextStyles.headingSmall),
              const SizedBox(height: 8),
              Text('اختر المبلغ الذي تريد شحنه',
                  style: AppTextStyles.bodySmall),
              const SizedBox(height: 20),

              // Preset amounts
              Row(
                children: [
                  _buildAmountChip('1.00'),
                  const SizedBox(width: 10),
                  _buildAmountChip('3.00'),
                  const SizedBox(width: 10),
                  _buildAmountChip('5.00'),
                  const SizedBox(width: 10),
                  _buildAmountChip('10.00'),
                ],
              ),
              const SizedBox(height: 24),

              // Payment instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('طريقة الدفع',
                        style: AppTextStyles.bodyMedium
                            .copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    _buildPaymentStep('1', 'حوّل المبلغ عبر CliQ إلى: rafiq@cliq'),
                    _buildPaymentStep('2', 'أرسل لنا صورة الإيصال'),
                    _buildPaymentStep('3', 'سيتم إضافة الرصيد خلال دقائق'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              CustomButton(
                text: 'تواصل معنا عبر واتساب',
                icon: Icons.chat_rounded,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAmountChip(String amount) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Center(
          child: Text('$amount\nد.أ',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium
                  .copyWith(fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget _buildPaymentStep(String step, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(step,
                  style: AppTextStyles.caption
                      .copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
        ],
      ),
    );
  }
}
