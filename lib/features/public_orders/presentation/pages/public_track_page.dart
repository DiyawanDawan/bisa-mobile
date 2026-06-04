import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
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
        _error = 'Pesanan tidak ditemukan.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BisaAppBar(
        title: 'Lacak Pengiriman',
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
                hintText: 'Nomor pesanan',
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
                  : const Text('Lacak'),
            ),
            if (_error != null) ...[
              SizedBox(height: 16.h),
              Text(_error!, style: TextStyle(color: Colors.red.shade700, fontSize: 13.sp)),
            ],
            if (_result != null) ...[
              SizedBox(height: 20.h),
              _infoCard(_result!),
              SizedBox(height: 12.h),
              OutlinedButton.icon(
                onPressed: () {
                  final no = _result!['orderNumber']?.toString() ?? _controller.text;
                  context.push('/verify/${Uri.encodeComponent(no)}');
                },
                icon: Icon(LucideIcons.fileCheck, size: 18.sp),
                label: const Text('Verifikasi kontrak'),
              ),
              SizedBox(height: 8.h),
              TextButton.icon(
                onPressed: () async {
                  final no = _result!['orderNumber']?.toString() ?? _controller.text;
                  final uri = Uri.parse(ContractVerifyUrl.track(no));
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
    final shipment = data['shipment'] as Map<String, dynamic>?;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row('Nomor pesanan', data['orderNumber']?.toString() ?? '—'),
          _row('Status pesanan', data['status']?.toString() ?? '—'),
          _row('Supplier', seller?['fullName']?.toString() ?? '—'),
          if (shipment == null)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                'Belum ada data pengiriman.',
                style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
              ),
            )
          else ...[
            SizedBox(height: 8.h),
            Text(
              'Pengiriman',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800),
            ),
            if (shipment['deliveryStatus'] != null)
              _row('Status delivery', shipment['deliveryStatus'].toString()),
            if (shipment['awbNumber'] != null)
              _row('No. resi', shipment['awbNumber'].toString()),
            if (shipment['courierCode'] != null)
              _row('Kurir', shipment['courierCode'].toString()),
            if (shipment['originHub'] != null)
              _row('Asal hub', shipment['originHub'].toString()),
            if (shipment['destinationHub'] != null)
              _row('Tujuan hub', shipment['destinationHub'].toString()),
            if (shipment['vesselName'] != null)
              _row('Armada', shipment['vesselName'].toString()),
            if (shipment['aiInsight'] != null)
              _row('Insight', shipment['aiInsight'].toString()),
          ],
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
