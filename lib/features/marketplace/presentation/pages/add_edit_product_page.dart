import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../core/utils/app_feedback.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/readiness/readiness_gate.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/product_image_draft.dart';
import '../widgets/product_image_editor.dart';
import '../utils/prediction_product_mapper.dart';
import '../widgets/iot_prediction_import_sheet.dart';
import '../widgets/product_specs_sheet.dart';
import '../bloc/marketplace_cubit.dart';
import '../bloc/category_cubit.dart';
import '../bloc/category_state.dart';
import '../widgets/category_search_picker.dart';
import '../../data/models/category_model.dart';
import '../../../../core/media/media_upload_progress_banner.dart';
import '../../../../core/media/media_upload_progress_controller.dart';
import '../../../../core/media/media_upload_queue.dart';
import '../../../../injection_container.dart';

class AddEditProductPage extends StatefulWidget {
  final ProductEntity? product;
  final IotPredictionImportResult? predictionSeed;

  const AddEditProductPage({
    super.key,
    this.product,
    this.predictionSeed,
  });

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
  String? _aiPredictionId;

  List<ProductImageDraft> _imageDrafts = [];
  final _imageEditorKey = GlobalKey<ProductImageEditorState>();

  bool _isGeneratingDesc = false;

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

    final seed = widget.predictionSeed;
    if (seed != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _applyPredictionSeed(seed, showSnack: false);
      });
    }
  }

  void _applyPredictionSeed(IotPredictionImportResult result, {bool showSnack = true}) {
    setState(() {
      _productMode = 'BIOMASS_MATERIAL';
      _selectedBiomassaType = result.biomassaType ?? 'BIOCHAR';
      _selectedGrade = result.grade;
      _specsData = result.specsData;
      _aiPredictionId = result.predictionId;
      if (_nameController.text.trim().isEmpty && result.suggestedName != null) {
        _nameController.text = result.suggestedName!;
      }
      if (result.suggestedPricePerUnit != null &&
          _priceController.text.trim().isEmpty) {
        _priceController.text = result.suggestedPricePerUnit!.round().toString();
      }
    });
    _reloadCategories(context);
    if (showSnack && mounted) {
      showSuccessSnackBar(context, productSeedAppliedMessage());
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

  Future<void> _importFromIot() async {
    final result = await IotPredictionImportSheet.show(context);
    if (result == null || !mounted) return;
    _applyPredictionSeed(result);
  }

  Future<void> _openSpecsSheet() async {
    final result = await showProductSpecsSheet(
      context,
      productMode: _productMode,
      initial: _specsData,
    );
    if (result != null) setState(() => _specsData = result);
  }

  /// Kirim foto produk pertama ke backend → Gemini Vision → prefill deskripsi.
  /// Prompt sudah dikunci ketat di backend — hanya output deskripsi biomassa.
  Future<void> _generateDescription() async {
    final drafts = _imageEditorKey.currentState?.items ?? _imageDrafts;
    if (drafts.isEmpty) {
      showErrorSnackBar(context, 'marketplace.generate_desc_no_image'.tr());
      return;
    }

    // Ambil gambar pertama yang sudah ada file lokalnya, fallback ke yang pertama
    final draft = drafts.firstWhere(
      (d) => d.localFile != null,
      orElse: () => drafts.first,
    );

    setState(() => _isGeneratingDesc = true);
    try {
      String imageBase64;
      String mimeType = 'image/jpeg';

      if (draft.localFile != null) {
        // Gambar baru dari kamera/galeri — encode langsung
        final bytes = await draft.localFile!.readAsBytes();
        imageBase64 = base64Encode(bytes);
        final ext = draft.localFile!.path.split('.').last.toLowerCase();
        if (ext == 'png') mimeType = 'image/png';
        if (ext == 'webp') mimeType = 'image/webp';
      } else if (draft.remoteUrl != null) {
        // Gambar existing dari server — download sebagai bytes
        final dio = sl<Dio>();
        final resp = await dio.get<List<int>>(
          draft.remoteUrl!,
          options: Options(responseType: ResponseType.bytes),
        );
        imageBase64 = base64Encode(resp.data!);
      } else {
        showErrorSnackBar(context, 'marketplace.generate_desc_no_image'.tr());
        return;
      }

      final dio = sl<Dio>();
      final response = await dio.post<Map<String, dynamic>>(
        '/ai/generate-product-description',
        data: {'imageBase64': imageBase64, 'mimeType': mimeType},
      );

      final description = response.data?['data']?['description'] as String? ?? '';

      if (description == 'BUKAN_PRODUK_BIOMASSA') {
        if (mounted) {
          showErrorSnackBar(context, 'marketplace.generate_desc_not_biomass'.tr());
        }
        return;
      }

      if (description.isNotEmpty && mounted) {
        setState(() => _descriptionController.text = description);
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, 'marketplace.generate_desc_error'.tr());
      }
    } finally {
      if (mounted) setState(() => _isGeneratingDesc = false);
    }
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

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategoryId == null) {
        showErrorSnackBar(
          context,
          _productMode == 'BIOMASS_MATERIAL'
              ? 'marketplace.pick_biomass_and_category'.tr()
              : 'marketplace.pick_organic_category'.tr(),
        );
        return;
      }
      final drafts = _imageEditorKey.currentState?.items ?? _imageDrafts;
      if (drafts.isEmpty) {
        showErrorSnackBar(context, 'marketplace.min_one_photo'.tr());
        return;
      }

      if (_selectedStatus == 'ACTIVE') {
        if (!await ReadinessGate.ensureStoreReady(context)) return;
        if (!mounted) return;
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
        if (_aiPredictionId != null) 'aiPredictionId': _aiPredictionId,
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
          title: isEdit
              ? 'marketplace.edit_product'.tr()
              : 'marketplace.add_product_new'.tr(),
          backgroundColor: AppColors.surface,
          centerTitle: true,
        ),
        bottomNavigationBar: _buildSubmitBar(isEdit),
        body: Column(
          children: [
            MediaUploadProgressBanner(
              controller: sl<MediaUploadProgressController>(),
              uploadQueue: sl<MediaUploadQueue>(),
            ),
            Expanded(
              child: BlocListener<MarketplaceCubit, MarketplaceState>(
          listener: (context, state) {
            state.maybeWhen(
              loaded: (products, hasReachedMax) {
                showSuccessSnackBar(
                  context,
                  isEdit
                      ? 'marketplace.product_updated'.tr()
                      : 'marketplace.product_added'.tr(),
                );
                Navigator.pop(context);
              },
              error: (message) async {
                if (!context.mounted) return;
                if (message.contains('toko') ||
                    message.contains('pengiriman') ||
                    message.contains('RajaOngkir')) {
                  await ReadinessGate.ensureStoreReady(context);
                  return;
                }
                showFailureSnackBarFromMessage(context, message);
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
                    title: 'marketplace.section_type_category'.tr(),
                    children: [
                      if (widget.product == null && _productMode == 'BIOMASS_MATERIAL')
                        Padding(
                          padding: EdgeInsets.only(bottom: _fieldGap.h),
                          child: OutlinedButton.icon(
                            onPressed: _importFromIot,
                            icon: Icon(LucideIcons.radio, size: 18.sp),
                            label: Text('marketplace.import_iot_cta'.tr()),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: BorderSide(
                                color: AppColors.primary.withValues(alpha: 0.35),
                              ),
                            ),
                          ),
                        ),
                      _buildProductModeFormToggle(),
                      if (_productMode == 'BIOMASS_MATERIAL')
                        _buildBiomassaTypeSelector(),
                      _buildCategoryPicker(),
                    ],
                  ),
                  SizedBox(height: _sectionGap.h),
                  _formSection(
                    title: 'marketplace.section_product_info'.tr(),
                    children: [
                      CustomTextField(
                        label: 'marketplace.product_name_label'.tr(),
                        controller: _nameController,
                        hint: _productMode == 'ORGANIC_PRODUCE'
                            ? 'marketplace.product_name_hint_organic'.tr()
                            : 'marketplace.product_name_hint_biomass'.tr(),
                        isRequired: true,
                        validator: (v) =>
                            v!.isEmpty ? 'marketplace.required_field'.tr() : null,
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
                              isRequired: true,
                              validator: (v) =>
                                  v!.isEmpty ? 'marketplace.required_short'.tr() : null,
                            ),
                          ),
                          SizedBox(width: AppSpacing.sm),
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
                          horizontal: AppSpacing.sm10,
                    vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.grey50,
                          borderRadius: BorderRadius.circular(AppRadius.button),
                          border: Border.all(color: AppColors.grey100),
                        ),
                        child: Text(
                          'marketplace.promo_hint'.tr(
                            namedArgs: {'unit': _selectedUnit},
                          ),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                        ),
                      ),
                      CustomTextField(
                        label: 'marketplace.strikethrough_price'.tr(
                          namedArgs: {'unit': _selectedUnit},
                        ),
                        controller: _originalPriceController,
                        keyboardType: TextInputType.number,
                        hint: 'marketplace.no_promo_hint'.tr(),
                        isOptional: true,
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
                    title: 'marketplace.section_stock_desc'.tr(),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: 'stok1'.tr(),
                              controller: _stockController,
                              keyboardType: TextInputType.number,
                              hint: '0',
                              isRequired: true,
                              validator: (v) =>
                                  v!.isEmpty ? 'marketplace.required_short'.tr() : null,
                            ),
                          ),
                          SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: CustomTextField(
                              label: 'minorder'.tr(),
                              controller: _minOrderController,
                              keyboardType: TextInputType.number,
                              hint: '100',
                              isOptional: true,
                            ),
                          ),
                        ],
                      ),
                      // Description field with ✨ Auto-generate button
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'deskripsi'.tr(),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              GestureDetector(
                                onTap: _isGeneratingDesc ? null : _generateDescription,
                                child: AnimatedOpacity(
                                  opacity: _isGeneratingDesc ? 0.5 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: _isGeneratingDesc
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: 10.sp,
                                                height: 10.sp,
                                                child: const CircularProgressIndicator(
                                                  strokeWidth: 1.5,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                'marketplace.generate_desc_loading'.tr(),
                                                style: TextStyle(
                                                  fontSize: 11.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            'marketplace.generate_desc_btn'.tr(),
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          CustomTextField(
                            label: '',
                            controller: _descriptionController,
                            maxLines: 3,
                            hint: 'jelaskan_kualitas_produk'.tr(),
                          ),
                        ],
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
    ],
  ),
),
);
  }

  Widget _buildSubmitBar(bool isEdit) {
    return Material(
      color: AppColors.surface,
      elevation: 8,
      shadowColor: AppColors.black.withValues(alpha: 0.08),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(_pageHPad.w, 10.h, _pageHPad.w, 10.h),
          child: BlocBuilder<MarketplaceCubit, MarketplaceState>(
            builder: (context, state) {
              return CustomButton(
                text: isEdit
                    ? 'marketplace.save_changes'.tr()
                    : 'marketplace.publish_product'.tr(),
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
      padding: EdgeInsets.all(AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
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
            SizedBox(height: AppSpacing.sm10),
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
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey300),
            borderRadius: BorderRadius.circular(AppRadius.button),
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
          'marketplace.biomassa_type_hint'.tr(),
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
          label: isBiomass
              ? 'marketplace.category_biomass'.tr()
              : 'marketplace.category_organic'.tr(),
          enabled: isBiomass ? true : true,
          isLoading: state is CategoryLoading,
          categories: categories,
          selectedId: _selectedCategoryId,
          disabledHint: isBiomass
              ? 'marketplace.loading_biomass_categories'.tr()
              : 'marketplace.loading_organic_categories'.tr(),
          emptyHint: isBiomass
              ? 'marketplace.no_category_for_type'.tr(
                  namedArgs: {'type': biomassaLabel},
                )
              : 'marketplace.no_organic_categories'.tr(),
          pickerTitle: isBiomass
              ? 'marketplace.category_picker_biomass'.tr(
                  namedArgs: {'type': biomassaLabel},
                )
              : 'marketplace.category_picker_organic'.tr(),
          searchHint: isBiomass
              ? 'marketplace.search_category_biomass'.tr(
                  namedArgs: {'type': biomassaLabel},
                )
              : 'marketplace.search_category_organic'.tr(),
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
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey200),
            borderRadius: BorderRadius.circular(AppRadius.button),
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
          'marketplace.product_type_label'.tr(),
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
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildFormModeTab(
                  label: 'marketplace.mode_biomass_industrial'.tr(),
                  mode: 'BIOMASS_MATERIAL',
                ),
              ),
              Expanded(
                child: _buildFormModeTab(
                  label: 'marketplace.mode_organic_consumption'.tr(),
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
          color: isSelected ? AppColors.primary : AppColors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            fontSize: 11.sp,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
