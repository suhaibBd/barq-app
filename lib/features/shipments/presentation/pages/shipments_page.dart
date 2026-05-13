import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../di/injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class ShipmentsPage extends StatefulWidget {
  const ShipmentsPage({super.key});

  @override
  State<ShipmentsPage> createState() => _ShipmentsPageState();
}

class _ShipmentsPageState extends State<ShipmentsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final bool _isDriver;

  final _myShipmentsNotifier =
      ValueNotifier<List<Map<String, dynamic>>>([]);
  final _availableShipmentsNotifier =
      ValueNotifier<List<Map<String, dynamic>>>([]);
  final _loadingMyNotifier = ValueNotifier<bool>(true);
  final _loadingAvailableNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    _isDriver = authState is AuthAuthenticated &&
        authState.user.isDriverVerified;
    _tabController = TabController(length: _isDriver ? 3 : 2, vsync: this);
    _fetchMyShipments();
    _fetchAvailableShipments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _myShipmentsNotifier.dispose();
    _availableShipmentsNotifier.dispose();
    _loadingMyNotifier.dispose();
    _loadingAvailableNotifier.dispose();
    super.dispose();
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

  Future<void> _fetchMyShipments() async {
    _loadingMyNotifier.value = true;
    try {
      final res = await sl<DioClient>().dio.get(ApiConstants.myShipments);
      _myShipmentsNotifier.value = _parseList(res.data);
    } catch (_) {}
    _loadingMyNotifier.value = false;
  }

  Future<void> _fetchAvailableShipments() async {
    _loadingAvailableNotifier.value = true;
    try {
      final res =
          await sl<DioClient>().dio.get(ApiConstants.availableShipments);
      _availableShipmentsNotifier.value = _parseList(res.data);
    } catch (_) {}
    _loadingAvailableNotifier.value = false;
  }

  Future<void> _refreshAll() async {
    await Future.wait([
      _fetchMyShipments(),
      _fetchAvailableShipments(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الطلبات', style: AppTextStyles.headingSmall),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textLight,
          indicatorColor: AppColors.primary,
          labelStyle:
              AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle: AppTextStyles.bodyMedium,
          tabs: [
            const Tab(text: 'طلباتي'),
            if (_isDriver) const Tab(text: 'متاحة'),
            const Tab(text: 'الكل'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTab(
            loadingNotifier: _loadingMyNotifier,
            dataNotifier: _myShipmentsNotifier,
            onRefresh: _fetchMyShipments,
            emptyIcon: Icons.inventory_2_outlined,
            emptyMsg: 'لا توجد طلبات حالياً',
            isMyShipment: true,
          ),
          if (_isDriver)
            _buildTab(
              loadingNotifier: _loadingAvailableNotifier,
              dataNotifier: _availableShipmentsNotifier,
              onRefresh: _fetchAvailableShipments,
              emptyIcon: Icons.delivery_dining_outlined,
              emptyMsg: 'لا توجد طلبات متاحة للتوصيل',
              isMyShipment: false,
            ),
          _buildTab(
            loadingNotifier: _loadingAvailableNotifier,
            dataNotifier: _availableShipmentsNotifier,
            onRefresh: _fetchAvailableShipments,
            emptyIcon: Icons.local_shipping_outlined,
            emptyMsg: 'لا توجد طلبات متاحة',
            isMyShipment: false,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await context.push('/orders/create');
          if (result == true) _refreshAll();
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('إنشاء طلب',
            style: AppTextStyles.button.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _buildTab({
    required ValueNotifier<bool> loadingNotifier,
    required ValueNotifier<List<Map<String, dynamic>>> dataNotifier,
    required Future<void> Function() onRefresh,
    required IconData emptyIcon,
    required String emptyMsg,
    required bool isMyShipment,
  }) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ValueListenableBuilder<bool>(
        valueListenable: loadingNotifier,
        builder: (context, loading, _) {
          if (loading) {
            return const Center(
                child: CircularProgressIndicator(strokeWidth: 2));
          }
          return ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable: dataNotifier,
            builder: (context, shipments, _) {
              if (shipments.isEmpty) {
                return _buildEmptyState(icon: emptyIcon, message: emptyMsg);
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: shipments.length,
                itemBuilder: (context, index) =>
                    _buildShipmentCard(shipments[index],
                        isMyShipment: isMyShipment),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
  }) {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
        Center(
          child: Column(
            children: [
              Icon(icon, size: 64, color: AppColors.textLight),
              const SizedBox(height: 16),
              Text(message,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShipmentCard(Map<String, dynamic> shipment,
      {required bool isMyShipment}) {
    final fromCity = shipment['from_city']?.toString() ?? '';
    final toCity = shipment['to_city']?.toString() ?? '';
    final description = shipment['description']?.toString() ?? '';
    final size = shipment['size']?.toString() ?? '';
    final price = shipment['price']?.toString() ?? '0';
    final status = shipment['status']?.toString() ?? 'pending';
    final urgency = shipment['urgency']?.toString() ?? 'normal';
    final receiverName = shipment['receiver_name']?.toString() ?? '';
    final receiverPhone = shipment['receiver_phone']?.toString() ?? '';
    final id = shipment['id']?.toString() ?? '';
    final matchedTripId = shipment['matched_trip_id']?.toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: urgency == 'urgent'
              ? AppColors.warning.withValues(alpha: 0.4)
              : AppColors.border.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Route + Status + Urgency
            Row(
              children: [
                if (urgency == 'urgent') ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt_rounded,
                            size: 12, color: AppColors.warning),
                        const SizedBox(width: 2),
                        Text('عاجل',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w700,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.circle,
                          size: 8, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(fromCity,
                            style: AppTextStyles.bodyMedium
                                .copyWith(fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.arrow_forward_rounded,
                            size: 16, color: AppColors.textLight),
                      ),
                      Flexible(
                        child: Text(toCity,
                            style: AppTextStyles.bodyMedium
                                .copyWith(fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(status),
              ],
            ),
            const SizedBox(height: 12),

            // Description
            if (description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(description,
                    style: AppTextStyles.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),

            // Size + Price row
            Row(
              children: [
                _buildSizeBadge(size),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$price د.أ',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                if (receiverName.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person_outline_rounded,
                          size: 14, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text(receiverName, style: AppTextStyles.caption),
                    ],
                  ),
              ],
            ),

            // Receiver phone
            if (receiverPhone.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    const Icon(Icons.phone_outlined,
                        size: 14, color: AppColors.textLight),
                    const SizedBox(width: 4),
                    Text(receiverPhone, style: AppTextStyles.caption),
                  ],
                ),
              ),

            // Action buttons
            if (_shouldShowActions(status, isMyShipment)) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              _buildActionButtons(id, status, isMyShipment, matchedTripId),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final (label, color) = switch (status) {
      'pending' => ('قيد الانتظار', AppColors.warning),
      'accepted' => ('مقبول', AppColors.info),
      'picked_up' => ('تم الاستلام', AppColors.primary),
      'delivered' => ('تم التوصيل', AppColors.success),
      'cancelled' => ('ملغي', AppColors.danger),
      _ => (status, AppColors.textLight),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSizeBadge(String size) {
    final label = switch (size) {
      'small' => 'صغير',
      'medium' => 'متوسط',
      'large' => 'كبير',
      _ => size,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primarySurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  bool _shouldShowActions(String status, bool isMyShipment) {
    if (!isMyShipment && status == 'pending') return true;
    if (isMyShipment && status == 'pending') return true;
    if (isMyShipment && (status == 'accepted' || status == 'picked_up')) {
      return true;
    }
    return false;
  }

  Widget _buildActionButtons(
      String id, String status, bool isMyShipment, String? matchedTripId) {
    if (!isMyShipment && status == 'pending') {
      return SizedBox(
        width: double.infinity,
        child: _buildActionButton(
          label: 'قبول الطلب',
          icon: Icons.check_circle_outline_rounded,
          color: AppColors.success,
          onTap: () => _acceptShipment(id, matchedTripId),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      children: [
        if (isMyShipment && status == 'pending')
          _buildActionButton(
            label: 'إلغاء',
            icon: Icons.close_rounded,
            color: AppColors.danger,
            onTap: () => _cancelShipment(id),
          ),
        if (isMyShipment && status == 'accepted')
          _buildActionButton(
            label: 'تم الاستلام',
            icon: Icons.inventory_rounded,
            color: AppColors.primary,
            onTap: () => _updateShipmentStatus(id, 'picked_up'),
          ),
        if (isMyShipment && status == 'picked_up')
          _buildActionButton(
            label: 'تم التوصيل',
            icon: Icons.done_all_rounded,
            color: AppColors.success,
            onTap: () => _updateShipmentStatus(id, 'delivered'),
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(label,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _acceptShipment(String id, String? tripId) async {
    try {
      await sl<DioClient>().dio.patch(
        '${ApiConstants.createShipment}/$id/accept',
        data: tripId != null ? {'trip_id': tripId} : null,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم قبول الطلب بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
      }
      _refreshAll();
    } catch (_) {
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

  Future<void> _cancelShipment(String id) async {
    try {
      await sl<DioClient>()
          .dio
          .patch('${ApiConstants.createShipment}/$id/cancel');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إلغاء الطلب'),
            backgroundColor: AppColors.success,
          ),
        );
      }
      _refreshAll();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء إلغاء الطلب'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  Future<void> _updateShipmentStatus(String id, String newStatus) async {
    try {
      await sl<DioClient>()
          .dio
          .patch('${ApiConstants.createShipment}/$id/status', data: {
        'status': newStatus,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث حالة الطلب'),
            backgroundColor: AppColors.success,
          ),
        );
      }
      _refreshAll();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء تحديث حالة الطلب'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }
}
