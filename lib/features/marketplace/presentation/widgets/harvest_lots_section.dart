import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/network/api_client.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';

/// Kelola jadwal panen produk hasil tani (supplier).
class HarvestLotsSection extends StatefulWidget {
  const HarvestLotsSection({super.key, required this.productId});

  final String productId;

  @override
  State<HarvestLotsSection> createState() => _HarvestLotsSectionState();
}

class _HarvestLotsSectionState extends State<HarvestLotsSection> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _lots = const [];
  bool _saving = false;

  final _seasonCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  DateTime? _harvestDate;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _seasonCtrl.dispose();
    _qtyCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  String? _apiMessage(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map) {
        final meta = data['meta'];
        if (meta is Map && meta['message'] != null) {
          return meta['message'].toString();
        }
        if (data['message'] != null) return data['message'].toString();
      }
      return e.message;
    }
    return e.toString();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await sl<ApiClient>().dio.get(
        '/harvest-lots/product/${widget.productId}',
      );
      final data = res.data;
      final list = data is Map && data['data'] is List
          ? (data['data'] as List)
          : data is List
              ? data
              : const [];
      setState(() {
        _lots = list
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      });
    } catch (e) {
      setState(() => _error = _apiMessage(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _harvestDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 3)),
    );
    if (picked != null) setState(() => _harvestDate = picked);
  }

  Future<void> _createLot() async {
    final qty = double.tryParse(_qtyCtrl.text.trim().replaceAll(',', '.'));
    if (_harvestDate == null || qty == null || qty <= 0) {
      setState(() => _error = 'marketplace.harvest_form_invalid'.tr());
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await sl<ApiClient>().dio.post(
        '/harvest-lots/product/${widget.productId}',
        data: {
          'expectedHarvestDate': _harvestDate!.toIso8601String(),
          'expectedQuantityTon': qty,
          if (_seasonCtrl.text.trim().isNotEmpty)
            'seasonLabel': _seasonCtrl.text.trim(),
          if (_notesCtrl.text.trim().isNotEmpty) 'notes': _notesCtrl.text.trim(),
        },
      );
      _seasonCtrl.clear();
      _qtyCtrl.clear();
      _notesCtrl.clear();
      _harvestDate = null;
      await _load();
    } catch (e) {
      setState(() => _error = _apiMessage(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd MMM yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.calendarDays, size: 18.sp, color: AppColors.primary),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'marketplace.harvest_schedule_title'.tr(),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            IconButton(
              onPressed: _loading ? null : _load,
              icon: Icon(LucideIcons.refreshCw, size: 18.sp),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          'marketplace.harvest_schedule_hint'.tr(),
          style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
        ),
        SizedBox(height: AppSpacing.md),
        if (_error != null)
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(
              _error!,
              style: TextStyle(fontSize: 12.sp, color: AppColors.error),
            ),
          ),
        if (_loading)
          const Center(child: CircularProgressIndicator())
        else if (_lots.isEmpty)
          Text(
            'marketplace.harvest_empty'.tr(),
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
          )
        else
          ..._lots.map((lot) {
            final dateRaw = lot['expectedHarvestDate']?.toString();
            final date = dateRaw != null ? DateTime.tryParse(dateRaw) : null;
            final qty = lot['expectedQuantityTon'];
            final status = lot['status']?.toString() ?? '';
            final season = lot['seasonLabel']?.toString();
            return Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (season != null && season.isNotEmpty)
                        ? season
                        : 'marketplace.harvest_lot_default'.tr(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${date != null ? dateFmt.format(date) : '—'} · $qty ton · $status',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }),
        Divider(height: AppSpacing.lg),
        Text(
          'marketplace.harvest_add_title'.tr(),
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: AppSpacing.sm),
        CustomTextField(
          label: 'marketplace.harvest_season_label'.tr(),
          hint: 'marketplace.harvest_season_hint'.tr(),
          controller: _seasonCtrl,
          isOptional: true,
        ),
        SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: _pickDate,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'marketplace.harvest_date_label'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            child: Text(
              _harvestDate != null
                  ? dateFmt.format(_harvestDate!)
                  : 'marketplace.harvest_date_hint'.tr(),
              style: TextStyle(
                fontSize: 13.sp,
                color: _harvestDate != null
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        CustomTextField(
          label: 'marketplace.harvest_qty_label'.tr(),
          hint: '0.5',
          controller: _qtyCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          isRequired: true,
        ),
        SizedBox(height: AppSpacing.sm),
        CustomTextField(
          label: 'marketplace.harvest_notes_label'.tr(),
          hint: 'marketplace.harvest_notes_hint'.tr(),
          controller: _notesCtrl,
          isOptional: true,
        ),
        SizedBox(height: AppSpacing.md),
        CustomButton(
          text: 'marketplace.harvest_add_cta'.tr(),
          onPressed: _saving ? null : _createLot,
          isLoading: _saving,
          height: AppSpacing.buttonHeight,
        ),
      ],
    );
  }
}
