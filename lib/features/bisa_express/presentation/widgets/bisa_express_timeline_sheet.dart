import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/features/bisa_express/data/datasources/bisa_express_remote_data_source.dart';
import 'package:mobile_bisa/features/bisa_express/data/models/bisa_express_track.dart';
import 'package:mobile_bisa/injection_container.dart';

/// Bottom sheet timeline status BISA Express dari AWB.
class BisaExpressTimelineSheet extends StatefulWidget {
  final String awb;

  const BisaExpressTimelineSheet({super.key, required this.awb});

  static Future<void> show(BuildContext context, {required String awb}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => BisaExpressTimelineSheet(awb: awb),
    );
  }

  @override
  State<BisaExpressTimelineSheet> createState() =>
      _BisaExpressTimelineSheetState();
}

class _BisaExpressTimelineSheetState extends State<BisaExpressTimelineSheet> {
  bool _loading = true;
  String? _error;
  BisaExpressTrackResult? _track;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final track = await sl<BisaExpressRemoteDataSource>().trackByAwb(widget.awb);
      if (!mounted) return;
      setState(() {
        _track = track;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'orders.bisa_express_timeline_failed'.tr();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          bottom + AppSpacing.md,
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.72,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'orders.bisa_express_timeline_title'.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          widget.awb,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'monospace',
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _loading ? null : _load,
                    icon: Icon(LucideIcons.refreshCcw, size: 18.sp),
                    color: AppColors.primary,
                  ),
                ],
              ),
              if (_track != null) ...[
                SizedBox(height: AppSpacing.sm),
                Text(
                  _statusLabel(_track!.status),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
              SizedBox(height: AppSpacing.md),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: AppSpacing.md),
            TextButton(onPressed: _load, child: Text('coba_lagi'.tr())),
          ],
        ),
      );
    }
    final logs = _track?.statusLogs ?? const [];
    if (logs.isEmpty) {
      return Center(
        child: Text(
          'orders.bisa_express_timeline_empty'.tr(),
          style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[logs.length - 1 - index];
        final isLatest = index == 0;
        return _TimelineTile(
          log: log,
          isLatest: isLatest,
          isLast: index == logs.length - 1,
        );
      },
    );
  }

  String _statusLabel(String status) {
    final key = 'orders.bisa_express_status.$status';
    final translated = key.tr();
    return translated == key ? status.replaceAll('_', ' ') : translated;
  }
}

class _TimelineTile extends StatelessWidget {
  final BisaExpressStatusLog log;
  final bool isLatest;
  final bool isLast;

  const _TimelineTile({
    required this.log,
    required this.isLatest,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final time = log.createdAt != null
        ? DateFormat('dd MMM yyyy, HH:mm').format(log.createdAt!.toLocal())
        : '—';
    final statusText = () {
      final key = 'orders.bisa_express_status.${log.status}';
      final t = key.tr();
      return t == key ? log.status.replaceAll('_', ' ') : t;
    }();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28.w,
            child: Column(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLatest ? AppColors.primary : AppColors.grey300,
                    border: Border.all(
                      color: isLatest ? AppColors.primary : AppColors.grey300,
                      width: 2,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2.w,
                      margin: EdgeInsets.symmetric(vertical: 2.h),
                      color: AppColors.grey200,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: isLatest ? FontWeight.w800 : FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (log.description.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      log.description,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                  if (log.location != null && log.location!.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      log.location!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  SizedBox(height: 2.h),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
