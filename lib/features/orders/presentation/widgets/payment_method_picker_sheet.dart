import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/network/api_client.dart';
import 'package:mobile_bisa/injection_container.dart';

/// Hasil pemilihan channel dari bottom sheet (belum inisialisasi pembayaran).
class PaymentMethodChoice {
  final String code;
  final String name;

  const PaymentMethodChoice({required this.code, required this.name});
}

/// Bottom sheet pemilih metode pembayaran.
///
/// Fetch `/payments/channels` (DB-driven, sama dengan yang dipakai
/// `IotSubscriptionPage`) lalu menampilkan daftar VA, QRIS, E-Wallet, dll.
/// Hasil yang di-return adalah **channel code** (mis. `BCA`, `OVO`, `QRIS`).
///
/// Ini menggantikan flow lama yang langsung memanggil `initializePayment(id, '')`
/// — karena tanpa `channelCode`, backend jatuh ke Invoice (Hosted Checkout)
/// dan memerlukan permission Xendit "Invoices: Write" yang belum tentu
/// diaktifkan. Dengan picker ini, kita selalu pakai PaymentRequest V3
/// yang mengembalikan data instan (VA number / QR string / redirect URL).
class PaymentMethodPickerSheet extends StatefulWidget {
  final num amount;
  final String? initialCode;

  const PaymentMethodPickerSheet({
    super.key,
    required this.amount,
    this.initialCode,
  });

  static Future<PaymentMethodChoice?> show(
    BuildContext context, {
    required num amount,
    String? initialCode,
  }) {
    return showModalBottomSheet<PaymentMethodChoice>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => PaymentMethodPickerSheet(
        amount: amount,
        initialCode: initialCode,
      ),
    );
  }

  @override
  State<PaymentMethodPickerSheet> createState() => _PaymentMethodPickerSheetState();
}

class _PaymentMethodPickerSheetState extends State<PaymentMethodPickerSheet> {
  List<Map<String, dynamic>> _channels = [];
  bool _loading = true;
  String? _error;
  String? _selectedCode;

  @override
  void initState() {
    super.initState();
    _selectedCode = widget.initialCode;
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await sl<ApiClient>().dio.get('/payments/channels');
      final raw = res.data['data'] as List? ?? [];
      final list = raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .where((e) => (e['isActive'] ?? true) == true)
          .toList();
      if (!mounted) return;
      setState(() {
        _channels = list;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Gagal memuat metode pembayaran.';
      });
    }
  }

  IconData _iconFor(String? group) {
    switch (group?.toUpperCase()) {
      case 'E_WALLET':
        return LucideIcons.wallet;
      case 'QRIS':
        return LucideIcons.qrCode;
      case 'BANK_TRANSFER':
      case 'VIRTUAL_ACCOUNT':
        return LucideIcons.landmark;
      case 'CREDIT_CARD':
        return LucideIcons.creditCard;
      case 'OVER_THE_COUNTER':
        return LucideIcons.store;
      default:
        return LucideIcons.creditCard;
    }
  }

  String _labelFor(String? group) {
    switch (group?.toUpperCase()) {
      case 'E_WALLET':
        return 'E-Wallet';
      case 'QRIS':
        return 'QRIS';
      case 'BANK_TRANSFER':
      case 'VIRTUAL_ACCOUNT':
        return 'Transfer Bank (VA)';
      case 'CREDIT_CARD':
        return 'Kartu Kredit';
      case 'OVER_THE_COUNTER':
        return 'Minimarket';
      default:
        return group ?? 'Pembayaran';
    }
  }

  /// Group channels by `group` field untuk section header rapi.
  Map<String, List<Map<String, dynamic>>> _grouped() {
    final map = <String, List<Map<String, dynamic>>>{};
    for (final c in _channels) {
      final g = (c['group']?.toString() ?? 'OTHER').toUpperCase();
      map.putIfAbsent(g, () => []).add(c);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) {
          return Column(
            children: [
              SizedBox(height: 10.h),
              Container(
                width: 42.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 10.h),
                child: Row(
                  children: [
                    Icon(LucideIcons.wallet, color: AppColors.primary, size: 22.sp),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pilih Metode Pembayaran',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Total: Rp ${_formatAmount(widget.amount)}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(LucideIcons.x),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: AppColors.grey100),
              Expanded(child: _buildBody(controller)),
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: _selectedCode == null
                          ? null
                          : () {
                              final code = _selectedCode!;
                              final channel = _channels.cast<Map<String, dynamic>?>().firstWhere(
                                    (c) => c?['code']?.toString() == code,
                                    orElse: () => null,
                                  );
                              final name =
                                  channel?['name']?.toString() ?? code;
                              Navigator.pop(
                                context,
                                PaymentMethodChoice(code: code, name: name),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.grey200,
                        disabledForegroundColor: AppColors.grey400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        _selectedCode == null
                            ? 'Pilih metode dulu'
                            : 'Gunakan $_selectedCode',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(ScrollController controller) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (_error != null) {
      return Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.circleAlert, size: 36.sp, color: AppColors.error),
            SizedBox(height: 12.h),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
            ),
            SizedBox(height: 16.h),
            TextButton(onPressed: _fetch, child: const Text('Coba Lagi')),
          ],
        ),
      );
    }
    if (_channels.isEmpty) {
      return Center(
        child: Text(
          'Belum ada metode pembayaran aktif.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
        ),
      );
    }

    final grouped = _grouped();
    final groupKeys = grouped.keys.toList()
      ..sort((a, b) {
        const order = ['QRIS', 'E_WALLET', 'VIRTUAL_ACCOUNT', 'BANK_TRANSFER', 'OVER_THE_COUNTER', 'CREDIT_CARD'];
        final ai = order.indexOf(a);
        final bi = order.indexOf(b);
        return (ai == -1 ? 99 : ai).compareTo(bi == -1 ? 99 : bi);
      });

    return ListView(
      controller: controller,
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
      children: [
        for (final g in groupKeys) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 6.h, 0, 8.h),
            child: Text(
              _labelFor(g),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
                letterSpacing: 0.4,
              ),
            ),
          ),
          ...grouped[g]!.map((c) => _channelTile(c, g)),
          SizedBox(height: 14.h),
        ],
      ],
    );
  }

  Widget _channelTile(Map<String, dynamic> channel, String group) {
    final code = channel['code']?.toString() ?? '';
    final name = channel['name']?.toString() ?? code;
    final isSel = _selectedCode == code;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: isSel ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isSel ? AppColors.primary : AppColors.grey200,
          width: isSel ? 1.6 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () {
          setState(() {
            _selectedCode = code;
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(_iconFor(group), size: 18.sp, color: AppColors.primary),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      code,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSel)
                Icon(LucideIcons.circleCheck, color: AppColors.primary, size: 20.sp)
              else
                Container(
                  width: 18.w,
                  height: 18.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.grey300, width: 1.5),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatAmount(num n) {
    final s = n.toStringAsFixed(0);
    final reversed = s.split('').reversed.toList();
    final chunks = <String>[];
    for (var i = 0; i < reversed.length; i += 3) {
      chunks.add(reversed.skip(i).take(3).join());
    }
    return chunks.join('.').split('').reversed.join();
  }
}
