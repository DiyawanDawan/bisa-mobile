import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/app_feedback.dart';
import 'package:mobile_bisa/features/invoice/domain/entities/invoice_draft.dart';
import 'package:mobile_bisa/features/invoice/presentation/bloc/create_invoice_cubit.dart';
import 'package:mobile_bisa/shared/widgets/osm_location_picker_page.dart';
import 'invoice_shipping_edit_card.dart';

class _BuyerAddressOption {
  const _BuyerAddressOption({
    required this.key,
    required this.label,
    required this.snapshot,
    required this.isPrimary,
    required this.isDefault,
  });

  final String key;
  final String label;
  final Map<String, dynamic> snapshot;
  final bool isPrimary;
  final bool isDefault;

  String get subtitle {
    final parts = <String>[
      snapshot['address']?.toString() ?? '',
      [
        snapshot['regency']?.toString(),
        snapshot['province']?.toString(),
      ].where((e) => e != null && e.trim().isNotEmpty).join(', '),
    ].where((e) => e.trim().isNotEmpty);
    return parts.join(' · ');
  }
}

/// Alamat penerima: pilih dari daftar (utama / default / lainnya) atau kustom + GIS.
class InvoiceBuyerShippingPanel extends StatefulWidget {
  const InvoiceBuyerShippingPanel({
    super.key,
    required this.negotiationId,
    required this.draft,
    required this.onDraftChanged,
    this.readOnly = false,
  });

  final String negotiationId;
  final InvoiceDraft draft;
  final ValueChanged<InvoiceDraft> onDraftChanged;
  final bool readOnly;

  @override
  State<InvoiceBuyerShippingPanel> createState() =>
      _InvoiceBuyerShippingPanelState();
}

class _InvoiceBuyerShippingPanelState extends State<InvoiceBuyerShippingPanel> {
  List<_BuyerAddressOption> _options = [];
  bool _loadingAddresses = false;
  String? _selectedKey;

  @override
  void initState() {
    super.initState();
    _selectedKey = _keyForDraft(widget.draft);
    if (!widget.readOnly) {
      _loadAddressOptions();
    }
  }

