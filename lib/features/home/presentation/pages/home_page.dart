import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../di/injection_container.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/user_role.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/role_toggle_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _myOrders =
      ValueNotifier<_DataState<List<Map<String, dynamic>>>>(_DataState.loading());
  final _availableOrders =
      ValueNotifier<_DataState<List<Map<String, dynamic>>>>(_DataState.loading());
  final _walletBalance = ValueNotifier<double?>(null);
  DateTime _lastFetch = DateTime(2000);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchAll();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _myOrders.dispose();
    _availableOrders.dispose();
    _walletBalance.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        DateTime.now().difference(_lastFetch).inSeconds > 30) {
      _fetchAll();
    }
  }

  void _fetchAll() {
    _lastFetch = DateTime.now();
    _fetchMyOrders();
    _fetchAvailableOrders();
    _fetchWalletBalance();
  }

  Future<void> _fetchWalletBalance() async {
    try {
      final response = await sl<DioClient>().dio.get(ApiConstants.wallet);
      if (!mounted) return;
      final data = response.data;
      final balance = data is Map ? (data['balance'] as num?)?.toDouble() : null;
      _walletBalance.value = balance;
    } catch (_) {}
  }

  List<Map<String, dynamic>> _parseList(dynamic data) {
    final List rawList;
    if (data is Map && data.containsKey('data')) {
      rawList = data['data'] is List ? data['data'] : [];
    } else if (data is List) {
      rawList = data;
    } else {
      rawList = [];
    }
    return rawList.map((e) => e as Map<String, dynamic>).toList();
  }

  Future<void> _fetchMyOrders() async {
    _myOrders.value = _DataState.loading();
    try {
      final response = await sl<DioClient>().dio.get(ApiConstants.myShipments);
      if (!mounted) return;
      final orders = _parseList(response.data);
      _myOrders.value = _DataState.loaded(orders.take(5).toList());
    } catch (_) {
      if (!mounted) return;
      _myOrders.value = _DataState.loaded([]);
    }
  }

  Future<void> _fetchAvailableOrders() async {
    _availableOrders.value = _DataState.loading();
    try {
      final response =
          await sl<DioClient>().dio.get(ApiConstants.availableShipments);
      if (!mounted) return;
      final orders = _parseList(response.data);
      _availableOrders.value = _DataState.loaded(orders.take(5).toList());
    } catch (_) {
      if (!mounted) return;
      _availableOrders.value = _DataState.loaded([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (DateTime.now().difference(_lastFetch).inSeconds > 30) {
      _fetchAll();
    }

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Scaffold(body: LoadingIndicator());
        }

        if (state is HomeLoaded) {
          return Scaffold(
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<AuthBloc>().add(RefreshProfileEvent());
                  _fetchAll();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 20),
                      RoleToggleWidget(
                        currentRole: state.currentRole,
                        onRoleChanged: (role) {
                          context
                              .read<HomeBloc>()
                              .add(SwitchRoleEvent(role));
                        },
                      ),
                      const SizedBox(height: 24),
                      if (state.currentRole == UserRole.restaurant)
                        _buildRestaurantContent(context)
                      else
                        _buildDriverContent(context, state),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return const Scaffold(body: LoadingIndicator());
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final user = state is AuthAuthenticated ? state.user : null;
            return CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
              child: user?.avatarUrl != null
                  ? ClipOval(
                      child: Image.network(user!.avatarUrl!,
                          width: 40, height: 40, fit: BoxFit.cover),
                    )
                  : Text(
                      user?.initials ?? '',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            );
          },
        ),
        const Spacer(),
        Text(
          S.of(context).appName,
          style: AppTextStyles.headingSmall.copyWith(
            color: AppColors.primary,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => context.push('/notifications'),
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined,
                  size: 28, color: AppColors.textPrimary),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════
  //  RESTAURANT CONTENT
  // ═══════════════════════════════════════════════

  Widget _buildRestaurantContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Create new order button
        GestureDetector(
          onTap: () async {
            final result = await context.push('/orders/create');
            if (result == true) _fetchAll();
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add_rounded,
                      color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).createNewOrder,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          )),
                      const SizedBox(height: 4),
                      Text(S.of(context).createOrderDesc,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          )),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: Colors.white70),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Recent orders
        _buildMyOrdersSection(context),
      ],
    );
  }

  Widget _buildMyOrdersSection(BuildContext context) {
    return ValueListenableBuilder<_DataState<List<Map<String, dynamic>>>>(
      valueListenable: _myOrders,
      builder: (context, state, _) {
        if (state.isLoading) {
          return _buildSectionShimmer();
        }
        final orders = state.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).myRecentOrders,
                    style: AppTextStyles.headingSmall),
                GestureDetector(
                  onTap: () => context.go('/orders'),
                  child: Text(S.of(context).viewAll,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.primary)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (orders.isEmpty)
              _buildEmptyState(
                icon: Icons.receipt_long_outlined,
                message: S.of(context).noOrdersYet,
              )
            else
              ...orders.map((order) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildOrderCard(order),
                  )),
          ],
        );
      },
    );
  }

  // ═══════════════════════════════════════════════
  //  DRIVER CONTENT
  // ═══════════════════════════════════════════════

  Widget _buildDriverContent(BuildContext context, HomeLoaded state) {
    if (!state.isDriverVerified) {
      return _buildDriverVerification(context, state);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOnlineToggle(context, state),
        const SizedBox(height: 16),
        _buildWalletCard(context),
        const SizedBox(height: 24),
        _buildAvailableOrdersSection(context),
      ],
    );
  }

  Widget _buildOnlineToggle(BuildContext context, HomeLoaded state) {
    final isOnline = state.isOnline;
    return GestureDetector(
      onTap: () => context.read<HomeBloc>().add(ToggleOnlineEvent()),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isOnline
              ? AppColors.success.withValues(alpha: 0.1)
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isOnline
                ? AppColors.success.withValues(alpha: 0.4)
                : AppColors.border.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOnline ? AppColors.success : AppColors.textLight,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isOnline
                    ? S.of(context).driverOnline
                    : S.of(context).driverOffline,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isOnline ? AppColors.success : AppColors.textLight,
                ),
              ),
            ),
            Switch.adaptive(
              value: isOnline,
              onChanged: (_) =>
                  context.read<HomeBloc>().add(ToggleOnlineEvent()),
              activeTrackColor: AppColors.success.withValues(alpha: 0.5),
              activeThumbColor: AppColors.success,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/wallet'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).wallet,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: Colors.white70)),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<double?>(
                    valueListenable: _walletBalance,
                    builder: (context, balance, _) {
                      return Text(
                        S.of(context)
                            .balanceAmount((balance ?? 0).toStringAsFixed(2)),
                        style: AppTextStyles.headingMedium
                            .copyWith(color: Colors.white),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.account_balance_wallet_rounded,
                  color: Colors.white, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableOrdersSection(BuildContext context) {
    return ValueListenableBuilder<_DataState<List<Map<String, dynamic>>>>(
      valueListenable: _availableOrders,
      builder: (context, state, _) {
        if (state.isLoading) {
          return _buildSectionShimmer();
        }
        final orders = state.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).availableOrdersTitle,
                    style: AppTextStyles.headingSmall),
                GestureDetector(
                  onTap: () => context.go('/orders'),
                  child: Text(S.of(context).viewAll,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.primary)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (orders.isEmpty)
              _buildEmptyState(
                icon: Icons.delivery_dining_outlined,
                message: S.of(context).noAvailableOrders,
              )
            else
              ...orders.map((order) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildOrderCard(order),
                  )),
          ],
        );
      },
    );
  }

  // ═══════════════════════════════════════════════
  //  DRIVER VERIFICATION
  // ═══════════════════════════════════════════════

  Widget _buildDriverVerification(BuildContext context, HomeLoaded state) {
    final docStatus = state.documentStatus;
    if (docStatus == 'pending') {
      return _buildVerificationStatus(
        icon: Icons.hourglass_top_rounded,
        iconColor: AppColors.warning,
        title: S.of(context).docsUnderReview,
        subtitle: S.of(context).docsUnderReviewDesc,
      );
    }
    if (docStatus == 'rejected') {
      return _buildVerificationStatus(
        icon: Icons.cancel_outlined,
        iconColor: AppColors.danger,
        title: S.of(context).docsRejected,
        subtitle: S.of(context).docsRejectedDesc,
        actionText: S.of(context).resubmitDocs,
        onAction: () => context.push('/profile/driver-verification'),
      );
    }
    return _buildVerificationStatus(
      icon: Icons.verified_outlined,
      iconColor: AppColors.primary,
      title: S.of(context).verifyDriverAccount,
      subtitle: S.of(context).verifyDriverDescription,
      actionText: S.of(context).startVerification,
      onAction: () => context.push('/profile/driver-verification'),
    );
  }

  Widget _buildVerificationStatus({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: iconColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: iconColor),
          const SizedBox(height: 16),
          Text(title,
              style: AppTextStyles.headingSmall,
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(subtitle,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center),
          if (actionText != null && onAction != null) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(actionText),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  //  SHARED WIDGETS
  // ═══════════════════════════════════════════════

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final fromCity = order['from_city']?.toString() ?? '';
    final toCity = order['to_city']?.toString() ?? '';
    final description = order['description']?.toString() ?? '';
    final price = order['price']?.toString() ?? '0';
    final status = order['status']?.toString() ?? 'pending';
    final urgency = order['urgency']?.toString() ?? 'normal';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: urgency == 'urgent'
              ? AppColors.warning.withValues(alpha: 0.3)
              : AppColors.border.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: urgency == 'urgent'
                  ? AppColors.warning.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              urgency == 'urgent'
                  ? Icons.bolt_rounded
                  : Icons.receipt_long_rounded,
              color: urgency == 'urgent' ? AppColors.warning : AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(fromCity,
                          style: AppTextStyles.bodyMedium
                              .copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(Icons.arrow_forward_rounded,
                          size: 14, color: AppColors.textLight),
                    ),
                    Flexible(
                      child: Text(toCity,
                          style: AppTextStyles.bodyMedium
                              .copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                if (description.isNotEmpty)
                  Text(description,
                      style: AppTextStyles.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$price ${S.of(context).jod}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  )),
              _buildStatusBadge(status,
                  isAssigning: status == 'pending' &&
                      order['assigned_driver_id'] != null),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, {bool isAssigning = false}) {
    final (label, color) = switch (status) {
      'pending' when isAssigning => ('جاري التعيين', AppColors.info),
      'pending' => ('قيد الانتظار', AppColors.warning),
      'accepted' => ('مقبول', AppColors.info),
      'picked_up' => ('تم الاستلام', AppColors.primary),
      'delivered' => ('تم التوصيل', AppColors.success),
      'cancelled' => ('ملغي', AppColors.danger),
      _ => (status, AppColors.textLight),
    };

    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppColors.textLight),
          const SizedBox(height: 12),
          Text(message,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildSectionShimmer() {
    return Column(
      children: List.generate(
        3,
        (_) => Container(
          height: 70,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppColors.shimmer,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _DataState<T> {
  final T? data;
  final bool isLoading;

  const _DataState._({this.data, required this.isLoading});

  factory _DataState.loading() => const _DataState._(isLoading: true);
  factory _DataState.loaded(T data) =>
      _DataState._(data: data, isLoading: false);
}
