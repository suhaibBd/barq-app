import 'package:flutter/material.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../di/injection_container.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/map/location_picker_page.dart';

class CreateShipmentPage extends StatefulWidget {
  const CreateShipmentPage({super.key});

  @override
  State<CreateShipmentPage> createState() => _CreateShipmentPageState();
}

class _CreateShipmentPageState extends State<CreateShipmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _fromCityController = TextEditingController();
  final _toCityController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _receiverNameController = TextEditingController();
  final _receiverPhoneController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedSize = 'small';
  String _selectedUrgency = 'normal';
  final _loadingNotifier = ValueNotifier<bool>(false);
  final _suggestedPriceNotifier = ValueNotifier<double?>(null);
  final _pickupLocation = ValueNotifier<PickedLocation?>(null);

  static const _sizes = [
    ('small', 'صغير', Icons.inventory_2_outlined),
    ('medium', 'متوسط', Icons.archive_outlined),
    ('large', 'كبير', Icons.luggage_outlined),
  ];

  @override
  void dispose() {
    _fromCityController.dispose();
    _toCityController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _receiverNameController.dispose();
    _receiverPhoneController.dispose();
    _notesController.dispose();
    _loadingNotifier.dispose();
    _suggestedPriceNotifier.dispose();
    _pickupLocation.dispose();
    super.dispose();
  }

  Future<void> _fetchSuggestedPrice() async {
    final from = _fromCityController.text.trim();
    final to = _toCityController.text.trim();
    if (from.isEmpty || to.isEmpty) return;

    try {
      final res = await sl<DioClient>().dio.get(
        ApiConstants.shipmentPriceEstimate,
        queryParameters: {
          'from_city': from,
          'to_city': to,
          'size': _selectedSize,
          'urgency': _selectedUrgency,
        },
      );
      final price = (res.data['suggested_price'] as num?)?.toDouble();
      _suggestedPriceNotifier.value = price;
      if (price != null && _priceController.text.isEmpty) {
        _priceController.text = price.toStringAsFixed(2);
      }
    } catch (_) {}
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _loadingNotifier.value = true;
    try {
      final data = <String, dynamic>{
        'from_city': _fromCityController.text.trim(),
        'to_city': _toCityController.text.trim(),
        'description': _descriptionController.text.trim(),
        'size': _selectedSize,
        'urgency': _selectedUrgency,
        'price': double.tryParse(_priceController.text.trim()) ?? 0,
        'receiver_name': _receiverNameController.text.trim(),
        'receiver_phone': _receiverPhoneController.text.trim(),
        'notes': _notesController.text.trim(),
      };
      final pickup = _pickupLocation.value;
      if (pickup != null) {
        data['pickup_lat'] = pickup.lat;
        data['pickup_lng'] = pickup.lng;
      }
      await sl<DioClient>().dio.post(ApiConstants.createShipment, data: data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء الطلب بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء إنشاء الطلب'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
    _loadingNotifier.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إنشاء طلب جديد', style: AppTextStyles.headingSmall),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // From / To cities
              Text('تفاصيل المسار',
                  style: AppTextStyles.bodyLarge
                      .copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _fromCityController,
                label: 'مدينة الإرسال',
                hint: 'مثال: عمان',
                prefixIcon: const Icon(Icons.circle,
                    size: 10, color: AppColors.primary),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                onChanged: (_) => _fetchSuggestedPrice(),
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<PickedLocation?>(
                valueListenable: _pickupLocation,
                builder: (context, pickup, _) {
                  return GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push<PickedLocation>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LocationPickerPage(
                            title: 'حدد موقع الاستلام',
                          ),
                        ),
                      );
                      if (result != null) {
                        _pickupLocation.value = result;
                        if (_fromCityController.text.trim().isEmpty) {
                          _fromCityController.text = result.cityName;
                          _fetchSuggestedPrice();
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: pickup != null
                            ? AppColors.success.withValues(alpha: 0.08)
                            : AppColors.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: pickup != null
                              ? AppColors.success.withValues(alpha: 0.3)
                              : AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            pickup != null
                                ? Icons.check_circle_rounded
                                : Icons.map_rounded,
                            size: 18,
                            color: pickup != null
                                ? AppColors.success
                                : AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              pickup != null
                                  ? 'موقع الاستلام: ${pickup.address}'
                                  : 'حدد موقع الاستلام على الخريطة (لتعيين أقرب سائق)',
                              style: AppTextStyles.caption.copyWith(
                                color: pickup != null
                                    ? AppColors.success
                                    : AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (pickup != null)
                            GestureDetector(
                              onTap: () => _pickupLocation.value = null,
                              child: const Icon(Icons.close_rounded,
                                  size: 16, color: AppColors.textLight),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _toCityController,
                label: 'مدينة الوصول',
                hint: 'مثال: إربد',
                prefixIcon: const Icon(Icons.location_on_rounded,
                    size: 18, color: AppColors.danger),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                onChanged: (_) => _fetchSuggestedPrice(),
              ),

              const SizedBox(height: 24),

              // Urgency selector
              Text('أولوية التوصيل',
                  style: AppTextStyles.bodyLarge
                      .copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              StatefulBuilder(
                builder: (context, setUrgencyState) {
                  return Row(
                    children: [
                      Expanded(
                        child: _UrgencyOption(
                          label: 'عادي',
                          subtitle: 'ينتظر رحلة متاحة',
                          icon: Icons.schedule_rounded,
                          color: AppColors.primary,
                          isSelected: _selectedUrgency == 'normal',
                          onTap: () {
                            setUrgencyState(() => _selectedUrgency = 'normal');
                            _fetchSuggestedPrice();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _UrgencyOption(
                          label: 'عاجل',
                          subtitle: 'توصيل سريع',
                          icon: Icons.bolt_rounded,
                          color: AppColors.warning,
                          isSelected: _selectedUrgency == 'urgent',
                          onTap: () {
                            setUrgencyState(() => _selectedUrgency = 'urgent');
                            _fetchSuggestedPrice();
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // Package details
              Text('تفاصيل الطلب',
                  style: AppTextStyles.bodyLarge
                      .copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _descriptionController,
                label: 'وصف الطلب',
                hint: 'مثال: وجبات غداء',
                maxLines: 3,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),

              // Size selector
              Text('حجم الطلب',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  )),
              const SizedBox(height: 8),
              StatefulBuilder(
                builder: (context, setSizeState) {
                  return Row(
                    children: _sizes.map((entry) {
                      final (value, label, icon) = entry;
                      final isSelected = _selectedSize == value;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setSizeState(() => _selectedSize = value);
                            _fetchSuggestedPrice();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: EdgeInsets.only(
                                left: value == 'small' ? 0 : 8),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(icon,
                                    size: 20,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textSecondary),
                                const SizedBox(height: 4),
                                Text(
                                  label,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Price with suggestion
              ValueListenableBuilder<double?>(
                valueListenable: _suggestedPriceNotifier,
                builder: (context, suggested, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: _priceController,
                        label: 'السعر (د.أ)',
                        hint: suggested != null
                            ? 'المقترح: ${suggested.toStringAsFixed(2)}'
                            : 'مثال: 5.00',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'مطلوب';
                          if (double.tryParse(v.trim()) == null) {
                            return 'أدخل رقماً صحيحاً';
                          }
                          return null;
                        },
                      ),
                      if (suggested != null) ...[
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () {
                            _priceController.text =
                                suggested.toStringAsFixed(2);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.auto_awesome_rounded,
                                    size: 14, color: AppColors.success),
                                const SizedBox(width: 6),
                                Text(
                                  'السعر المقترح: ${suggested.toStringAsFixed(2)} د.أ',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text('(اضغط للاستخدام)',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textLight)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // Receiver info
              Text('معلومات المستلم',
                  style: AppTextStyles.bodyLarge
                      .copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _receiverNameController,
                label: 'اسم المستلم',
                hint: 'الاسم الكامل',
                prefixIcon: const Icon(Icons.person_outline_rounded,
                    size: 18, color: AppColors.textLight),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _receiverPhoneController,
                label: 'رقم هاتف المستلم',
                hint: '07XXXXXXXX',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined,
                    size: 18, color: AppColors.textLight),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _notesController,
                label: 'ملاحظات (اختياري)',
                hint: 'أي تعليمات إضافية...',
                maxLines: 2,
              ),

              const SizedBox(height: 32),

              // Submit
              ValueListenableBuilder<bool>(
                valueListenable: _loadingNotifier,
                builder: (context, loading, _) {
                  return CustomButton(
                    text: 'إنشاء الطلب',
                    icon: Icons.local_shipping_rounded,
                    isLoading: loading,
                    onPressed: _submit,
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _UrgencyOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _UrgencyOption({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: isSelected ? color : AppColors.textLight),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: isSelected ? color : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
