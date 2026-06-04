import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../public_orders/data/public_order_api.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final _api = PublicOrderApi();
  bool _loading = true;
  String? _whatsapp;
  List<Map<String, dynamic>> _faqs = [];
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
      final support = await _api.fetchSupportSettings();
      final faqs = await _api.fetchFaqs();
      if (!mounted) return;
      setState(() {
        _whatsapp = support['supportWhatsapp']?.toString();
        _faqs = faqs;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Gagal memuat FAQ. Menampilkan pertanyaan default.';
        _faqs = _fallbackFaqs;
        _loading = false;
      });
    }
  }

  static const _fallbackFaqs = [
    {
      'question': 'Bagaimana cara menjual produk biomassa?',
      'answer':
          'Daftar sebagai Supplier dan lengkapi verifikasi akun di menu Profil.',
    },
    {
      'question': 'Apakah transaksi di BISA aman?',
      'answer': 'Ya, kami menggunakan sistem escrow untuk menjamin keamanan transaksi.',
    },
  ];

  Future<void> _openWhatsApp() async {
    final raw = (_whatsapp ?? '6281234567890').replaceAll(RegExp(r'\D'), '');
    final phone = raw.startsWith('0') ? '62${raw.substring(1)}' : raw;
    final uri = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BisaAppBar(
        title: 'Pusat Bantuan',
        backgroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _load,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildContactCard(),
                    SizedBox(height: 24.h),
                    Text(
                      'Pertanyaan Populer (FAQ)',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    if (_error != null) ...[
                      SizedBox(height: 8.h),
                      Text(_error!, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                    ],
                    SizedBox(height: 16.h),
                    if (_faqs.isEmpty)
                      Text(
                        'Belum ada FAQ. Hubungi tim CS.',
                        style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
                      )
                    else
                      ..._faqs.map(
                        (f) => _buildFaqItem(
                          f['question']?.toString() ?? '',
                          f['answer']?.toString() ?? '',
                        ),
                      ),
                  ],
                ),
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
                    Text(
                      'Butuh Bantuan Lebih Lanjut?',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      'tim_kami_siap_membantu_anda_24'.tr(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: _openWhatsApp,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              minimumSize: Size(double.infinity, 44.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            child: Text(
              'hubungi_cs_via_whatsapp'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
