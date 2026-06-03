import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/safe_navigator.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/bisa_dialog.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/iot_dashboard_entity.dart';
import '../bloc/iot_cubit.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../widgets/iot_alert_tile.dart';
import '../widgets/iot_metric_summary_row.dart';
import '../widgets/iot_range_chips.dart';
import '../widgets/iot_telemetry_chart.dart';
import '../widgets/iot_settings_tab.dart';
import 'dart:async';

class IotDeviceDetailPage extends StatefulWidget {
  final String deviceId;
  final String? deviceName;

  const IotDeviceDetailPage({
    super.key,
    required this.deviceId,
    this.deviceName,
  });

  @override
  State<IotDeviceDetailPage> createState() => _IotDeviceDetailPageState();
}

class _IotDeviceDetailPageState extends State<IotDeviceDetailPage>
    with SingleTickerProviderStateMixin {
  bool _changed = false;
  late TabController _tabController;
  Timer? _autoRefreshTimer;
  bool _autoRefresh = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  void _toggleAutoRefresh(BuildContext context, String range) {
    setState(() {
      _autoRefresh = !_autoRefresh;
      _autoRefreshTimer?.cancel();
      if (_autoRefresh) {
        _autoRefreshTimer = Timer.periodic(const Duration(seconds: 45), (_) {
          if (!mounted) return;
          context.read<IotCubit>().getDeviceDashboard(widget.deviceId, range: range);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<IotCubit>()..getDeviceDashboard(widget.deviceId),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          safeRouterPop(context, _changed);
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: BisaAppBar(
            title: widget.deviceName ?? 'Detail Perangkat',
            backgroundColor: AppColors.surface,
            onBackTap: () => safeRouterPop(context, _changed),
            bottom: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Ringkasan'),
                Tab(text: 'Grafik'),
                Tab(text: 'Alert'),
                Tab(text: 'Atur'),
              ],
            ),
          ),
          body: BlocBuilder<IotCubit, IotState>(
            builder: (context, state) {
              return state.maybeWhen(
                loading: () => ShimmerListPlaceholder(
                  itemCount: 5,
                  itemHeight: 96.h,
                  scrollable: true,
                  padding: EdgeInsets.all(16.w),
                ),
                error: (message) => Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(message, textAlign: TextAlign.center),
                        SizedBox(height: 16.h),
                        TextButton(
                          onPressed: () => context
                              .read<IotCubit>()
                              .getDeviceDashboard(widget.deviceId),
                          child: const Text('Coba lagi'),
                        ),
                      ],
                    ),
                  ),
                ),
                dashboardLoaded: (dashboard, range, alertsPage, alertsLoading) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildSummaryTab(context, dashboard),
                      _buildChartTab(context, dashboard, range, alertsLoading),
                      _buildAlertsTab(
                        context,
                        dashboard,
                        alertsPage,
                        alertsLoading,
                      ),
                      IotSettingsTab(
                        deviceId: widget.deviceId,
                        dashboard: dashboard,
                        range: range,
                        onChanged: () => setState(() => _changed = true),
                      ),
                    ],
                  );
                },
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryTab(BuildContext context, IotDashboardEntity d) {
    final last = d.lastReading;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonitoringPanel(context, d.isMonitoringEnabled, d.liveStatus),
          SizedBox(height: 16.h),
          if (d.isMonitoringEnabled) ...[
            Text(
              'Kondisi Terkini',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16.sp,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Suhu',
                    '${last?.temperature.toStringAsFixed(1) ?? "-"}°C',
                    LucideIcons.thermometer,
                    AppColors.error,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildMetricCard(
                    'Kelembaban',
                    '${last?.humidity?.toStringAsFixed(1) ?? "-"}%',
                    LucideIcons.droplets,
                    AppColors.ocean,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            IotMetricSummaryRow(
              stats: d.summaryStats,
              uptimePercent: d.uptimePercent,
            ),
            SizedBox(height: 12.h),
            Text(
              '${d.readingsInRange} pembacaan dalam rentang ${d.range}',
              style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
            ),
          ] else
            _buildDisabledPlaceholder(),
          SizedBox(height: 24.h),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildChartTab(
    BuildContext context,
    IotDashboardEntity d,
    String range,
    bool loading,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Perbarui otomatis (45 dtk)',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Switch.adaptive(
                value: _autoRefresh,
                activeColor: AppColors.primary,
                onChanged: (_) => _toggleAutoRefresh(context, range),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          IotRangeChips(
            selected: range,
            onSelected: (r) {
              context.read<IotCubit>().getDeviceDashboard(widget.deviceId, range: r);
            },
          ),
          SizedBox(height: 16.h),
          IotTelemetryChart(
            isLoading: loading,
            temperatureSeries: d.temperatureSeries,
            humiditySeries: d.humiditySeries,
            co2Series: d.co2Series,
            thresholdMin: d.thresholdMin,
            thresholdMax: d.thresholdMax,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsTab(
    BuildContext context,
    IotDashboardEntity d,
    alertsPage,
    bool loading,
  ) {
    final alerts = alertsPage?.alerts ?? d.recentAlerts;

    if (loading && alerts.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (alerts.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.bellOff, size: 48.sp, color: AppColors.grey300),
              SizedBox(height: 12.h),
              Text(
                'Tidak ada peringatan',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Semua kondisi dalam batas aman',
                style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return IotAlertTile(
          alert: alert,
          onMarkRead: () {
            context.read<IotCubit>().markAlertRead(widget.deviceId, alert.id);
            setState(() => _changed = true);
          },
        );
      },
    );
  }

  Widget _buildMonitoringPanel(
    BuildContext context,
    bool isMonitoringEnabled,
    String liveStatus,
  ) {
    final isOnline = liveStatus == 'ONLINE';
    final isAlert = liveStatus == 'ALERT';

    Color bannerColor;
    IconData bannerIcon;
    String title;
    String subtitle;

    if (!isMonitoringEnabled) {
      bannerColor = AppColors.grey500;
      bannerIcon = LucideIcons.powerOff;
      title = 'Monitoring Nonaktif';
      subtitle =
          'Perangkat tidak menerima data sensor dan tidak mengirim peringatan bahaya.';
    } else if (isAlert) {
      bannerColor = AppColors.error;
      bannerIcon = LucideIcons.triangleAlert;
      title = 'Peringatan Aktif';
      subtitle = 'Suhu atau kondisi di luar batas aman. Segera periksa lokasi.';
    } else if (isOnline) {
      bannerColor = AppColors.success;
      bannerIcon = LucideIcons.check;
      title = 'Monitoring Aktif — Online';
      subtitle = 'Data sensor diterima secara real-time.';
    } else {
      bannerColor = AppColors.warning;
      bannerIcon = LucideIcons.wifiOff;
      title = 'Monitoring Aktif — Offline';
      subtitle = 'Belum ada data baru. Periksa koneksi perangkat.';
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: bannerColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: bannerColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(bannerIcon, color: bannerColor, size: 22.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14.sp,
                        color: bannerColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
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
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    isMonitoringEnabled
                        ? 'Nonaktifkan saat produksi berhenti'
                        : 'Aktifkan untuk mulai monitoring',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Switch.adaptive(
                  value: isMonitoringEnabled,
                  activeColor: AppColors.primary,
                  onChanged: (enabled) {
                    if (!enabled) {
                      _confirmDisableMonitoring(context);
                    } else {
                      _setMonitoring(context, true);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledPlaceholder() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        children: [
          Icon(LucideIcons.powerOff, size: 40.sp, color: AppColors.grey300),
          SizedBox(height: 12.h),
          Text(
            'Sensor dinonaktifkan',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Aktifkan monitoring kembali saat produksi dimulai.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20.sp),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 22.sp,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textHint,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return CustomButton(
      text: 'hapus_perangkat'.tr(),
      backgroundColor: AppColors.error,
      onPressed: () => _confirmDelete(context),
    );
  }

  Future<void> _confirmDisableMonitoring(BuildContext context) async {
    final confirmed = await showBisaConfirmDialog(
      context,
      title: 'Nonaktifkan Monitoring?',
      message:
          'Perangkat tidak akan lagi menerima data sensor atau mengirim peringatan bahaya.',
      confirmText: 'Nonaktifkan',
      destructive: true,
    );
    if (confirmed == true && context.mounted) {
      _setMonitoring(context, false);
    }
  }

  void _setMonitoring(BuildContext context, bool enabled) {
    setState(() => _changed = true);
    context.read<IotCubit>().setMonitoringEnabled(widget.deviceId, enabled);
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showBisaConfirmDialog(
      context,
      title: 'hapus_perangkat'.tr(),
      message: 'apakah_anda_yakin_ingin_mengha'.tr(),
      confirmText: 'hapus'.tr(),
      destructive: true,
    );
    if (confirmed == true && context.mounted) {
      await context.read<IotCubit>().deleteDevice(
            widget.deviceId,
            refreshList: false,
          );
      if (context.mounted) context.pop(true);
    }
  }
}
