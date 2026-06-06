import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/network/api_client.dart';
import 'package:mobile_bisa/core/utils/payment_status_utils.dart';
import 'package:mobile_bisa/core/utils/safe_area_utils.dart';
import 'package:mobile_bisa/core/utils/pro_subscription.dart';
import 'package:mobile_bisa/features/auth/domain/entities/user_entity.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mobile_bisa/features/iot/presentation/bloc/iot_cubit.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';

class IotSubscriptionPage extends StatefulWidget {
  const IotSubscriptionPage({super.key});

  @override
  State<IotSubscriptionPage> createState() => _IotSubscriptionPageState();
}

class _IotSubscriptionPageState extends State<IotSubscriptionPage> {
  List<Map<String, dynamic>> _channels = [];
  bool _loadingChannels = true;
  String? _channelsError;
  String? _selectedChannelCode;
  String? _selectedMethod;

  @override
  void initState() {
    super.initState();
    _fetchChannels();
  }

  Future<void> _fetchChannels() async {
    setState(() {
      _loadingChannels = true;
      _channelsError = null;
    });
    try {
      final response = await sl<ApiClient>().dio.get('/payments/channels');
      final raw = response.data['data'] as List? ?? [];
      final channels = raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      if (!mounted) return;
      setState(() {
        _channels = channels;
        _loadingChannels = false;
        if (channels.isNotEmpty) {
          _selectedChannelCode = channels.first['code']?.toString();
          _selectedMethod = channels.first['group']?.toString() ?? 'E_WALLET';
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingChannels = false;
        _channelsError = 'Gagal memuat metode pembayaran';
      });
    }
  }

  bool _isProExpired(UserEntity user) {
    if (user.tier != 'PRO') return false;
    if (user.subscriptionExpiresAt == null) return true;
    return user.subscriptionExpiresAt!.isBefore(DateTime.now());
  }

  Future<bool> _pollProSubscriptionStatus() async {
    for (var i = 0; i < 10; i++) {
      await context.read<AuthCubit>().checkAuth();
      if (!mounted) return false;
      final user = context.read<AuthCubit>().state.maybeWhen(
            authenticated: (u) => u,
            orElse: () => null,
          );
      if (user != null && isProActive(user)) return true;
      if (i < 9) {
        await Future.delayed(const Duration(seconds: 3));
      }
    }
    return false;
  }

  IconData _channelIcon(String? group) {
    switch (group?.toUpperCase()) {
      case 'E_WALLET':
        return LucideIcons.wallet;
      case 'QRIS':
        return LucideIcons.qrCode;
      case 'BANK_TRANSFER':
        return LucideIcons.landmark;
      case 'CREDIT_CARD':
        return LucideIcons.creditCard;
      default:
        return LucideIcons.creditCard;
    }
  }

  String _groupLabel(String? group) {
    switch (group?.toUpperCase()) {
      case 'E_WALLET':
        return 'E-Wallet';
      case 'QRIS':
        return 'QRIS';
      case 'BANK_TRANSFER':
        return 'Transfer Bank';
      case 'CREDIT_CARD':
        return 'Kartu Kredit';
      case 'CASH':
        return 'Tunai';
      default:
        return group ?? 'Pembayaran';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );
    final isActive = user != null && isProActive(user);
    final isExpired = user != null && _isProExpired(user);
    final isRenewal = isActive || isExpired;

    // Pertahanan in-depth: Pro = fitur khusus Supplier (IoT, analitik bisnis).
    // Jika Buyer membuka /iot-subscription via deep-link / navigasi lama,
    // tampilkan halaman informasi saja, bukan flow upgrade.
    if (user != null && user.role != 'SUPPLIER') {
      return _buildBuyerNotAllowedScreen(context);
    }

    return BlocProvider(
      create: (context) => sl<IotCubit>(),
      child: BlocConsumer<IotCubit, IotState>(
        listener: (context, state) {
          state.maybeWhen(
            subscriptionSuccess: (data) async {
              final pmData = data['paymentData'];
              String? url;
              if (pmData != null && pmData['actions'] != null) {
                final actions = pmData['actions'] as List;
                if (actions.isNotEmpty) {
                  url = actions.first['url'];
                }
              }
              url ??= data['paymentUrl'] ?? data['invoiceUrl'];

              if (url != null) {
                final result = await context.push(
                  '/payment-webview',
                  extra: {
                    'url': url,
                    'title': isRenewal ? 'Perpanjang Langganan PRO' : 'Pembayaran Langganan PRO',
                  },
                );
                if (!mounted) return;
                final exit = parsePaymentWebViewExit(result);
                if (exit == PaymentWebViewExit.failed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pembayaran gagal atau dibatalkan.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                if (exit == PaymentWebViewExit.callbackDetected ||
                    exit == PaymentWebViewExit.dismissed) {
                  final upgraded = await _pollProSubscriptionStatus();
                  if (!mounted) return;
                  if (upgraded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isRenewal
                              ? 'Pembayaran sukses! Masa aktif PRO Anda diperpanjang.'
                              : 'Pembayaran sukses! Akun Anda telah diupgrade ke PRO.',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.pop(true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Pembayaran belum terkonfirmasi. Coba refresh profil beberapa saat lagi.',
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Gagal memproses link pembayaran.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            error: (message) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Pembayaran Gagal'),
                  content: Text(message),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup'),
                    ),
                  ],
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

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: BisaAppBar(
              title: isRenewal ? 'Perpanjang BISA Pro' : 'BISA IoT PRO Plan',
              backgroundColor: Colors.white,
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: fullScreenScrollPadding(
                    context,
                    horizontal: 20,
                    top: 20,
                    baseBottom: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isActive && user.subscriptionExpiresAt != null)
                        _buildActiveStatusCard(user.subscriptionExpiresAt!),
                      if (isExpired && user.subscriptionExpiresAt != null)
                        _buildExpiredStatusCard(user.subscriptionExpiresAt!),
                      _buildHeaderCard(isRenewal: isRenewal),
                      SizedBox(height: 24.h),
                      Text(
                        'Keuntungan Anggota PRO:',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildFeatureItem(
                        LucideIcons.thermometer,
                        'Pemantauan Suhu Gudang Real-time',
                        'Pantau tungku atau gudang pertanian Anda 24 jam non-stop.',
                      ),
                      _buildFeatureItem(
                        LucideIcons.bellRing,
                        'Notifikasi Bahaya Instan (Alerting)',
                        'Terima push notifikasi instan ketika sensor melewati batas suhu aman.',
                      ),
                      _buildFeatureItem(
                        LucideIcons.chartBar,
                        'Analitik Penjualan Lanjutan',
                        'Rekomendasi bisnis, funnel minat, dan insight performa toko.',
                      ),
                      _buildFeatureItem(
                        LucideIcons.sparkles,
                        'Analitik Pasar Mendalam (AI)',
                        'Prediksi harga 3 bulan, proyeksi, dan insight bisnis komoditas biomassa.',
                      ),
                      _buildFeatureItem(
                        LucideIcons.map,
                        'Smart GIS Supply-Demand Matching',
                        'Dapatkan pencocokan armada logistik dan pembeli biomassa radius terdekat.',
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Pilih Metode Pembayaran:',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildPaymentMethodsList(),
                      SizedBox(height: 32.h),
                      CustomButton(
                        text: isActive
                            ? 'Perpanjang Langganan PRO'
                            : isExpired
                                ? 'Perpanjang BISA Pro Sekarang'
                                : 'Aktifkan PRO Plan Sekarang',
                        useGradient: true,
                        onPressed: _selectedChannelCode == null || _selectedMethod == null
                            ? null
                            : () {
                                context.read<IotCubit>().subscribePro(
                                      _selectedChannelCode!,
                                      _selectedMethod!,
                                    );
                              },
                      ),
                      if (isRenewal) ...[
                        SizedBox(height: 10.h),
                        Text(
                          'Masa aktif akan ditambah 30 hari setelah pembayaran berhasil.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
                if (isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentMethodsList() {
    if (_loadingChannels) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: ShimmerListPlaceholder(
          itemCount: 3,
          itemHeight: 56.h,
        ),
      );
    }

    if (_channelsError != null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.grey100),
        ),
        child: Column(
          children: [
            Text(_channelsError!, style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp)),
            SizedBox(height: 10.h),
            TextButton(onPressed: _fetchChannels, child: const Text('Coba lagi')),
          ],
        ),
      );
    }

    if (_channels.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Text(
          'Belum ada metode pembayaran tersedia.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _channels.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        final item = _channels[index];
        final code = item['code']?.toString() ?? '';
        final group = item['group']?.toString();
        final isSelected = _selectedChannelCode == code;

        return InkWell(
          onTap: () {
            setState(() {
              _selectedChannelCode = code;
              _selectedMethod = group ?? 'E_WALLET';
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.grey200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _channelIcon(group),
                  color: isSelected ? AppColors.primary : AppColors.grey400,
                  size: 22.sp,
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name']?.toString() ?? code,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _groupLabel(group),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(LucideIcons.check, color: AppColors.primary)
                else
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.grey300, width: 2),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActiveStatusCard(DateTime expiresAt) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.circleCheck, color: AppColors.success, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'PRO aktif hingga ${DateFormat('d MMMM yyyy').format(expiresAt)}. Perpanjang untuk menambah 30 hari.',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredStatusCard(DateTime expiredAt) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.clockAlert, color: AppColors.warning, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Langganan PRO berakhir ${DateFormat('d MMMM yyyy').format(expiredAt)}. Perpanjang untuk akses penuh kembali.',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Fallback screen ketika pembeli (Buyer) mengakses halaman ini.
  /// Pro = paket fitur penjual (Supplier) — jadi pembeli diberi info
  /// non-konversi alih-alih flow upgrade berbayar.
  Widget _buildBuyerNotAllowedScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BisaAppBar(
        title: 'BISA Pro',
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(22.r),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.store,
                size: 48.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Fitur khusus Supplier',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'BISA Pro berisi paket fitur penjual seperti monitoring '
              'IoT gudang, analitik bisnis mendalam, dan asisten AI '
              'untuk supplier. Sebagai pembeli, semua kebutuhan belanja '
              'biomassa & hasil tani sudah tersedia gratis untuk Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.55,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: 220.w,
              child: ElevatedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(LucideIcons.arrowLeft, size: 18),
                label: const Text('Kembali'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard({required bool isRenewal}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  isRenewal ? 'PERPANJANG' : 'POPULER',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Icon(LucideIcons.crown, color: Colors.amber, size: 28.sp),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            isRenewal ? 'Perpanjang BISA Pro' : 'IoT Smart Farm PRO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'Rp 99.000',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                '/ bulan',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
