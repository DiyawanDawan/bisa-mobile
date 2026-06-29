import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';

class IotQrScanPage extends StatefulWidget {
  const IotQrScanPage({super.key});

  @override
  State<IotQrScanPage> createState() => _IotQrScanPageState();
}

class _IotQrScanPageState extends State<IotQrScanPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _handled = false;

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final barcode = capture.barcodes.firstOrNull;
    final value = barcode?.rawValue?.trim();
    if (value == null || value.isEmpty) return;
    _handled = true;
    Navigator.pop(context, value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: BisaAppBar(
        title: 'iot.scan_device_title'.tr(),
        backgroundColor: AppColors.black,
        showShadow: false,
        iconColor: AppColors.white,
        titleColor: AppColors.white,
        backButtonBackgroundColor: AppColors.white.withValues(alpha: 0.15),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          Center(
            child: Container(
              width: 220.w,
              height: 220.w,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
            ),
          ),
          Positioned(
            bottom: 40.h + MediaQuery.paddingOf(context).bottom,
            left: 24.w,
            right: 24.w,
            child: Container(
              padding: EdgeInsets.all(AppSpacing.section),
              decoration: BoxDecoration(
                color: AppColors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.qrCode, color: AppColors.textOnPrimary, size: 20.sp),
                  SizedBox(width: AppSpacing.sm10),
                  Expanded(
                    child: Text(
                      'iot.scan_qr_hint'.tr(),
                      style: TextStyle(color: AppColors.textOnPrimary, fontSize: 12.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
