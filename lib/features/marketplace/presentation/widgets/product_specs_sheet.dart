import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/product_entity.dart';
import '../utils/product_specs_mapper.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';

export '../utils/product_specs_mapper.dart' show ProductSpecEntry, ProductSpecsMapper;

class ProductSpecsData {
  const ProductSpecsData({this.entries = const []});

  final List<ProductSpecEntry> entries;

  factory ProductSpecsData.fromProduct(ProductEntity product) {
    return ProductSpecsData(entries: ProductSpecsMapper.fromProduct(product));
  }

  List<MapEntry<String, String>> entriesForMode(String productMode) {
    return ProductSpecsMapper.toDisplayEntries(entries);
  }

  Map<String, dynamic> toApiPayload(String productMode) {
    return ProductSpecsMapper.toApiPayload(productMode, entries);
  }
}

/// Spesifikasi di form tambah/edit: bisa dibuka/tutup + preset cepat show/hide.
class ProductSpecsExpandableSection extends StatefulWidget {
  const ProductSpecsExpandableSection({
    super.key,
    required this.productMode,
    required this.specs,
    required this.onSpecsChanged,
    required this.onOpenFullEditor,
  });

  final String productMode;
  final ProductSpecsData specs;
  final ValueChanged<ProductSpecsData> onSpecsChanged;
  final VoidCallback onOpenFullEditor;

  @override
  State<ProductSpecsExpandableSection> createState() =>
      _ProductSpecsExpandableSectionState();
}

