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

class PublicTrackPage extends StatefulWidget {
  final String? orderNumber;

  const PublicTrackPage({super.key, this.orderNumber});

  @override
  State<PublicTrackPage> createState() => _PublicTrackPageState();
}

class _PublicTrackPageState extends State<PublicTrackPage> {
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
      final data = await _api.trackShipment(no);
      if (!mounted) return;
      setState(() {
        _result = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'public.track_not_found'.tr();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: 'public.track_title'.tr(),
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
                hintText: 'public.track_order_hint'.tr(),
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
                  : Text('public.track_button'.tr()),
            ),
            if (_error != null) ...[
              SizedBox(height: AppSpacing.md),
              Text(_error!, style: TextStyle(color: AppColors.error, fontSize: 13.sp)),
            ],
            if (_result != null) ...[
              SizedBox(height: AppSpacing.lg),
              _infoCard(_result!),
              SizedBox(height: AppSpacing.md12),
              OutlinedButton.icon(
                onPressed: () {
                  final no = _result!['orderNumber']?.toString() ?? _controller.text;
                  context.push('/verify/${Uri.encodeComponent(no)}');
                },
                icon: Icon(LucideIcons.fileCheck, size: 18.sp),
                label: Text('public.track_verify_contract'.tr()),
              ),
              SizedBox(height: AppSpacing.sm),
              TextButton.icon(
                onPressed: () async {
                  final no = _result!['orderNumber']?.toString() ?? _controller.text;
                  final uri = Uri.parse(ContractVerifyUrl.track(no));
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
    final shipment = data['shipment'] as Map<String, dynamic>?;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row('public.track_label_order_number'.tr(), data['orderNumber']?.toString() ?? '—'),
          _row('public.track_label_order_status'.tr(), data['status']?.toString() ?? '—'),
          _row('public.track_label_supplier'.tr(), seller?['fullName']?.toString() ?? '—'),
          if (shipment == null)
            Padding(
              padding: EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                'public.track_no_shipment'.tr(),
                style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
              ),
            )
          else ...[
            SizedBox(height: AppSpacing.sm),
            Text(
              'public.track_section_shipment'.tr(),
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800),
            ),
            if (shipment['deliveryStatus'] != null)
              _row('public.track_label_delivery_status'.tr(), shipment['deliveryStatus'].toString()),
            if (shipment['awbNumber'] != null)
              _row('public.track_label_awb'.tr(), shipment['awbNumber'].toString()),
            if (shipment['courier'] != null)
              _row('public.track_label_courier'.tr(), shipment['courier'].toString()),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
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
            child: Text(
              value,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
