import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../marketplace/data/datasources/marketplace_remote_data_source.dart';
import '../../../marketplace/data/models/product_model.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../data/datasources/stretch_remote_data_source.dart';

class LiveCommercePage extends StatefulWidget {
  const LiveCommercePage({super.key});

  @override
  State<LiveCommercePage> createState() => _LiveCommercePageState();
}

class _LiveCommercePageState extends State<LiveCommercePage> {
  List<Map<String, dynamic>> _sessions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _sessions = await sl<StretchRemoteDataSource>().listLiveSessions();
    } catch (_) {
      _sessions = [];
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSupplier = context.watch<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u.role == 'SUPPLIER',
          orElse: () => false,
        );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(title: 'live.title'.tr(), backgroundColor: AppColors.surface),
      floatingActionButton: isSupplier
          ? FloatingActionButton.extended(
              onPressed: () => _createSession(context),
              icon: Icon(LucideIcons.radio, size: 18.sp),
              label: Text('live.create'.tr()),
            )
          : null,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _sessions.isEmpty
              ? Center(child: Text('live.empty'.tr(), style: TextStyle(color: AppColors.textSecondary)))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: EdgeInsets.all(AppSpacing.md),
                    itemCount: _sessions.length,
                    separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm10),
                    itemBuilder: (context, i) => _sessionTile(_sessions[i]),
                  ),
                ),
    );
  }

  Widget _sessionTile(Map<String, dynamic> s) {
    final status = s['status']?.toString() ?? 'SCHEDULED';
    final isLive = status == 'LIVE';
    return ListTile(
      tileColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.tile)),
      leading: CircleAvatar(
        backgroundColor: isLive ? AppColors.error : AppColors.grey100,
        child: Icon(LucideIcons.radio, color: isLive ? AppColors.surface : AppColors.textSecondary, size: 18.sp),
      ),
      title: Text(s['title']?.toString() ?? '—', style: TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(
        isLive
            ? 'live.status_live'.tr(namedArgs: {'count': '${s['viewerCount'] ?? 0}'})
            : 'live.status_scheduled'.tr(),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push('/live/${s['id']}'),
    );
  }

  Future<void> _createSession(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.pill))),
      builder: (ctx) => const _LiveCreateSheet(),
    );
    if (result == null || !mounted) return;

    try {
      final created = await sl<StretchRemoteDataSource>().createLiveSession(result);
      await sl<StretchRemoteDataSource>().startLiveSession(created['id'].toString());
      await _load();
      if (mounted) context.push('/live/${created['id']}');
    } catch (_) {
      if (mounted) {
        showErrorSnackBar(context, 'errors.generic');
      }
    }
  }
}

class _LiveCreateSheet extends StatefulWidget {
  const _LiveCreateSheet();

  @override
  State<_LiveCreateSheet> createState() => _LiveCreateSheetState();
}

class _LiveCreateSheetState extends State<_LiveCreateSheet> {
  final _titleCtrl = TextEditingController();
  final _streamCtrl = TextEditingController();
  List<ProductModel> _products = [];
  final _selectedIds = <String>{};
  bool _loadingProducts = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _streamCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    try {
      final list = await sl<MarketplaceRemoteDataSource>().getMyProducts(
        status: 'ACTIVE',
        limit: 50,
      );
      if (mounted) {
        setState(() {
          _products = list;
          _loadingProducts = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingProducts = false);
    }
  }

  void _submit() {
    final title = _titleCtrl.text.trim();
    if (title.length < 3) return;
    Navigator.pop(context, {
      'title': title,
      if (_streamCtrl.text.trim().isNotEmpty) 'streamUrl': _streamCtrl.text.trim(),
      if (_selectedIds.isNotEmpty) 'pinnedProductIds': _selectedIds.toList(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('live.create_title'.tr(), style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800)),
          SizedBox(height: 6.h),
          Text('live.create_hint'.tr(), style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
          SizedBox(height: AppSpacing.md),
          TextField(
            controller: _titleCtrl,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'live.create_title'.tr(),
              hintText: 'live.create_hint'.tr(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
            ),
          ),
          SizedBox(height: AppSpacing.md12),
          TextField(
            controller: _streamCtrl,
            decoration: InputDecoration(
              labelText: 'live.field_stream_url'.tr(),
              hintText: 'live.field_stream_hint'.tr(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
            ),
            keyboardType: TextInputType.url,
          ),
          SizedBox(height: AppSpacing.md),
          Text('live.field_products'.tr(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.sp)),
          SizedBox(height: 4.h),
          Text('live.field_products_hint'.tr(), style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
          SizedBox(height: AppSpacing.sm),
          if (_loadingProducts)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_products.isEmpty)
            Text('live.no_products'.tr(), style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary))
          else
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 180.h),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _products.length,
                itemBuilder: (context, i) {
                  final p = _products[i];
                  final checked = _selectedIds.contains(p.id);
                  return CheckboxListTile(
                    value: checked,
                    onChanged: (v) {
                      setState(() {
                        if (v == true) {
                          if (_selectedIds.length < 5) _selectedIds.add(p.id);
                        } else {
                          _selectedIds.remove(p.id);
                        }
                      });
                    },
                    title: Text(p.name, style: TextStyle(fontSize: 13.sp)),
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                },
              ),
            ),
          SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: _titleCtrl.text.trim().length >= 3 ? _submit : null,
            child: Text('live.create'.tr()),
          ),
        ],
      ),
    );
  }
}