class _ProductSpecsExpandableSectionState
    extends State<ProductSpecsExpandableSection> {
  bool _sectionExpanded = false;
  bool _presetsExpanded = true;

  String get _title => widget.productMode == 'ORGANIC_PRODUCE'
      ? 'Spesifikasi Hasil Tani'
      : 'Spesifikasi Teknis';

  List<String> get _presets => ProductSpecsMapper.presetLabels(widget.productMode);

  List<ProductSpecEntry> get _validEntries =>
      widget.specs.entries.where((e) => e.isValid).toList();

  void _updateEntries(List<ProductSpecEntry> entries) {
    widget.onSpecsChanged(ProductSpecsData(entries: entries));
  }

  void _togglePreset(String label) {
    final entries = List<ProductSpecEntry>.from(widget.specs.entries);
    final idx = entries.indexWhere(
      (e) => e.label.trim().toLowerCase() == label.trim().toLowerCase(),
    );
    if (idx >= 0) {
      entries.removeAt(idx);
    } else {
      entries.add(ProductSpecEntry(label: label, value: ''));
    }
    _updateEntries(entries);
  }

  void _setEntryValue(int indexInAll, String value) {
    final entries = List<ProductSpecEntry>.from(widget.specs.entries);
    if (indexInAll < 0 || indexInAll >= entries.length) return;
    final e = entries[indexInAll];
    entries[indexInAll] = ProductSpecEntry(label: e.label, value: value);
    _updateEntries(entries);
  }

  void _removeEntry(int indexInAll) {
    final entries = List<ProductSpecEntry>.from(widget.specs.entries);
    if (indexInAll < 0 || indexInAll >= entries.length) return;
    entries.removeAt(indexInAll);
    _updateEntries(entries);
  }

  bool _hasPreset(String label) {
    return widget.specs.entries.any(
      (e) => e.label.trim().toLowerCase() == label.trim().toLowerCase(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filledCount = _validEntries.length;
    final draftRows = widget.specs.entries
        .where((e) => e.label.trim().isNotEmpty)
        .toList();

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12.r),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _sectionExpanded = !_sectionExpanded),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12.r),
                  bottom: Radius.circular(_sectionExpanded ? 0 : 12.r),
                ),
                border: Border.all(color: AppColors.grey100),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.listChecks,
                    size: 16.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _title,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          filledCount > 0
                              ? '$filledCount spesifikasi terisi'
                              : 'Opsional — tap untuk preset cepat',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (filledCount > 0)
                    Container(
                      margin: EdgeInsets.only(right: 6.w),
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '$filledCount',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  Icon(
                    _sectionExpanded
                        ? LucideIcons.chevronUp
                        : LucideIcons.chevronDown,
                    size: 18.sp,
                    color: AppColors.textHint,
                  ),
                ],
              ),
            ),
          ),
          if (_sectionExpanded) ...[
            Divider(height: 1, color: AppColors.grey100),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 0),
              child: _PresetsCollapsibleHeader(
                expanded: _presetsExpanded,
                onToggle: () =>
                    setState(() => _presetsExpanded = !_presetsExpanded),
              ),
            ),
            if (_presetsExpanded)
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 4.h),
                child: ProductSpecsPresetChips(
                  presets: _presets,
                  isSelected: _hasPreset,
                  onToggle: _togglePreset,
                ),
              ),
            if (draftRows.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 0),
                child: Text(
                  'Isi nilai spesifikasi',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 6.h, 12.w, 8.h),
                child: Column(
                  children: [
                    for (int i = 0, shown = 0; i < widget.specs.entries.length; i++)
                      if (widget.specs.entries[i].label.trim().isNotEmpty) ...[
                        if (shown++ > 0) SizedBox(height: 8.h),
                        _InlineSpecValueRow(
                          key: ValueKey('spec-$i-${widget.specs.entries[i].label}'),
                          label: widget.specs.entries[i].label,
                          value: widget.specs.entries[i].value,
                          onChanged: (v) => _setEntryValue(i, v),
                          onRemove: () => _removeEntry(i),
                        ),
                      ],
                  ],
                ),
              ),
            ],
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
              child: TextButton.icon(
                onPressed: widget.onOpenFullEditor,
                icon: Icon(LucideIcons.slidersHorizontal, size: 16.sp),
                label: Text(
                  'Kelola spesifikasi lengkap',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  minimumSize: Size(double.infinity, 40.h),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PresetsCollapsibleHeader extends StatelessWidget {
  const _PresetsCollapsibleHeader({
    required this.expanded,
    required this.onToggle,
  });

  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            Icon(
              LucideIcons.zap,
              size: 14.sp,
              color: AppColors.secondary,
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                'Preset cepat',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              expanded ? 'Sembunyikan' : 'Tampilkan',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              expanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
              size: 16.sp,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class ProductSpecsPresetChips extends StatelessWidget {
  const ProductSpecsPresetChips({
    super.key,
    required this.presets,
    required this.isSelected,
    required this.onToggle,
  });

  final List<String> presets;
  final bool Function(String label) isSelected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: presets
          .map(
            (label) {
              final selected = isSelected(label);
              return FilterChip(
                label: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: selected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
                selected: selected,
                showCheckmark: true,
                checkmarkColor: AppColors.primary,
                selectedColor: AppColors.primaryLight.withValues(alpha: 0.5),
                backgroundColor: AppColors.grey50,
                side: BorderSide(
                  color: selected
                      ? AppColors.primary.withValues(alpha: 0.4)
                      : AppColors.grey200,
                ),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onSelected: (_) => onToggle(label),
              );
            },
          )
          .toList(),
    );
  }
}

class _InlineSpecValueRow extends StatefulWidget {
  const _InlineSpecValueRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.onRemove,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback onRemove;

  @override
  State<_InlineSpecValueRow> createState() => _InlineSpecValueRowState();
}

class _InlineSpecValueRowState extends State<_InlineSpecValueRow> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(_InlineSpecValueRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                TextField(
                  controller: _controller,
                  onChanged: widget.onChanged,
                  decoration: InputDecoration(
                    hintText: 'Isi nilai...',
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColors.grey200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColors.grey200),
                    ),
                  ),
                  style: TextStyle(fontSize: 13.sp),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: widget.onRemove,
            icon: Icon(LucideIcons.x, size: 16.sp, color: AppColors.error),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

/// Ringkasan key-value compact — tap untuk buka sheet editor.
class ProductSpecsSummaryCard extends StatelessWidget {
  const ProductSpecsSummaryCard({
    super.key,
    required this.productMode,
    required this.specs,
    required this.onTap,
  });

  final String productMode;
  final ProductSpecsData specs;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final entries = specs.entriesForMode(productMode);
    final title = productMode == 'ORGANIC_PRODUCE'
        ? 'Spesifikasi Hasil Tani'
        : 'Spesifikasi Teknis';

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.grey100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.listChecks,
                    size: 16.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    LucideIcons.chevronRight,
                    size: 16.sp,
                    color: AppColors.textHint,
                  ),
                ],
              ),
              if (entries.isEmpty) ...[
                SizedBox(height: 6.h),
                Text(
                  'Tap untuk tambah spesifikasi (key-value)',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textHint,
                  ),
                ),
              ] else ...[
                SizedBox(height: 8.h),
                ...entries.take(4).map(_kvRow),
                if (entries.length > 4)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      '+${entries.length - 4} lainnya',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _kvRow(MapEntry<String, String> e) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              e.key,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textHint,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              e.value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

Future<ProductSpecsData?> showProductSpecsSheet(
  BuildContext context, {
  required String productMode,
  required ProductSpecsData initial,
}) {
  return showModalBottomSheet<ProductSpecsData>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _ProductSpecsSheet(
      productMode: productMode,
      initial: initial,
    ),
  );
}

class _EditableSpecRow {
  _EditableSpecRow({required this.id, String label = '', String value = ''})
      : labelCtrl = TextEditingController(text: label),
        valueCtrl = TextEditingController(text: value);

  final String id;
  final TextEditingController labelCtrl;
  final TextEditingController valueCtrl;

  void dispose() {
    labelCtrl.dispose();
    valueCtrl.dispose();
  }
}

class _ProductSpecsSheet extends StatefulWidget {
  const _ProductSpecsSheet({
    required this.productMode,
    required this.initial,
  });

  final String productMode;
  final ProductSpecsData initial;

  @override
  State<_ProductSpecsSheet> createState() => _ProductSpecsSheetState();
}

