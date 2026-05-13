import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/locale/locale_notifier.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../di/injection_container.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _walletBalance = ValueNotifier<double?>(null);

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  @override
  void dispose() {
    _walletBalance.dispose();
    super.dispose();
  }

  Future<void> _fetchBalance() async {
    try {
      final res = await sl<DioClient>().dio.get(ApiConstants.wallet);
      if (!mounted) return;
      final data = res.data;
      _walletBalance.value =
          data is Map ? (data['balance'] as num?)?.toDouble() : null;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Gradient header background
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.08),
                      AppColors.background,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final user =
                        state is AuthAuthenticated ? state.user : null;
                    return Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundColor:
                                  AppColors.primaryLight.withValues(alpha: 0.2),
                              child: user?.avatarUrl != null
                                  ? ClipOval(
                                      child: Image.network(user!.avatarUrl!,
                                          width: 96,
                                          height: 96,
                                          fit: BoxFit.cover),
                                    )
                                  : Text(
                                      user?.initials ?? '؟',
                                      style: AppTextStyles.headingLarge
                                          .copyWith(color: AppColors.primary),
                                    ),
                            ),
                            if (user?.isDriverVerified ?? false)
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: AppColors.surface,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.verified_rounded,
                                    size: 22,
                                    color: AppColors.info,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user?.fullName ?? S.of(context).user,
                          style: AppTextStyles.headingMedium,
                        ),
                        const SizedBox(height: 4),
                        if (user != null) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.star_rounded,
                                  size: 16, color: AppColors.accent),
                              const SizedBox(width: 4),
                              Text('${user.rating}',
                                  style: AppTextStyles.bodySmall),
                              const SizedBox(width: 8),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: AppColors.textLight,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(S.of(context).orders,
                                  style: AppTextStyles.bodySmall),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              children: [
                                Text(S.of(context).currentBalance,
                                    style: AppTextStyles.caption),
                                const SizedBox(height: 4),
                                ValueListenableBuilder<double?>(
                                  valueListenable: _walletBalance,
                                  builder: (context, balance, _) {
                                    return Text(
                                      'JOD ${(balance ?? 0).toStringAsFixed(2)}',
                                      style: AppTextStyles.headingSmall
                                          .copyWith(
                                        color: AppColors.accent,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),

              // Menu items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Account section
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, right: 4),
                      child: Text(S.of(context).account,
                          style: AppTextStyles.caption
                              .copyWith(fontWeight: FontWeight.w600)),
                    ),
                    _buildMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: S.of(context).editProfile,
                      onTap: () => context.push('/profile/edit'),
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final user =
                            state is AuthAuthenticated ? state.user : null;
                        final isVerified = user?.isDriverVerified ?? false;
                        final docStatus = user?.documentStatus;
                        final isPending = docStatus == 'pending';
                        return _buildMenuItem(
                          icon: isVerified
                              ? Icons.verified_rounded
                              : Icons.verified_outlined,
                          title: S.of(context).verifyDriverAccountMenu,
                          subtitle: isVerified
                              ? S.of(context).verified
                              : isPending
                                  ? S.of(context).docsUnderReview
                                  : S.of(context).notVerified,
                          subtitleColor: isVerified
                              ? AppColors.success
                              : isPending
                                  ? AppColors.warning
                                  : AppColors.danger,
                          onTap: isVerified
                              ? () {}
                              : () => context
                                  .push('/profile/driver-verification'),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.location_on_outlined,
                      title: S.of(context).savedAddresses,
                      onTap: () => _showComingSoon(context),
                    ),
                    _buildMenuItem(
                      icon: Icons.contact_phone_outlined,
                      title: S.of(context).emergencyContacts,
                      onTap: () => _showComingSoon(context),
                    ),
                    const Divider(height: 32),

                    // Settings section
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, right: 4),
                      child: Text(S.of(context).settingsAndHelp,
                          style: AppTextStyles.caption
                              .copyWith(fontWeight: FontWeight.w600)),
                    ),
                    _buildMenuItem(
                      icon: Icons.language_rounded,
                      title: S.of(context).language,
                      subtitle: sl<LocaleNotifier>().isArabic
                          ? S.of(context).arabic
                          : S.of(context).english,
                      onTap: () => _showLanguageDialog(context),
                    ),
                    _buildMenuItem(
                      icon: Icons.help_outline_rounded,
                      title: S.of(context).helpAndSupport,
                      onTap: () => _showComingSoon(context),
                    ),
                    _buildMenuItem(
                      icon: Icons.privacy_tip_outlined,
                      title: S.of(context).privacyPolicy,
                      onTap: () => _showComingSoon(context),
                    ),
                    _buildMenuItem(
                      icon: Icons.description_outlined,
                      title: S.of(context).termsOfService,
                      onTap: () => _showComingSoon(context),
                    ),
                    const Divider(height: 32),
                    _buildMenuItem(
                      icon: Icons.logout_rounded,
                      title: S.of(context).logout,
                      titleColor: AppColors.danger,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(S.of(context).logout),
                            content:
                                Text(S.of(context).logoutConfirm),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(S.of(context).cancel),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  context
                                      .read<AuthBloc>()
                                      .add(LogoutEvent());
                                },
                                child: Text(S.of(context).logout,
                                    style:
                                        TextStyle(color: AppColors.danger)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                          S.of(context).appVersion('1.0.0'), style: AppTextStyles.caption),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final localeNotifier = sl<LocaleNotifier>();
    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: Text(S.of(context).language),
          children: [
            ListTile(
              leading: Icon(
                localeNotifier.isArabic
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: AppColors.primary,
              ),
              title: const Text('العربية'),
              onTap: () {
                localeNotifier.setLocale(const Locale('ar'));
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: Icon(
                !localeNotifier.isArabic
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: AppColors.primary,
              ),
              title: const Text('English'),
              onTap: () {
                localeNotifier.setLocale(const Locale('en'));
                Navigator.pop(ctx);
              },
            ),
          ],
        );
      },
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).comingSoon),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
    final isDestructive = titleColor == AppColors.danger;
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: !isDestructive
            ? Border(
                right: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  width: 3,
                ),
              )
            : null,
      ),
      child: ListTile(
        leading: Icon(icon, color: titleColor ?? AppColors.textPrimary),
        title: Text(title,
            style: AppTextStyles.bodyMedium.copyWith(color: titleColor)),
        trailing: subtitle != null
            ? Text(subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                    color: subtitleColor ?? AppColors.textSecondary))
            : const Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: AppColors.textLight),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
