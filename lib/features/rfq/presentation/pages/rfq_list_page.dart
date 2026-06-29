import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: 'rfq.list_title'.tr(),
        actions: [
          IconButton(
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
          : _items.isEmpty
              ? Center(child: Text('rfq.empty'.tr()))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: EdgeInsets.all(16.w),
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (context, i) {
                      final r = _items[i];
                      final responses = (r['responses'] as List?)?.length ?? 0;
                      return ListTile(
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
                            'status': '${r['status']}',
                            'responses': '$responses',
                          }),
                        ),
                        trailing: const Icon(LucideIcons.chevronRight),
                      );
                    },
                  ),
                ),
    );
  }
}
