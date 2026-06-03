import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../core/constants/app_colors.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BisaAppBar(
        title: 'Pusat Bantuan',
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContactCard(),
            SizedBox(height: 24.h),
            Text('Pertanyaan Populer (FAQ)', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.h),
            _buildFaqItem('Bagaimana cara menjual produk biomassa?', 'Anda dapat mendaftar sebagai Supplier dan mengunggah dokumen verifikasi akun...'),
            _buildFaqItem('Apakah transaksi di BISA aman?', 'Ya, kami menggunakan sistem Escrow (Rekening Bersama) untuk menjamin keamanan transaksi...'),
            _buildFaqItem('Berapa lama proses verifikasi akun?', 'Proses verifikasi biasanya memakan waktu 1-3 hari kerja setelah dokumen dikirim...'),
            _buildFaqItem('Bagaimana cara tarik saldo penghasilan?', 'Supplier dapat melakukan penarikan saldo melalui menu Dompet ke rekening bank yang terdaftar...'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(LucideIcons.headset, color: Colors.white, size: 32.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Butuh Bantuan Lebih Lanjut?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp)),
                    Text('tim_kami_siap_membantu_anda_24'.tr(), style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12.sp)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              minimumSize: Size(double.infinity, 44.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            child: Text('hubungi_cs_via_whatsapp'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
      child: ExpansionTile(
        title: Text(question, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: Text(answer, style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary, height: 1.5)),
          ),
        ],
      ),
    );
  }
}
