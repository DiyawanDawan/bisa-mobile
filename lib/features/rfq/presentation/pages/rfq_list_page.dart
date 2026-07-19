import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../data/datasources/rfq_remote_data_source.dart';

class RfqListPage extends StatefulWidget {
  const RfqListPage({super.key});

  @override
  State<RfqListPage> createState() => _RfqListPageState();
}

class _RfqListPageState extends State<RfqListPage> {
  final _ds = RfqRemoteDataSource();
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final items = await _ds.listMyRfqs();
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  String _statusLabel(String? raw) {
    switch ((raw ?? '').toUpperCase()) {
      case 'OPEN':
        return 'rfq.status_open'.tr();
      case 'CLOSED':
        return 'rfq.status_closed'.tr();
      case 'CANCELLED':
        return 'rfq.status_cancelled'.tr();
      default:
        return raw ?? '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: 'rfq.list_title'.tr(),
        actions: [
          IconButton(
            tooltip: 'rfq.create_title'.tr(),
            onPressed: () async {
              final ok = await context.push<bool>('/rfq/create');
              if (ok == true) _load();
            },
            icon: Icon(LucideIcons.plus, size: 22.sp),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  _introCard(),
                  SizedBox(height: AppSpacing.md12),
                  if (_items.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 48.h),
                      child: Column(
                        children: [
                          Icon(
                            LucideIcons.fileText,
                            size: 40.sp,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: AppSpacing.sm),
                          Text(
                            'rfq.empty'.tr(),
                            style: AppTextStyles.body(fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'rfq.empty_hint'.tr(),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.caption(),
                          ),
                          SizedBox(height: AppSpacing.md),
                          FilledButton.icon(
                            onPressed: () async {
                              final ok = await context.push<bool>('/rfq/create');
                              if (ok == true) _load();
                            },
                            icon: const Icon(LucideIcons.plus),
                            label: Text('rfq.create_title'.tr()),
                          ),
                        ],
                      ),
                    )
                  else
                    ..._items.map((r) {
                      final id = r['id']?.toString() ?? '';
                      final responses = (r['responses'] as List?)?.length ?? 0;
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: ListTile(
                          onTap: id.isEmpty
                              ? null
                              : () => context.push('/rfq/$id'),
                          tileColor: AppColors.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          title: Text(
                            '${r['title']}',
                            style: AppTextStyles.body(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            'rfq.list_meta'.tr(namedArgs: {
                              'status': _statusLabel(r['status']?.toString()),
                              'responses': '$responses',
                            }),
                          ),
                          trailing: const Icon(LucideIcons.chevronRight),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }

  Widget _introCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'rfq.what_is_title'.tr(),
            style: AppTextStyles.bodySm(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 4.h),
          Text(
            'rfq.what_is_body'.tr(),
            style: AppTextStyles.caption(height: 1.45),
          ),
        ],
      ),
    );
  }
}