  @override
  void didUpdateWidget(InvoiceBuyerShippingPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.draft.customerAddressId != widget.draft.customerAddressId ||
        oldWidget.draft.source != widget.draft.source ||
        oldWidget.draft.address != widget.draft.address) {
      _selectedKey = _keyForDraft(widget.draft);
    }
  }

  String? _keyForDraft(InvoiceDraft d) {
    if (d.customerAddressId != null && d.customerAddressId!.isNotEmpty) {
      return d.customerAddressId;
    }
    if (d.source == 'buyer_profile') return 'profile';
    if (d.source == 'custom') return 'custom';
    return null;
  }

  Future<void> _loadAddressOptions() async {
    setState(() => _loadingAddresses = true);
    final cubit = context.read<CreateInvoiceCubit>();
    final data = await cubit.fetchBuyerShippingAddresses(widget.negotiationId);
    if (!mounted) return;

    final options = <_BuyerAddressOption>[];
    if (data != null) {
      final unified = data['addresses'] as List?;
      if (unified != null && unified.isNotEmpty) {
        for (final row in unified) {
          if (row is! Map) continue;
          final snap = row['snapshot'];
          if (snap is! Map) continue;
          options.add(
            _BuyerAddressOption(
              key: row['key']?.toString() ?? '',
              label: row['label']?.toString() ?? 'invoice.address_unnamed'.tr(),
              snapshot: Map<String, dynamic>.from(snap),
              isPrimary: row['isPrimary'] == true,
              isDefault: row['isDefault'] == true,
            ),
          );
        }
      } else {
        options.addAll(_legacyOptionsFromData(data));
      }
    }

    setState(() {
      _options = options;
      _loadingAddresses = false;
      if (_selectedKey == null && options.isNotEmpty) {
        final def = options.firstWhere(
          (o) => o.isDefault,
          orElse: () => options.first,
        );
        _selectedKey = def.key;
      }
    });
  }

  List<_BuyerAddressOption> _legacyOptionsFromData(Map<String, dynamic> data) {
    final options = <_BuyerAddressOption>[];
    final profile = data['profileAddress'];
    if (profile is Map && profile['address']?.toString().isNotEmpty == true) {
      final def = data['defaultSnapshot'];
      options.add(
        _BuyerAddressOption(
          key: 'profile',
          label: 'invoice.buyer_address_profile'.tr(),
          snapshot: Map<String, dynamic>.from(profile),
          isPrimary: false,
          isDefault: def is Map && _snapMatch(profile, def),
        ),
      );
    }
    final saved = data['savedAddresses'] as List? ?? [];
    final def = data['defaultSnapshot'];
    for (final row in saved) {
      if (row is! Map) continue;
      final snap = row['snapshot'];
      if (snap is! Map) continue;
      final id = row['id']?.toString() ?? '';
      options.add(
        _BuyerAddressOption(
          key: id,
          label: row['label']?.toString() ?? 'invoice.address_unnamed'.tr(),
          snapshot: Map<String, dynamic>.from(snap),
          isPrimary: row['isPrimary'] == true,
          isDefault: def is Map && _snapMatch(snap, def),
        ),
      );
    }
    options.sort((a, b) {
      if (a.isDefault != b.isDefault) return a.isDefault ? -1 : 1;
      if (a.isPrimary != b.isPrimary) return a.isPrimary ? -1 : 1;
      return a.label.compareTo(b.label);
    });
    return options;
  }

  bool _snapMatch(Map a, Map b) {
    final idA = a['customerAddressId']?.toString();
    final idB = b['customerAddressId']?.toString();
    if (idA != null && idB != null && idA == idB) return true;
    return (a['address']?.toString().trim() ?? '') ==
            (b['address']?.toString().trim() ?? '') &&
        (a['regency']?.toString() ?? '') == (b['regency']?.toString() ?? '');
  }

  bool _isSelected(_BuyerAddressOption opt) {
    if (_selectedKey != null) return _selectedKey == opt.key;
    return _snapMatch(widget.draft.toShippingSnapshot(), opt.snapshot);
  }

  Future<void> _applyOption(_BuyerAddressOption opt) async {
    final cubit = context.read<CreateInvoiceCubit>();
    cubit.applyShippingSnapshot(opt.snapshot);
    final next = cubit.state.draft ?? widget.draft;
    setState(() => _selectedKey = opt.key);
    widget.onDraftChanged(next);
    await cubit.refreshPreview(widget.negotiationId);
    if (!mounted) return;
    showCustomSnackBar(
      context,
      content: Text(
        'invoice.address_selected'.tr(namedArgs: {'label': opt.label}),
      ),
      backgroundColor: AppColors.secondary,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> _showAllAddressesSheet() async {
    if (_options.isEmpty) {
      await _loadAddressOptions();
    }
    if (!mounted) return;
    if (_options.isEmpty) {
      showWarningSnackBar(context, 'invoice.buyer_no_saved_address');
      return;
    }

    final picked = await showModalBottomSheet<_BuyerAddressOption>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        final bottom = MediaQuery.paddingOf(ctx).bottom;
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.55,
          minChildSize: 0.35,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, bottom + 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColors.grey200,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'invoice.buyer_pick_address'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'invoice.buyer_address_legend'.tr(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textHint,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: _options.length,
                      separatorBuilder: (_, __) => SizedBox(height: 8.h),
                      itemBuilder: (_, i) {
                        final opt = _options[i];
                        final selected = _isSelected(opt);
                        return _AddressPickTile(
                          option: opt,
                          selected: selected,
                          onTap: () => Navigator.pop(ctx, opt),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (picked != null) await _applyOption(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!widget.readOnly) ...[
          _buildSourceHint(widget.draft),
          SizedBox(height: 10.h),
          _buildAddressPickerHeader(context),
          if (_loadingAddresses)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else if (_options.isNotEmpty) ...[
            SizedBox(height: 10.h),
            _buildQuickPickList(),
          ],
          SizedBox(height: 10.h),
          _buildActionRow(context),
          SizedBox(height: 12.h),
        ],
        InvoiceShippingEditCard(
          draft: widget.draft,
          readOnly: widget.readOnly,
          onChanged: widget.readOnly ? null : widget.onDraftChanged,
          hintText: 'invoice.buyer_address_edit_hint'.tr(),
        ),
      ],
    );
  }

  Widget _buildAddressPickerHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'invoice.buyer_address_list_title'.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: _showAllAddressesSheet,
          icon: Icon(Icons.swap_horiz, size: 18.sp),
          label: Text(
            'invoice.buyer_change_address'.tr(),
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickPickList() {
    final visible = _options.length > 4 ? _options.take(4).toList() : _options;
    return Column(
      children: [
        ...visible.map((opt) {
          final selected = _isSelected(opt);
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _AddressPickTile(
              option: opt,
              selected: selected,
              compact: true,
              onTap: () => _applyOption(opt),
            ),
          );
        }),
        if (_options.length > 4)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: _showAllAddressesSheet,
              child: Text(
                '+${_options.length - 4} alamat lainnya',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.sp),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSourceHint(InvoiceDraft draft) {
    final label = switch (draft.source) {
      'buyer_saved_address' => 'invoice.shipping_source_saved'.tr(),
      'buyer_profile' => 'invoice.shipping_source_profile'.tr(),
      'custom' => 'invoice.shipping_source_custom'.tr(),
      _ => 'invoice.shipping_source_default'.tr(),
    };
    final hasGis = draft.latitude != null &&
        draft.longitude != null &&
        (draft.latitude != 0 || draft.longitude != 0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 16.sp, color: AppColors.info),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              hasGis
                  ? 'invoice.shipping_source_gis'.tr(namedArgs: {'label': label})
                  : label,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.info,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _actionChip(
          icon: Icons.refresh,
          label: 'invoice.action_reload_address_list'.tr(),
          onTap: _loadAddressOptions,
        ),
        _actionChip(
          icon: Icons.star_outline,
          label: 'invoice.action_use_default_address'.tr(),
          onTap: () => _onUseDefault(context),
        ),
        _actionChip(
          icon: Icons.map_outlined,
          label: 'invoice.action_pick_map_gis'.tr(),
          onTap: () => _onPickMap(context),
        ),
      ],
    );
  }

  Future<void> _onUseDefault(BuildContext context) async {
    _BuyerAddressOption? def;
    for (final o in _options) {
      if (o.isDefault) {
        def = o;
        break;
      }
    }
    if (def != null) {
      await _applyOption(def);
      return;
    }
    final cubit = context.read<CreateInvoiceCubit>();
    await cubit.resetShippingFromBuyerProfile(widget.negotiationId);
    final next = cubit.state.draft;
    if (next != null) {
      setState(() => _selectedKey = _keyForDraft(next));
      widget.onDraftChanged(next);
    }
    await _loadAddressOptions();
  }

  Widget _actionChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16.sp, color: AppColors.primary),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onPickMap(BuildContext context) async {
    final picked = await OsmLocationPickerPage.open(
      context,
      initialLatitude: widget.draft.latitude,
      initialLongitude: widget.draft.longitude,
    );
    if (picked == null || !context.mounted) return;

    final postcode = picked.addressData['postcode']?.toString();
    final city = picked.addressData['city']?.toString() ??
        picked.addressData['town']?.toString() ??
        picked.addressData['county']?.toString();
    final stateName = picked.addressData['state']?.toString();

    final next = widget.draft.copyWith(
      address: picked.formattedAddress.trim().isNotEmpty
          ? picked.formattedAddress
          : widget.draft.address,
      regency: city ?? widget.draft.regency,
      province: stateName ?? widget.draft.province,
      zipCode: postcode ?? widget.draft.zipCode,
      latitude: picked.latLong.latitude,
      longitude: picked.latLong.longitude,
      source: 'custom',
      customerAddressId: null,
    );
    final cubit = context.read<CreateInvoiceCubit>();
    cubit.updateDraft(next);
    setState(() => _selectedKey = 'custom');
    widget.onDraftChanged(cubit.state.draft ?? next);
    await cubit.refreshPreview(widget.negotiationId);
  }
}

class _AddressPickTile extends StatelessWidget {
  const _AddressPickTile({
    required this.option,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  final _BuyerAddressOption option;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.primary.withValues(alpha: 0.06)
          : AppColors.grey50,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(compact ? 10.w : 12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.grey200,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                selected ? Icons.check_circle : Icons.location_on_outlined,
                color: selected ? AppColors.primary : AppColors.textHint,
                size: compact ? 20.sp : 22.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            option.label,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: compact ? 13.sp : 14.sp,
                            ),
                          ),
                        ),
                        ..._badges(),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      option.subtitle,
                      maxLines: compact ? 2 : 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _badges() {
    final badges = <Widget>[];
    if (option.isDefault) {
      badges.add(_badge('Default', AppColors.success));
    }
    if (option.isPrimary) {
      badges.add(_badge('Utama', AppColors.primary));
    }
    if (!option.isPrimary && !option.isDefault) {
      badges.add(_badge('Lainnya', AppColors.textHint));
    }
    return badges
        .map(
          (b) => Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: b,
          ),
        )
        .toList();
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}
