import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_layout.dart';
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
        _error = 'public.verify_not_found'.tr();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: 'public.verify_title'.tr(),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'public.verify_hint'.tr(),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md12),
            ElevatedButton(
              onPressed: _loading ? null : () => _load(_controller.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
              ),
              child: _loading
                  ? SizedBox(
                      width: 22.w,
                      height: 22.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.surface,
                      ),
                    )
                  : Text('public.verify_button'.tr()),
            ),
            if (_error != null) ...[
              SizedBox(height: AppSpacing.md),
              Text(_error!, style: TextStyle(color: AppColors.error, fontSize: 13.sp)),
            ],
            if (_result != null) ...[
              SizedBox(height: AppSpacing.lg),
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.badgeCheck, color: AppColors.primary, size: 28.sp),
                    SizedBox(width: AppSpacing.md12),
                    Expanded(
                      child: Text(
                        'public.verify_badge'.tr(),
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
              SizedBox(height: AppSpacing.md12),
              _infoCard(_result!),
              SizedBox(height: AppSpacing.md12),
              OutlinedButton.icon(
                onPressed: () {
                  final no = _result!['orderNumber']?.toString() ?? _controller.text;
                  context.push('/track/${Uri.encodeComponent(no)}');
                },
                icon: Icon(LucideIcons.truck, size: 18.sp),
                label: Text('public.verify_track_shipment'.tr()),
              ),
              SizedBox(height: AppSpacing.sm),
              TextButton.icon(
                onPressed: () async {
                  final no = _result!['orderNumber']?.toString() ?? _controller.text;
                  final uri = Uri.parse(ContractVerifyUrl.verify(no));
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                icon: Icon(LucideIcons.externalLink, size: 16.sp),
                label: Text('public.track_open_browser'.tr()),
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
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row('public.verify_label_contract_number'.tr(), data['orderNumber']?.toString() ?? '—'),
          _row('public.verify_label_status'.tr(), data['status']?.toString() ?? '—'),
          _row('public.verify_label_supplier'.tr(), seller?['fullName']?.toString() ?? '—'),
          if (firstProduct != null)
            _row('public.verify_label_product'.tr(), firstProduct['name']?.toString() ?? '—'),
          _row(
            'public.verify_label_digital_sign'.tr(),
            data['isDigitalSigned'] == true
                ? 'public.verify_signed'.tr()
                : 'public.verify_unsigned'.tr(),
          ),
          if (data['buyerSignedAt'] != null)
            _row('public.verify_signed_buyer'.tr(), _formatSignDate(data['buyerSignedAt'])),
          if (data['sellerSignedAt'] != null)
            _row('public.verify_signed_seller'.tr(), _formatSignDate(data['sellerSignedAt'])),
        ],
      ),
    );
  }

  String _formatSignDate(dynamic raw) {
    if (raw == null) return '—';
    final parsed = DateTime.tryParse(raw.toString());
    if (parsed == null) return raw.toString();
    return DateFormat.yMMMd().add_jm().format(parsed.toLocal());
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm10),
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
