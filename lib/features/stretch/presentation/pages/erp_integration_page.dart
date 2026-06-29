import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../data/datasources/stretch_remote_data_source.dart';

class ErpIntegrationPage extends StatefulWidget {
  const ErpIntegrationPage({super.key});

  @override
  State<ErpIntegrationPage> createState() => _ErpIntegrationPageState();
}

class _ErpIntegrationPageState extends State<ErpIntegrationPage> {
  List<Map<String, dynamic>> _keys = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _keys = await sl<StretchRemoteDataSource>().listErpKeys();
    } catch (_) {
      _keys = [];
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _createKey() async {
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final ctrl = TextEditingController(text: 'ERP Warehouse');
        return AlertDialog(
          title: Text('erp.create_key_title'.tr()),
          content: TextField(
            controller: ctrl,
            decoration: InputDecoration(hintText: 'erp.key_name_hint'.tr()),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('cancel'.tr())),
            TextButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
              child: Text('erp.create'.tr()),
            ),
          ],
        );
      },
    );
    if (name == null || name.isEmpty || !mounted) return;
    try {
      final created = await sl<StretchRemoteDataSource>().createErpKey(name);
      final apiKey = created['apiKey']?.toString() ?? '';
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('erp.key_created_title'.tr()),
          content: SelectableText(apiKey),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: apiKey));
                Navigator.pop(ctx);
              },
              child: Text('erp.copy_key'.tr()),
            ),
          ],
        ),
      );
      await _load();
    } catch (_) {
      if (mounted) {
        showErrorSnackBar(context, 'errors.generic');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(title: 'erp.title'.tr(), backgroundColor: AppColors.surface),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(AppSpacing.md),
              children: [
                Text('erp.intro'.tr(), style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary, height: 1.45)),
                SizedBox(height: AppSpacing.sm),
                Text('erp.endpoint_inventory'.tr(), style: TextStyle(fontSize: 11.sp, fontFamily: 'monospace')),
                Text('erp.endpoint_products'.tr(), style: TextStyle(fontSize: 11.sp, fontFamily: 'monospace')),
                SizedBox(height: AppSpacing.md),
                CustomButton(text: 'erp.create_key'.tr(), icon: LucideIcons.key, useGradient: true, onPressed: _createKey),
                SizedBox(height: AppSpacing.md),
                Text('erp.keys_title'.tr(), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.sp)),
                SizedBox(height: AppSpacing.sm),
                if (_keys.isEmpty)
                  Text('erp.no_keys'.tr(), style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp))
                else
                  ..._keys.map(_keyTile),
              ],
            ),
    );
  }

  Widget _keyTile(Map<String, dynamic> key) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(key['name']?.toString() ?? '—'),
      subtitle: Text('${key['keyPrefix']}… · ${key['isActive'] == false ? 'erp.revoked'.tr() : 'erp.active'.tr()}'),
      trailing: key['isActive'] != false
          ? IconButton(
              icon: Icon(LucideIcons.trash2, color: AppColors.error, size: 18.sp),
              onPressed: () async {
                await sl<StretchRemoteDataSource>().revokeErpKey(key['id'].toString());
                await _load();
              },
            )
          : null,
    );
  }
}
