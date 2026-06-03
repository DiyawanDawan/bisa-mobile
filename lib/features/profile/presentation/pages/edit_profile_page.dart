import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/features/auth/domain/entities/user_entity.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../bloc/profile_cubit.dart';
import '../../../../injection_container.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _companyController;
  late TextEditingController _phoneController;
  File? _imageFile;
  final _formKey = GlobalKey<FormState>();

  bool get _isSupplier => widget.user.role == 'SUPPLIER';

  String get _companyLabel =>
      _isSupplier ? 'Nama Toko' : 'Nama Perusahaan';

  String get _companyHint => _isSupplier
      ? 'Masukkan nama toko Anda'
      : 'Masukkan nama perusahaan Anda';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _companyController =
        TextEditingController(text: widget.user.companyName ?? '');
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
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
          backgroundColor: Colors.white,
          title: 'Ubah Profil',
        ),
        body: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            state.maybeWhen(
              success: (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('profil_berhasil_diperbarui'.tr())),
                );
                Navigator.pop(context);
              },
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: AppColors.error,
                  ),
                );
              },
              orElse: () {},
            );
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60.r,
                          backgroundColor: AppColors.primary,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : resolveMediaImageProvider(widget.user.avatar),
                          child: _imageFile == null && widget.user.avatar == null
                              ? Icon(
                                  LucideIcons.user,
                                  size: 60.sp,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                LucideIcons.camera,
                                size: 20.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                  CustomTextField(
                    label: 'namalengkap_1'.tr(),
                    hint: 'masukkannamalengkapanda_1'.tr(),
                    controller: _nameController,
                    prefixIcon: LucideIcons.user,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    label: _companyLabel,
                    hint: _companyHint,
                    controller: _companyController,
                    prefixIcon:
                        _isSupplier ? LucideIcons.store : LucideIcons.building2,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '$_companyLabel tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    label: 'nomortelepon_1'.tr(),
                    hint: 'contoh081234567890_1'.tr(),
                    controller: _phoneController,
                    prefixIcon: LucideIcons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 40.h),
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'simpanperubahan_1'.tr(),
                        isLoading: state.maybeWhen(
                          loading: () => true,
                          orElse: () => false,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<ProfileCubit>().updateProfile(
                                  fullName: _nameController.text.trim(),
                                  companyName: _companyController.text.trim(),
                                  phone: _phoneController.text.trim(),
                                  avatarPath: _imageFile?.path,
                                );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
