import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/features/iot/data/models/iot_device_model.dart';
import 'package:mobile_bisa/features/iot/domain/entities/iot_dashboard_entity.dart';
import 'package:mobile_bisa/features/iot/presentation/bloc/iot_cubit.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/pro_required_placeholder.dart';
import 'package:mobile_bisa/shared/widgets/pro_gate.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';
import 'package:mobile_bisa/shared/widgets/bisa_dialog.dart';
import 'package:mobile_bisa/shared/widgets/custom_text_field.dart';
import 'package:mobile_bisa/features/iot/presentation/pages/iot_qr_scan_page.dart';
import 'package:mobile_bisa/features/iot/presentation/widgets/iot_sparkline.dart';

class IotDashboardPage extends StatefulWidget {
  const IotDashboardPage({super.key});

  @override
  State<IotDashboardPage> createState() => _IotDashboardPageState();
}

class _IotDashboardPageState extends State<IotDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return ProGate(
      icon: LucideIcons.cpu,
      title: 'iot.dashboard_title'.tr(),
      lockedMessage: 'iot.pro_locked_message',
      child: BlocProvider(
        create: (context) => sl<IotCubit>()..getDevices(),
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: BisaAppBar(
            title: 'iot.dashboard_title'.tr(),
            backgroundColor: AppColors.surface,
          ),
          body: BlocBuilder<IotCubit, IotState>(
            builder: (context, state) {
              return state.maybeWhen(
                loading: () => Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: const ShimmerListPlaceholder(),
                ),
                error: (message) => _buildErrorState(context, message),
                loaded: (devices, fleet, statusSummary) => RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async => context.read<IotCubit>().getDevices(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoBanner(),
                        SizedBox(height: AppSpacing.sm),
                        _buildSummaryCard(devices, fleet, statusSummary),
                        SizedBox(height: AppSpacing.sm10),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'iot.devices_section_title'.tr(),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 6.w),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () => _showAddDeviceDialog(context),
                              icon: Icon(
                                LucideIcons.plus,
                                size: 14.sp,
                                color: AppColors.primary,
                              ),
                              label: Text(
                                'tambah'.tr(),
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.sm),
                        if (devices.isEmpty)
                          _buildEmptyState()
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: devices.length,
                            separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm),
                            itemBuilder: (context, index) => _buildDeviceCard(
                              context,
                              devices[index],
                              fleet: fleet,
                              statusSummary: statusSummary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                orElse: () => const SizedBox(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(LucideIcons.shieldAlert, color: AppColors.warning, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'iot.safety_banner'.tr(),
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    List<IotDeviceModel> devices,
    IotFleetAnalyticsEntity? fleet,
    IotStatusSummaryEntity? statusSummary,
  ) {
    final totals = fleet?.totals;
    final total = totals?.devices ??
        statusSummary?.totalDevices ??
        devices.length;
    final online = totals?.online ??
        statusSummary?.onlineCount ??
        devices.where((d) => d.isMonitoringEnabled && d.status == 'ONLINE').length;
    final alerts = totals?.alerting ??
        statusSummary?.alertingCount ??
        devices.where((d) => d.isMonitoringEnabled && d.status == 'ALERT').length;
    final disabled = totals?.disabled ??
        devices.where((d) => !d.isMonitoringEnabled).length;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: AppColors.mediumShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            LucideIcons.cpu,
            total.toString(),
            'iot.summary_total'.tr(),
          ),
          _buildSummaryItem(
            LucideIcons.signal,
            online.toString(),
            'iot.summary_online'.tr(),
          ),
          _buildSummaryItem(
            LucideIcons.triangleAlert,
            alerts.toString(),
            'iot.summary_alerts'.tr(),
          ),
          _buildSummaryItem(
            LucideIcons.powerOff,
            disabled.toString(),
            'iot.summary_disabled'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.textOnPrimary, size: 18.sp),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            color: AppColors.surface,
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textOnPrimary.withValues(alpha: 0.85),
            fontSize: 9.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceCard(
    BuildContext context,
    IotDeviceModel device, {
    IotFleetAnalyticsEntity? fleet,
    IotStatusSummaryEntity? statusSummary,
  }) {
    final summaryRow = statusSummary?.rowFor(device.id);
    final liveStatus = summaryRow?.liveStatus ?? device.status;
    final fleetDevice = fleet?.devices.where((d) => d.id == device.id).firstOrNull;
    final statusMeta = _liveStatusMetaFromStatus(liveStatus, device.isMonitoringEnabled);
    final isDisabled = !device.isMonitoringEnabled;

    return Opacity(
      opacity: isDisabled ? 0.75 : 1,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () async {
            final refreshed = await context.push<bool>(
              '/iot-device/${device.id}',
              extra: {'name': device.name},
            );
            if (refreshed == true && context.mounted) {
              context.read<IotCubit>().getDevices();
            }
          },
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isDisabled ? AppColors.grey200 : AppColors.grey100,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: statusMeta.color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        statusMeta.icon,
                        color: statusMeta.color,
                        size: 16.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            device.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13.sp,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'iot.device_id_prefix'.tr(
                              namedArgs: {'deviceId': device.deviceId},
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(statusMeta),
                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        LucideIcons.ellipsisVertical,
                        size: 16.sp,
                        color: AppColors.grey500,
                      ),
                      onSelected: (value) {
                        if (value == 'delete') {
                          _confirmDeleteDevice(context, device);
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.trash2,
                                size: 16.sp,
                                color: AppColors.error,
                              ),
                              SizedBox(width: AppSpacing.sm),
                              Text(
                                'hapus'.tr(),
                                style: TextStyle(color: AppColors.error),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        device.isMonitoringEnabled
                            ? 'iot.monitoring_active_desc'.tr()
                            : 'iot.monitoring_inactive_desc'.tr(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Switch.adaptive(
                      value: device.isMonitoringEnabled,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (enabled) {
                        if (!enabled) {
                          _confirmDisableMonitoring(context, device);
                        } else {
                          context
                              .read<IotCubit>()
                              .setMonitoringEnabled(device.id, true);
                        }
                      },
                    ),
                  ],
                ),
                if (device.isMonitoringEnabled) ...[
                  SizedBox(height: 8.h),
                  if (fleetDevice != null && fleetDevice.sparkline.length >= 2) ...[
                    Row(
                      children: [
                        Text(
                          'iot.trend_24h'.tr(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: IotSparkline(
                            points: fleetDevice.sparkline,
                            color: statusMeta.color,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                  ],
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildSensorValue(
                            LucideIcons.thermometer,
                            '${device.lastTemp?.toStringAsFixed(1) ?? "--"}°C',
                            'iot.metric_temperature'.tr(),
                          ),
                        ),
                        Expanded(
                          child: _buildSensorValue(
                            LucideIcons.droplets,
                            '${device.lastHum?.toStringAsFixed(0) ?? "--"}%',
                            'iot.metric_humidity'.tr(),
                          ),
                        ),
                        Expanded(
                          child: _buildSensorValue(
                            LucideIcons.wind,
                            '${device.lastCo2?.toStringAsFixed(0) ?? "--"}',
                            'iot.metric_co2'.tr(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(_LiveStatusMeta meta) {
    return Container(
      margin: EdgeInsets.only(right: 2.w),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: meta.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        meta.label,
        style: TextStyle(
          color: meta.color,
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  _LiveStatusMeta _liveStatusMetaFromStatus(String status, bool monitoringEnabled) {
    if (!monitoringEnabled) {
      return _LiveStatusMeta(
        'iot.status_disabled'.tr(),
        AppColors.grey500,
        LucideIcons.powerOff,
      );
    }
    switch (status) {
      case 'ONLINE':
        return _LiveStatusMeta(
          'iot.status_online'.tr(),
          AppColors.success,
          LucideIcons.signal,
        );
      case 'ALERT':
        return _LiveStatusMeta(
          'iot.status_alert'.tr(),
          AppColors.error,
          LucideIcons.triangleAlert,
        );
      default:
        return _LiveStatusMeta(
          'iot.status_offline'.tr(),
          AppColors.warning,
          LucideIcons.wifiOff,
        );
    }
  }

  Widget _buildSensorValue(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary, size: 14.sp),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 12.sp,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 9.sp),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        children: [
          Icon(LucideIcons.cpu, size: 40.sp, color: AppColors.grey200),
          SizedBox(height: AppSpacing.sm),
          Text(
            'belum_ada_perangkat_terdaftar'.tr(),
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final isProError = message.contains('PRO') || message.contains('Langganan');

    if (isProError) {
      return ProRequiredPlaceholder(
        message: message,
        icon: LucideIcons.cpu,
        onRetryPressed: () => context.read<IotCubit>().getDevices(),
        onActionPressed: () => context.push('/iot-subscription'),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.info, size: 48.sp, color: AppColors.error),
          SizedBox(height: AppSpacing.md),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(message, textAlign: TextAlign.center),
          ),
          TextButton(
            onPressed: () => context.read<IotCubit>().getDevices(),
            child: Text('iot.retry'.tr()),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDisableMonitoring(
    BuildContext context,
    IotDeviceModel device,
  ) async {
    final confirmed = await showBisaConfirmDialog(
      context,
      title: 'iot.disable_confirm_title'.tr(),
      message: 'iot.disable_confirm_message'.tr(
        namedArgs: {'name': device.name},
      ),
      confirmText: 'iot.disable_confirm_action'.tr(),
      destructive: true,
    );
    if (confirmed == true && context.mounted) {
      context.read<IotCubit>().setMonitoringEnabled(device.id, false);
    }
  }

  Future<void> _confirmDeleteDevice(
    BuildContext context,
    IotDeviceModel device,
  ) async {
    final confirmed = await showBisaConfirmDialog(
      context,
      title: 'hapus_perangkat'.tr(),
      message: 'iot.delete_device_message'.tr(
        namedArgs: {'name': device.name},
      ),
      confirmText: 'hapus'.tr(),
      destructive: true,
    );
    if (confirmed == true && context.mounted) {
      context.read<IotCubit>().deleteDevice(device.id);
    }
  }

  void _showAddDeviceDialog(BuildContext context) {
    final idController = TextEditingController();
    final nameController = TextEditingController();

    showBisaFormDialog(
      context,
      title: 'tambah_perangkat_iot'.tr(),
      submitText: 'simpan'.tr(),
      fields: [
        CustomTextField(
          label: 'iot.add_device_id_label'.tr(),
          hint: 'iot.add_device_id_hint'.tr(),
          controller: idController,
          suffixIcon: IconButton(
            icon: const Icon(LucideIcons.qrCode),
            onPressed: () async {
              final scanned = await Navigator.push<String>(
                context,
                MaterialPageRoute(builder: (_) => const IotQrScanPage()),
              );
              if (scanned != null) {
                idController.text = scanned;
              }
            },
          ),
        ),
        SizedBox(height: AppSpacing.md12),
        CustomTextField(
          label: 'iot.add_device_name_label'.tr(),
          hint: 'iot.add_device_name_hint'.tr(),
          controller: nameController,
        ),
      ],
      onSubmit: () {
        if (idController.text.isEmpty) return false;
        context.read<IotCubit>().registerDevice(
              idController.text,
              nameController.text.isEmpty
                  ? 'iot.add_device_default_name'.tr()
                  : nameController.text,
            );
        return true;
      },
    );
  }
}

class _LiveStatusMeta {
  final String label;
  final Color color;
  final IconData icon;

  const _LiveStatusMeta(this.label, this.color, this.icon);
}
