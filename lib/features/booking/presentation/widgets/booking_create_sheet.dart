import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
  import 'package:dio/dio.dart';
  import '../../../../core/constants/app_colors.dart';
  import '../../../../core/constants/app_layout.dart';
  import '../../../../core/i18n/failure_messages.dart';
  import '../../../../core/network/api_client.dart';
  import '../../../../core/readiness/readiness_gate.dart';
  import '../../../../core/utils/app_feedback.dart';
  import '../../../../core/utils/money_format.dart';
  import '../../../../injection_container.dart';
  import '../../../../shared/widgets/custom_button.dart';
  import '../../../../shared/widgets/custom_text_field.dart';
  import '../../../marketplace/domain/entities/product_entity.dart';
  import '../bloc/booking_cubit.dart';

  Future<void> showBookingCreateSheet({
    required BuildContext context,
    required ProductEntity product,
  }) async {
    if (!await ReadinessGate.ensureBuyerReady(context)) return;
    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (ctx) => BlocProvider(
        create: (_) => sl<BookingCubit>(),
        child: _BookingCreateSheet(product: product),
      ),
    );
  }

  class _BookingCreateSheet extends StatefulWidget {
    final ProductEntity product;

    const _BookingCreateSheet({required this.product});

    @override
    State<_BookingCreateSheet> createState() => _BookingCreateSheetState();
  }

  class _BookingCreateSheetState extends State<_BookingCreateSheet> {
    late final TextEditingController _qtyController;
    final _notesController = TextEditingController();
    DateTime? _expectedDeliveryDate;
    List<_HarvestLotOption> _lotOptions = const [];
    bool _isLoadingLots = false;
    String? _selectedLotId;

    @override
    void initState() {
      super.initState();
      _qtyController = TextEditingController(
        text: widget.product.minOrder.toStringAsFixed(
          widget.product.minOrder % 1 == 0 ? 0 : 1,
        ),
      );
      _loadHarvestLots();
    }

    @override
    void dispose() {
      _qtyController.dispose();
      _notesController.dispose();
      super.dispose();
    }

    double? _parseQty() => double.tryParse(_qtyController.text.replaceAll(',', '.'));

    Future<void> _loadHarvestLots() async {
      final p = widget.product;
      if (p.productMode != 'ORGANIC_PRODUCE') return;

      setState(() => _isLoadingLots = true);
      try {
        final res = await sl<ApiClient>().dio.get('/harvest-lots/product/${p.id}');
        final rows = (res.data['data'] as List? ?? const []);
        final parsed = rows
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .map(_HarvestLotOption.fromJson)
            .where((e) => e.isBookable)
            .toList(growable: false);
        if (!mounted) return;
        setState(() {
          _lotOptions = parsed;
        });
      } on DioException {
        // Keep sheet usable for ready-stock booking even when lots unavailable.
      } finally {
        if (mounted) setState(() => _isLoadingLots = false);
      }
    }

    Future<void> _submit() async {
      final qty = _parseQty();
      if (qty == null || qty <= 0) {
        showErrorSnackBar(context, 'booking.qty_invalid'.tr());
        return;
      }
      if (qty < widget.product.minOrder) {
        showErrorSnackBar(
          context,
          'booking.qty_below_min'.tr(namedArgs: {
            'min': '${widget.product.minOrder}',
            'unit': widget.product.unit,
          }),
        );
        return;
      }
      if (qty > widget.product.stock) {
        if (_selectedLotId == null) {
          showErrorSnackBar(
            context,
            'booking.qty_exceeds_stock'.tr(namedArgs: {
              'max': '${widget.product.stock}',
              'unit': widget.product.unit,
            }),
          );
          return;
        }
      }

      if (_selectedLotId != null) {
        _HarvestLotOption? selected;
        for (final lot in _lotOptions) {
          if (lot.id == _selectedLotId) {
            selected = lot;
            break;
          }
        }
        if (selected == null) {
          showErrorSnackBar(context, 'booking.qty_invalid'.tr());
          return;
        }
        final qtyTon = widget.product.unit == 'TON' ? qty : qty / 1000;
        if (qtyTon > selected.availableQuantityTon) {
          showErrorSnackBar(
            context,
            'booking.qty_exceeds_stock'.tr(namedArgs: {
              'max': '${selected.availableQuantityTon}',
              'unit': 'TON',
            }),
          );
          return;
        }
      }

      final body = <String, dynamic>{
        'productId': widget.product.id,
        'quantity': qty,
        if (_selectedLotId != null) 'harvestLotId': _selectedLotId,
        if (_expectedDeliveryDate != null)
          'expectedDeliveryDate': _expectedDeliveryDate!.toIso8601String(),
        if (_notesController.text.trim().isNotEmpty) 'notes': _notesController.text.trim(),
      };

      final err = await context.read<BookingCubit>().createBooking(body);
      if (!mounted) return;
      if (err != null) {
        showErrorSnackBar(context, err.localizedFailure);
        return;
      }

      final booking = context.read<BookingCubit>().state.selected;
      Navigator.pop(context);
      if (booking != null && context.mounted) {
        showSuccessSnackBar(context, 'booking.create_success'.tr());
        context.push('/bookings/${booking.id}');
      }
    }

    @override
    Widget build(BuildContext context) {
      final p = widget.product;
      final qty = _parseQty() ?? 0;
      final subtotal = qty * p.pricePerUnit;
      final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

      return Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md + bottomInset,
        ),
        child: BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.grey200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Icon(LucideIcons.calendarClock, color: AppColors.primary, size: 22.sp),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'booking.create_title'.tr(),
                        style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  p.name,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
                ),
                SizedBox(height: AppSpacing.md),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(AppRadius.tile),
                  ),
                  child: Text(
                    'booking.create_banner'.tr(namedArgs: {
                      'stock': '${p.stock}',
                      'unit': p.unit,
                    }),
                    style: TextStyle(fontSize: 12.sp, color: AppColors.primary),
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                if (_isLoadingLots) ...[
                  const LinearProgressIndicator(),
                  SizedBox(height: AppSpacing.sm),
                ],
                if (_lotOptions.isNotEmpty) ...[
                  Text(
                    'Pilih batch panen (opsional)',
                    style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<String?>(
                    initialValue: _selectedLotId,
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Tanpa lot panen (stok siap kirim)'),
                      ),
                      ..._lotOptions.map(
                        (lot) => DropdownMenuItem<String?>(
                          value: lot.id,
                          child: Text(
                            '${DateFormat('dd MMM yyyy').format(lot.expectedHarvestDate)} · ~${lot.availableQuantityTon} ton',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() => _selectedLotId = value),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.tile),
                      ),
                      isDense: true,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                ],
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Target kirim (opsional)', style: TextStyle(fontSize: 13.sp)),
                  subtitle: Text(
                    _expectedDeliveryDate == null
                        ? '-'
                        : DateFormat('dd MMM yyyy').format(_expectedDeliveryDate!),
                  ),
                  trailing: IconButton(
                    icon: const Icon(LucideIcons.calendar),
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _expectedDeliveryDate ?? now.add(const Duration(days: 7)),
                        firstDate: now,
                        lastDate: now.add(const Duration(days: 730)),
                      );
                      if (picked != null) setState(() => _expectedDeliveryDate = picked);
                    },
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                CustomTextField(
                  label: 'booking.field_quantity'.tr(namedArgs: {'unit': p.unit}),
                  controller: _qtyController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  hint: '${p.minOrder} ${p.unit}',
                  onChanged: (_) => setState(() {}),
                ),
                SizedBox(height: AppSpacing.sm),
                CustomTextField(
                  label: 'booking.field_notes'.tr(),
                  controller: _notesController,
                  maxLines: 2,
                  hint: 'booking.field_notes_hint'.tr(),
                ),
                SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('booking.field_subtotal'.tr(), style: TextStyle(fontSize: 13.sp)),
                    Text(
                      formatMoneyDisplay(subtotal),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                CustomButton(
                  text: 'booking.submit'.tr(),
                  isLoading: state.isSubmitting,
                  onPressed: state.isSubmitting ? null : _submit,
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'booking.hold_note'.tr(),
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      );
    }
  }

  class _HarvestLotOption {
    final String id;
    final DateTime expectedHarvestDate;
    final String status;
    final double availableQuantityTon;

    const _HarvestLotOption({
      required this.id,
      required this.expectedHarvestDate,
      required this.status,
      required this.availableQuantityTon,
    });

    bool get isBookable =>
        (status == 'SCHEDULED' || status == 'HARVESTING') && availableQuantityTon > 0;

    factory _HarvestLotOption.fromJson(Map<String, dynamic> json) {
      final expected = (json['expectedQuantityTon'] as num?)?.toDouble() ?? 0;
      final reserved = (json['reservedQuantityTon'] as num?)?.toDouble() ?? 0;
      return _HarvestLotOption(
        id: json['id']?.toString() ?? '',
        expectedHarvestDate: DateTime.tryParse(json['expectedHarvestDate']?.toString() ?? '') ??
            DateTime.now(),
        status: json['status']?.toString() ?? 'SCHEDULED',
        availableQuantityTon: (expected - reserved).clamp(0, double.infinity),
      );
    }
  }
