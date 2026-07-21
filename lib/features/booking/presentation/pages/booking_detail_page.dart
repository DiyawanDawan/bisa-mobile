import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/i18n/failure_messages.dart';
import '../../../../core/readiness/readiness_gate.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/seller_identity_row.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../domain/entities/booking_entity.dart';
import '../bloc/booking_cubit.dart';
import '../widgets/booking_status_chip.dart';

class BookingDetailPage extends StatelessWidget {
  final String bookingId;

  const BookingDetailPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookingCubit>()..loadDetail(bookingId),
      child: _BookingDetailBody(bookingId: bookingId),
    );
  }
}

class _BookingDetailBody extends StatelessWidget {
  final String bookingId;

  const _BookingDetailBody({required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<AuthCubit>().state.maybeWhen(
      authenticated: (u) => u.id,
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        backgroundColor: AppColors.surface,
        title: 'booking.detail_title'.tr(),
      ),
      body: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state.error != null && !state.isSubmitting) {
            showErrorSnackBar(context, state.error!.localizedFailure);
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.selected == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final b = state.selected;
          if (b == null) {
            return Center(child: Text('booking.not_found'.tr()));
          }

          final isBuyer = userId == b.buyerId;
          final isSupplier = userId == b.supplierId;
          final counterparty = isSupplier ? b.buyer : b.supplier;
          final dateFmt = DateFormat('dd MMM yyyy, HH:mm');

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeaderCard(booking: b),
                      if (b.canCheckout && !b.isExpired) ...[
                        SizedBox(height: AppSpacing.comfortable),
                        _CountdownBanner(booking: b),
                      ],
                      SizedBox(height: AppSpacing.sectionGap),
                      _Section(
                        title: 'booking.section_product'.tr(),
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.lg,
                                ),
                                child: SizedBox(
                                  width: 72.w,
                                  height: 72.w,
                                  child: BisaNetworkImage(
                                    imageUrl: b.product.thumbnailUrl,
                                    fit: BoxFit.cover,
                                    errorWidget: (_, __, ___) => Container(
                                      color: AppColors.grey100,
                                      child: Icon(
                                        LucideIcons.package,
                                        color: AppColors.grey400,
                                        size: 28.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: AppSpacing.sm10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      b.product.name,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    _Row(
                                      'booking.field_quantity'.tr(),
                                      '${b.quantity} ${b.unit}',
                                    ),
                                    _Row(
                                      'booking.field_price'.tr(),
                                      formatMoneyDisplay(b.priceSnapshot),
                                    ),
                                    _Row(
                                      'booking.field_subtotal'.tr(),
                                      formatMoneyDisplay(b.subtotalSnapshot),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.md),
                      _Section(
                        title: 'booking.section_party'.tr(),
                        children: [
                          SellerIdentityRow(
                            displayName:
                                counterparty.companyName?.trim().isNotEmpty ==
                                    true
                                ? counterparty.companyName!
                                : counterparty.fullName,
                            avatarUrl: counterparty.avatarUrl,
                            isVerified: counterparty.isVerified,
                            avatarRadius: 16.r,
                            fallbackIcon: isSupplier
                                ? LucideIcons.user
                                : LucideIcons.store,
                            nameStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            maxNameLines: 2,
                          ),
                          SizedBox(height: AppSpacing.sm),
                          _Row(
                            'booking.field_created'.tr(),
                            dateFmt.format(b.createdAt),
                          ),
                          _Row(
                            'booking.expires_at'.tr(
                              namedArgs: {'date': dateFmt.format(b.expiresAt)},
                            ),
                            dateFmt.format(b.expiresAt),
                          ),
                          if (b.confirmedAt != null)
                            _Row(
                              'booking.field_confirmed'.tr(),
                              dateFmt.format(b.confirmedAt!),
                            ),
                        ],
                      ),
                      if (b.notes?.isNotEmpty == true) ...[
                        SizedBox(height: AppSpacing.md),
                        _Section(
                          title: 'booking.field_notes'.tr(),
                          children: [
                            Text(b.notes!, style: TextStyle(fontSize: 13.sp)),
                          ],
                        ),
                      ],
                      if (b.harvestLot != null) ...[
                        SizedBox(height: AppSpacing.md),
                        _Section(
                          title: 'booking.section_harvest_lot'.tr(),
                          children: [
                            if (b.harvestLot!.seasonLabel?.isNotEmpty == true)
                              _Row(
                                'booking.field_season'.tr(),
                                b.harvestLot!.seasonLabel!,
                              ),
                            _Row(
                              'booking.field_harvest_date'.tr(),
                              DateFormat(
                                'dd MMM yyyy',
                              ).format(b.harvestLot!.expectedHarvestDate),
                            ),
                          ],
                        ),
                      ],
                      if (b.order != null) ...[
                        SizedBox(height: AppSpacing.md),
                        OutlinedButton.icon(
                          onPressed: () =>
                              context.push('/order/${b.order!.id}'),
                          icon: Icon(LucideIcons.shoppingBag, size: 18.sp),
                          label: Text('booking.view_order'.tr()),
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
                  booking: b,
                  isBuyer: isBuyer,
                  isSupplier: isSupplier,
                  isSubmitting: state.isSubmitting,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final BookingEntity booking;

  const _HeaderCard({required this.booking});

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
          Text(
            booking.bookingNumber,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            booking.product.name,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          BookingStatusChip(status: booking.status),
        ],
      ),
    );
  }
}

class _CountdownBanner extends StatelessWidget {
  final BookingEntity booking;

  const _CountdownBanner({required this.booking});

  @override
  Widget build(BuildContext context) {
    final left = booking.timeLeft;
    final hours = left.inHours;
    final minutes = left.inMinutes.remainder(60);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.timer, color: AppColors.warning, size: 20.sp),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'booking.hold_countdown'.tr(
                namedArgs: {'hours': '$hours', 'minutes': '$minutes'},
              ),
              style: TextStyle(fontSize: 13.sp, color: AppColors.warning),
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
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: AppSpacing.sm),
          ...children,
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 13.sp)),
          ),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  final BookingEntity booking;
  final bool isBuyer;
  final bool isSupplier;
  final bool isSubmitting;

  const _ActionBar({
    required this.booking,
    required this.isBuyer,
    required this.isSupplier,
    required this.isSubmitting,
  });

  Future<void> _checkout(BuildContext context) async {
    if (!await ReadinessGate.ensureBuyerReady(context)) return;
    if (!context.mounted) return;

    final result = await context.read<BookingCubit>().checkout(booking.id);
    if (!context.mounted || result == null) return;

    final orders = (result.checkout['orders'] as List?) ?? const [];
    final orderId = orders.isNotEmpty
        ? orders.first['orderId']?.toString()
        : result.checkout['leadOrderId']?.toString();

    showSuccessSnackBar(context, 'booking.checkout_success'.tr());
    if (orderId != null && orderId.isNotEmpty) {
      context.push('/order/$orderId');
    }
  }

  Future<void> _cancel(BuildContext context) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final ctrl = TextEditingController();
        return AlertDialog(
          title: Text('booking.cancel_title'.tr()),
          content: TextField(
            controller: ctrl,
            decoration: InputDecoration(
              hintText: 'booking.cancel_reason_hint'.tr(),
            ),
            maxLines: 2,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('cancel'.tr()),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
              child: Text('booking.cancel_confirm'.tr()),
            ),
          ],
        );
      },
    );
    if (!context.mounted) return;
    final err = await context.read<BookingCubit>().cancel(
      booking.id,
      reason: reason,
    );
    if (err == null && context.mounted) {
      showSuccessSnackBar(context, 'booking.cancel_success'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[];

    if (isSupplier && booking.canConfirm) {
      actions.add(
        Expanded(
          child: CustomButton(
            text: 'booking.confirm'.tr(),
            isLoading: isSubmitting,
            onPressed: isSubmitting
                ? null
                : () async {
                    final err = await context.read<BookingCubit>().confirm(
                      booking.id,
                    );
                    if (err == null && context.mounted) {
                      showSuccessSnackBar(
                        context,
                        'booking.confirm_success'.tr(),
                      );
                    }
                  },
          ),
        ),
      );
    }

    if (isBuyer && booking.canCheckout) {
      actions.add(
        Expanded(
          child: CustomButton(
            text: 'booking.checkout'.tr(),
            isLoading: isSubmitting,
            onPressed: isSubmitting ? null : () => _checkout(context),
          ),
        ),
      );
    }

    if (booking.canCancel && (isBuyer || isSupplier)) {
      if (actions.isNotEmpty) actions.add(SizedBox(width: AppSpacing.sm));
      actions.add(
        Expanded(
          child: OutlinedButton(
            onPressed: isSubmitting ? null : () => _cancel(context),
            style: OutlinedButton.styleFrom(minimumSize: Size(0, 48.h)),
            child: Text('booking.cancel'.tr()),
          ),
        ),
      );
    }

    if (actions.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        0,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.grey100)),
      ),
      child: SafeArea(top: false, child: Row(children: actions)),
    );
  }
}
