import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/i18n/failure_messages.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../domain/entities/partnership_entity.dart';
import '../bloc/partnership_cubit.dart';
import '../widgets/partnership_status_chip.dart';
import '../utils/partnership_pdf_export_helper.dart';

class PartnershipDetailPage extends StatelessWidget {
  final String partnershipId;

  const PartnershipDetailPage({super.key, required this.partnershipId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PartnershipCubit>()..loadDetail(partnershipId),
      child: _PartnershipDetailBody(partnershipId: partnershipId),
    );
  }
}

class _PartnershipDetailBody extends StatelessWidget {
  final String partnershipId;

  const _PartnershipDetailBody({required this.partnershipId});

  Future<void> _sendPartnershipToChat(
    BuildContext context,
    PartnershipEntity p,
  ) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    final userId = context.read<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u.id,
          orElse: () => null,
        );
    final counterpartyId =
        userId == p.buyerId ? p.supplierId : p.buyerId;
    final negotiationId =
        await PartnershipPdfExportHelper.findNegotiationIdWithUser(
      counterpartyId,
    );

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    if (!context.mounted) return;

    if (negotiationId == null) {
      showErrorSnackBar(context, 'partnership.chat_no_room'.tr());
      return;
    }

    await PartnershipPdfExportHelper.showSendProposalSheet(
      context,
      negotiationId: negotiationId,
      partnership: p,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u.id,
          orElse: () => null,
        );
    final userRole = context.watch<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u.role,
          orElse: () => null,
        );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        backgroundColor: AppColors.surface,
        title: 'partnership.detail_title'.tr(),
        actions: [
          BlocBuilder<PartnershipCubit, PartnershipState>(
            builder: (context, state) {
              final p = state.selected;
              if (p == null) return const SizedBox.shrink();
              return IconButton(
                tooltip: p.isFullySigned
                    ? 'partnership.pdf_download'.tr()
                    : 'partnership.pdf_download_draft'.tr(),
                onPressed: () =>
                    PartnershipPdfExportHelper.exportEntity(context, p),
                icon: Icon(LucideIcons.download, size: 20.sp),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<PartnershipCubit, PartnershipState>(
        listener: (context, state) {
          if (state.error != null && !state.isSubmitting) {
            showErrorSnackBar(context, state.error!.localizedFailure);
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.selected == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final p = state.selected;
          if (p == null) {
            return Center(child: Text('partnership.not_found'.tr()));
          }

          final isBuyer = userId == p.buyerId;
          final isSupplier = userId == p.supplierId;
          final counterparty = isSupplier ? p.buyer : p.supplier;
          final dateFmt = DateFormat('dd MMM yyyy');

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ContractHeader(partnership: p),
                      SizedBox(height: AppSpacing.md),
                      _ContractPeriodBanner(partnership: p),
                      SizedBox(height: AppSpacing.md),
                      _PartyCard(user: counterparty, label: 'partnership.counterparty'.tr()),
                      SizedBox(height: AppSpacing.md),
                      _Section(title: 'partnership.section_terms'.tr(), children: [
                        if (p.description?.isNotEmpty == true)
                          _TermRow('partnership.field_description'.tr(), p.description!),
                        if (p.productCategory?.isNotEmpty == true)
                          _TermRow('partnership.field_category'.tr(), p.productCategory!),
                        if (p.estimatedMonthlyQty != null)
                          _TermRow(
                            'partnership.field_qty'.tr(),
                            '${p.estimatedMonthlyQty} ton/bulan',
                          ),
                        if (p.priceAgreement?.isNotEmpty == true)
                          _TermRow('partnership.field_price'.tr(), p.priceAgreement!),
                        if (p.deliveryTerms?.isNotEmpty == true)
                          _TermRow('partnership.field_delivery'.tr(), p.deliveryTerms!),
                        if (p.paymentTerms?.isNotEmpty == true)
                          _TermRow('partnership.field_payment'.tr(), p.paymentTerms!),
                        if (p.specialTerms?.isNotEmpty == true)
                          _TermRow('partnership.field_special'.tr(), p.specialTerms!),
                        _TermRow(
                          'partnership.field_period'.tr(),
                          '${dateFmt.format(p.startDate)} – ${dateFmt.format(p.endDate)}',
                        ),
                        if (p.renewalCount > 0)
                          _TermRow(
                            'partnership.renewal_count'.tr(),
                            '${p.renewalCount}x',
                          ),
                      ]),
                      SizedBox(height: AppSpacing.md),
                      _Section(title: 'partnership.section_signature'.tr(), children: [
                        Text(
                          'partnership.signers_progress'.tr(
                            namedArgs: {
                              'signed': '${p.signedCount}',
                              'total': '${p.requiredSigners}',
                            },
                          ),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        _SignRow(
                          label: 'partnership.buyer_sign'.tr(),
                          signedAt: p.buyerSignedAt,
                          signerName: p.buyerSignerName ?? p.buyer.fullName,
                          signerTitle: p.buyerSignerTitle,
                          companyName: p.buyerCompanyName ?? p.buyer.companyName,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        _SignRow(
                          label: 'partnership.supplier_sign'.tr(),
                          signedAt: p.sellerSignedAt,
                          signerName: p.sellerSignerName ?? p.supplier.fullName,
                          signerTitle: p.sellerSignerTitle,
                          companyName: p.sellerCompanyName ?? p.supplier.companyName,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        _SignRow(
                          label: 'partnership.platform_sign'.tr(),
                          signedAt: p.platformSignedAt,
                          signerName: p.platformSignerName ?? 'BISA Agri',
                          signerTitle: p.platformSignerTitle,
                          companyName: 'BISA Agri',
                        ),
                      ]),
                      if (p.isRenewalPending && p.renewalProposedEndDate != null) ...[
                        SizedBox(height: AppSpacing.md),
                        _Section(title: 'partnership.renewal_pending_title'.tr(), children: [
                          _TermRow(
                            'partnership.renewal_new_end'.tr(),
                            dateFmt.format(p.renewalProposedEndDate!),
                          ),
                          if (p.renewalNote?.isNotEmpty == true)
                            _TermRow('partnership.renewal_note'.tr(), p.renewalNote!),
                        ]),
                      ],
                      if (p.rejectionReason?.isNotEmpty == true &&
                          p.status == 'REJECTED') ...[
                        SizedBox(height: AppSpacing.md),
                        _Section(title: 'partnership.rejection_reason'.tr(), children: [
                          Text(p.rejectionReason!, style: TextStyle(fontSize: 13.sp)),
                        ]),
                      ],
                      SizedBox(height: AppSpacing.md),
                      OutlinedButton.icon(
                        onPressed: () =>
                            PartnershipPdfExportHelper.exportEntity(context, p),
                        icon: Icon(LucideIcons.download, size: 18.sp),
                        label: Text(
                          p.isFullySigned
                              ? 'partnership.pdf_download'.tr()
                              : 'partnership.pdf_download_draft'.tr(),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 48.h),
                          foregroundColor: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm10),
                      OutlinedButton.icon(
                        onPressed: () => _sendPartnershipToChat(context, p),
                        icon: Icon(LucideIcons.messageSquare, size: 18.sp),
                        label: Text('partnership.chat_send_cta'.tr()),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 48.h),
                          foregroundColor: AppColors.success,
                        ),
                      ),
                      if (p.isActive) ...[
                        SizedBox(height: AppSpacing.sm10),
                        OutlinedButton.icon(
                          onPressed: () => context.push(
                            '/supplier/${p.supplierId}',
                            extra: {'name': p.supplier.fullName},
                          ),
                          icon: Icon(LucideIcons.store, size: 18.sp),
                          label: Text('partnership.order_from_partner'.tr()),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 48.h),
                            foregroundColor: AppColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (userId != null)
                _ActionBar(
                  partnership: p,
                  userId: userId!,
                  isBuyer: isBuyer,
                  isSupplier: isSupplier,
                  userRole: userRole,
                  isSubmitting: state.isSubmitting,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ContractHeader extends StatelessWidget {
  final PartnershipEntity partnership;

  const _ContractHeader({required this.partnership});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.tile),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  partnership.title,
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              PartnershipStatusChip(status: partnership.status),
            ],
          ),
          SizedBox(height: AppSpacing.sm10),
          Text(
            partnership.contractNumber,
            style: TextStyle(color: AppColors.textOnPrimary.withValues(alpha: 0.9), fontSize: 12.sp),
          ),
          if (partnership.tier == 'MAIN_PARTNER') ...[
            SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(LucideIcons.star, size: 14.sp, color: AppColors.warning),
                SizedBox(width: 4.w),
                Text(
                  'partnership.tier_main'.tr(),
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ContractPeriodBanner extends StatelessWidget {
  final PartnershipEntity partnership;

  const _ContractPeriodBanner({required this.partnership});

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd MMM yyyy');
    Color bg;
    Color fg;
    String message;

    switch (partnership.contractPhase) {
      case 'UPCOMING':
        bg = AppColors.info.withValues(alpha: 0.12);
        fg = AppColors.info;
        message = 'partnership.phase_upcoming'.tr(
          namedArgs: {'date': dateFmt.format(partnership.startDate)},
        );
        break;
      case 'EXPIRING_SOON':
        bg = AppColors.warning.withValues(alpha: 0.15);
        fg = AppColors.warning;
        message = 'partnership.phase_expiring_soon'.tr(
          namedArgs: {'days': '${partnership.daysUntilExpiry ?? 0}'},
        );
        break;
      case 'EXPIRED':
        bg = AppColors.error.withValues(alpha: 0.12);
        fg = AppColors.error;
        message = 'partnership.phase_expired'.tr(
          namedArgs: {'date': dateFmt.format(partnership.endDate)},
        );
        break;
      case 'ACTIVE':
        bg = AppColors.success.withValues(alpha: 0.12);
        fg = AppColors.success;
        message = 'partnership.phase_active'.tr(
          namedArgs: {
            'start': dateFmt.format(partnership.startDate),
            'end': dateFmt.format(partnership.endDate),
            'days': '${partnership.daysUntilExpiry ?? 0}',
          },
        );
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: fg.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.calendarRange, color: fg, size: 20.sp),
          SizedBox(width: AppSpacing.sm10),
          Expanded(
            child: Text(message, style: TextStyle(fontSize: 13.sp, color: fg)),
          ),
        ],
      ),
    );
  }
}

class _PartyCard extends StatelessWidget {
  final PartnershipUserEntity user;
  final String label;

  const _PartyCard({required this.user, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundImage: resolveMediaImageProvider(user.avatarUrl),
            child: user.avatarUrl == null
                ? Icon(LucideIcons.building2, color: AppColors.primary)
                : null,
          ),
          SizedBox(width: AppSpacing.md12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
                Text(
                  user.companyName?.isNotEmpty == true ? user.companyName! : user.fullName,
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
          SizedBox(height: AppSpacing.sm10),
          ...children,
        ],
      ),
    );
  }
}

class _TermRow extends StatelessWidget {
  final String label;
  final String value;

  const _TermRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
          SizedBox(height: 2.h),
          Text(value, style: TextStyle(fontSize: 13.sp)),
        ],
      ),
    );
  }
}

class _SignRow extends StatelessWidget {
  final String label;
  final DateTime? signedAt;
  final String? signerName;
  final String? signerTitle;
  final String? companyName;

  const _SignRow({
    required this.label,
    this.signedAt,
    this.signerName,
    this.signerTitle,
    this.companyName,
  });

  @override
  Widget build(BuildContext context) {
    final signed = signedAt != null;
    final identityParts = <String>[
      if (signerName != null && signerName!.trim().isNotEmpty) signerName!.trim(),
      if (signerTitle != null && signerTitle!.trim().isNotEmpty) signerTitle!.trim(),
      if (companyName != null && companyName!.trim().isNotEmpty) companyName!.trim(),
    ];
    final identityLine = identityParts.join(' · ');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Icon(
            signed ? LucideIcons.circleCheck : LucideIcons.circle,
            size: 18.sp,
            color: signed ? AppColors.success : AppColors.textHint,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                signed
                    ? '$label · ${DateFormat('dd MMM yyyy HH:mm').format(signedAt!)}'
                    : label,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
              if (identityLine.isNotEmpty) ...[
                SizedBox(height: 2.h),
                Text(
                  identityLine,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionBar extends StatelessWidget {
  final PartnershipEntity partnership;
  final String userId;
  final bool isBuyer;
  final bool isSupplier;
  final String? userRole;
  final bool isSubmitting;

  const _ActionBar({
    required this.partnership,
    required this.userId,
    required this.isBuyer,
    required this.isSupplier,
    required this.userRole,
    required this.isSubmitting,
  });

  Future<void> _reject(BuildContext context) async {
    final reasonCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('partnership.reject_title'.tr()),
        content: TextField(
          controller: reasonCtrl,
          decoration: InputDecoration(hintText: 'partnership.reject_hint'.tr()),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('cancel'.tr())),
          TextButton(
            onPressed: () => Navigator.pop(ctx, reasonCtrl.text.trim().length >= 5),
            child: Text('partnership.reject_confirm'.tr()),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final err = await context.read<PartnershipCubit>().reject(partnership.id, reasonCtrl.text.trim());
    if (context.mounted && err == null) {
      showSuccessSnackBar(context, 'partnership.reject_success'.tr());
    }
  }

  Future<void> _terminate(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('partnership.terminate_title'.tr()),
        content: Text('partnership.terminate_message'.tr()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('cancel'.tr())),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('partnership.terminate_confirm'.tr()),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final err = await context.read<PartnershipCubit>().terminate(partnership.id);
    if (context.mounted && err == null) {
      showSuccessSnackBar(context, 'partnership.terminate_success'.tr());
    }
  }

  Future<void> _requestRenewal(BuildContext context) async {
    final defaultEnd = partnership.endDate.add(const Duration(days: 365));
    DateTime pickedEnd = defaultEnd;
    final noteCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text('partnership.renew_title'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('partnership.renew_message'.tr()),
              SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: () async {
                  final d = await showDatePicker(
                    context: ctx,
                    initialDate: pickedEnd,
                    firstDate: partnership.endDate.add(const Duration(days: 30)),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (d != null) setLocal(() => pickedEnd = d);
                },
                icon: Icon(LucideIcons.calendar, size: 16.sp),
                label: Text(DateFormat('dd MMM yyyy').format(pickedEnd)),
              ),
              SizedBox(height: AppSpacing.sm10),
              TextField(
                controller: noteCtrl,
                decoration: InputDecoration(hintText: 'partnership.renewal_note_hint'.tr()),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('cancel'.tr())),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('partnership.renew_submit'.tr())),
          ],
        ),
      ),
    );
    if (ok != true || !context.mounted) return;
    final err = await context.read<PartnershipCubit>().requestRenewal(
          partnership.id,
          pickedEnd,
          note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
        );
    if (context.mounted && err == null) {
      showSuccessSnackBar(context, 'partnership.renew_request_success'.tr());
    }
  }

  Future<void> _rejectRenewal(BuildContext context) async {
    final err = await context.read<PartnershipCubit>().rejectRenewal(partnership.id);
    if (context.mounted && err == null) {
      showSuccessSnackBar(context, 'partnership.renew_reject_success'.tr());
    }
  }

  bool _needsSign() {
    if (isBuyer && partnership.buyerSignedAt == null) return true;
    if (isSupplier && partnership.sellerSignedAt == null) return true;
    if (userRole == 'ADMIN' &&
        partnership.platformSignedAt == null &&
        partnership.buyerSignedAt != null &&
        partnership.sellerSignedAt != null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PartnershipCubit>();
    final actions = <Widget>[];

    if (partnership.status == 'PENDING' && isSupplier) {
      actions.addAll([
        Expanded(
          child: OutlinedButton(
            onPressed: isSubmitting ? null : () => _reject(context),
            child: Text('partnership.reject'.tr()),
          ),
        ),
        SizedBox(width: AppSpacing.sm10),
        Expanded(
          child: CustomButton(
            text: 'partnership.accept'.tr(),
            isLoading: isSubmitting,
            onPressed: isSubmitting
                ? null
                : () async {
                    final err = await cubit.accept(partnership.id);
                    if (context.mounted && err == null) {
                      showSuccessSnackBar(context, 'partnership.accept_success'.tr());
                    }
                  },
          ),
        ),
      ]);
    } else if (partnership.canSign && _needsSign()) {
      actions.add(
        Expanded(
          child: CustomButton(
            text: 'partnership.sign_contract'.tr(),
            isLoading: isSubmitting,
            onPressed: isSubmitting
                ? null
                : () async {
                    final err = await cubit.sign(partnership.id);
                    if (context.mounted && err == null) {
                      showSuccessSnackBar(context, 'partnership.sign_success'.tr());
                    }
                  },
          ),
        ),
      );
    } else if (partnership.isRenewalPending &&
        partnership.renewalRequestedBy != null &&
        partnership.renewalRequestedBy != userId) {
      actions.addAll([
        Expanded(
          child: OutlinedButton(
            onPressed: isSubmitting ? null : () => _rejectRenewal(context),
            child: Text('partnership.renew_reject'.tr()),
          ),
        ),
        SizedBox(width: AppSpacing.sm10),
        Expanded(
          child: CustomButton(
            text: 'partnership.renew_accept'.tr(),
            isLoading: isSubmitting,
            onPressed: isSubmitting
                ? null
                : () async {
                    final err = await cubit.acceptRenewal(partnership.id);
                    if (context.mounted && err == null) {
                      showSuccessSnackBar(context, 'partnership.renew_accept_success'.tr());
                    }
                  },
          ),
        ),
      ]);
    } else if (partnership.canRenew && !partnership.isRenewalPending) {
      actions.add(
        Expanded(
          child: CustomButton(
            text: 'partnership.renew_contract'.tr(),
            isLoading: isSubmitting,
            onPressed: isSubmitting ? null : () => _requestRenewal(context),
          ),
        ),
      );
    } else if (partnership.isActive && (isBuyer || isSupplier)) {
      actions.add(
        Expanded(
          child: OutlinedButton(
            onPressed: isSubmitting ? null : () => _terminate(context),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
            child: Text('partnership.terminate'.tr()),
          ),
        ),
      );
    }

    if (actions.isEmpty) return const SizedBox.shrink();

    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(children: actions),
      ),
    );
  }
}
