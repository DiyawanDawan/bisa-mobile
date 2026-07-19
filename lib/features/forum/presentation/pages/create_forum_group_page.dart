import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../bloc/forum_group_cubit.dart';

class CreateForumGroupPage extends StatefulWidget {
  const CreateForumGroupPage({super.key});

  @override
  State<CreateForumGroupPage> createState() => _CreateForumGroupPageState();
}

class _CreateForumGroupPageState extends State<CreateForumGroupPage> {
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _picker = ImagePicker();
  String? _avatarPath;
  String? _bannerPath;
  bool _isPublic = true;

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final x = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (x != null) setState(() => _avatarPath = x.path);
  }

  Future<void> _pickBanner() async {
    final x = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (x != null) setState(() => _bannerPath = x.path);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ForumGroupCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const BisaAppBar(title: 'Buat Grup'),
        body: BlocConsumer<ForumGroupCubit, ForumGroupState>(
          listener: (context, state) {
            if (state is ForumGroupError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if (state is ForumGroupSuccess) {
              Navigator.pop(context, true);
            }
          },
          builder: (context, state) {
            final loading = state is ForumGroupLoading;
            return ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                _buildMediaPreview(),
                SizedBox(height: 16.h),
                CustomTextField(
                  label: 'Nama Grup',
                  hint: 'Contoh: Komunitas Biochar Sulsel',
                  controller: _name,
                  isRequired: true,
                ),
                SizedBox(height: 12.h),
                CustomTextField(
                  label: 'Deskripsi',
                  hint: 'Tuliskan tujuan grup...',
                  controller: _desc,
                  maxLines: 4,
                  isOptional: true,
                ),
                SizedBox(height: 12.h),
                SwitchListTile(
                  value: _isPublic,
                  onChanged: (v) => setState(() => _isPublic = v),
                  title: const Text('Public Group'),
                  subtitle: const Text(
                    'Jika off, grup hanya untuk member yang diundang.',
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: 'Buat Grup',
                  isLoading: loading,
                  onPressed: loading
                      ? null
                      : () {
                          if (_name.text.trim().length < 3) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Nama grup minimal 3 karakter'),
                              ),
                            );
                            return;
                          }
                          context.read<ForumGroupCubit>().createGroup(
                                name: _name.text.trim(),
                                description: _desc.text.trim(),
                                avatarPath: _avatarPath,
                                bannerPath: _bannerPath,
                                isPublic: _isPublic,
                              );
                        },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tampilan grup',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: SizedBox(
            height: 140.h,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_bannerPath != null)
                  Image.file(File(_bannerPath!), fit: BoxFit.cover)
                else
                  _DefaultBanner(),
                Positioned(
                  left: 14.w,
                  bottom: 14.h,
                  child: GestureDetector(
                    onTap: _pickAvatar,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          backgroundColor: AppColors.surface,
                          backgroundImage: _avatarPath != null
                              ? FileImage(File(_avatarPath!))
                              : null,
                          child: _avatarPath == null
                              ? Icon(
                                  LucideIcons.users,
                                  size: 26.sp,
                                  color: AppColors.primary,
                                )
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.surface,
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              LucideIcons.camera,
                              size: 10.sp,
                              color: AppColors.surface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 10.w,
                  top: 10.h,
                  child: _MediaChip(
                    label: _bannerPath == null ? 'Pilih Banner' : 'Ganti Banner',
                    onTap: _pickBanner,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          _avatarPath == null && _bannerPath == null
              ? 'Avatar & banner default dipakai sampai kamu memilih gambar.'
              : 'Ketuk avatar atau tombol banner untuk mengganti.',
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _DefaultBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.85),
            AppColors.primaryDark,
            AppColors.grey800,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          LucideIcons.image,
          size: 36.sp,
          color: AppColors.surface.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}

class _MediaChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MediaChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.imagePlus, size: 14.sp, color: AppColors.primary),
              SizedBox(width: 4.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
