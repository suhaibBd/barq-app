import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class DriverSetupPage extends StatefulWidget {
  const DriverSetupPage({super.key});

  @override
  State<DriverSetupPage> createState() => _DriverSetupPageState();
}

class _DriverSetupPageState extends State<DriverSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _carNumberController = TextEditingController();
  final _picker = ImagePicker();

  final _nationalIdPath = ValueNotifier<String?>(null);
  final _driverLicensePath = ValueNotifier<String?>(null);
  final _carImagePath = ValueNotifier<String?>(null);

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _carNumberController.dispose();
    _nationalIdPath.dispose();
    _driverLicensePath.dispose();
    _carImagePath.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ValueNotifier<String?> notifier) async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 80,
    );
    if (image == null) return;
    notifier.value = image.path;
  }

  bool get _allImagesSelected =>
      _nationalIdPath.value != null &&
      _driverLicensePath.value != null &&
      _carImagePath.value != null;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_allImagesSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).pleaseAttachAllImages),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }
    context.read<AuthBloc>().add(RegisterDriverEvent(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          nationalIdPath: _nationalIdPath.value!,
          driverLicensePath: _driverLicensePath.value!,
          carImagePath: _carImagePath.value!,
          carNumber: _carNumberController.text.trim(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated && !state.isNewUser) {
          context.go('/home');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.danger,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.directions_car_rounded,
                        size: 36,
                        color: AppColors.accentDark,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      S.of(context).registerAsDriver,
                      style: AppTextStyles.headingMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      S.of(context).completeDocsToStart,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Name fields
                    CustomTextField(
                      controller: _firstNameController,
                      label: S.of(context).firstName,
                      hint: S.of(context).firstNameHint,
                      validator: (v) =>
                          Validators.required(v, S.of(context).firstName),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _lastNameController,
                      label: S.of(context).lastName,
                      hint: S.of(context).lastNameHint,
                      validator: (v) =>
                          Validators.required(v, S.of(context).lastName),
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppColors.border)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(S.of(context).requiredDocs,
                              style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary)),
                        ),
                        const Expanded(child: Divider(color: AppColors.border)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // National ID
                    ValueListenableBuilder<String?>(
                      valueListenable: _nationalIdPath,
                      builder: (_, path, __) => _ImagePickerField(
                        label: S.of(context).nationalId,
                        icon: Icons.badge_rounded,
                        imagePath: path,
                        onTap: () => _pickImage(_nationalIdPath),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Driver License
                    ValueListenableBuilder<String?>(
                      valueListenable: _driverLicensePath,
                      builder: (_, path, __) => _ImagePickerField(
                        label: S.of(context).driverLicense,
                        icon: Icons.card_membership_rounded,
                        imagePath: path,
                        onTap: () => _pickImage(_driverLicensePath),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Car Image
                    ValueListenableBuilder<String?>(
                      valueListenable: _carImagePath,
                      builder: (_, path, __) => _ImagePickerField(
                        label: S.of(context).carImage,
                        icon: Icons.directions_car_filled_rounded,
                        imagePath: path,
                        onTap: () => _pickImage(_carImagePath),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Car Number
                    CustomTextField(
                      controller: _carNumberController,
                      label: S.of(context).carNumber,
                      hint: S.of(context).carNumberHint,
                      validator: (v) =>
                          Validators.required(v, S.of(context).carNumber),
                    ),
                    const SizedBox(height: 32),

                    CustomButton(
                      text: S.of(context).createAccount,
                      isLoading: state is AuthLoading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ImagePickerField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? imagePath;
  final VoidCallback onTap;

  const _ImagePickerField({
    required this.label,
    required this.icon,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasImage ? AppColors.success : AppColors.border,
            width: hasImage ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: hasImage
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: hasImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(imagePath!),
                        fit: BoxFit.cover,
                        width: 48,
                        height: 48,
                      ),
                    )
                  : Icon(icon, color: AppColors.textLight, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 2),
                  Text(
                    hasImage ? S.of(context).imageSelected : S.of(context).tapToSelect,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: hasImage ? AppColors.success : AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              hasImage ? Icons.check_circle_rounded : Icons.add_photo_alternate_outlined,
              color: hasImage ? AppColors.success : AppColors.textLight,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
