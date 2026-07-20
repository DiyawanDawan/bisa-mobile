import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/i18n/failure_messages.dart';
import 'package:mobile_bisa/core/utils/safe_area_utils.dart';
import 'package:mobile_bisa/features/wallet/domain/entities/payout_account_entity.dart';
import 'package:mobile_bisa/features/wallet/domain/entities/wallet_entity.dart';
import 'package:mobile_bisa/features/wallet/domain/entities/wallet_transaction_entity.dart';
import 'package:mobile_bisa/features/wallet/presentation/bloc/wallet_cubit.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_bisa/features/wallet/presentation/widgets/wallet_transaction_ui.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/core/utils/money_format.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';
import 'package:mobile_bisa/shared/widgets/custom_text_field.dart';
import 'payout_accounts_page.dart';
import '../../../../shared/widgets/wallet_skeleton.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<WalletCubit>()..getWalletData(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          backgroundColor: AppColors.surface,
          title: 'wallet.page_title'.tr(),
        ),
        body: BlocConsumer<WalletCubit, WalletState>(
          listener: (context, state) {
            final cubit = context.read<WalletCubit>();

            state.maybeWhen(
              loaded: (_, __, ___, ____) {
                final withdrawError = cubit.consumeWithdrawErrorPending();
                if (withdrawError != null) {
                  showBisaSnackBarMessage(
                    context,
                    withdrawError,
                    isError: true,
                  );
                } else if (cubit.consumeWithdrawSnackPending()) {
                  showBisaSnackBarMessage(
                    context,
                    'permintaan_penarikan_dana_berh'.tr(),
                  );
                }
              },
              payoutAccountSuccess: () {
                showBisaSnackBarMessage(
                  context,
                  'wallet.account_saved_success'.tr(),
                );
              },
              error: (message) {
                showBisaSnackBarMessage(context, message, isError: true);
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const ShimmerWalletPlaceholder(),
              loaded: (wallet, transactions, banks, payoutAccounts) =>
                  RefreshIndicator(
                    onRefresh: () =>
                        context.read<WalletCubit>().getWalletData(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          _buildBalanceCard(wallet),
                          _buildActionButtons(
                            context,
                            banks,
                            wallet,
                            payoutAccounts,
                          ),
                          _buildTransactionHistory(context, transactions),
                          SizedBox(
                            height: 40.h + systemBottomInset(context),
                          ),
                        ],
                      ),
                    ),
                  ),
              error: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(message.localizedFailure),
                    SizedBox(height: 16.h),
                    CustomButton(
                      text: 'coba_lagi'.tr(),
                      width: 160.w,
                      onPressed: () =>
                          context.read<WalletCubit>().getWalletData(),
                    ),
                  ],
                ),
              ),
              orElse: () => const ShimmerWalletPlaceholder(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBalanceCard(WalletEntity wallet) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(24.w),
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'saldo_tersedia'.tr(),
                style: TextStyle(
                  color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                LucideIcons.wallet,
                color: AppColors.white.withValues(alpha: 0.5),
                size: 24.sp,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            formatMoneyIdr(wallet.balance),
            style: TextStyle(
              color: AppColors.surface,
              fontSize: 32.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              _buildBalanceDetail(
                LucideIcons.trendingUp,
                'wallet.income_label'.tr(),
                formatMoneyIdr(wallet.totalEarned),
              ),
              Container(
                width: 1,
                height: 30,
                color: AppColors.white.withValues(alpha: 0.2),
                margin: EdgeInsets.symmetric(horizontal: 20.w),
              ),
              _buildBalanceDetail(
                LucideIcons.trendingDown,
                'wallet.withdrawn_label'.tr(),
                formatMoneyIdr(wallet.totalWithdrawn),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceDetail(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12.sp, color: AppColors.white.withValues(alpha: 0.7)),
              SizedBox(width: 4.w),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textOnPrimary.withValues(alpha: 0.7),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              color: AppColors.surface,
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    List<Map<String, dynamic>> banks,
    WalletEntity wallet,
    List<PayoutAccountEntity> accounts,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          _buildQuickAction(
            LucideIcons.arrowUpRight,
            'wallet.action_withdraw'.tr(),
            AppColors.primary,
            onTap: () =>
                _showWithdrawDialog(context, wallet.balance, accounts),
          ),
          SizedBox(width: 16.w),
          _buildQuickAction(
            LucideIcons.landmark,
            'wallet.action_my_bank'.tr(),
            AppColors.info,
            onTap: () {
              final walletCubit = context.read<WalletCubit>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: walletCubit,
                    child: const PayoutAccountsPage(),
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 16.w),
          _buildQuickAction(
            LucideIcons.chartColumn,
            'wallet.action_analytics'.tr(),
            AppColors.warning,
            onTap: () => context.push('/sales-analytics'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    IconData icon,
    String label,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20.sp),
              ),
              SizedBox(height: 10.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionHistory(
    BuildContext context,
    List<WalletTransactionEntity> transactions,
  ) {
    final preview = transactions.take(5).toList();

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'wallet.history_title'.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/wallet/transactions'),
                child: Text(
                  'wallet.view_all'.tr(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          // SizedBox(height: 24.h),
          if (transactions.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text(
                  'belum_ada_transaksi'.tr(),
                  style: TextStyle(color: AppColors.textHint),
                ),
              ),
            )
          else ...[
            SizedBox(height: 8.h),
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: preview.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: AppColors.grey100,
              ),
              itemBuilder: (context, index) {
                return WalletTransactionTile(tx: preview[index]);
              },
            ),
          ],
        ],
      ),
    );
  }

  void _showWithdrawDialog(
    BuildContext context,
    double currentBalance,
    List<PayoutAccountEntity> accounts,
  ) {
    final amountController = TextEditingController();
    final mainAccount = accounts.where((a) => a.isMain).firstOrNull;
    final walletCubit = context.read<WalletCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (bContext) => BlocProvider.value(
        value: walletCubit,
        child: Builder(
          builder: (context) {
            return Padding(
              padding: sheetBottomPadding(bContext),
              child: Container(
                constraints: BoxConstraints(maxHeight: 0.92.sh),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10.h),
                    Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColors.grey200,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'wallet.action_withdraw'.tr(),
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'wallet.available_balance'.tr(
                                namedArgs: {
                                  'amount': formatMoneyIdr(currentBalance),
                                },
                              ),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            if (mainAccount == null)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(14.w),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: AppColors.warning.withValues(alpha: 0.25),
                                  ),
                                ),
                                child: Text(
                                  'wallet.no_main_account_warning'.tr(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              )
                            else ...[
                              Text(
                                'wallet.destination_account_title'.tr(),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(14.w),
                                decoration: BoxDecoration(
                                  color: AppColors.grey50,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: AppColors.grey200),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      localizeFailureMessage(mainAccount.bankName),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      mainAccount.accountNumber,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      mainAccount.accountName,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12.h),
                              CustomTextField(
                                label: 'wallet.withdraw_amount_label'.tr(),
                                hint: 'wallet.withdraw_amount_hint'.tr(),
                                controller: amountController,
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
                        child: mainAccount == null
                            ? CustomButton(
                                text: 'wallet.setup_primary_account'.tr(),
                                height: AppSpacing.buttonHeight,
                                onPressed: () {
                                  Navigator.pop(bContext);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const PayoutAccountsPage(),
                                    ),
                                  );
                                },
                              )
                            : CustomButton(
                                text: 'wallet.confirm_withdrawal'.tr(),
                                height: AppSpacing.buttonHeight,
                                onPressed: () {
                                  final amount =
                                      double.tryParse(amountController.text) ?? 0;
                                  if (amount <= 0) {
                                    showBisaSnackBarMessage(
                                      context,
                                      'jumlah_penarikan_tidak_valid'.tr(),
                                      isError: true,
                                    );
                                    return;
                                  }
                                  if (amount > currentBalance) {
                                    showBisaSnackBarMessage(
                                      context,
                                      'saldo_tidak_mencukupi'.tr(),
                                      isError: true,
                                    );
                                    return;
                                  }
                                  Navigator.pop(bContext);
                                  walletCubit.requestWithdrawal(amount: amount);
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
