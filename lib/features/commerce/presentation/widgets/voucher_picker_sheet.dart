import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/network/api_client.dart';
import '../../../../injection_container.dart';

class VoucherItem {
  final String id;
  final String code;
  final String type; // PERCENTAGE | FIXED
  final double value;
  final double? minOrderAmount;
  final double? maxDiscount;
  final DateTime? expiresAt;

  const VoucherItem({
    required this.id,
    required this.code,
    required this.type,
    required this.value,
    this.minOrderAmount,
    this.maxDiscount,
    this.expiresAt,
  });

  factory VoucherItem.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val);
      return null;
    }

    return VoucherItem(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      type: json['type'] as String? ?? 'FIXED',
      value: parseDouble(json['value']) ?? 0,
      minOrderAmount: parseDouble(json['minOrderAmount']),
      maxDiscount: parseDouble(json['maxDiscount']),
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'].toString())
          : null,
    );
  }

  String get discountLabel {
    if (type == 'PERCENTAGE' || type == 'PERCENT') {
      final pct = value.toStringAsFixed(0);
      if (maxDiscount != null && maxDiscount! > 0) {
        return 'Diskon $pct% (maks. ${_formatIdr(maxDiscount!)})';
      }
      return 'Diskon $pct%';
    }
    return 'Diskon ${_formatIdr(value)}';
  }

  String _formatIdr(double v) {
    final n = v.toInt();
    final s = n.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (m) => '.',
        );
    return 'Rp $s';
  }
}

/// Bottom Sheet untuk browse & pilih voucher tersedia.
/// Panggil via [VoucherPickerSheet.show].
class VoucherPickerSheet extends StatefulWidget {
  const VoucherPickerSheet({super.key});

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const VoucherPickerSheet(),
    );
  }

  @override
  State<VoucherPickerSheet> createState() => _VoucherPickerSheetState();
}

class _VoucherPickerSheetState extends State<VoucherPickerSheet> {
  List<VoucherItem> _vouchers = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final dio = sl<ApiClient>().dio;
      final resp = await dio.get('/commerce/vouchers/available');
      final list = (resp.data['data'] as List<dynamic>? ?? [])
          .map((e) => VoucherItem.fromJson(e as Map<String, dynamic>))
          .toList();
      if (mounted) setState(() => _vouchers = list);
    } catch (e) {
      if (mounted) setState(() => _error = 'Gagal memuat voucher.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _formatExpiry(DateTime? dt) {
    if (dt == null) return 'Tidak ada batas waktu';
    final df = DateFormat('d MMM yyyy', 'id');
    return 'Berlaku hingga ${df.format(dt)}';
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.textHint.withAlpha(80),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.ticket, size: 18.sp, color: AppColors.primary),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      'Pilih Voucher',
                      style: AppTextStyles.sectionTitle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(LucideIcons.x, size: 18.sp),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: AppColors.grey100),
              // Body
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.circleX,
                                    size: 36.sp, color: AppColors.error),
                                SizedBox(height: AppSpacing.sm),
                                Text(_error!,
                                    style: AppTextStyles.body(
                                      color: AppColors.textHint,
                                    )),
                                SizedBox(height: AppSpacing.sm),
                                TextButton.icon(
                                  onPressed: _load,
                                  icon: Icon(LucideIcons.refreshCw, size: 14.sp),
                                  label: const Text('Coba lagi'),
                                ),
                              ],
                            ),
                          )
                        : _vouchers.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(LucideIcons.ticketX,
                                        size: 40.sp, color: AppColors.textHint),
                                    SizedBox(height: AppSpacing.sm),
                                    Text(
                                      'Tidak ada voucher tersedia',
                                      style: AppTextStyles.body(
                                        color: AppColors.textHint,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                controller: scrollController,
                                padding: EdgeInsets.all(AppSpacing.md),
                                itemCount: _vouchers.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: AppSpacing.sm),
                                itemBuilder: (_, i) {
                                  final v = _vouchers[i];
                                  return _VoucherCard(
                                    voucher: v,
                                    expiryLabel: _formatExpiry(v.expiresAt),
                                    onTap: () => Navigator.pop(context, v.code),
                                  );
                                },
                              ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _VoucherCard extends StatelessWidget {
  final VoucherItem voucher;
  final String expiryLabel;
  final VoidCallback onTap;

  const _VoucherCard({
    required this.voucher,
    required this.expiryLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.primary.withAlpha(60)),
          color: AppColors.primary.withAlpha(8),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(LucideIcons.tag, size: 20.sp, color: AppColors.primary),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    voucher.code,
                    style: AppTextStyles.sectionTitle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    voucher.discountLabel,
                    style: AppTextStyles.bodySm(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (voucher.minOrderAmount != null && voucher.minOrderAmount! > 0)
                    Text(
                      'Min. belanja ${voucher._formatIdr(voucher.minOrderAmount!)}',
                      style: AppTextStyles.caption(
                        color: AppColors.textHint,
                      ),
                    ),
                  Text(
                    expiryLabel,
                    style: AppTextStyles.caption(
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, size: 16.sp, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
