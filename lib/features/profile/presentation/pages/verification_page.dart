import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/core.dart';
import '../../../../core/utils/text_recognition_util.dart';
import '../../../../core/utils/face_detector_util.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../../injection_container.dart';
import '../widgets/verification_photo_guide.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AuthCubit>().checkAuth();
    });
  }

  String? _ktpPath;
  String? _nibPath;
  String? _selfiePath;
  String? _siupPath;

  final _businessNameCtrl = TextEditingController();
  final _taxIdCtrl = TextEditingController();
  final _businessAddressCtrl = TextEditingController();

  bool _isSubmitting = false;
  String? _uploadStatus;
  bool _scanningDocument = false;

  final _picker = ImagePicker();

  @override
  void dispose() {
    _businessNameCtrl.dispose();
    _taxIdCtrl.dispose();
    _businessAddressCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String type) async {
    final source = await _showImageSourceSheet();
    if (source == null) return;

    String? pickedPath;

    if (source == ImageSource.camera && type != 'selfie') {
      try {
        final pictures = await CunningDocumentScanner.getPictures();
        if (pictures != null && pictures.isNotEmpty) {
          pickedPath = pictures.first;
        } else {
          // User cancelled the document scanner
          return;
        }
      } catch (e) {
        debugPrint('Document scanner failed: $e');
        // Fallback to normal camera on error
      }
    }

    if (pickedPath == null) {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 2048,
      );
      if (image == null) return;
      pickedPath = image.path;
    }

    if (type == 'selfie') {
      setState(() {
        _isSubmitting = true;
        _uploadStatus = 'verification.detecting_face'.tr();
      });
      bool hasFace = false;
      try {
        hasFace = await FaceDetectorUtil.detectFace(pickedPath);
      } catch (_) {
        hasFace = false;
      }
      setState(() {
        _isSubmitting = false;
        _uploadStatus = null;
      });

      if (!hasFace) {
        if (mounted) {
          showErrorSnackBar(
            context,
            'verification.selfie_no_face_detected'.tr(),
          );
        }
        return;
      }
    }

    setState(() {
      switch (type) {
        case 'ktp':
          _ktpPath = pickedPath;
          break;
        case 'nib':
          _nibPath = pickedPath;
          break;
        case 'selfie':
          _selfiePath = pickedPath;
          break;
        case 'siup':
          _siupPath = pickedPath;
          break;
      }
    });
  }

  Future<ImageSource?> _showImageSourceSheet() async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'verification.pick_photo_source'.tr(),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),
              ListTile(
                leading: Icon(LucideIcons.camera, color: AppColors.primary),
                title: Text('verification.take_photo_camera'.tr()),
                subtitle: Text(
                  'verification.take_photo_camera_hint'.tr(),
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                ),
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
              ListTile(
                leading: Icon(LucideIcons.image, color: AppColors.primary),
                title: Text('verification.pick_from_gallery'.tr()),
                onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// OCR assist: foto dokumen (NIB/SIUP/dll) → tampilkan baris teks hasil
  /// pembacaan → user PILIH baris yang benar untuk mengisi [controller].
  ///
  /// Sengaja tidak auto-fill heuristik (lihat TextRecognitionUtil untuk
  /// alasan) supaya data KYC penting tidak salah isi karena tebakan OCR.
  Future<void> _scanDocumentText(TextEditingController controller) async {
    final source = await _showImageSourceSheet();
    if (source == null || !mounted) return;

    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked == null || !mounted) return;

    setState(() => _scanningDocument = true);
    List<String> lines = const [];
    try {
      lines = await TextRecognitionUtil.extractLines(picked.path);
    } catch (_) {
      lines = const [];
    }
    if (!mounted) return;
    setState(() => _scanningDocument = false);

    if (lines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('verification.scan_no_text_found'.tr())),
      );
      return;
    }

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.6),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'verification.scan_pick_line_title'.tr(),
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 4.h),
                Text(
                  'verification.scan_pick_line_hint'.tr(),
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                ),
                SizedBox(height: 8.h),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: lines.length,
                    itemBuilder: (context, index) => ListTile(
                      dense: true,
                      title: Text(lines[index], style: TextStyle(fontSize: 13.sp)),
                      onTap: () => Navigator.pop(ctx, lines[index]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (selected != null && mounted) {
      setState(() => controller.text = selected);
    }
  }

  String _mapUploadStatus(String status) {
    return switch (status) {
      'ktp' => 'verification.uploading_doc'.tr(
          namedArgs: {'doc': 'verification.doc_ktp'.tr()},
        ),
      'nib' => 'verification.uploading_doc'.tr(
          namedArgs: {'doc': 'verification.doc_nib'.tr()},
        ),
      'selfie' => 'verification.uploading_doc'.tr(
          namedArgs: {'doc': 'verification.doc_selfie'.tr()},
        ),
      'siup' => 'verification.uploading_doc'.tr(
          namedArgs: {'doc': 'verification.doc_siup'.tr()},
        ),
      'submit' => 'verification.upload_submitting'.tr(),
      _ => status,
    };
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final businessName = _businessNameCtrl.text.trim();
    if (businessName.isNotEmpty && businessName.length < 2) {
      showErrorSnackBar(
        context,
        'verification.business_name_min_length'.tr(),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _uploadStatus = 'verification.upload_preparing'.tr();
    });

    final result = await sl<AuthRepository>().submitVerification(
      ktpPath: _ktpPath,
      nibPath: _nibPath,
      selfiePath: _selfiePath,
      siupPath: _siupPath,
      businessName: businessName,
      taxId: _taxIdCtrl.text.trim(),
      businessAddress: _businessAddressCtrl.text.trim(),
      onUploadStatus: (status) {
        if (mounted) setState(() => _uploadStatus = _mapUploadStatus(status));
      },
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
      _uploadStatus = null;
    });

    result.fold(
      (failure) {
        showErrorSnackBar(
          context,
          failure.message,
          duration: const Duration(seconds: 5),
        );
      },
      (_) async {
        await context.read<AuthCubit>().checkAuth();
        if (!mounted) return;
        showSuccessSnackBar(context, 'dokumen_verifikasi_berhasil_di');
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final user = authState.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );
        final canUpload = user?.canSubmitKycDocuments ?? true;
        final isPending = user?.isKycPending ?? false;
        final isApproved = user?.isKycApproved ?? false;
        final isRejected = user?.isKycRejected ?? false;
        final canSubmit =
            canUpload && _ktpPath != null && _selfiePath != null && !_isSubmitting;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: BisaAppBar(
            backgroundColor: AppColors.surface,
            title: 'verification.title'.tr(),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (user != null) ...[
                            _buildStatusCard(user),
                            SizedBox(height: 16.h),
                          ],
                          if (!isApproved) ...[
                            _buildInfoCard(),
                            SizedBox(height: 16.h),
                          ],
                          if (isPending)
                            _buildLockedNotice('verification.kyc_locked_pending'.tr())
                          else if (isApproved)
                            _buildLockedNotice('verification.kyc_locked_verified'.tr())
                          else ...[
                            if (isRejected && user?.kycRejectionReason != null) ...[
                              _buildRejectionCard(user!.kycRejectionReason!),
                              SizedBox(height: 16.h),
                            ],
                            _buildUploadSection(
                              title: 'verification.ktp_required'.tr(),
                              type: 'ktp',
                              path: _ktpPath,
                              guideType: VerificationGuideType.ktp,
                              enabled: canUpload,
                            ),
                            _buildUploadSection(
                              title: 'verification.selfie_required'.tr(),
                              type: 'selfie',
                              path: _selfiePath,
                              guideType: VerificationGuideType.selfie,
                              enabled: canUpload,
                            ),
                            _buildUploadSection(
                              title: 'verification.nib_optional'.tr(),
                              type: 'nib',
                              path: _nibPath,
                              guideType: VerificationGuideType.nib,
                              enabled: canUpload,
                            ),
                            _buildUploadSection(
                              title: 'verification.siup_optional'.tr(),
                              type: 'siup',
                              path: _siupPath,
                              guideType: VerificationGuideType.siup,
                              enabled: canUpload,
                            ),
                            _buildBusinessDetailsSection(canUpload),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (canUpload)
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                        child: CustomButton(
                          text: 'verification.submit_documents'.tr(),
                          height: 50.h,
                          isLoading: _isSubmitting,
                          onPressed: canSubmit ? _submit : null,
                        ),
                      ),
                    ),
                ],
              ),
              if (_isSubmitting) _buildUploadOverlay(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBusinessDetailsSection(bool canUpload) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        const Divider(),
        SizedBox(height: 8.h),
        Text(
          'verification.business_details_section'.tr(),
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        CustomTextField(
          label: 'verification.business_name_label'.tr(),
          hint: 'verification.business_name_hint'.tr(),
          controller: _businessNameCtrl,
          enabled: canUpload && !_isSubmitting,
          isOptional: true,
          suffixIcon: _scanningDocument
              ? Padding(
                  padding: EdgeInsets.all(12.w),
                  child: SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: const CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  ),
                )
              : IconButton(
                  icon: Icon(LucideIcons.camera, color: AppColors.primary, size: 20.sp),
                  tooltip: 'verification.scan_document_tooltip'.tr(),
                  onPressed: () => _scanDocumentText(_businessNameCtrl),
                ),
        ),
        SizedBox(height: 12.h),
        CustomTextField(
          label: 'verification.tax_id_label'.tr(),
          hint: 'verification.tax_id_hint'.tr(),
          controller: _taxIdCtrl,
          enabled: canUpload && !_isSubmitting,
          isOptional: true,
          suffixIcon: _scanningDocument
              ? Padding(
                  padding: EdgeInsets.all(12.w),
                  child: SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: const CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  ),
                )
              : IconButton(
                  icon: Icon(LucideIcons.camera, color: AppColors.primary, size: 20.sp),
                  tooltip: 'verification.scan_document_tooltip'.tr(),
                  onPressed: () => _scanDocumentText(_taxIdCtrl),
                ),
        ),
        SizedBox(height: 12.h),
        CustomTextField(
          label: 'verification.business_address_label'.tr(),
          hint: 'verification.business_address_hint'.tr(),
          controller: _businessAddressCtrl,
          enabled: canUpload && !_isSubmitting,
          maxLines: 3,
          isOptional: true,
          suffixIcon: _scanningDocument
              ? Padding(
                  padding: EdgeInsets.all(12.w),
                  child: SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: const CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  ),
                )
              : IconButton(
                  icon: Icon(LucideIcons.camera, color: AppColors.primary, size: 20.sp),
                  tooltip: 'verification.scan_document_tooltip'.tr(),
                  onPressed: () => _scanDocumentText(_businessAddressCtrl),
                ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildStatusCard(UserEntity user) {
    final Color accent;
    final IconData icon;
    final String titleKey;
    final String bodyKey;

    if (user.isKycApproved) {
      accent = AppColors.success;
      icon = LucideIcons.badgeCheck;
      titleKey = 'verification.kyc_status_verified_title';
      bodyKey = 'verification.kyc_status_verified_body';
    } else if (user.isKycPending) {
      accent = AppColors.warning;
      icon = LucideIcons.clock;
      titleKey = 'verification.kyc_status_pending_title';
      bodyKey = 'verification.kyc_status_pending_body';
    } else if (user.isKycRejected) {
      accent = AppColors.error;
      icon = LucideIcons.circleX;
      titleKey = 'verification.kyc_status_rejected_title';
      bodyKey = 'verification.kyc_status_rejected_body';
    } else {
      accent = AppColors.info;
      icon = LucideIcons.shield;
      titleKey = 'verification.kyc_status_unverified_title';
      bodyKey = 'verification.kyc_status_unverified_body';
    }

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: accent.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 22.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleKey.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  bodyKey.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectionCard(String reason) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'verification.kyc_rejection_reason'.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.error,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            reason,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textPrimary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedNotice(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.lock, size: 18.sp, color: AppColors.textSecondary),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadOverlay() {
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.black.withValues(alpha: 0.45),
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 32.w),
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: 16.h),
                Text(
                  _uploadStatus ?? 'verification.upload_default'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'verification.wait_dont_close'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
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
              'verification.info_card'.tr(),
              style: TextStyle(fontSize: 12.sp, color: AppColors.textPrimary, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection({
    required String title,
    required String type,
    required String? path,
    required VerificationGuideType guideType,
    bool enabled = true,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
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
          VerificationPhotoGuide(type: guideType),
          SizedBox(height: 8.h),
          InkWell(
            onTap: enabled && !_isSubmitting ? () => _pickImage(type) : null,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              width: double.infinity,
              height: 120.h,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: path != null ? AppColors.success : AppColors.grey200,
                  width: path != null ? 1.5 : 1,
                ),
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
                          left: 8.w,
                          top: 8.h,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.circleCheck, size: 12.sp, color: AppColors.white),
                                SizedBox(width: 4.w),
                                Text(
                                  'verification.photo_uploaded'.tr(),
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: AppColors.surface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8.w,
                          top: 8.h,
                          child: CircleAvatar(
                            radius: 14.r,
                            backgroundColor: AppColors.black.withValues(alpha: 0.5),
                            child: Icon(
                              LucideIcons.pencil,
                              size: 14.sp,
                              color: AppColors.surface,
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
                          'verification.pick_or_take_photo'.tr(),
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
}
