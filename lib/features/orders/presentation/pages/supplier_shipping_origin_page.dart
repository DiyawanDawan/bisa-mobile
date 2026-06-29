import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/app_feedback.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';
import '../bloc/order_cubit.dart';

class SupplierShippingOriginPage extends StatefulWidget {
  const SupplierShippingOriginPage({super.key});

  @override
  State<SupplierShippingOriginPage> createState() =>
      _SupplierShippingOriginPageState();
}

class _SupplierShippingOriginPageState extends State<SupplierShippingOriginPage> {
  late final OrderCubit _orderCubit;
  final _queryController = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  Map<String, dynamic>? _selected;
  Map<String, dynamic>? _stored;
  bool _loading = false;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _orderCubit = sl<OrderCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadStored());
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _loadStored() async {
    setState(() => _loading = true);
    final stored = await _orderCubit.getShippingOrigin();
    if (!mounted) return;
    setState(() {
      _stored = stored;
      _loading = false;
      if (stored != null) {
        _selected = {
          'id': stored['originId'],
          'label': stored['originLabel'],
        };
      }
    });
  }

  Future<void> _search() async {
    final query = _queryController.text.trim();
    if (query.length < 3) {
      setState(() => _error = 'orders.shipping_origin_min_chars'.tr());
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await _orderCubit.searchShippingDestinations(search: query, limit: 15);
    if (!mounted) return;

    if (result.quotaExceeded) {
      setState(() {
        _loading = false;
        _error = result.errorMessage ?? 'orders.shipping_origin_quota_exceeded'.tr();
      });
      return;
    }

    setState(() {
      _loading = false;
      _results = result.items;
      if (_results.isEmpty) {
        _error = 'orders.shipping_origin_not_found'.tr();
      }
    });
  }

  Future<void> _save() async {
    final id = int.tryParse(_selected?['id']?.toString() ?? '');
    if (id == null) {
      setState(() => _error = 'orders.shipping_origin_select_first'.tr());
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    final ok = await _orderCubit.setShippingOrigin(
      originId: id,
      originLabel: _selected?['label']?.toString(),
    );

    if (!mounted) return;
    setState(() => _saving = false);

    if (!ok) {
      setState(() => _error = 'orders.shipping_origin_save_failed'.tr());
      return;
    }

    showSuccessSnackBar(context, 'orders.shipping_origin_save_success');
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: 'orders.shipping_origin_title'.tr(),
        showBackButton: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'orders.shipping_origin_description'.tr(),
            style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: AppSpacing.md12),
          if (_stored != null) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacing.md12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Text(
                'orders.shipping_origin_current'.tr(namedArgs: {
                  'label': '${_stored?['originLabel'] ?? _stored?['originId']}',
                }),
                style: TextStyle(fontSize: 12.sp, color: AppColors.primary),
              ),
            ),
            SizedBox(height: AppSpacing.md12),
          ],
          TextField(
            controller: _queryController,
            decoration: InputDecoration(
              hintText: 'orders.shipping_origin_search_hint'.tr(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: _loading ? null : _search,
              ),
            ),
            onSubmitted: (_) => _search(),
          ),
          if (_error != null) ...[
            SizedBox(height: AppSpacing.sm),
            Text(_error!, style: TextStyle(color: AppColors.error, fontSize: 12.sp)),
          ],
          SizedBox(height: AppSpacing.md12),
          ..._results.map(
            (item) => RadioListTile<Map<String, dynamic>>(
              value: item,
              groupValue: _selected,
              onChanged: (value) => setState(() => _selected = value),
              title: Text(item['label']?.toString() ?? item['id']?.toString() ?? ''),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          CustomButton(
            text: 'orders.shipping_origin_save_button'.tr(),
            height: 48.h,
            useGradient: true,
            isLoading: _saving,
            onPressed: _saving ? null : _save,
          ),
        ],
      ),
    );
  }
}
