import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';

class CreateBookingPage extends StatefulWidget {
  final String tripId;

  const CreateBookingPage({super.key, required this.tripId});

  @override
  State<CreateBookingPage> createState() => _CreateBookingPageState();
}

class _CreateBookingPageState extends State<CreateBookingPage> {
  final _formKey = GlobalKey<FormState>();
  int _seatsCount = 1;
  final List<TextEditingController> _passengerControllers = [];
  final _notesController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  void dispose() {
    for (final c in _passengerControllers) {
      c.dispose();
    }
    _notesController.dispose();
    super.dispose();
  }

  void _updateSeats(int count) {
    setState(() {
      _seatsCount = count;
      while (_passengerControllers.length < count - 1) {
        _passengerControllers.add(TextEditingController());
      }
      while (_passengerControllers.length > count - 1) {
        _passengerControllers.removeLast().dispose();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const double pricePerSeat = 2.50; // TODO: Get from trip

    return Scaffold(
      appBar: AppBar(title: const Text('حجز مقاعد')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trip summary card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.route_rounded,
                            color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text('ملخص الرحلة',
                            style: AppTextStyles.bodyLarge
                                .copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('عمّان → إربد',
                            style: AppTextStyles.bodyMedium),
                        Text('${Formatters.price(pricePerSeat)} / مقعد',
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Seats selector
              Text('عدد المقاعد', style: AppTextStyles.headingSmall),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  AppConstants.maxSeatsPerBooking,
                  (index) {
                    final count = index + 1;
                    final isSelected = _seatsCount == count;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: GestureDetector(
                        onTap: () => _updateSeats(count),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$count',
                              style: AppTextStyles.headingSmall.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Additional passenger names
              if (_seatsCount > 1) ...[
                Text('أسماء الركاب الإضافيين',
                    style: AppTextStyles.headingSmall),
                const SizedBox(height: 8),
                Text('أدخل أسماء الأشخاص الذين ستحجز لهم',
                    style: AppTextStyles.bodySmall),
                const SizedBox(height: 16),
                ...List.generate(_seatsCount - 1, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CustomTextField(
                      controller: _passengerControllers[index],
                      label: 'الراكب ${index + 2}',
                      hint: 'الاسم الكامل',
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'الرجاء إدخال اسم الراكب';
                        }
                        return null;
                      },
                    ),
                  );
                }),
                const SizedBox(height: 12),
              ],

              // Notes
              CustomTextField(
                controller: _notesController,
                label: 'ملاحظات (اختياري)',
                hint: 'أي ملاحظات للسائق...',
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Price summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            'سعر المقعد × $_seatsCount',
                            style: AppTextStyles.bodyMedium),
                        Text(
                            Formatters.price(
                                pricePerSeat * _seatsCount),
                            style: AppTextStyles.bodyMedium),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('الإجمالي',
                            style: AppTextStyles.bodyLarge
                                .copyWith(fontWeight: FontWeight.w700)),
                        Text(
                            Formatters.price(
                                pricePerSeat * _seatsCount),
                            style: AppTextStyles.headingSmall
                                .copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Terms
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    onChanged: (v) =>
                        setState(() => _agreedToTerms = v ?? false),
                    activeColor: AppColors.primary,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _agreedToTerms = !_agreedToTerms),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          'أوافق على شروط الاستخدام وسياسة الحجز. الدفع يتم مباشرة للسائق (نقداً أو CliQ).',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: 'تأكيد الحجز',
                onPressed: _agreedToTerms
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          // TODO: Submit booking
                        }
                      }
                    : null,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
