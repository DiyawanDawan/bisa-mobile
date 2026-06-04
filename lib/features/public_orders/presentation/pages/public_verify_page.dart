import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/contract_verify_url.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../data/public_order_api.dart';

class PublicVerifyPage extends StatefulWidget {
  final String? orderNumber;

  const PublicVerifyPage({super.key, this.orderNumber});

  @override
  State<PublicVerifyPage> createState() => _PublicVerifyPageState();
}

class _PublicVerifyPageState extends State<PublicVerifyPage> {
  final _api = PublicOrderApi();
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;
  Map<String, dynamic>? _result;

  @override
  void initState() {
    super.initState();
    final initial = widget.orderNumber?.trim();
    if (initial != null && initial.isNotEmpty) {
      _controller.text = ContractVerifyUrl.parseOrderNumber(initial);
      _load(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load(String orderNumber) async {
    final no = orderNumber.trim();
    if (no.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });
    try {
      final data = await _api.verifyContract(no);
      if (!mounted) return;
      setState(() {
        _result = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Kontrak tidak ditemukan atau nomor tidak valid.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BisaAppBar(
        title: 'Verifikasi Kontrak',
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Nomor pesanan / kontrak',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: _loading ? null : () => _load(_controller.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: _loading
                  ? SizedBox(
                      width: 22.w,
                      height: 22.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Verifikasi'),
            ),
            if (_error != null) ...[
              SizedBox(height: 16.h),
              Text(_error!, style: TextStyle(color: Colors.red.shade700, fontSize: 13.sp)),
            ],
            if (_result != null) ...[
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.badgeCheck, color: AppColors.primary, size: 28.sp),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'Terverifikasi oleh BISA B2B',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14.sp,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              _infoCard(_result!),
              SizedBox(height: 12.h),
              OutlinedButton.icon(
                onPressed: () {
                  final no = _result!['orderNumber']?.toString() ?? _controller.text;
                  context.push('/track/${Uri.encodeComponent(no)}');
                },
                icon: Icon(LucideIcons.truck, size: 18.sp),
                label: const Text('Lacak pengiriman'),
              ),
              SizedBox(height: 8.h),
              TextButton.icon(
                onPressed: () async {
                  final no = _result!['orderNumber']?.toString() ?? _controller.text;
                  final uri = Uri.parse(ContractVerifyUrl.verify(no));
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                icon: Icon(LucideIcons.externalLink, size: 16.sp),
                label: const Text('Buka di browser'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoCard(Map<String, dynamic> data) {
    final seller = data['seller'] as Map<String, dynamic>?;
    final items = data['items'] as List<dynamic>?;
    final firstProduct = items != null && items.isNotEmpty
        ? (items.first as Map)['product'] as Map<String, dynamic>?
        : null;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row('Nomor kontrak', data['orderNumber']?.toString() ?? '—'),
          _row('Status', data['status']?.toString() ?? '—'),
          _row('Supplier', seller?['fullName']?.toString() ?? '—'),
          if (firstProduct != null)
            _row('Produk', firstProduct['name']?.toString() ?? '—'),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
          Text(value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
