import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/payment_expiry_utils.dart';

/// Banner hitung mundur pembayaran atau peringatan kedaluwarsa.
class PaymentExpiryBanner extends StatefulWidget {
  const PaymentExpiryBanner({
    super.key,
    this.pendingPayment,
    this.orderCreatedAt,
    this.paymentStatus,
    this.compact = false,
  });

  final Map<String, dynamic>? pendingPayment;
  final DateTime? orderCreatedAt;
  final String? paymentStatus;
  final bool compact;

  @override
  State<PaymentExpiryBanner> createState() => _PaymentExpiryBannerState();
}

class _PaymentExpiryBannerState extends State<PaymentExpiryBanner> {
  Timer? _timer;
  late DateTime? _expiresAt;
  late bool _expired;

  @override
  void initState() {
    super.initState();
    _syncState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _syncState());
  }

  @override
  void didUpdateWidget(covariant PaymentExpiryBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pendingPayment != widget.pendingPayment ||
        oldWidget.orderCreatedAt != widget.orderCreatedAt ||
        oldWidget.paymentStatus != widget.paymentStatus) {
      _syncState();
    }
  }

  void _syncState() {
    final expiresAt = resolvePaymentExpiresAt(
      pendingPayment: widget.pendingPayment,
      orderCreatedAt: widget.orderCreatedAt,
    );
    final expired = isPaymentExpired(
      expiresAt: expiresAt,
      paymentStatus: widget.paymentStatus,
    );
    if (!mounted) return;
    setState(() {
      _expiresAt = expiresAt;
      _expired = expired;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final payStatus = widget.paymentStatus?.toUpperCase() ?? '';
    final isPendingPayment = payStatus.isEmpty || payStatus == 'PENDING';

    if (!isPendingPayment && !_expired) return const SizedBox.shrink();
    if (_expiresAt == null && !_expired) return const SizedBox.shrink();

    if (_expired) {
      return _ExpiredBanner(compact: widget.compact);
    }

    final remaining = remainingUntilPaymentExpiry(_expiresAt);
    if (remaining == null) return const SizedBox.shrink();

    return _CountdownBanner(
      remaining: remaining,
      expiresAt: _expiresAt!,
      compact: widget.compact,
    );
  }
}

class _ExpiredBanner extends StatelessWidget {
  const _ExpiredBanner({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.error;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10.w : 12.w,
        vertical: compact ? 8.h : 12.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(compact ? 10.r : 12.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.circleX, size: compact ? 16.sp : 20.sp, color: color),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'orders.payment_expired_title'.tr(),
                  style: TextStyle(
                    fontSize: compact ? 12.sp : 14.sp,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
                SizedBox(height: compact ? 2.h : 4.h),
                Text(
                  'orders.payment_expired_body'.tr(),
                  style: TextStyle(
                    fontSize: compact ? 10.sp : 11.sp,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownBanner extends StatelessWidget {
  const _CountdownBanner({
    required this.remaining,
    required this.expiresAt,
    required this.compact,
  });

  final Duration remaining;
  final DateTime expiresAt;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = remaining.inMinutes < 30
        ? AppColors.error
        : AppColors.warning;
    final countdown = formatPaymentCountdown(remaining);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10.w : 12.w,
        vertical: compact ? 8.h : 12.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(compact ? 10.r : 12.r),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.timer, size: compact ? 16.sp : 20.sp, color: color),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'orders.payment_countdown_prefix'.tr(),
                  style: TextStyle(
                    fontSize: compact ? 10.sp : 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  countdown,
                  style: TextStyle(
                    fontSize: compact ? 18.sp : 22.sp,
                    fontWeight: FontWeight.w900,
                    color: color,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'orders.payment_valid_until'.tr(namedArgs: {
                    'datetime': formatPaymentExpiryDateTime(expiresAt),
                  }),
                  style: TextStyle(
                    fontSize: compact ? 9.sp : 10.sp,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
