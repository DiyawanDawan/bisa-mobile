import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/media/media_upload_progress_banner.dart';
import '../../../../core/media/media_upload_progress_controller.dart';
import '../../../../core/media/media_upload_queue.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../bloc/forum_cubit.dart';
import '../../domain/entities/forum_entity.dart';
import '../../domain/entities/forum_media.dart';
import '../widgets/forum_media_widgets.dart';

// Regex sederhana untuk preview (sinkron dengan parser server).
final _hashtagRe = RegExp(r'(?<![A-Za-z0-9_])#([A-Za-z0-9_-]{2,40})');
final _mentionRe = RegExp(r'(?<![A-Za-z0-9_])@([A-Za-z0-9_-]{2,60})');

/// Halaman tulis postingan forum. Mendukung 2 mode:
/// - **Create** (default): buat post baru, bisa langsung publish atau simpan draft.
/// - **Edit** (`editPost` di-pass): edit post existing — judul/konten/kategori/media
///   bisa diubah, status bisa di-toggle PUBLISHED ↔ DRAFT.
class AddPostPage extends StatefulWidget {
  final ForumPostEntity? editPost;

  const AddPostPage({super.key, this.editPost});

  bool get isEditMode => editPost != null;

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  final _picker = ImagePicker();
  String? _selectedCategoryId;
  List<ForumCategoryEntity> _categories = [];
  final List<ForumMediaAttachment> _attachments = [];
  // Media yang sudah ada di server (edit mode) — bisa di-remove satu-satu.
  late final List<ForumMediaItem> _existingMedia;
  late String _status;

  @override
  void initState() {
    super.initState();
    final post = widget.editPost;
    _titleController = TextEditingController(text: post?.title ?? '');
    _contentController = TextEditingController(text: post?.content ?? '');
    _selectedCategoryId =
        (post?.categoryId.isEmpty ?? true) ? null : post!.categoryId;
    _existingMedia = [...?post?.mediaUrls];
    _status = post?.status ?? 'PUBLISHED';
    // Listener untuk live-preview chip tag & mention saat user ngetik.
    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
  }

  // Tag/mention yang sedang ter-detect untuk preview.
  List<String> _detectedTags = [];
  List<String> _detectedMentions = [];

  void _onTextChanged() {
    final combined = '${_titleController.text}\n${_contentController.text}';
    final tags = <String>{};
    for (final m in _hashtagRe.allMatches(combined)) {
      tags.add(m.group(1)!.toLowerCase());
    }
    final mentions = <String>{};
    for (final m in _mentionRe.allMatches(combined)) {
      mentions.add(m.group(1)!.toLowerCase());
    }
    final nextTags = tags.toList();
    final nextMentions = mentions.toList();
    if (_listEq(nextTags, _detectedTags) &&
        _listEq(nextMentions, _detectedMentions)) {
      return;
    }
    setState(() {
      _detectedTags = nextTags;
      _detectedMentions = nextMentions;
    });
  }

