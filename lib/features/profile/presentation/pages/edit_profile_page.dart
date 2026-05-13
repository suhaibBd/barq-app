import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated && _initialized) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).profileUpdated),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop();
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.danger,
            ),
          );
        }
      },
      builder: (context, state) {
        if (!_initialized && state is AuthAuthenticated) {
          _firstNameController.text = state.user.firstName;
          _lastNameController.text = state.user.lastName;
          _emailController.text = state.user.email ?? '';
          _initialized = true;
        }

        final isLoading = state is AuthLoading;

        return Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).editProfile),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () => context.pop(),
            ),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              AppColors.primaryLight.withValues(alpha: 0.2),
                          child: state is AuthAuthenticated &&
                                  state.user.avatarUrl != null
                              ? ClipOval(
                                  child: Image.network(
                                    state.user.avatarUrl!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Text(
                                  state is AuthAuthenticated
                                      ? state.user.initials
                                      : '؟',
                                  style: AppTextStyles.headingLarge
                                      .copyWith(color: AppColors.primary),
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt_rounded,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: _firstNameController,
                    label: S.of(context).firstName,
                    hint: S.of(context).firstName,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return S.of(context).firstNameRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _lastNameController,
                    label: S.of(context).lastName,
                    hint: S.of(context).lastName,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return S.of(context).lastNameRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _emailController,
                    label: S.of(context).emailOptional,
                    hint: 'example@email.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  if (state is AuthAuthenticated)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.phone_rounded,
                              size: 20, color: AppColors.textSecondary),
                          const SizedBox(width: 12),
                          Text(state.user.phone,
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: AppColors.textSecondary)),
                          const Spacer(),
                          const Icon(Icons.lock_rounded,
                              size: 16, color: AppColors.textLight),
                        ],
                      ),
                    ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: S.of(context).saveChanges,
                    isLoading: isLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(UpdateProfileEvent(
                              firstName: _firstNameController.text.trim(),
                              lastName: _lastNameController.text.trim(),
                              email: _emailController.text.trim().isNotEmpty
                                  ? _emailController.text.trim()
                                  : null,
                            ));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
