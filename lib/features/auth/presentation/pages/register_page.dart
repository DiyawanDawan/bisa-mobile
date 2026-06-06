import 'dart:async';

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
import '../../../../core/constants/app_colors.dart';
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
        final available =
            await sl<AuthRemoteDataSource>().checkEmailAvailable(trimmed);
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
          _indonesiaCountry = indonesia ?? (countries.isNotEmpty ? countries.first : null);
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
    super.dispose();
  }

  void _onAuthState(BuildContext context, AuthState state) {
    state.maybeWhen(
      success: (message) {
        final lower = message.toLowerCase();
        if (!lower.contains('terdaftar') && !lower.contains('otp')) return;
        context.push(
          '/otp-verification',
          extra: {
            'email': _emailController.text.trim(),
            'type': 'EMAIL_VERIFICATION',
          },
        );
      },
      error: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16.r),
          ),
        );
      },
      orElse: () {},
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final email = _emailController.text.trim();
    if (_emailAvailable == false && email == _lastCheckedEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Email sudah digunakan. Gunakan email lain atau masuk ke akun Anda.',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16.r),
        ),
      );
      return;
    }

    if (_isSupplier) {
      if (_selectedProvince == null || _selectedRegency == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Provinsi dan kota/kabupaten wajib dipilih'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16.r),
          ),
        );
        return;
      }
    }

    final auth = context.read<AuthCubit>();
    if (_isSupplier) {
      auth.registerSupplier(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
        province: _selectedProvince?.name,
        regency: _selectedRegency?.name,
      );
    } else {
      auth.registerBuyer(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthCubit, AuthState>(
        listenWhen: (prev, curr) =>
            curr.maybeWhen(success: (_) => true, error: (_) => true, orElse: () => false),
        listener: _onAuthState,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildMeshBackground(),
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildBackButton(),
                          _buildBrandLogo(),
                        ],
                      ),
                      SizedBox(height: 40.h),
                      Text(
                        'Buat Akun Baru',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.8,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Daftar untuk mulai bertransaksi dan nikmati layanan terbaik kami.',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                        ),
                      ),
                      SizedBox(height: 28.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          'Langkah 1 · Buat akun',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Daftar Sebagai',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            child: _roleCard(
                              title: 'Pembeli',
                            icon: LucideIcons.shoppingBag,
                            isSelected: !_isSupplier,
                            onTap: () => setState(() {
                              _isSupplier = false;
                              _selectedProvince = null;
                              _selectedRegency = null;
                            }),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _roleCard(
                            title: 'Supplier',
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
                    SizedBox(height: 24.h),
                    Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            CustomTextField(
                              label: 'Nama Lengkap',
                              hint: 'Masukkan nama lengkap',
                              controller: _fullNameController,
                              prefixIcon: Icons.person_outline_rounded,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Nama wajib diisi' : null,
                            ),
                            SizedBox(height: 18.h),
                            CustomTextField(
                              label: 'Email',
                              hint: 'nama@email.com',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.alternate_email_rounded,
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Email wajib diisi';
                                if (!_emailFormat.hasMatch(v)) {
                                  return 'Format email tidak valid';
                                }
                                if (_emailAvailable == false &&
                                    v.trim() == _lastCheckedEmail) {
                                  return 'Email sudah digunakan';
                                }
                                return null;
                              },
                            ),
                            if (_checkingEmail)
                              Padding(
                                padding: EdgeInsets.only(top: 6.h),
                                child: Text(
                                  'Memeriksa ketersediaan email…',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              )
                            else if (_emailAvailable == true &&
                                _emailController.text.trim() == _lastCheckedEmail)
                              Padding(
                                padding: EdgeInsets.only(top: 6.h),
                                child: Text(
                                  'Email tersedia',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.success,
                                  ),
                                ),
                              ),
                            SizedBox(height: 18.h),
                            CustomTextField(
                              label: 'Nomor Telepon',
                              hint: '0812xxxxxxxx',
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              prefixIcon: Icons.phone_android_rounded,
                            ),
                            SizedBox(height: 18.h),
                            CustomTextField(
                              label: 'Kata Sandi',
                              hint: 'Min. 8 karakter',
                              controller: _passwordController,
                              isPassword: true,
                              prefixIcon: Icons.lock_outline_rounded,
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Kata sandi wajib diisi';
                                if (v.length < 8) return 'Minimal 8 karakter';
                                return null;
                              },
                            ),
                            if (_isSupplier) ...[
                              SizedBox(height: 22.h),
                              _buildSupplierLocationSection(),
                            ],
                            SizedBox(height: 28.h),
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                final loading = state.maybeWhen(
                                  loading: () => true,
                                  orElse: () => false,
                                );
                                return CustomButton(
                                  text: 'Daftar Sekarang',
                                  useGradient: true,
                                  isLoading: loading,
                                  onPressed: loading ? null : _submit,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 28.h),
                      _buildLoginFooter(),
                      SizedBox(height: 32.h),
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
      color: AppColors.white,
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
          padding: EdgeInsets.all(10.r),
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
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(50.r),
        boxShadow: AppColors.softShadow,
      ),
      child: BisaLogo(width: 88.w, height: 36.h),
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
        child: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            children: const [
              TextSpan(text: 'Sudah punya akun? '),
              TextSpan(
                text: 'Masuk',
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
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: EdgeInsets.symmetric(vertical: 20.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : AppColors.grey50,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.grey200,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected ? AppColors.softShadow : null,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : AppColors.grey100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? AppColors.primary : AppColors.grey400,
                  size: 24.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
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
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.mapPin, size: 18.sp, color: AppColors.primary),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Lokasi operasional',
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
            'Pilih provinsi dan kota/kabupaten dari daftar. Wajib untuk akun supplier.',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          SizedBox(height: 14.h),
          _buildIndonesiaCountryRow(),
          SizedBox(height: 14.h),
          _buildRegionDropdown(
            label: 'Provinsi',
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
          SizedBox(height: 14.h),
          _buildRegionDropdown(
            label: 'Kota/Kabupaten',
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
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: Image.asset(
              AppAssets.flagIndonesia,
              width: 32.w,
              height: 22.h,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                LucideIcons.flag,
                size: 22.sp,
                color: AppColors.error,
              ),
            ),
          ),
          SizedBox(width: 12.w),
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
                      ? 'Memuat wilayah...'
                      : (_indonesiaCountry == null
                          ? 'Gagal memuat — ketuk Muat ulang'
                          : 'Wilayah operasional Indonesia'),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          if (_loadingCountry)
            SizedBox(
              width: 20.r,
              height: 20.r,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            )
          else if (_indonesiaCountry == null)
            TextButton(
              onPressed: _resolveIndonesiaCountry,
              child: Text(
                'Muat ulang',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
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
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: enabled ? () => _openRegionPicker(label, level, onChanged) : null,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: enabled ? AppColors.white : AppColors.grey100,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.grey300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value?.name ?? 'Pilih $label',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: value != null
                          ? AppColors.textPrimary
                          : AppColors.textHint,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.grey400),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Daftar wilayah belum tersedia. Periksa koneksi internet lalu coba lagi.',
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16.r),
          ),
        );
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
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) => BlocProvider.value(
        value: gisCubit,
        child: _RegionPickerSheet(
          title: title,
          onRetry: () => loadRegions(),
        ),
      ),
    ).then((result) {
      if (result != null) onChanged(result);
    });
  }
}

class _RegionPickerSheet extends StatelessWidget {
  const _RegionPickerSheet({
    required this.title,
    this.onRetry,
  });

  final String title;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.65,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
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
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Pilih $title',
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
            SizedBox(height: 12.h),
            Expanded(
              child: BlocBuilder<GisCubit, GisState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    loading: () => ShimmerListPlaceholder(
                      itemCount: 8,
                      itemHeight: 48.h,
                      scrollable: true,
                    ),
                    error: (msg) => _RegionEmptyState(
                      message: msg,
                      onRetry: onRetry,
                    ),
                    loaded: (regions) {
                      if (regions.isEmpty) {
                        return _RegionEmptyState(
                          message:
                              'Belum ada daftar wilayah untuk dipilih.\nSilakan muat ulang atau coba beberapa saat lagi.',
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
                      message: 'Memuat...',
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
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.mapPinOff, size: 40.sp, color: AppColors.grey400),
            SizedBox(height: 12.h),
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
              SizedBox(height: 16.h),
              TextButton(
                onPressed: onRetry,
                child: const Text('Muat ulang'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