  bool _listEq(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  bool _isValid({required bool publishing}) {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final hasMedia = _attachments.isNotEmpty || _existingMedia.isNotEmpty;
    if (publishing) {
      // Publish: butuh title min 5 char + (content min 10 char ATAU ada media).
      return title.length >= 5 && (content.length >= 10 || hasMedia);
    }
    // Draft: cukup ada title (≥5 char).
    return title.length >= 5;
  }

  void _submit(BuildContext ctx, {required String targetStatus}) {
    final cubit = ctx.read<ForumCubit>();
    final publishing = targetStatus == 'PUBLISHED';
    if (!_isValid(publishing: publishing)) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            publishing
                ? 'Judul min. 5 karakter, isi min. 10 karakter atau lampirkan media'
                : 'Judul minimal 5 karakter untuk disimpan sebagai draft',
          ),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (widget.isEditMode) {
      cubit.updatePost(
        widget.editPost!.id,
        title: title,
        content: content,
        categoryId: _selectedCategoryId,
        existingMedia: _existingMedia,
        newAttachments: List.from(_attachments),
        status: targetStatus,
      );
    } else {
      cubit.createPost(
        title,
        content,
        _selectedCategoryId,
        attachments: List.from(_attachments),
        status: targetStatus,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ForumCubit>()..getCategories(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: BisaAppBar(
          backgroundColor: AppColors.white,
          title: widget.isEditMode ? 'Edit Diskusi' : 'Buat Diskusi Baru',
        ),
        body: BlocConsumer<ForumCubit, ForumState>(
          listener: (context, state) {
            state.maybeWhen(
              success: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.isEditMode
                          ? 'Diskusi berhasil diperbarui'
                          : 'postingan_berhasil_dibuat'.tr(),
                    ),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
                Navigator.pop(context, true);
              },
              categoriesLoaded: (cats) {
                setState(() {
                  _categories = cats;
                });
              },
              error: (msg) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(msg),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            final isLoading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );
            return Column(
              children: [
                MediaUploadProgressBanner(
                  controller: sl<MediaUploadProgressController>(),
                  uploadQueue: sl<MediaUploadQueue>(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 20.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.isEditMode) _buildStatusBanner(),
                        _buildCategorySelector(),
                        SizedBox(height: 24.h),
                        CustomTextField(
                          label: 'Judul Diskusi',
                          hint: 'Apa topik pembicaraan Anda?',
                          controller: _titleController,
                          maxLines: 2,
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          label: 'Isi Diskusi',
                          hint: 'Ceritakan lebih detail di sini...',
                          controller: _contentController,
                          maxLines: 10,
                        ),
                        SizedBox(height: 16.h),
                        if (_existingMedia.isNotEmpty) ...[
                          _buildExistingMediaList(),
                          SizedBox(height: 12.h),
                        ],
                        ForumMediaPickerRow(
                          attachments: _attachments,
                          maxItems: 10 - _existingMedia.length,
                          onRemove: (index) =>
                              setState(() => _attachments.removeAt(index)),
                          onPickImage: _pickImages,
                          onPickVideo: _pickVideo,
                        ),
                        SizedBox(height: 16.h),
                        _buildTagHintAndPreview(),
                      ],
                    ),
                  ),
                ),
                _buildBottomActionBar(context, isLoading),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusBanner() {
    final isDraft = _status == 'DRAFT';
    final isArchived = _status == 'ARCHIVED';
    final label = isArchived
        ? 'Diarsipkan'
        : isDraft
            ? 'Draft (belum dipublikasikan)'
            : 'Sudah dipublikasikan';
    final color = isArchived
        ? AppColors.grey400
        : isDraft
            ? AppColors.warning
            : AppColors.success;
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Icon(
              isDraft ? LucideIcons.fileText : LucideIcons.circleCheck,
              size: 16.sp,
              color: color,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'Status: $label',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tip + live preview chip untuk tag (#) dan mention (@).
  /// Bantuan visual supaya user paham fitur tanpa harus tap "?" / help.
  Widget _buildTagHintAndPreview() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.lightbulb, size: 14.sp, color: AppColors.primary),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'Tip: pakai #tag untuk topik & @nama-produk untuk tautkan produk',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          if (_detectedTags.isNotEmpty || _detectedMentions.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: [
                ..._detectedMentions.map(
                  (m) => _previewChip(
                    icon: LucideIcons.package,
                    label: '@$m',
                    color: AppColors.success,
                  ),
                ),
                ..._detectedTags.map(
                  (t) => _previewChip(
                    icon: LucideIcons.hash,
                    label: t,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              _detectedMentions.isNotEmpty
                  ? 'Produk akan otomatis dicocokkan dengan @${_detectedMentions.first}'
                  : 'Tag akan otomatis disimpan sebagai topik',
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.textHint,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _previewChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExistingMediaList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Media tersimpan',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: _existingMedia.asMap().entries.map((entry) {
            final index = entry.key;
            final m = entry.value;
            return Stack(
              children: [
                Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: m.isImage
                      ? BisaNetworkImage(
                          imageUrl: m.url,
                          width: 72.w,
                          height: 72.w,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Icon(
                            LucideIcons.play,
                            color: AppColors.grey500,
                            size: 24.sp,
                          ),
                        ),
                ),
                Positioned(
                  right: -4,
                  top: -4,
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _existingMedia.removeAt(index)),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(BuildContext context, bool isLoading) {
    final isDraft = _status == 'DRAFT';
    final publishLabel = widget.isEditMode
        ? (isDraft ? 'Terbitkan' : 'Simpan Perubahan')
        : 'Posting';
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Simpan Draft',
                isOutlined: true,
                isLoading: false,
                onPressed: isLoading
                    ? null
                    : () => _submit(context, targetStatus: 'DRAFT'),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              flex: 2,
              child: CustomButton(
                text: publishLabel,
                useGradient: true,
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () => _submit(context, targetStatus: 'PUBLISHED'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final slots = 10 - _existingMedia.length - _attachments.length;
    if (slots <= 0) return;
    final files = await _picker.pickMultiImage(imageQuality: 85);
    if (files.isEmpty) return;
    setState(() {
      for (final file in files) {
        if (_attachments.length + _existingMedia.length >= 10) break;
        _attachments.add(
          ForumMediaAttachment(localPath: file.path, type: 'image'),
        );
      }
    });
  }

  Future<void> _pickVideo() async {
    if (_attachments.length + _existingMedia.length >= 10) return;
    final file = await _picker.pickVideo(source: ImageSource.gallery);
    if (file == null) return;
    setState(() {
      _attachments.add(
        ForumMediaAttachment(localPath: file.path, type: 'video'),
      );
    });
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.tag, size: 16.sp, color: AppColors.primary),
            SizedBox(width: 8.w),
            Text(
              'Pilih Kategori',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 40.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildCatChip(null, 'Umum'),
              ..._categories.map((cat) => _buildCatChip(cat.id, cat.name)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCatChip(String? id, String name) {
    final isSelected = _selectedCategoryId == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategoryId = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : AppColors.grey50,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.grey200,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Text(
          name,
          style: TextStyle(
            fontSize: 13.sp,
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
