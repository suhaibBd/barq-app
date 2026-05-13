import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../di/injection_container.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/custom_button.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final _balanceNotifier = ValueNotifier<String>('0.00');
  final _transactionsNotifier =
      ValueNotifier<List<Map<String, dynamic>>>([]);
  final _loadingNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _fetchWallet();
  }

  @override
  void dispose() {
    _balanceNotifier.dispose();
    _transactionsNotifier.dispose();
    _loadingNotifier.dispose();
    super.dispose();
  }

  Future<void> _fetchWallet() async {
    _loadingNotifier.value = true;
    try {
      final dio = sl<DioClient>().dio;
      final walletRes = await dio.get(ApiConstants.wallet);
      final walletData = walletRes.data;
      if (walletData is Map) {
        final balance = walletData['balance'] ?? walletData['data']?['balance'];
        _balanceNotifier.value =
            double.tryParse(balance?.toString() ?? '0')?.toStringAsFixed(2) ??
                '0.00';
      }

      final txRes = await dio.get(ApiConstants.transactions);
      final txData = txRes.data;
      final List rawList;
      if (txData is Map && txData.containsKey('data')) {
        rawList = txData['data'] is List ? txData['data'] : [];
      } else if (txData is List) {
        rawList = txData;
      } else {
        rawList = [];
      }
      _transactionsNotifier.value =
          rawList.map((e) => e as Map<String, dynamic>).take(20).toList();
    } catch (_) {}
    _loadingNotifier.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).wallet)),
      body: RefreshIndicator(
        onRefresh: _fetchWallet,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance card
              ValueListenableBuilder<String>(
                valueListenable: _balanceNotifier,
                builder: (context, balance, _) {
                  return _buildBalanceCard(context, balance);
                },
              ),
              const SizedBox(height: 20),

              // Recharge card section
              _buildRechargeCardSection(context),
              const SizedBox(height: 20),

              // Top up with preset amounts
              _buildPresetTopUp(context),
              const SizedBox(height: 24),

              // Transactions
              Text(S.of(context).recentTransactions,
                  style: AppTextStyles.headingSmall),
              const SizedBox(height: 16),
              ValueListenableBuilder<bool>(
                valueListenable: _loadingNotifier,
                builder: (context, loading, _) {
                  if (loading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }
                  return ValueListenableBuilder<List<Map<String, dynamic>>>(
                    valueListenable: _transactionsNotifier,
                    builder: (context, transactions, _) {
                      if (transactions.isEmpty) {
                        return _buildEmptyTransactions(context);
                      }
                      return Column(
                        children: transactions
                            .map((tx) => _buildTransactionItem(context, tx))
                            .toList(),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, String balance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
      child: Stack(
        children: [
          Positioned(
            left: -20,
            bottom: -20,
            child: Icon(
              Icons.account_balance_wallet_rounded,
              size: 120,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).currentBalance,
                  style:
                      AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
              const SizedBox(height: 8),
              Text(
                S.of(context).balanceAmount(balance),
                style: AppTextStyles.headingLarge
                    .copyWith(color: Colors.white, fontSize: 36),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRechargeCardSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.card_giftcard_rounded,
                    color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).rechargeCard,
                        style: AppTextStyles.bodyLarge
                            .copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(S.of(context).rechargeCardDesc,
                        style: AppTextStyles.caption),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: S.of(context).rechargeNow,
            icon: Icons.arrow_forward_rounded,
            onPressed: () => _showRechargeSheet(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetTopUp(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context).orRechargeWithCard,
            style: AppTextStyles.caption
                .copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _showTopupSheet(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.chat_rounded,
                    size: 20, color: AppColors.textSecondary),
                const SizedBox(width: 12),
                Text(S.of(context).contactViaWhatsapp,
                    style: AppTextStyles.bodyMedium),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: AppColors.textLight),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyTransactions(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.receipt_long_rounded,
                size: 48, color: AppColors.textLight),
            const SizedBox(height: 12),
            Text(S.of(context).noTransactions,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
      BuildContext context, Map<String, dynamic> tx) {
    final type = tx['type']?.toString() ?? '';
    final amount = double.tryParse(tx['amount']?.toString() ?? '0') ?? 0;
    final description = tx['description']?.toString() ?? '';
    final createdAt = tx['created_at']?.toString() ?? '';

    final isCredit = type == 'topup' || type == 'recharge' || type == 'refund';
    final icon = switch (type) {
      'recharge' => Icons.card_giftcard_rounded,
      'topup' => Icons.add_circle_outline_rounded,
      'booking' => Icons.directions_car_rounded,
      'commission' => Icons.percent_rounded,
      'refund' => Icons.replay_rounded,
      _ => Icons.swap_horiz_rounded,
    };
    final color = isCredit ? AppColors.success : AppColors.danger;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description.isNotEmpty ? description : type,
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (createdAt.isNotEmpty)
                  Text(
                    _formatDate(createdAt),
                    style: AppTextStyles.caption,
                  ),
              ],
            ),
          ),
          Text(
            '${isCredit ? '+' : '-'} ${amount.toStringAsFixed(2)}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  // ─── RECHARGE CARD SHEET ───

  void _showRechargeSheet(BuildContext context) {
    final codeController = TextEditingController();
    final loadingNotifier = ValueNotifier<bool>(false);
    final errorNotifier = ValueNotifier<String?>(null);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, MediaQuery.of(sheetContext).viewInsets.bottom + 20),
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.card_giftcard_rounded,
                        color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(S.of(context).rechargeCard,
                      style: AppTextStyles.headingSmall),
                ],
              ),
              const SizedBox(height: 8),
              Text(S.of(context).rechargeCardDesc,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              Directionality(
                textDirection: TextDirection.ltr,
                child: TextField(
                  controller: codeController,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headingSmall.copyWith(
                    letterSpacing: 2,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9\-]')),
                    LengthLimitingTextInputFormatter(14),
                    _CardCodeFormatter(),
                  ],
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: S.of(context).cardNumberHint,
                    hintStyle: AppTextStyles.headingSmall.copyWith(
                      color: AppColors.textLight.withValues(alpha: 0.5),
                      letterSpacing: 2,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ValueListenableBuilder<String?>(
                valueListenable: errorNotifier,
                builder: (context, error, _) {
                  if (error == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(error,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.danger)),
                  );
                },
              ),
              ValueListenableBuilder<bool>(
                valueListenable: loadingNotifier,
                builder: (context, loading, _) {
                  return CustomButton(
                    text: S.of(context).rechargeNow,
                    icon: Icons.check_rounded,
                    isLoading: loading,
                    onPressed: () async {
                      final code = codeController.text.trim();
                      if (code.isEmpty) {
                        errorNotifier.value =
                            S.of(context).enterCardNumber;
                        return;
                      }
                      errorNotifier.value = null;
                      loadingNotifier.value = true;
                      try {
                        final response = await sl<DioClient>()
                            .dio
                            .post(ApiConstants.rechargeCard, data: {
                          'code': code,
                        });
                        final data = response.data;
                        final amount =
                            data['amount']?.toString() ?? '0';
                        final newBalance =
                            data['new_balance']?.toString() ?? '0';
                        _balanceNotifier.value =
                            double.tryParse(newBalance)
                                    ?.toStringAsFixed(2) ??
                                '0.00';
                        _fetchWallet();
                        if (sheetContext.mounted) {
                          Navigator.pop(sheetContext);
                        }
                        if (mounted) {
                          _showRechargeSuccessDialog(context, amount);
                        }
                      } catch (e) {
                        final statusCode = _extractStatusCode(e);
                        if (statusCode == 404) {
                          errorNotifier.value =
                              S.of(context).invalidCardCode;
                        } else if (statusCode == 400) {
                          errorNotifier.value =
                              S.of(context).cardAlreadyUsed;
                        } else {
                          errorNotifier.value =
                              S.of(context).somethingWentWrong;
                        }
                      }
                      loadingNotifier.value = false;
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    ).then((_) {
      codeController.dispose();
      loadingNotifier.dispose();
      errorNotifier.dispose();
    });
  }

  int? _extractStatusCode(dynamic error) {
    try {
      return (error as dynamic).response?.statusCode as int?;
    } catch (_) {
      return null;
    }
  }

  void _showRechargeSuccessDialog(BuildContext context, String amount) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    size: 40, color: AppColors.success),
              ),
              const SizedBox(height: 20),
              Text(S.of(context).rechargeSuccess,
                  style: AppTextStyles.headingSmall,
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                S.of(context).rechargedAmount(amount),
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: S.of(context).done,
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── WHATSAPP TOP UP SHEET ───

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
              Text(S.of(context).topUpBalance,
                  style: AppTextStyles.headingSmall),
              const SizedBox(height: 8),
              Text(S.of(context).chooseTopUpAmount,
                  style: AppTextStyles.bodySmall),
              const SizedBox(height: 20),
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).paymentMethod,
                        style: AppTextStyles.bodyMedium
                            .copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    _buildPaymentStep('1', S.of(context).paymentStep1),
                    _buildPaymentStep('2', S.of(context).paymentStep2),
                    _buildPaymentStep('3', S.of(context).paymentStep3),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: S.of(context).contactViaWhatsapp,
                icon: Icons.chat_rounded,
                onPressed: () => Navigator.pop(context),
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
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border:
              Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text('$amount\nد.أ',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              )),
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
                  style: AppTextStyles.caption.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
        ],
      ),
    );
  }
}

class _CardCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll('-', '').toUpperCase();
    if (text.length > 12) {
      return oldValue;
    }
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write('-');
      buffer.write(text[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
