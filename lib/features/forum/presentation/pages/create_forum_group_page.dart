import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ForumGroupCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const BisaAppBar(title: 'Create Group'),
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
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: _avatarPath == null ? 'Pilih Avatar' : 'Avatar dipilih',
                        isOutlined: true,
                        height: 42.h,
                        onPressed: () async {
                          final x = await _picker.pickImage(source: ImageSource.gallery);
                          if (x != null) setState(() => _avatarPath = x.path);
                        },
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CustomButton(
                        text: _bannerPath == null ? 'Pilih Banner' : 'Banner dipilih',
                        isOutlined: true,
                        height: 42.h,
                        onPressed: () async {
                          final x = await _picker.pickImage(source: ImageSource.gallery);
                          if (x != null) setState(() => _bannerPath = x.path);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                SwitchListTile(
                  value: _isPublic,
                  onChanged: (v) => setState(() => _isPublic = v),
                  title: const Text('Public Group'),
                  subtitle: const Text('Jika off, grup hanya untuk member yang diundang.'),
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
                              const SnackBar(content: Text('Nama grup minimal 3 karakter')),
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
}
