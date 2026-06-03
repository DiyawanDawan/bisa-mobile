import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';

class SupplierVerificationPage extends StatefulWidget {
  const SupplierVerificationPage({super.key});

  @override
  State<SupplierVerificationPage> createState() => _SupplierVerificationPageState();
}

class _SupplierVerificationPageState extends State<SupplierVerificationPage> {
  String? _ktpPath;
  String? _nibPath;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(String type) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (type == 'KTP') _ktpPath = image.path;
        if (type == 'NIB') _nibPath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BisaAppBar(title: 'Verifikasi Supplier'),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            success: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: AppColors.success),
              );
              Navigator.pop(context);
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: AppColors.error),
              );
            },
            orElse: () {},
          );
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lengkapi Dokumen',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 8.h),
              Text(
                'Unggah dokumen legalitas untuk mendapatkan badge "Verified" dan meningkatkan kepercayaan pembeli.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
              ),
              SizedBox(height: 32.h),
              _buildUploadCard(
                title: 'Foto KTP / Identitas',
                path: _ktpPath,
                onTap: () => _pickImage('KTP'),
              ),
              SizedBox(height: 20.h),
              _buildUploadCard(
                title: 'Nomor Induk Berusaha (NIB)',
                path: _nibPath,
                onTap: () => _pickImage('NIB'),
              ),
              SizedBox(height: 48.h),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
                  return SizedBox(
                    width: double.infinity,
                    height: 54.h,
                    child: ElevatedButton(
                      onPressed: isLoading || _ktpPath == null || _nibPath == null
                          ? null
                          : () {
                              context.read<AuthCubit>().submitVerification(
                                    ktpPath: _ktpPath,
                                    nibPath: _nibPath,
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Kirim Verifikasi',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16.sp,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadCard({required String title, String? path, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 160.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.grey200, style: BorderStyle.solid),
            ),
            child: path != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Image.file(File(path), fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.imagePlus, color: AppColors.grey400, size: 32.sp),
                      SizedBox(height: 12.h),
                      Text('Pilih Foto', style: TextStyle(color: AppColors.grey400, fontSize: 12.sp)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
