import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_bisa/core/i18n/failure_messages.dart';
import 'package:mobile_bisa/core/utils/app_feedback.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/network/api_client.dart';
import 'package:mobile_bisa/core/utils/money_format.dart';
import 'package:mobile_bisa/core/utils/payment_status_utils.dart';
import 'package:mobile_bisa/core/utils/safe_area_utils.dart';
import 'package:mobile_bisa/core/utils/pro_subscription.dart';
import 'package:mobile_bisa/features/auth/domain/entities/user_entity.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mobile_bisa/features/iot/presentation/bloc/iot_cubit.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';
import 'package:mobile_bisa/shared/widgets/pro_tier_matrix.dart';
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
  // Tracks which payment group accordions are expanded
  Set<String> _expandedPaymentGroups = {};

  // Dynamic Plans Data from Backend
  List<Map<String, dynamic>> _plans = [];
  List<Map<String, dynamic>> _durations = [];
  List<Map<String, dynamic>> _comparisonTable = [];

  // State Pemilihan Paket & Durasi
  String _selectedPlanType = 'rental'; // 'rental', 'buy_hardware', 'software_only'
  int _selectedDurationMonths = 1; // 1, 3, 6, 12

  int get _hardwarePrice {
    if (_plans.isNotEmpty) {
      final p = _plans.firstWhere((element) => element['id'] == _selectedPlanType, orElse: () => {});
      if (p['hardwarePrice'] != null) {
        return (p['hardwarePrice'] as num).toInt();
      }
    }
    return 0;
  }

  int get _monthlySoftwareRate {
    if (_plans.isNotEmpty) {
      final p = _plans.firstWhere((element) => element['id'] == _selectedPlanType, orElse: () => {});
      if (p['monthlyRate'] != null) {
        return (p['monthlyRate'] as num).toInt();
      }
    }
    return 0;
  }

  int get _softwareSubtotal => _monthlySoftwareRate * _selectedDurationMonths;

  int get _discountAmount {
    if (_durations.isNotEmpty) {
      final d = _durations.firstWhere((element) => element['months'] == _selectedDurationMonths, orElse: () => {});
      final dType = d['discountType']?.toString();
      final dValue = (d['discountValue'] as num?)?.toDouble();
      if (dType == 'FIXED' && dValue != null) {
        return dValue.toInt().clamp(0, _softwareSubtotal);
      }
      if (d['discountRate'] != null) {
        final rate = (d['discountRate'] as num).toDouble();
        return (_softwareSubtotal * rate).round();
      }
    }
    return 0;
  }

  double get _discountRate {
    if (_softwareSubtotal > 0 && _discountAmount > 0) {
      return _discountAmount / _softwareSubtotal;
    }
    return 0.0;
  }

  String get _discountLabelText {
    if (_durations.isNotEmpty) {
      final d = _durations.firstWhere((element) => element['months'] == _selectedDurationMonths, orElse: () => {});
      final label = d['discountLabel']?.toString() ?? d['discount']?.toString();
      if (label != null && label.isNotEmpty) {
        return 'Diskon Durasi ($label)';
      }
    }
    if (_discountRate > 0) {
      return 'Diskon Durasi (${(_discountRate * 100).toInt()}%)';
    }
    return 'Diskon Durasi';
  }

  int get _softwareTotal => _softwareSubtotal - _discountAmount;
  int get _grandTotal => _hardwarePrice + _softwareTotal;

  @override
  void initState() {
    super.initState();
    _fetchPlansAndChannels();
  }

  Future<void> _fetchPlansAndChannels() async {
    setState(() {
      _loadingChannels = true;
      _channelsError = null;
    });
    try {
      final dio = sl<ApiClient>().dio;

      // 1. Fetch Dynamic Plans Config from Backend
      try {
        final plansResp = await dio.get('/iot/plans');
        final pData = plansResp.data['data'] as Map<String, dynamic>?;
        if (pData != null) {
          final fetchedPlans = (pData['plans'] as List? ?? [])
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
          final fetchedDurations = (pData['durations'] as List? ?? [])
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
          final fetchedComparison = (pData['comparisonTable'] as List? ?? [])
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();

          if (mounted) {
            setState(() {
              if (fetchedPlans.isNotEmpty) _plans = fetchedPlans;
              if (fetchedDurations.isNotEmpty) _durations = fetchedDurations;
              if (fetchedComparison.isNotEmpty) _comparisonTable = fetchedComparison;
            });
          }
        }
      } catch (e) {
        debugPrint('[BISA IoT] Fallback to local plans config: $e');
      }

      // 2. Fetch Payment Channels
      final response = await dio.get('/payments/channels');
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
          // Auto-expand the group of the first selected channel
          final firstGroup = channels.first['group']?.toString() ?? 'E_WALLET';
          _expandedPaymentGroups = {firstGroup};
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingChannels = false;
        _channelsError = 'iot.subscription_channels_error'.tr();
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
                    'title': isRenewal
                        ? 'iot.subscription_payment_renew_webview'.tr()
                        : 'iot.subscription_payment_new_webview'.tr(),
                  },
                );
                if (!mounted) return;
                final exit = parsePaymentWebViewExit(result);
                if (exit == PaymentWebViewExit.failed) {
                  showErrorSnackBar(context, 'iot.payment_failed_body'.tr());
                  return;
                }
                if (exit == PaymentWebViewExit.callbackDetected ||
                    exit == PaymentWebViewExit.dismissed) {
                  final upgraded = await _pollProSubscriptionStatus();
                  if (!mounted) return;
                  if (upgraded) {
                    showSuccessSnackBar(
                      context,
                      isRenewal
                          ? 'iot.subscription_payment_success_renew'.tr()
                          : 'iot.subscription_payment_success_new'.tr(),
                    );
                    context.pop(true);
                  } else {
                    showWarningSnackBar(
                      context,
                      'iot.subscription_payment_pending'.tr(),
                    );
                  }
                }
              } else {
                showErrorSnackBar(context, 'iot.payment_link_failed'.tr());
              }
            },
            error: (message) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('iot.payment_failed_title'.tr()),
                  content: Text(localizeFailureMessage(message)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('iot.close'.tr()),
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
              title: isRenewal
                  ? 'iot.subscription_renew_title'.tr()
                  : 'iot.subscription_plan_title'.tr(),
              backgroundColor: AppColors.surface,
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
                      SizedBox(height: AppSpacing.xl),

                      // STAGE 1: PILIH PAKET LANGGANAN
                      _buildSectionTitle('1. Pilih Paket Langganan IoT'),
                      SizedBox(height: AppSpacing.md12),
                      _buildPlanSelectionCards(),
                      SizedBox(height: AppSpacing.md12),
                      _buildPlanComparisonTable(),

                      SizedBox(height: AppSpacing.xl),

                      // STAGE 2: PILIH DURASI BERLANGGANAN
                      _buildSectionTitle('2. Pilih Durasi Berlangganan'),
                      SizedBox(height: AppSpacing.md12),
                      _buildDurationSelector(),

                      SizedBox(height: AppSpacing.xl),

                      // STAGE 3: RINGKASAN RINCIAN BIAYA
                      _buildSectionTitle('3. Ringkasan Rincian Biaya'),
                      SizedBox(height: AppSpacing.md12),
                      _buildCostCalculationSummary(),

                      SizedBox(height: AppSpacing.xl),

                      // STAGE 4: PILIH METODE PEMBAYARAN
                      _buildSectionTitle('4. Pilih Metode Pembayaran'),
                      SizedBox(height: AppSpacing.md12),
                      _buildPaymentMethodsList(),

                      SizedBox(height: AppSpacing.xl),

                      // SECTION FITUR & MATRIKS PRO
                      _buildSectionTitle('pro.matrix_section_title'.tr()),
                      SizedBox(height: AppSpacing.md12),
                      const ProTierMatrix(),
                      SizedBox(height: AppSpacing.xl),
                      _buildSectionTitle('iot.subscription_benefits_title'.tr()),
                      SizedBox(height: AppSpacing.md12),
                      _buildFeatureItem(
                        LucideIcons.thermometer,
                        'iot.subscription_feature_temp_title'.tr(),
                        'iot.subscription_feature_temp_desc'.tr(),
                      ),
                      _buildFeatureItem(
                        LucideIcons.bellRing,
                        'iot.subscription_feature_alert_title'.tr(),
                        'iot.subscription_feature_alert_desc'.tr(),
                      ),
                      _buildFeatureItem(
                        LucideIcons.chartBar,
                        'iot.subscription_feature_analytics_title'.tr(),
                        'iot.subscription_feature_analytics_desc'.tr(),
                      ),
                      _buildFeatureItem(
                        LucideIcons.sparkles,
                        'iot.subscription_feature_market_title'.tr(),
                        'iot.subscription_feature_market_desc'.tr(),
                      ),
                      _buildFeatureItem(
                        LucideIcons.map,
                        'iot.subscription_feature_gis_title'.tr(),
                        'iot.subscription_feature_gis_desc'.tr(),
                      ),
                      SizedBox(height: AppSpacing.xxl),

                      // TOMBOL CHECKOUT / BAYAR
                      CustomButton(
                        text: 'Bayar ${formatMoneyIdr(_grandTotal)}',
                        useGradient: true,
                        onPressed: _selectedChannelCode == null || _selectedMethod == null
                            ? null
                            : () {
                                context.read<IotCubit>().subscribePro(
                                      _selectedChannelCode!,
                                      _selectedMethod!,
                                      planType: _selectedPlanType,
                                      durationMonths: _selectedDurationMonths,
                                    );
                              },
                      ),
                      if (isRenewal) ...[
                        SizedBox(height: AppSpacing.sm10),
                        Text(
                          'iot.subscription_extend_note'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                      SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
                if (isLoading)
                  Container(
                    color: AppColors.black.withValues(alpha: 0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  IconData _parsePlanIcon(dynamic icon) {
    if (icon is IconData) return icon;
    switch (icon?.toString()) {
      case 'cpu':
        return LucideIcons.cpu;
      case 'shoppingBag':
        return LucideIcons.shoppingBag;
      case 'sparkles':
        return LucideIcons.sparkles;
      default:
        return LucideIcons.cpu;
    }
  }

  Widget _buildPlanSelectionCards() {
    if (_plans.isEmpty) {
      return const SizedBox.shrink();
    }

    final plans = _plans.map((p) {
      final monthlyRate = p['monthlyRate'] != null ? (p['monthlyRate'] as num).toInt() : null;
      final hardwarePrice = p['hardwarePrice'] != null ? (p['hardwarePrice'] as num).toInt() : null;

      String displayPrice = p['price']?.toString() ?? '';
      if (displayPrice.isEmpty && monthlyRate != null) {
        if (hardwarePrice != null && hardwarePrice > 0) {
          displayPrice = formatMoneyIdr(hardwarePrice);
        } else {
          displayPrice = formatMoneyIdr(monthlyRate);
        }
      }

      return {
        'id': p['id']?.toString() ?? '',
        'title': p['title']?.toString() ?? '',
        'price': displayPrice,
        'unit': p['unit']?.toString() ?? '',
        'tag': p['tag']?.toString(),
        'desc': p['desc']?.toString() ?? '',
        'icon': _parsePlanIcon(p['icon']),
      };
    }).toList();

    return Column(
      children: plans.map((p) {
        final isSelected = _selectedPlanType == p['id'];
        return Container(
          margin: EdgeInsets.only(bottom: AppSpacing.md12),
          child: InkWell(
            onTap: () => setState(() => _selectedPlanType = p['id'] as String),
            borderRadius: BorderRadius.circular(AppRadius.tile),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(AppSpacing.md12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.tile),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.grey200,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.15)
                              : AppColors.grey100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          p['icon'] as IconData,
                          color: isSelected ? AppColors.primary : AppColors.grey600,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm10),
                      Expanded(
                        child: Text(
                          p['title'] as String,
                          style: TextStyle(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (p['tag'] != null)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.grey200,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            p['tag'] as String,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppColors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xs6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        p['price'] as String,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        p['unit'] as String,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    p['desc'] as String,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Tabel perbandingan keuntungan antar paket (100% Dinamis dari Backend)
  Widget _buildPlanComparisonTable() {
    if (_comparisonTable.isEmpty) {
      return const SizedBox.shrink();
    }

    final activePlans = _plans.isNotEmpty
        ? _plans
        : [
            {'id': 'rental', 'title': 'Sewa'},
            {'id': 'buy_hardware', 'title': 'Beli'},
            {'id': 'software_only', 'title': 'SW Only'},
          ];

    Widget _cellText(String text, bool isHeader) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isHeader ? 11.sp : 10.5.sp,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        );

    Widget _checkCell(bool? val) => Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: val == null
              ? Text('—',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.grey400))
              : Icon(
                  val ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  size: 18.sp,
                  color: val ? AppColors.success : AppColors.grey300,
                ),
        );

    Color _colBg(bool active) =>
        active ? AppColors.primary.withValues(alpha: 0.06) : Colors.transparent;

    final Map<int, TableColumnWidth> colWidths = {
      0: const FlexColumnWidth(2.2),
    };
    for (int i = 0; i < activePlans.length; i++) {
      colWidths[i + 1] = const FlexColumnWidth(1.4);
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.grey200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.tile),
        child: Table(
          border: TableBorder(
            horizontalInside: BorderSide(color: AppColors.grey100),
            verticalInside: BorderSide(color: AppColors.grey200),
          ),
          columnWidths: colWidths,
          children: [
            // Dynamic Header row
            TableRow(
              decoration: BoxDecoration(color: AppColors.grey50),
              children: [
                _cellText('Fitur', true),
                ...activePlans.map((p) {
                  final headerLabel = (p['tag'] as String?) ??
                      (p['title'] as String?) ??
                      (p['id'] as String? ?? '');
                  return _cellText(headerLabel, true);
                }),
              ],
            ),
            // Dynamic Data rows from Backend comparisonTable
            ..._comparisonTable.map((f) {
              final label = (f['label'] as String?) ?? '';

              bool rowHasText = false;
              for (final p in activePlans) {
                final pId = p['id'] as String? ?? '';
                final aliases = [pId];
                if (pId == 'buy_hardware') aliases.add('buy');
                if (pId == 'software_only') aliases.add('software');
                for (final a in aliases) {
                  if (f[a] != null) {
                    rowHasText = true;
                    break;
                  }
                }
              }

              return TableRow(
                children: [
                  Container(
                    color: _colBg(false),
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                    child: Text(
                      label,
                      style: TextStyle(
                          fontSize: 10.5.sp,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  ...activePlans.map((p) {
                    final pId = p['id'] as String? ?? '';
                    final isActivePlan = _selectedPlanType == pId;

                    final aliases = [pId];
                    if (pId == 'buy_hardware') aliases.add('buy');
                    if (pId == 'software_only') aliases.add('software');

                    String? textVal;
                    bool? okVal;
                    for (final a in aliases) {
                      if (f[a] != null) textVal = f[a]?.toString();
                      if (f['${a}_ok'] != null) okVal = f['${a}_ok'] as bool?;
                    }

                    return Container(
                      color: _colBg(isActivePlan),
                      child: rowHasText
                          ? _cellText(textVal ?? '—', false)
                          : Center(child: _checkCell(okVal)),
                    );
                  }),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationSelector() {
    final rawDurations = _durations;
    final durations = rawDurations.map((d) {
      final months = (d['months'] as num).toInt();
      final label = d['label']?.toString() ?? '$months Bulan';
      final discountLabel = d['discountLabel']?.toString() ?? d['discount']?.toString();
      return {
        'months': months,
        'label': label,
        'discount': discountLabel,
      };
    }).toList();

    return Row(
      children: durations.map((d) {
        final months = d['months'] as int;
        final isSelected = _selectedDurationMonths == months;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: InkWell(
              onTap: () => setState(() => _selectedDurationMonths = months),
              borderRadius: BorderRadius.circular(AppRadius.tile),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.tile),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.grey300,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      d['label'] as String,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.white : AppColors.textPrimary,
                      ),
                    ),
                    if (d['discount'] != null) ...[
                      SizedBox(height: 2.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.white.withValues(alpha: 0.25)
                              : AppColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          d['discount'] as String,
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? AppColors.white : AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCostCalculationSummary() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_hardwarePrice > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Perangkat Fisik IoT (Hak Milik)',
                  style: TextStyle(fontSize: 12.5.sp, color: AppColors.textSecondary),
                ),
                Text(
                  formatMoneyIdr(_hardwarePrice),
                  style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 6.h),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Langganan Software ($_selectedDurationMonths Bln x ${formatMoneyIdr(_monthlySoftwareRate)})',
                style: TextStyle(fontSize: 12.5.sp, color: AppColors.textSecondary),
              ),
              Text(
                formatMoneyIdr(_softwareSubtotal),
                style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          if (_discountAmount > 0) ...[
            SizedBox(height: 6.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _discountLabelText,
                  style: TextStyle(fontSize: 12.5.sp, color: AppColors.success, fontWeight: FontWeight.w600),
                ),
                Text(
                  '- ${formatMoneyIdr(_discountAmount)}',
                  style: TextStyle(fontSize: 12.5.sp, color: AppColors.success, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: const Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Pembayaran',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                formatMoneyIdr(_grandTotal),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsList() {
    if (_loadingChannels) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: ShimmerListPlaceholder(itemCount: 3, itemHeight: 56.h),
      );
    }

    if (_channelsError != null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.tile),
          border: Border.all(color: AppColors.grey100),
        ),
        child: Column(
          children: [
            Text(
              _channelsError!,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
            ),
            SizedBox(height: AppSpacing.sm10),
            TextButton(
              onPressed: _fetchPlansAndChannels,
              child: Text('iot.retry'.tr()),
            ),
          ],
        ),
      );
    }

    if (_channels.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.tile),
        ),
        child: Text(
          'iot.subscription_no_channels'.tr(),
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
        ),
      );
    }

    // Group channels by 'group' key
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final ch in _channels) {
      final g = ch['group']?.toString() ?? 'OTHER';
      grouped.putIfAbsent(g, () => []).add(ch);
    }

    return Column(
      children: grouped.entries.map((entry) {
        final groupKey = entry.key;
        final groupChannels = entry.value;
        final isExpanded = _expandedPaymentGroups.contains(groupKey);
        // Check if any channel in this group is selected
        final hasSelected = groupChannels.any((c) => c['code']?.toString() == _selectedChannelCode);
        final selectedName = hasSelected
            ? groupChannels
                .firstWhere((c) => c['code']?.toString() == _selectedChannelCode)['name']
                ?.toString()
            : null;

        return Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.sm10),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.tile),
              border: Border.all(
                color: hasSelected ? AppColors.primary : AppColors.grey200,
                width: hasSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              children: [
                // Accordion Header
                InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.tile),
                  onTap: () {
                    setState(() {
                      if (isExpanded) {
                        _expandedPaymentGroups.remove(groupKey);
                      } else {
                        _expandedPaymentGroups.add(groupKey);
                      }
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.section,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _channelIcon(groupKey),
                          color: hasSelected ? AppColors.primary : AppColors.grey500,
                          size: 20.sp,
                        ),
                        SizedBox(width: AppSpacing.sm10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _groupLabel(groupKey),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              if (hasSelected && selectedName != null) ...[
                                SizedBox(height: 2.h),
                                Text(
                                  selectedName,
                                  style: TextStyle(
                                    fontSize: 11.5.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ] else ...[
                                SizedBox(height: 2.h),
                                Text(
                                  '${groupChannels.length} opsi tersedia',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (hasSelected)
                          Container(
                            margin: EdgeInsets.only(right: 8.w),
                            child: const Icon(LucideIcons.check, color: AppColors.primary, size: 16),
                          ),
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            LucideIcons.chevronDown,
                            size: 18.sp,
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Accordion Body - Channel list
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  child: isExpanded
                      ? Column(
                          children: [
                            Divider(height: 1, color: AppColors.grey100),
                            ...groupChannels.map((item) {
                              final code = item['code']?.toString() ?? '';
                              final isSelected = _selectedChannelCode == code;
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedChannelCode = code;
                                    _selectedMethod = groupKey;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md + 8.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary.withValues(alpha: 0.04)
                                        : Colors.transparent,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['name']?.toString() ?? code,
                                          style: TextStyle(
                                            fontSize: 13.5.sp,
                                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(LucideIcons.check, color: AppColors.primary, size: 16)
                                      else
                                        Container(
                                          width: 18.w,
                                          height: 18.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: AppColors.grey300, width: 1.5),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActiveStatusCard(DateTime expiresAt) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.circleCheck, color: AppColors.success, size: 20.sp),
          SizedBox(width: AppSpacing.sm10),
          Expanded(
            child: Text(
              'iot.subscription_pro_active_card'.tr(
                namedArgs: {
                  'date': DateFormat('d MMMM yyyy').format(expiresAt),
                },
              ),
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
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.clockAlert, color: AppColors.warning, size: 20.sp),
          SizedBox(width: AppSpacing.sm10),
          Expanded(
            child: Text(
              'iot.subscription_pro_expired_card'.tr(
                namedArgs: {
                  'date': DateFormat('d MMMM yyyy').format(expiredAt),
                },
              ),
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

  Widget _buildBuyerNotAllowedScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: 'iot.subscription_bisa_pro_appbar'.tr(),
        backgroundColor: AppColors.surface,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.pageGutter,
          vertical: AppSpacing.spacious,
        ),
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
            SizedBox(height: AppSpacing.lg),
            Text(
              'iot.subscription_buyer_title'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'iot.subscription_buyer_body'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.55,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: 220.w,
              child: ElevatedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(LucideIcons.arrowLeft, size: 18),
                label: Text('iot.back'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.tile),
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
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSpacing.xlPx.r),
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
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md12,
                  vertical: AppSpacing.xs6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Text(
                  isRenewal
                      ? 'iot.subscription_header_renew_badge'.tr()
                      : 'iot.subscription_header_popular_badge'.tr(),
                  style: TextStyle(
                    color: AppColors.surface,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Icon(LucideIcons.crown, color: AppColors.warning, size: 28.sp),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            isRenewal
                ? 'iot.subscription_header_plan_renew'.tr()
                : 'iot.subscription_header_plan_new'.tr(),
            style: TextStyle(
              color: AppColors.surface,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Pilih skema fleksibel sewa alat atau beli alat + software PRO',
            style: TextStyle(
              color: AppColors.textOnPrimary.withValues(alpha: 0.9),
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20.sp),
          ),
          SizedBox(width: AppSpacing.section),
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
