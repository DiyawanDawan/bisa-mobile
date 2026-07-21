import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../data/datasources/rfq_remote_data_source.dart';

class RfqInboxPage extends StatefulWidget {
  const RfqInboxPage({super.key});

  @override
  State<RfqInboxPage> createState() => _RfqInboxPageState();
}

class _RfqInboxPageState extends State<RfqInboxPage> {
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
      final items = await _ds.listInbox();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(title: 'rfq.inbox_title'.tr()),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? Center(child: Text('rfq.inbox_empty'.tr()))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: EdgeInsets.all(16.w),
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (context, i) {
                      final r = _items[i];
                      final id = r['id']?.toString() ?? '';
                      final responded = ((r['responses'] as List?) ?? []).isNotEmpty;
                      return ListTile(
                        onTap: () async {
                          await context.push('/rfq/inbox/$id');
                          if (mounted) _load();
                        },
                        tileColor: AppColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        title: Text(
                          '${r['title']}',
                          style: AppTextStyles.body(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text('${r['quantity']} · ${r['productMode']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (responded)
                              Icon(
                                LucideIcons.circleCheck,
                                color: AppColors.success,
                                size: 18.sp,
                              ),
                            SizedBox(width: 6.w),
                            Icon(
                              LucideIcons.chevronRight,
                              color: AppColors.textHint,
                              size: 18.sp,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
