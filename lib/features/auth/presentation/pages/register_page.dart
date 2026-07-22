import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/features/gis/domain/entities/region_entity.dart';
import 'package:mobile_bisa/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mobile_bisa/features/gis/domain/repositories/gis_repository.dart';
import 'package:mobile_bisa/features/gis/presentation/bloc/gis_cubit.dart';
import 'package:mobile_bisa/injection_container.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/utils/safe_area_utils.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/bisa_logo.dart';
import '../bloc/auth_cubit.dart';
import '../../../../shared/widgets/shimmer_loading.dart';

/// Halaman daftar — struktur disamakan dengan [LoginPage] (terbukti render benar).
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _referralCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  RegionEntity? _indonesiaCountry;
  RegionEntity? _selectedProvince;
  RegionEntity? _selectedRegency;
  bool _isSupplier = false;
  bool _loadingCountry = false;
  Timer? _emailCheckTimer;
  bool? _emailAvailable;
  bool _checkingEmail = false;
  String? _lastCheckedEmail;

  static final _emailFormat = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _resolveIndonesiaCountry();
  }

  void _onEmailChanged() {
    _scheduleEmailCheck(_emailController.text);
  }

  void _scheduleEmailCheck(String email) {
    _emailCheckTimer?.cancel();
    final trimmed = email.trim();
    if (trimmed.isEmpty || !_emailFormat.hasMatch(trimmed)) {
      setState(() {
        _emailAvailable = null;
        _checkingEmail = false;
        _lastCheckedEmail = null;
      });
      return;
    }

    setState(() => _checkingEmail = true);
    _emailCheckTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final available = await sl<AuthRemoteDataSource>().checkEmailAvailable(
          trimmed,
        );
        if (!mounted || _emailController.text.trim() != trimmed) return;
        setState(() {
          _emailAvailable = available;
          _checkingEmail = false;
          _lastCheckedEmail = trimmed;
        });
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _emailAvailable = null;
          _checkingEmail = false;
        });
      }
    });
  }

  /// Backend: GET /api/v1/gis?level=province&parentId={country.uuid}
  /// Bukan kode "ID" — parentId harus id dari tabel countries (seed Prisma).
  Future<void> _resolveIndonesiaCountry() async {
    setState(() => _loadingCountry = true);
    final result = await sl<GisRepository>().getRegions(
      level: 'country',
      forceRefresh: true,
    );
    if (!mounted) return;
    result.fold(
      (_) => setState(() {
        _loadingCountry = false;
        _indonesiaCountry = null;
      }),
      (countries) {
        RegionEntity? indonesia;
        for (final c in countries) {
          if (c.name.toLowerCase() == 'indonesia') {
            indonesia = c;
            break;
          }
        }
        setState(() {
          _indonesiaCountry =
              indonesia ?? (countries.isNotEmpty ? countries.first : null);
          _loadingCountry = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _emailCheckTimer?.cancel();
    _emailController.removeListener(_onEmailChanged);
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  void _onAuthState(BuildContext context, AuthState state) {
    state.maybeWhen(
      success: (message) {
        if (message != 'auth.register_buyer_success' &&
            message != 'auth.register_supplier_success') {
          return;
        }
        context.push(
          '/otp-verification',
          extra: {
            'email': _emailController.text.trim(),
            'type': 'EMAIL_VERIFICATION',
          },
        );
      },
      error: (message) {
        showErrorSnackBar(context, message);
      },
      orElse: () {},
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final email = _emailController.text.trim();
    if (_emailAvailable == false && email == _lastCheckedEmail) {
      showErrorSnackBar(context, 'auth.email_in_use_long'.tr());
      return;
    }

    if (_isSupplier) {
      if (_selectedProvince == null || _selectedRegency == null) {
        showErrorSnackBar(context, 'auth.region_required'.tr());
        return;
      }
    }

    final referralCode = _referralCodeController.text.trim();
    final auth = context.read<AuthCubit>();
    if (_isSupplier) {
      auth.registerSupplier(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
        province: _selectedProvince?.name,
        regency: _selectedRegency?.name,
        referralCode: referralCode.isEmpty ? null : referralCode,
      );
    } else {
      auth.registerBuyer(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
        referralCode: referralCode.isEmpty ? null : referralCode,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthCubit, AuthState>(
        listenWhen: (prev, curr) => curr.maybeWhen(
          success: (_) => true,
          error: (_) => true,
          orElse: () => false,
        ),
        listener: _onAuthState,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildMeshBackground(),
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [_buildBackButton(), _buildBrandLogo()],
                      ),
                      SizedBox(height: AppSpacing.lg),
                      Text(
                        'auth.register_title'.tr(),
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.6,
                          height: 1.15,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        'auth.register_subtitle'.tr(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                        ),
                      ),
                      SizedBox(height: AppSpacing.md12),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm10,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight.withValues(
                                alpha: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                            child: Text(
                              'auth.register_step'.tr(),
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          SizedBox(width: AppSpacing.sm),
                          Text(
                            'auth.register_as'.tr(),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.sm10),
                      Row(
                        children: [
                          Expanded(
                            child: _roleCard(
                              title: 'auth.role_buyer'.tr(),
                              icon: LucideIcons.shoppingBag,
                              isSelected: !_isSupplier,
                              onTap: () => setState(() {
                                _isSupplier = false;
                                _selectedProvince = null;
                                _selectedRegency = null;
                              }),
                            ),
                          ),
                          SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: _roleCard(
                              title: 'auth.role_supplier'.tr(),
                              icon: LucideIcons.store,
                              isSelected: _isSupplier,
                              onTap: () {
                                setState(() => _isSupplier = true);
                                if (_indonesiaCountry == null) {
                                  _resolveIndonesiaCountry();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.md12),
                      Container(
                        padding: EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            CustomTextField(
                              label: 'nama_lengkap'.tr(),
                              hint: 'masukkan_nama_lengkap'.tr(),
                              controller: _fullNameController,
                              prefixIcon: Icons.person_outline_rounded,
                              isRequired: true,
                              dense: true,
                              validator: (v) => v == null || v.isEmpty
                                  ? 'auth.name_required'.tr()
                                  : null,
                            ),
                            SizedBox(height: AppSpacing.md12),
                            CustomTextField(
                              label: 'email'.tr(),
                              hint: 'email_hint'.tr(),
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.alternate_email_rounded,
                              isRequired: true,
                              dense: true,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'email_required'.tr();
                                }
                                if (!_emailFormat.hasMatch(v)) {
                                  return 'email_invalid'.tr();
                                }
                                if (_emailAvailable == false &&
                                    v.trim() == _lastCheckedEmail) {
                                  return 'auth.email_in_use'.tr();
                                }
                                return null;
                              },
                            ),
                            if (_checkingEmail)
                              Padding(
                                padding: EdgeInsets.only(top: 4.h),
                                child: Text(
                                  'auth.checking_email'.tr(),
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              )
                            else if (_emailAvailable == true &&
                                _emailController.text.trim() ==
                                    _lastCheckedEmail)
                              Padding(
                                padding: EdgeInsets.only(top: 4.h),
                                child: Text(
                                  'auth.email_available_msg'.tr(),
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppColors.success,
                                  ),
                                ),
                              ),
                            SizedBox(height: AppSpacing.md12),
                            CustomTextField(
                              label: 'nomor_telepon'.tr(),
                              hint: '0812xxxxxxxx'.tr(),
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              prefixIcon: Icons.phone_android_rounded,
                              isOptional: true,
                              dense: true,
                            ),
                            SizedBox(height: AppSpacing.md12),
                            CustomTextField(
                              label: 'kata_sandi'.tr(),
                              hint: 'auth.password_hint_register'.tr(),
                              controller: _passwordController,
                              isPassword: true,
                              prefixIcon: Icons.lock_outline_rounded,
                              isRequired: true,
                              dense: true,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'password_required'.tr();
                                }
                                if (v.length < 8) {
                                  return 'auth.password_min_8'.tr();
                                }
                                return null;
                              },
                            ),
                            if (_isSupplier) ...[
                              SizedBox(height: AppSpacing.md12),
                              _buildSupplierLocationSection(),
                            ],
                            SizedBox(height: AppSpacing.md12),
                            CustomTextField(
                              label: 'auth.referral_code_label'.tr(),
                              hint: 'auth.referral_code_hint'.tr(),
                              controller: _referralCodeController,
                              prefixIcon: Icons.card_giftcard_outlined,
                              isOptional: true,
                              dense: true,
                            ),
                            SizedBox(height: AppSpacing.xl),
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                final loading = state.maybeWhen(
                                  loading: () => true,
                                  orElse: () => false,
                                );
                                return CustomButton(
                                  text: 'daftar_sekarang'.tr(),
                                  useGradient: true,
                                  isLoading: loading,
                                  onPressed: loading ? null : _submit,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.lg),
                      _buildLoginFooter(),
                      SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeshBackground() {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: -100.h,
            right: -50.w,
            child: Container(
              width: 280.w,
              height: 280.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 80.h,
            left: -40.w,
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/login');
          }
        },
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.sm10),
          child: Icon(
            LucideIcons.arrowLeft,
            size: 20.sp,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildBrandLogo() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md12,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: AppColors.softShadow,
      ),
      child: BisaLogo(width: 72.w, height: 28.h),
    );
  }

  Widget _buildLoginFooter() {
    return Center(
      child: TextButton(
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/login');
          }
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
            children: [
              TextSpan(text: 'auth.have_account'.tr()),
              TextSpan(
                text: 'auth.sign_in_link'.tr(),
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 44.h,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.grey200,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16.sp,
                color: isSelected ? AppColors.primary : AppColors.grey400,
              ),
              SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupplierLocationSection() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.mapPin, size: 18.sp, color: AppColors.primary),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'auth.operational_location'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            'auth.region_hint'.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          SizedBox(height: AppSpacing.section),
          _buildIndonesiaCountryRow(),
          SizedBox(height: AppSpacing.section),
          _buildRegionDropdown(
            label: 'provinsi'.tr(),
            value: _selectedProvince,
            level: 'province',
            enabled: _indonesiaCountry != null && !_loadingCountry,
            onChanged: (val) {
              setState(() {
                _selectedProvince = val;
                _selectedRegency = null;
              });
            },
          ),
          SizedBox(height: AppSpacing.section),
          _buildRegionDropdown(
            label: 'kota_kabupaten'.tr(),
            value: _selectedRegency,
            level: 'regency',
            enabled: _selectedProvince != null,
            onChanged: (val) => setState(() => _selectedRegency = val),
          ),
        ],
      ),
    );
  }

  Widget _buildIndonesiaCountryRow() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.section,
        vertical: AppSpacing.md12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: Image.asset(
              AppAssets.flagIndonesia,
              width: AppSpacing.xxl,
              height: 22.h,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Icon(LucideIcons.flag, size: 22.sp, color: AppColors.error),
            ),
          ),
          SizedBox(width: AppSpacing.md12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _indonesiaCountry?.name ?? 'Indonesia',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  _loadingCountry
                      ? 'auth.loading_regions'.tr()
                      : (_indonesiaCountry == null
                            ? 'auth.region_load_failed'.tr()
                            : 'auth.region_indonesia'.tr()),
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
                ),
              ],
            ),
          ),
          if (_loadingCountry)
            SizedBox(
              width: AppSpacing.lg,
              height: AppSpacing.lg,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            )
          else if (_indonesiaCountry == null)
            TextButton(
              onPressed: _resolveIndonesiaCountry,
              child: Text(
                'auth.reload'.tr(),
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRegionDropdown({
    required String label,
    required RegionEntity? value,
    required String level,
    required bool enabled,
    required ValueChanged<RegionEntity?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        GestureDetector(
          onTap: enabled
              ? () => _openRegionPicker(label, level, onChanged)
              : null,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.section,
            ),
            decoration: BoxDecoration(
              color: enabled ? AppColors.surface : AppColors.grey100,
              borderRadius: BorderRadius.circular(AppRadius.tile),
              border: Border.all(color: AppColors.grey300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value?.name ??
                        'auth.select_label'.tr(namedArgs: {'label': label}),
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: value != null
                          ? AppColors.textPrimary
                          : AppColors.textHint,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.grey400,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openRegionPicker(
    String title,
    String level,
    ValueChanged<RegionEntity?> onChanged,
  ) async {
    if (level == 'province') {
      if (_indonesiaCountry == null) {
        await _resolveIndonesiaCountry();
      }
      if (_indonesiaCountry == null) {
        if (!mounted) return;
        showErrorSnackBar(context, 'auth.regions_unavailable'.tr());
        return;
      }
    }

    final gisCubit = sl<GisCubit>();
    Future<void> loadRegions() async {
      if (level == 'province' && _indonesiaCountry != null) {
        await gisCubit.getProvinces(_indonesiaCountry!.id, force: true);
      } else if (level == 'regency' && _selectedProvince != null) {
        await gisCubit.getRegencies(_selectedProvince!.id, force: true);
      }
    }

    await loadRegions();

    if (!mounted) return;
    showModalBottomSheet<RegionEntity>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.pill),
        ),
      ),
      builder: (sheetContext) => BlocProvider.value(
        value: gisCubit,
        child: _RegionPickerSheet(title: title, onRetry: () => loadRegions()),
      ),
    ).then((result) {
      if (result != null) onChanged(result);
    });
  }
}

class _RegionPickerSheet extends StatelessWidget {
  const _RegionPickerSheet({required this.title, this.onRetry});

  final String title;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.65,
      child: Padding(
        padding: bisaSheetPadding(
          context,
          horizontal: AppSpacing.lg,
          top: AppSpacing.md,
          bottom: AppSpacing.lg,
        ),
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'auth.select_title'.tr(namedArgs: {'title': title}),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md12),
            Expanded(
              child: BlocBuilder<GisCubit, GisState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    loading: () => ShimmerListPlaceholder(
                      itemCount: 8,
                      itemHeight: 48.h,
                      scrollable: true,
                    ),
                    error: (msg) =>
                        _RegionEmptyState(message: msg, onRetry: onRetry),
                    loaded: (regions) {
                      if (regions.isEmpty) {
                        return _RegionEmptyState(
                          message: 'auth.no_regions_list'.tr(),
                          onRetry: onRetry,
                        );
                      }
                      return ListView.separated(
                        itemCount: regions.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final region = regions[index];
                          return ListTile(
                            title: Text(
                              region.name,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onTap: () => Navigator.pop(context, region),
                          );
                        },
                      );
                    },
                    orElse: () => _RegionEmptyState(
                      message: 'loading'.tr(),
                      onRetry: onRetry,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegionEmptyState extends StatelessWidget {
  const _RegionEmptyState({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.mapPinOff, size: 40.sp, color: AppColors.grey400),
            SizedBox(height: AppSpacing.md12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: AppSpacing.md),
              TextButton(onPressed: onRetry, child: Text('auth.reload'.tr())),
            ],
          ],
        ),
      ),
    );
  }
}
