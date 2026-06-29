import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/i18n/tr_safe.dart';
import '../../../../core/utils/safe_navigator.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/bisa_dialog.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/iot_dashboard_entity.dart';
import '../bloc/iot_cubit.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../widgets/iot_alert_tile.dart';
import '../widgets/iot_current_conditions_panel.dart';
import '../widgets/iot_range_chips.dart';
import '../widgets/iot_telemetry_chart.dart';
import '../widgets/iot_realtime_panel.dart';
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
            title: widget.deviceName ?? 'iot.detail_default_title'.tr(),
            backgroundColor: AppColors.surface,
            onBackTap: () => safeRouterPop(context, _changed),
            bottom: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              isScrollable: true,
              tabs: [
                Tab(text: 'iot.tab_summary'.tr()),
                Tab(text: 'iot.tab_chart'.tr()),
                Tab(text: 'iot.tab_alerts'.tr()),
                Tab(text: 'iot.tab_settings'.tr()),
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
                  padding: EdgeInsets.all(AppSpacing.md),
                ),
                error: (message) => Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(message, textAlign: TextAlign.center),
                        SizedBox(height: AppSpacing.md),
                        TextButton(
                          onPressed: () => context
                              .read<IotCubit>()
                              .getDeviceDashboard(widget.deviceId),
                          child: Text('iot.retry'.tr()),
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
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonitoringPanel(context, d.isMonitoringEnabled, d.liveStatus),
          SizedBox(height: AppSpacing.sm),
          IotRealtimePanel(
            deviceId: widget.deviceId,
            lastTemperature: last?.temperature,
            enabled: d.isMonitoringEnabled,
            onAnalysisComplete: () {
              if (!context.mounted) return;
              context.read<IotCubit>().getDeviceDashboard(widget.deviceId, range: d.range);
            },
          ),
          if (d.isMonitoringEnabled) ...[
            SizedBox(height: AppSpacing.sm10),
            IotCurrentConditionsPanel(
              lastReading: last,
              stats: d.summaryStats,
              uptimePercent: d.uptimePercent,
              readingsLabel: trSafe(
                'iot.detail_readings_current_status',
                namedArgs: {
                  'count': '${d.currentReadingsCount ?? d.summaryStats.totalReadings}',
                  'window': d.statusWindow,
                },
                fallback: '{count} · {window}',
              ),
            ),
          ] else ...[
            SizedBox(height: AppSpacing.sm10),
            _buildDisabledPlaceholder(),
          ],
          SizedBox(height: AppSpacing.md),
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
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'iot.detail_auto_refresh'.tr(),
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
          SizedBox(height: AppSpacing.sm),
          IotRangeChips(
            selected: range,
            onSelected: (r) {
              context.read<IotCubit>().getDeviceDashboard(widget.deviceId, range: r);
            },
          ),
          SizedBox(height: AppSpacing.md),
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
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.bellOff, size: 48.sp, color: AppColors.grey300),
              SizedBox(height: AppSpacing.md12),
              Text(
                'iot.no_alerts_title'.tr(),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'iot.no_alerts_subtitle'.tr(),
                style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.lg),
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
      title = 'iot.panel_monitoring_off_title'.tr();
      subtitle = 'iot.panel_monitoring_off_subtitle'.tr();
    } else if (isAlert) {
      bannerColor = AppColors.error;
      bannerIcon = LucideIcons.triangleAlert;
      title = 'iot.panel_monitoring_alert_title'.tr();
      subtitle = 'iot.panel_monitoring_alert_subtitle'.tr();
    } else if (isOnline) {
      bannerColor = AppColors.success;
      bannerIcon = LucideIcons.check;
      title = 'iot.panel_monitoring_online_title'.tr();
      subtitle = 'iot.panel_monitoring_online_subtitle'.tr();
    } else {
      bannerColor = AppColors.warning;
      bannerIcon = LucideIcons.wifiOff;
      title = 'iot.panel_monitoring_offline_title'.tr();
      subtitle = 'iot.panel_monitoring_offline_subtitle'.tr();
    }

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: bannerColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: bannerColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(bannerIcon, color: bannerColor, size: 18.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.sp,
                        color: bannerColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: isMonitoringEnabled,
                activeColor: AppColors.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
        ],
      ),
    );
  }

  Widget _buildDisabledPlaceholder() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.powerOff, size: 20.sp, color: AppColors.grey300),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'iot.sensor_disabled_title'.tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'iot.sensor_disabled_subtitle'.tr(),
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: CustomButton(
        text: 'hapus_perangkat'.tr(),
        backgroundColor: AppColors.error,
        onPressed: () => _confirmDelete(context),
      ),
    );
  }

  Future<void> _confirmDisableMonitoring(BuildContext context) async {
    final confirmed = await showBisaConfirmDialog(
      context,
      title: 'iot.disable_confirm_title'.tr(),
      message: 'iot.disable_confirm_message'.tr(
        namedArgs: {'name': widget.deviceName ?? ''},
      ),
      confirmText: 'iot.disable_confirm_action'.tr(),
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
