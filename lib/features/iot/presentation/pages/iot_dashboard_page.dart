import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
      title: 'Smart Monitoring IoT',
      lockedMessage:
          'Monitoring IoT Smart Farm khusus langganan PRO. Upgrade untuk pantau sensor gudang secara real-time.',
      child: BlocProvider(
        create: (context) => sl<IotCubit>()..getDevices(),
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: const BisaAppBar(
            title: 'Smart Monitoring IoT',
            backgroundColor: AppColors.surface,
          ),
          body: BlocBuilder<IotCubit, IotState>(
            builder: (context, state) {
              return state.maybeWhen(
                loading: () => Padding(
                  padding: EdgeInsets.all(20.w),
                  child: const ShimmerListPlaceholder(),
                ),
                error: (message) => _buildErrorState(context, message),
                loaded: (devices, fleet, statusSummary) => RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async => context.read<IotCubit>().getDevices(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoBanner(),
                        SizedBox(height: 16.h),
                        _buildSummaryCard(devices, fleet, statusSummary),
                        SizedBox(height: 24.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Perangkat Anda',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _showAddDeviceDialog(context),
                              icon: Icon(
                                LucideIcons.plus,
                                size: 16.sp,
                                color: AppColors.primary,
                              ),
                              label: Text(
                                'tambah'.tr(),
                                style: TextStyle(color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        if (devices.isEmpty)
                          _buildEmptyState()
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: devices.length,
                            separatorBuilder: (_, __) => SizedBox(height: 12.h),
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
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.warning.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.shieldAlert, color: AppColors.warning, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Nonaktifkan monitoring jika produksi sudah berhenti. '
              'Perangkat yang tetap aktif dapat memicu peringatan bahaya.',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
                height: 1.4,
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
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: AppColors.mediumShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            LucideIcons.cpu,
            total.toString(),
            'Total',
          ),
          _buildSummaryItem(LucideIcons.signal, online.toString(), 'Online'),
          _buildSummaryItem(
            LucideIcons.triangleAlert,
            alerts.toString(),
            'Peringatan',
          ),
          _buildSummaryItem(
            LucideIcons.powerOff,
            disabled.toString(),
            'Nonaktif',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.white, size: 22.sp),
        SizedBox(height: 6.h),
        Text(
          value,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.white.withOpacity(0.85),
            fontSize: 10.sp,
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
      opacity: isDisabled ? 0.72 : 1,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
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
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isDisabled ? AppColors.grey200 : AppColors.grey100,
              ),
              boxShadow: isDisabled ? null : AppColors.softShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: statusMeta.color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        statusMeta.icon,
                        color: statusMeta.color,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            device.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'ID: ${device.deviceId}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(statusMeta),
                    PopupMenuButton<String>(
                      icon: Icon(
                        LucideIcons.ellipsisVertical,
                        size: 18.sp,
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
                              SizedBox(width: 8.w),
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
                SizedBox(height: 14.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Monitoring',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              device.isMonitoringEnabled
                                  ? 'Aktif — menerima data & peringatan'
                                  : 'Nonaktif — tidak ada peringatan',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: device.isMonitoringEnabled,
                        activeColor: AppColors.primary,
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
                ),
                if (device.isMonitoringEnabled) ...[
                  SizedBox(height: 14.h),
                  const Divider(height: 1, color: AppColors.grey100),
                  SizedBox(height: 14.h),
                  if (fleetDevice != null && fleetDevice.sparkline.length >= 2)
                    Row(
                      children: [
                        Text(
                          'Trend 24j',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        IotSparkline(
                          points: fleetDevice.sparkline,
                          color: statusMeta.color,
                        ),
                      ],
                    ),
                  if (fleetDevice != null && fleetDevice.sparkline.length >= 2)
                    SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSensorValue(
                        LucideIcons.thermometer,
                        '${device.lastTemp?.toStringAsFixed(1) ?? "--"}°C',
                        'Suhu',
                      ),
                      _buildSensorValue(
                        LucideIcons.droplets,
                        '${device.lastHum?.toStringAsFixed(0) ?? "--"}%',
                        'Kelembaban',
                      ),
                      _buildSensorValue(
                        LucideIcons.wind,
                        '${device.lastCo2?.toStringAsFixed(0) ?? "--"} ppm',
                        'CO2',
                      ),
                    ],
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
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: meta.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        meta.label,
        style: TextStyle(
          color: meta.color,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  _LiveStatusMeta _liveStatusMetaFromStatus(String status, bool monitoringEnabled) {
    if (!monitoringEnabled) {
      return _LiveStatusMeta('Nonaktif', AppColors.grey500, LucideIcons.powerOff);
    }
    switch (status) {
      case 'ONLINE':
        return _LiveStatusMeta('Online', AppColors.success, LucideIcons.signal);
      case 'ALERT':
        return _LiveStatusMeta(
          'Peringatan',
          AppColors.error,
          LucideIcons.triangleAlert,
        );
      default:
        return _LiveStatusMeta('Offline', AppColors.warning, LucideIcons.wifiOff);
    }
  }

  Widget _buildSensorValue(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 18.sp),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 10.sp),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Column(
          children: [
            Icon(LucideIcons.cpu, size: 64.sp, color: AppColors.grey200),
            SizedBox(height: 16.h),
            Text(
              'belum_ada_perangkat_terdaftar'.tr(),
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
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
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(message, textAlign: TextAlign.center),
          ),
          TextButton(
            onPressed: () => context.read<IotCubit>().getDevices(),
            child: Text('coba_lagi'.tr()),
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
      title: 'Nonaktifkan Monitoring?',
      message:
          'Perangkat "${device.name}" tidak akan lagi menerima data sensor '
          'atau mengirim peringatan bahaya. Aktifkan kembali saat produksi dimulai.',
      confirmText: 'Nonaktifkan',
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
      message:
          'Hapus "${device.name}" secara permanen? Riwayat sensor dan peringatan ikut terhapus.',
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
          label: 'Device ID (Hardware)',
          hint: 'Scan atau ketik ID',
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
        SizedBox(height: 12.h),
        CustomTextField(
          label: 'Nama Perangkat',
          hint: 'Gudang A, dsb',
          controller: nameController,
        ),
      ],
      onSubmit: () {
        if (idController.text.isEmpty) return false;
        context.read<IotCubit>().registerDevice(
              idController.text,
              nameController.text.isEmpty
                  ? 'Perangkat Baru'
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
