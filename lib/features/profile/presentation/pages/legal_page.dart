import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Halaman legal — konten diambil dari API `/policies/:key`.
class LegalPage extends StatefulWidget {
  /// `terms` atau `privacy`
  final String policyKey;
  final String fallbackTitle;

  const LegalPage({
    super.key,
    required this.policyKey,
    required this.fallbackTitle,
  });

  @override
  State<LegalPage> createState() => _LegalPageState();
}

class _LegalPageState extends State<LegalPage> {
  String? _title;
  String? _content;
  String? _version;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPolicy();
  }

  Future<void> _fetchPolicy() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response =
          await sl<ApiClient>().dio.get('/policies/${widget.policyKey}');
      final data = response.data['data'] as Map<String, dynamic>?;

      if (!mounted) return;
      setState(() {
        _title = data?['title'] as String? ?? widget.fallbackTitle;
        _content = data?['content'] as String? ?? '';
        _version = data?['version'] as String?;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Gagal memuat dokumen. Periksa koneksi Anda.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = _title ?? widget.fallbackTitle;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        backgroundColor: AppColors.white,
        title: displayTitle,
      ),
      body: _buildBody(displayTitle),
    );
  }

  Widget _buildBody(String displayTitle) {
    if (_isLoading) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: ShimmerLoading(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bone(width: 200.w, height: 20.h),
              SizedBox(height: 16.h),
              const Bone.multiText(lines: 12),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.circleAlert, size: 48.sp, color: AppColors.error),
              SizedBox(height: 12.h),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 20.h),
              CustomButton(
                text: 'Coba Lagi',
                width: 160.w,
                onPressed: _fetchPolicy,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: AppColors.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_version != null) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Versi $_version',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
            Text(
              _content ?? '',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary,
                height: 1.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