class _ProductSpecsSheetState extends State<_ProductSpecsSheet> {
  final List<_EditableSpecRow> _rows = [];
  int _idSeq = 0;
  bool _presetsExpanded = true;

  @override
  void initState() {
    super.initState();
    if (widget.initial.entries.isEmpty) {
      _addRow();
    } else {
      for (final entry in widget.initial.entries) {
        _rows.add(_EditableSpecRow(
          id: '${_idSeq++}',
          label: entry.label,
          value: entry.value,
        ));
      }
    }
  }

  @override
  void dispose() {
    for (final row in _rows) {
      row.dispose();
    }
    super.dispose();
  }

  void _addRow({String label = '', String value = ''}) {
    setState(() {
      _rows.add(_EditableSpecRow(id: '${_idSeq++}', label: label, value: value));
    });
  }

  void _removeRow(int index) {
    setState(() {
      _rows[index].dispose();
      _rows.removeAt(index);
      if (_rows.isEmpty) _addRow();
    });
  }

  void _togglePreset(String label) {
    final idx = _rows.indexWhere(
      (r) => r.labelCtrl.text.trim().toLowerCase() == label.trim().toLowerCase(),
    );
    if (idx >= 0) {
      _removeRow(idx);
      return;
    }
    _addRow(label: label);
  }

  bool _hasPreset(String label) {
    return _rows.any(
      (r) => r.labelCtrl.text.trim().toLowerCase() == label.trim().toLowerCase(),
    );
  }

  ProductSpecsData _buildResult() {
    final entries = _rows
        .map(
          (r) => ProductSpecEntry(
            label: r.labelCtrl.text.trim(),
            value: r.valueCtrl.text.trim(),
          ),
        )
        .where((e) => e.label.trim().isNotEmpty)
        .toList();
    return ProductSpecsData(entries: entries);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardBottom = MediaQuery.viewInsetsOf(context).bottom;
    final maxH = MediaQuery.sizeOf(context).height * 0.88;
    final isOrganic = widget.productMode == 'ORGANIC_PRODUCE';
    final title =
        isOrganic ? 'Spesifikasi Hasil Tani' : 'Spesifikasi Teknis';
    final presets = ProductSpecsMapper.presetLabels(widget.productMode);

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardBottom),
      child: Container(
        constraints: BoxConstraints(maxHeight: maxH),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.h),
              Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(LucideIcons.x, size: 20.sp),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 0),
                child: Text(
                  'Tambah baris key-value sebanyak yang dibutuhkan.',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _PresetsCollapsibleHeader(
                      expanded: _presetsExpanded,
                      onToggle: () =>
                          setState(() => _presetsExpanded = !_presetsExpanded),
                    ),
                    if (_presetsExpanded) ...[
                      SizedBox(height: 8.h),
                      ProductSpecsPresetChips(
                        presets: presets,
                        isSelected: _hasPreset,
                        onToggle: _togglePreset,
                      ),
                    ],
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    children: [
                      for (int i = 0; i < _rows.length; i++) ...[
                        if (i > 0) SizedBox(height: 10.h),
                        _buildEditableRow(i),
                      ],
                      SizedBox(height: 12.h),
                      OutlinedButton.icon(
                        onPressed: () => _addRow(),
                        icon: Icon(LucideIcons.plus, size: 18.sp),
                        label: Text(
                          'Tambah Spesifikasi',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary),
                          minimumSize: Size(double.infinity, 46.h),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
                  child: CustomButton(
                    text: 'Simpan Spesifikasi',
                    onPressed: () => Navigator.pop(context, _buildResult()),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildEditableRow(int index) {
    final row = _rows[index];
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Baris ${index + 1}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textHint,
                  ),
                ),
              ),
              if (_rows.length > 1)
                IconButton(
                  onPressed: () => _removeRow(index),
                  icon: Icon(LucideIcons.trash2, size: 16.sp, color: AppColors.error),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          SizedBox(height: 6.h),
          CustomTextField(
            label: 'Label / Nama',
            controller: row.labelCtrl,
            hint: 'Contoh: Kadar Air',
          ),
          SizedBox(height: 8.h),
          CustomTextField(
            label: 'Nilai',
            controller: row.valueCtrl,
            hint: 'Contoh: 12%',
          ),
        ],
      ),
    );
  }
}

/// Tampilan key-value read-only (manajemen produk / detail).
class ProductSpecsKeyValueList extends StatelessWidget {
  const ProductSpecsKeyValueList({
    super.key,
    required this.entries,
    this.dense = true,
  });

  final List<MapEntry<String, String>> entries;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    final labelSize = dense ? 11.sp : 13.sp;
    final valueSize = dense ? 11.sp : 13.sp;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          for (int i = 0; i < entries.length; i++) ...[
            if (i > 0) Divider(height: 1, color: AppColors.grey100),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: dense ? 8.h : 10.h,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      entries[i].key,
                      style: TextStyle(
                        fontSize: labelSize,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      entries[i].value,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: valueSize,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
