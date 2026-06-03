import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/features/wallet/presentation/bloc/wallet_cubit.dart';
import 'package:mobile_bisa/features/wallet/domain/entities/payout_account_entity.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';
import 'package:mobile_bisa/shared/widgets/custom_text_field.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';

class PayoutAccountsPage extends StatelessWidget {
  const PayoutAccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BisaAppBar(
        title: 'Rekening Bank',
        backgroundColor: AppColors.surface,
      ),
      body: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => ShimmerListPlaceholder(
              itemCount: 4,
              itemHeight: 88.h,
              scrollable: true,
              padding: EdgeInsets.all(16.w),
            ),
            loaded: (wallet, transactions, banks, accounts) {
              if (accounts.isEmpty) {
                return _buildEmptyState(context, banks);
              }
              return ListView.separated(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                itemCount: accounts.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  return _buildAccountCard(context, accounts[index], banks);
                },
              );
            },
            orElse: () => const SizedBox(),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          return state.maybeWhen(
            loaded: (wallet, transactions, banks, accounts) {
              return SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h + bottomInset * 0.25),
                  child: CustomButton(
                    text: 'Tambah Rekening Baru',
                    height: 50.h,
                    onPressed: () => _showAddAccountSheet(context, banks),
                  ),
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _buildAccountCard(
    BuildContext context,
    PayoutAccountEntity account,
    List<Map<String, dynamic>> banks,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey100),
        boxShadow: AppColors.softShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              LucideIcons.landmark,
              color: AppColors.primary,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6.w,
                  runSpacing: 4.h,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      account.bankName,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (account.isMain)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'Utama',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  account.accountNumber,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  account.accountName,
                  style: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 11.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!account.isMain) ...[
                  SizedBox(height: 6.h),
                  GestureDetector(
                    onTap: () => context
                        .read<WalletCubit>()
                        .setMainPayoutAccount(account.id),
                    child: Text(
                      'Set sebagai Utama',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            children: [
              _actionIcon(
                LucideIcons.pencil,
                AppColors.info,
                () => _showAddAccountSheet(context, banks, account: account),
              ),
              SizedBox(height: 4.h),
              _actionIcon(
                LucideIcons.trash2,
                AppColors.error,
                () => _showDeleteConfirm(context, account.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Icon(icon, color: color, size: 16.sp),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    List<Map<String, dynamic>> banks,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.landmark, size: 64.sp, color: AppColors.grey200),
            SizedBox(height: 16.h),
            Text(
              'Belum Ada Rekening Bank',
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Tambahkan rekening untuk mempermudah proses penarikan dana.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
            ),
            SizedBox(height: 24.h),
            CustomButton(
              text: 'Tambah Sekarang',
              width: 200.w,
              height: 48.h,
              onPressed: () => _showAddAccountSheet(context, banks),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, String id) {
    final walletCubit = context.read<WalletCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: walletCubit,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text('hapus_rekening'.tr()),
          content: const Text(
            'Apakah Anda yakin ingin menghapus rekening ini?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('batal'.tr()),
            ),
            TextButton(
              onPressed: () {
                walletCubit.deletePayoutAccount(id);
                Navigator.pop(dialogContext);
              },
              child: Text(
                'hapus'.tr(),
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAccountSheet(
    BuildContext context,
    List<Map<String, dynamic>> banks, {
    PayoutAccountEntity? account,
  }) {
    String? selectedBankId = account?.bankId;
    final accountNoController = TextEditingController(
      text: account?.accountNumber,
    );
    final accountNameController = TextEditingController(
      text: account?.accountName,
    );
    bool isMain = account?.isMain ?? false;

    final walletCubit = context.read<WalletCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider.value(
        value: walletCubit,
        child: StatefulBuilder(
          builder: (context, setState) {
            final bottomInset = MediaQuery.paddingOf(sheetContext).bottom;
            final keyboardInset = MediaQuery.viewInsetsOf(sheetContext).bottom;

            return Padding(
              padding: EdgeInsets.only(bottom: keyboardInset),
              child: Container(
                constraints: BoxConstraints(maxHeight: 0.88.sh),
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 16.h, 12.w, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              account == null ? 'Tambah Rekening' : 'Edit Rekening',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(sheetContext),
                            icon: Icon(LucideIcons.x, size: 20.sp),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pilih Bank',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.grey50,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(color: AppColors.grey200),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(color: AppColors.grey200),
                                ),
                              ),
                              value: selectedBankId,
                              items: banks
                                  .map(
                                    (bank) => DropdownMenuItem(
                                      value: bank['id'].toString(),
                                      child: Text(
                                        bank['name'] as String? ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) => setState(() => selectedBankId = val),
                            ),
                            SizedBox(height: 12.h),
                            CustomTextField(
                              label: 'Nomor Rekening',
                              hint: 'Masukkan nomor rekening',
                              controller: accountNoController,
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 12.h),
                            CustomTextField(
                              label: 'Nama Pemilik Rekening',
                              hint: 'Nama sesuai buku tabungan',
                              controller: accountNameController,
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                SizedBox(
                                  width: 22.w,
                                  height: 22.w,
                                  child: Checkbox(
                                    value: isMain,
                                    onChanged: (val) =>
                                        setState(() => isMain = val ?? false),
                                    activeColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => isMain = !isMain),
                                    child: Text(
                                      'Set sebagai Rekening Utama',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h + bottomInset * 0.25),
                        child: CustomButton(
                          text: account == null ? 'Simpan Rekening' : 'Simpan Perubahan',
                          height: 50.h,
                          onPressed: () {
                            if (selectedBankId != null &&
                                accountNoController.text.isNotEmpty &&
                                accountNameController.text.isNotEmpty) {
                              if (account == null) {
                                walletCubit.createPayoutAccount(
                                  bankId: selectedBankId!,
                                  accountNumber: accountNoController.text,
                                  accountName: accountNameController.text,
                                  isMain: isMain,
                                );
                              } else {
                                walletCubit.updatePayoutAccount(
                                  id: account.id,
                                  bankId: selectedBankId,
                                  accountNumber: accountNoController.text,
                                  accountName: accountNameController.text,
                                  isMain: isMain,
                                );
                              }
                              Navigator.pop(sheetContext);
                            }
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
