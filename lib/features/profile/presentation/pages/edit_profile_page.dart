import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/features/auth/domain/entities/user_entity.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../bloc/profile_cubit.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
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
  bool _awaitingSaveResult = false;

  bool get _isSupplier => widget.user.role == 'SUPPLIER';

  String get _companyLabel => _isSupplier
      ? 'profile.edit_store_name_label'.tr()
      : 'profile.edit_company_name_label'.tr();

  String get _companyHint => _isSupplier
      ? 'profile.edit_store_name_hint'.tr()
      : 'profile.edit_company_name_hint'.tr();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _companyController = TextEditingController(
      text: widget.user.companyName ?? '',
    );
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
        appBar: BisaAppBar(
          backgroundColor: AppColors.surface,
          title: 'profile.menu_edit_profile'.tr(),
        ),
        body: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            state.maybeWhen(
              loaded: (user) {
                if (!_awaitingSaveResult) return;
                _awaitingSaveResult = false;
                context.read<AuthCubit>().applyUser(user);
                showSuccessSnackBar(context, 'profile.edit_success');
                Navigator.pop(context);
              },
              error: (message) {
                if (_awaitingSaveResult) _awaitingSaveResult = false;
                showErrorSnackBar(context, message);
              },
              orElse: () {},
            );
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.pageGutter),
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
                          child:
                              _imageFile == null && widget.user.avatar == null
                              ? Icon(
                                  LucideIcons.user,
                                  size: 60.sp,
                                  color: AppColors.surface,
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
                                  color: AppColors.surface,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                LucideIcons.camera,
                                size: 20.sp,
                                color: AppColors.surface,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.sectionGapLarge),
                  CustomTextField(
                    label: 'profile.edit_full_name_label'.tr(),
                    hint: 'profile.edit_full_name_hint'.tr(),
                    controller: _nameController,
                    prefixIcon: LucideIcons.user,
                    isRequired: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'profile.edit_name_required'.tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSpacing.sectionGap),
                  CustomTextField(
                    label: _companyLabel,
                    hint: _companyHint,
                    controller: _companyController,
                    prefixIcon: _isSupplier
                        ? LucideIcons.store
                        : LucideIcons.building2,
                    isRequired: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'profile.edit_field_required'.tr(
                          namedArgs: {'label': _companyLabel},
                        );
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSpacing.sectionGap),
                  CustomTextField(
                    label: 'profile.edit_phone_label'.tr(),
                    hint: 'profile.edit_phone_hint'.tr(),
                    controller: _phoneController,
                    prefixIcon: LucideIcons.phone,
                    keyboardType: TextInputType.phone,
                    isOptional: true,
                  ),
                  SizedBox(height: AppSpacing.spacious),
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'profile.edit_save_button'.tr(),
                        isLoading: state.maybeWhen(
                          loading: () => true,
                          orElse: () => false,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _awaitingSaveResult = true;
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
