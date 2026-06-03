import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/product_image_draft.dart';
import '../widgets/product_image_editor.dart';
import '../widgets/product_specs_sheet.dart';
import '../bloc/marketplace_cubit.dart';
import '../bloc/category_cubit.dart';
import '../bloc/category_state.dart';
import '../widgets/category_search_picker.dart';
import '../../data/models/category_model.dart';
import '../../../../injection_container.dart';

class AddEditProductPage extends StatefulWidget {
  final ProductEntity? product;

  const AddEditProductPage({super.key, this.product});

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  static const _pageHPad = 16.0;
  static const _fieldGap = 10.0;
  static const _sectionGap = 12.0;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _originalPriceController;
  late TextEditingController _stockController;
  late TextEditingController _descriptionController;
  late TextEditingController _minOrderController;

  ProductSpecsData _specsData = const ProductSpecsData();

  String _productMode = 'BIOMASS_MATERIAL';
  String _selectedBiomassaType = 'BIOCHAR';
  String _selectedUnit = 'KG';
  String _selectedStatus = 'ACTIVE';
  String? _selectedGrade;
  String? _selectedCategoryId;

  List<ProductImageDraft> _imageDrafts = [];
  final _imageEditorKey = GlobalKey<ProductImageEditorState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name);
    _priceController = TextEditingController(
      text: widget.product?.pricePerUnit.toString(),
    );
    _originalPriceController = TextEditingController(
      text: widget.product?.originalPrice?.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: widget.product?.stock.toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.product?.description,
    );
    _minOrderController = TextEditingController(
      text: widget.product?.minOrder.toString() ?? '100',
    );

    if (widget.product != null) {
      _specsData = ProductSpecsData.fromProduct(widget.product!);
      _selectedBiomassaType = widget.product!.biomassaType;
      _selectedUnit = widget.product!.unit;
      _selectedGrade = widget.product!.grade;
      _selectedStatus = widget.product!.status;
      _productMode = widget.product!.productMode;
      _selectedCategoryId = widget.product!.categoryId;
      if (widget.product!.images != null) {
        _imageDrafts = ProductImageDraft.fromProductImages(widget.product!.images);
      } else if (widget.product!.thumbnailUrl != null) {
        _imageDrafts = [
          ProductImageDraft(id: 'thumb', remoteUrl: widget.product!.thumbnailUrl),
        ];
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    _minOrderController.dispose();
    super.dispose();
  }

  Future<void> _openSpecsSheet() async {
    final result = await showProductSpecsSheet(
      context,
      productMode: _productMode,
      initial: _specsData,
    );
    if (result != null) setState(() => _specsData = result);
  }

  void _onBiomassaTypeChanged(BuildContext context, String? v) {
    if (v == null) return;
    setState(() {
      _selectedBiomassaType = v;
      _selectedCategoryId = null;
      if (v != 'BIOCHAR') _selectedGrade = null;
    });
    _reloadCategories(context);
  }

  void _reloadCategories(BuildContext context) {
    if (_productMode == 'BIOMASS_MATERIAL') {
      context.read<CategoryCubit>().getCategories(
        productMode: _productMode,
        biomassaType: _selectedBiomassaType,
      );
    } else {
      context.read<CategoryCubit>().getCategories(productMode: _productMode);
    }
  }

  /// Safety net: ignore stale cubit payloads that do not match current form selection.
  List<CategoryModel> _categoriesForCurrentSelection(List<CategoryModel> raw) {
    if (_productMode == 'ORGANIC_PRODUCE') {
      return raw
          .where((c) => c.productMode == 'ORGANIC_PRODUCE')
          .toList(growable: false);
    }
    return raw
        .where(
          (c) =>
              c.productMode == 'BIOMASS_MATERIAL' &&
              c.biomassaType == _selectedBiomassaType,
        )
        .toList(growable: false);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _productMode == 'BIOMASS_MATERIAL'
                  ? 'Pilih jenis biomassa dan kategori produk'
                  : 'Pilih kategori hasil pertanian',
            ),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
      final drafts = _imageEditorKey.currentState?.items ?? _imageDrafts;
      if (drafts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pilih minimal satu foto produk'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final payload = ProductImageDraft.buildPayload(drafts);

      final data = {
        'name': _nameController.text.trim(),
        'biomassaType': _productMode == 'ORGANIC_PRODUCE' ? 'OTHER' : _selectedBiomassaType,
        'pricePerUnit': double.parse(_priceController.text),
        if (_originalPriceController.text.trim().isNotEmpty)
          'originalPrice': double.parse(_originalPriceController.text.trim()),
        'stock': double.parse(_stockController.text),
        'minOrder': double.parse(_minOrderController.text),
        'unit': _selectedUnit,
        if (_descriptionController.text.isNotEmpty)
          'description': _descriptionController.text.trim(),
        'status': _selectedStatus,
        'productMode': _productMode,
        if (_selectedCategoryId != null) 'categoryId': _selectedCategoryId,
        'imageOrder': payload.imageOrderJson,
        ..._buildSpecsPayload(),
      };

      if (widget.product == null) {
        context.read<MarketplaceCubit>().createProduct(data, payload.newImagePaths);
      } else {
        data['syncImages'] = 'true';
        context.read<MarketplaceCubit>().updateProduct(
          widget.product!.id,
          data,
          payload.newImagePaths,
        );
      }
    }
  }

  Map<String, dynamic> _buildSpecsPayload() {
    final payload = _specsData.toApiPayload(_productMode);
    final specs = payload.remove('specs');
    final result = <String, dynamic>{...payload};
    if (_productMode != 'ORGANIC_PRODUCE' && _selectedGrade != null) {
      result['grade'] = _selectedGrade;
    }
    result['specs'] = jsonEncode(specs ?? []);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

    return BlocProvider(
      create: (context) {
        final cubit = sl<CategoryCubit>();
        if (_productMode == 'BIOMASS_MATERIAL') {
          cubit.getCategories(
            productMode: _productMode,
            biomassaType: _selectedBiomassaType,
          );
        } else {
          cubit.getCategories(productMode: _productMode);
        }
        return cubit;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: true,
        appBar: BisaAppBar(
          title: isEdit ? 'Edit Produk' : 'Tambah Produk Baru',
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        bottomNavigationBar: _buildSubmitBar(isEdit),
        body: BlocListener<MarketplaceCubit, MarketplaceState>(
          listener: (context, state) {
            state.maybeWhen(
              loaded: (products, hasReachedMax) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEdit
                          ? 'Produk diperbarui'
                          : 'Produk berhasil ditambahkan',
                    ),
                  ),
                );
                Navigator.pop(context);
              },
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: AppColors.error,
                  ),
                );
              },
              orElse: () {},
            );
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              _pageHPad.w,
              12.h,
              _pageHPad.w,
              12.h,
            ),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _formSection(
                    child: ProductImageEditor(
                      key: _imageEditorKey,
                      initialImages: _imageDrafts,
                      onChanged: (items) => _imageDrafts = items,
                    ),
                  ),
                  SizedBox(height: _sectionGap.h),
                  _formSection(
                    title: 'Tipe & Kategori',
                    children: [
                      _buildProductModeFormToggle(),
                      if (_productMode == 'BIOMASS_MATERIAL')
                        _buildBiomassaTypeSelector(),
                      _buildCategoryPicker(),
                    ],
                  ),
                  SizedBox(height: _sectionGap.h),
                  _formSection(
                    title: 'Informasi Produk',
                    children: [
                      CustomTextField(
                        label: 'namaproduk_1'.tr(),
                        controller: _nameController,
                        hint: _productMode == 'ORGANIC_PRODUCE'
                            ? 'contoh: Beras Organik Mentik Wangi'
                            : 'contohbiochargradeasekamp_1'.tr(),
                        validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                      ),
                      if (_productMode == 'BIOMASS_MATERIAL' &&
                          _selectedBiomassaType == 'BIOCHAR')
                        _buildDropdown(
                          label: 'grade1'.tr(),
                          value: _selectedGrade,
                          items: ['A', 'B', 'C'],
                          onChanged: (v) => setState(() => _selectedGrade = v),
                        ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: 'hargaperunit_1'.tr(),
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              hint: '0',
                              validator: (v) => v!.isEmpty ? 'Wajib' : null,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: _buildDropdown(
                              label: 'satuan1'.tr(),
                              value: _selectedUnit,
                              items: ['KG', 'TON'],
                              onChanged: (v) =>
                                  setState(() => _selectedUnit = v!),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.grey50,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColors.grey100),
                        ),
                        child: Text(
                          'Diskon promo berlaku per 1 $_selectedUnit. '
                          'Total = qty × harga jual. Min. order terpisah.',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                        ),
                      ),
                      CustomTextField(
                        label: 'Harga coret per $_selectedUnit (opsional)',
                        controller: _originalPriceController,
                        keyboardType: TextInputType.number,
                        hint: 'Kosongkan jika tanpa promo',
                      ),
                    ],
                  ),
                  SizedBox(height: _sectionGap.h),
                  ProductSpecsExpandableSection(
                    key: ValueKey(_productMode),
                    productMode: _productMode,
                    specs: _specsData,
                    onSpecsChanged: (data) => setState(() => _specsData = data),
                    onOpenFullEditor: _openSpecsSheet,
                  ),
                  SizedBox(height: _sectionGap.h),
                  _formSection(
                    title: 'Stok & Keterangan',
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: 'stok1'.tr(),
                              controller: _stockController,
                              keyboardType: TextInputType.number,
                              hint: '0',
                              validator: (v) => v!.isEmpty ? 'Wajib' : null,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomTextField(
                              label: 'minorder'.tr(),
                              controller: _minOrderController,
                              keyboardType: TextInputType.number,
                              hint: '100',
                            ),
                          ),
                        ],
                      ),
                      CustomTextField(
                        label: 'deskripsi'.tr(),
                        controller: _descriptionController,
                        maxLines: 3,
                        hint: 'jelaskan_kualitas_produk'.tr(),
                      ),
                      _buildDropdown(
                        label: 'status_produk'.tr(),
                        value: _selectedStatus,
                        items: ['ACTIVE', 'DRAFT', 'INACTIVE', 'OUT_OF_STOCK'],
                        onChanged: (v) => setState(() => _selectedStatus = v!),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitBar(bool isEdit) {
    return Material(
      color: AppColors.surface,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(_pageHPad.w, 10.h, _pageHPad.w, 10.h),
          child: BlocBuilder<MarketplaceCubit, MarketplaceState>(
            builder: (context, state) {
              return CustomButton(
                text: isEdit ? 'Simpan Perubahan' : 'Terbitkan Produk',
                isLoading: state.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                ),
                onPressed: _submit,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _formSection({
    String? title,
    Widget? child,
    List<Widget>? children,
  }) {
    final fields = child != null ? [child] : (children ?? const []);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 10.h),
          ],
          for (var i = 0; i < fields.length; i++) ...[
            if (i > 0) SizedBox(height: _fieldGap.h),
            fields[i],
          ],
        ],
      ),
    );
  }

  Widget _buildBiomassaTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'jenisbiomassa_1'.tr(),
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey300),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedBiomassaType,
              isExpanded: true,
              hint: Text('pilih'.tr()),
              items: kBiomassaTypeValues
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(biomassaTypeLabel(e)),
                    ),
                  )
                  .toList(),
              onChanged: widget.product != null
                  ? null
                  : (v) => _onBiomassaTypeChanged(context, v),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Pilih jenis biomassa dulu — kategori akan muncul sesuai tipe (biochar, sekam, jagung, dll.)',
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.textHint,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryPicker() {
    final isBiomass = _productMode == 'BIOMASS_MATERIAL';

    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        List<CategoryModel> categories = [];
        if (state is CategoryLoaded) {
          categories = _categoriesForCurrentSelection(state.categories);
          if (_selectedCategoryId != null &&
              !categories.any((c) => c.id == _selectedCategoryId)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _selectedCategoryId = null);
            });
          }
        }

        final biomassaLabel = biomassaTypeLabel(_selectedBiomassaType);

        return CategoryPickerField(
          label: isBiomass ? 'Kategori Biomassa' : 'Kategori Hasil Pertanian',
          enabled: isBiomass ? true : true,
          isLoading: state is CategoryLoading,
          categories: categories,
          selectedId: _selectedCategoryId,
          disabledHint: isBiomass
              ? 'Memuat kategori biomassa...'
              : 'Memuat kategori hasil pertanian...',
          emptyHint: isBiomass
              ? 'Belum ada kategori untuk $biomassaLabel'
              : 'Belum ada kategori hasil pertanian',
          pickerTitle: isBiomass
              ? 'Kategori — $biomassaLabel'
              : 'Pilih Kategori Hasil Tani',
          searchHint: isBiomass
              ? 'Cari kategori $biomassaLabel...'
              : 'Cari kategori, mis. Beras / Sayur / Buah...',
          onSelected: (cat) => setState(() => _selectedCategoryId = cat?.id),
        );
      },
    );
  }

  Widget _buildDropdown({
    required String label,
    String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey200),
            borderRadius: BorderRadius.circular(8.r),
            color: AppColors.grey50,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text('pilih'.tr()),
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductModeFormToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipe Produk',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          height: 38.h,
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildFormModeTab(
                  label: 'Bahan Baku Industri',
                  mode: 'BIOMASS_MATERIAL',
                ),
              ),
              Expanded(
                child: _buildFormModeTab(
                  label: 'Hasil Tani Konsumsi',
                  mode: 'ORGANIC_PRODUCE',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormModeTab({required String label, required String mode}) {
    final isSelected = _productMode == mode;
    return GestureDetector(
      onTap: widget.product != null ? null : () {
        setState(() {
          _productMode = mode;
          _specsData = const ProductSpecsData();
          if (mode == 'ORGANIC_PRODUCE') {
            _selectedUnit = 'KG';
          } else {
            _selectedUnit = 'TON';
            _selectedBiomassaType = 'BIOCHAR';
          }
          _selectedCategoryId = null;
        });
        _reloadCategories(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            fontSize: 11.sp,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
