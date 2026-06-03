import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/core.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../bloc/profile_cubit.dart';
import '../../../../injection_container.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  String? _ktpPath;
  String? _nibPath;
  String? _selfiePath;
  String? _siupPath;

  final _picker = ImagePicker();

  Future<void> _pickImage(String type) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        switch (type) {
          case 'ktp':
            _ktpPath = image.path;
            break;
          case 'nib':
            _nibPath = image.path;
            break;
          case 'selfie':
            _selfiePath = image.path;
            break;
          case 'siup':
            _siupPath = image.path;
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const BisaAppBar(
          backgroundColor: AppColors.surface,
          title: 'Verifikasi Akun',
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            state.maybeWhen(
              loaded: (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('dokumen_verifikasi_berhasil_di'.tr()),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pop(context);
              },
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            final canSubmit = _ktpPath != null && _selfiePath != null;
            final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoCard(),
                        SizedBox(height: 16.h),
                        _buildUploadSection('KTP (Wajib)', 'ktp', _ktpPath),
                        _buildUploadSection(
                          'Selfie dengan KTP (Wajib)',
                          'selfie',
                          _selfiePath,
                        ),
                        _buildUploadSection('NIB (Opsional)', 'nib', _nibPath),
                        _buildUploadSection('SIUP (Opsional)', 'siup', _siupPath),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                    child: CustomButton(
                      text: 'Kirim Dokumen',
                      height: 50.h,
                      isLoading: isLoading,
                      onPressed: canSubmit && !isLoading ? _submit : null,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.info, color: AppColors.info, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Verifikasi akun diperlukan untuk meningkatkan limit transaksi dan mendapatkan badge Terpercaya.',
              style: TextStyle(fontSize: 12.sp, color: AppColors.textPrimary, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection(String title, String type, String? path) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          InkWell(
            onTap: () => _pickImage(type),
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              width: double.infinity,
              height: 96.h,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.grey200),
              ),
              child: path != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.file(
                            File(path),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 8.w,
                          top: 8.h,
                          child: CircleAvatar(
                            radius: 14.r,
                            backgroundColor: Colors.black.withValues(alpha: 0.5),
                            child: Icon(
                              LucideIcons.pencil,
                              size: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.upload,
                          size: 28.sp,
                          color: AppColors.grey400,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Pilih Gambar',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
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

  void _submit() {
    context.read<ProfileCubit>().submitVerification(
      ktpPath: _ktpPath,
      nibPath: _nibPath,
      selfiePath: _selfiePath,
      siupPath: _siupPath,
    );
  }
}
