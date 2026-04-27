import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile header
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final user = state is AuthAuthenticated ? state.user : null;
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor:
                            AppColors.primaryLight.withValues(alpha: 0.2),
                        child: user?.avatarUrl != null
                            ? ClipOval(
                                child: Image.network(user!.avatarUrl!,
                                    width: 96, height: 96, fit: BoxFit.cover),
                              )
                            : Text(
                                user?.initials ?? '؟',
                                style: AppTextStyles.headingLarge
                                    .copyWith(color: AppColors.primary),
                              ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user?.fullName ?? 'مستخدم',
                        style: AppTextStyles.headingMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.phone ?? '',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      if (user != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star_rounded,
                                size: 18, color: AppColors.accent),
                            const SizedBox(width: 4),
                            Text('${user.rating}',
                                style: AppTextStyles.bodyMedium),
                            const SizedBox(width: 16),
                            const Icon(Icons.route_rounded,
                                size: 18, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text('${user.totalTrips} رحلة',
                                style: AppTextStyles.bodyMedium),
                          ],
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),

              // Menu items
              _buildMenuItem(
                icon: Icons.person_outline_rounded,
                title: 'تعديل الملف الشخصي',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.verified_outlined,
                title: 'توثيق حساب السائق',
                subtitle: 'غير موثق',
                subtitleColor: AppColors.warning,
                onTap: () => context.push('/profile/driver-verification'),
              ),
              _buildMenuItem(
                icon: Icons.location_on_outlined,
                title: 'العناوين المحفوظة',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.contact_phone_outlined,
                title: 'جهات اتصال الطوارئ',
                onTap: () {},
              ),
              const Divider(height: 32),
              _buildMenuItem(
                icon: Icons.language_rounded,
                title: 'اللغة',
                subtitle: 'العربية',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.help_outline_rounded,
                title: 'المساعدة والدعم',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.privacy_tip_outlined,
                title: 'سياسة الخصوصية',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.description_outlined,
                title: 'شروط الاستخدام',
                onTap: () {},
              ),
              const Divider(height: 32),
              _buildMenuItem(
                icon: Icons.logout_rounded,
                title: 'تسجيل الخروج',
                titleColor: AppColors.danger,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('تسجيل الخروج'),
                      content:
                          const Text('هل أنت متأكد من تسجيل الخروج؟'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('إلغاء'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            context.read<AuthBloc>().add(LogoutEvent());
                          },
                          child: Text('تسجيل الخروج',
                              style: TextStyle(color: AppColors.danger)),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text('رافق v1.0.0', style: AppTextStyles.caption),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    Color? subtitleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? AppColors.textPrimary),
      title: Text(title,
          style: AppTextStyles.bodyMedium.copyWith(color: titleColor)),
      trailing: subtitle != null
          ? Text(subtitle,
              style: AppTextStyles.bodySmall
                  .copyWith(color: subtitleColor ?? AppColors.textSecondary))
          : const Icon(Icons.arrow_forward_ios_rounded,
              size: 16, color: AppColors.textLight),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
