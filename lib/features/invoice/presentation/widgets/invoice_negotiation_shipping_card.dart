import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/extensions.dart';
import 'package:mobile_bisa/features/invoice/domain/entities/invoice_preview_entity.dart';
import 'package:mobile_bisa/features/invoice/presentation/bloc/create_invoice_cubit.dart';
import 'package:mobile_bisa/features/orders/presentation/bloc/order_cubit.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';
import 'package:mobile_bisa/shared/widgets/osm_location_picker_page.dart';

/// Pilih ongkir RajaOngkir saat menerbitkan tagihan dari negosiasi (supplier).
class InvoiceNegotiationShippingCard extends StatefulWidget {
  final String negotiationId;
  final InvoicePreviewEntity preview;

  const InvoiceNegotiationShippingCard({
    super.key,
    required this.negotiationId,
    required this.preview,
  });

  @override
  State<InvoiceNegotiationShippingCard> createState() =>
      _InvoiceNegotiationShippingCardState();
}

class _InvoiceNegotiationShippingCardState
    extends State<InvoiceNegotiationShippingCard> {
  bool _loading = false;
  String? _error;
  String? _manualDestinationQuery;
  String? _courierCode;

  Future<void> _pickShipping() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final orderCubit = context.read<OrderCubit>();
      final origin = await orderCubit.getShippingOrigin();
      final originId = int.tryParse(origin?['originId']?.toString() ?? '');
      if (originId == null) {
        throw Exception(
          'Atur asal pengiriman di profil supplier (menu Pengiriman) terlebih dahulu.',
        );
      }

      final snapshot = widget.preview.shippingSnapshot ?? {};
      final defaultQuery = [
        snapshot['regency']?.toString(),
        snapshot['province']?.toString(),
        snapshot['address']?.toString(),
      ].where((e) => e != null && e.trim().isNotEmpty).join(', ');
      final destQuery = (_manualDestinationQuery?.trim().isNotEmpty ?? false)
          ? _manualDestinationQuery!.trim()
          : defaultQuery;
      if (destQuery.length < 3) {
        throw Exception('Alamat tujuan buyer belum lengkap untuk hitung ongkir.');
      }

      final destinationSearch = await orderCubit.searchShippingDestinations(
        search: destQuery,
        limit: 10,
      );
      if (destinationSearch.quotaExceeded) {
        throw Exception(
          destinationSearch.errorMessage ??
              'Kuota harian API ongkir habis. Coba lagi besok.',
        );
      }
      if (destinationSearch.items.isEmpty) {
        throw Exception('Lokasi tujuan ongkir tidak ditemukan.');
      }
      final destination = destinationSearch.items.first;
      final destinationId = int.tryParse(destination['id']?.toString() ?? '');
      if (destinationId == null) {
        throw Exception('ID tujuan ongkir tidak valid.');
      }

      final weightGrams = (widget.preview.quantity * 1000).ceil().clamp(1000, 500000);
      final options = await orderCubit.calculateDomesticShipping(
        originId: originId,
        destinationId: destinationId,
        weightGrams: weightGrams,
        courier: _courierCode,
      );
      if (!mounted) return;
      if (options.isEmpty) {
        throw Exception('Opsi kurir tidak tersedia untuk rute ini.');
      }

      final selected = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        builder: (ctx) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih Layanan Kurir',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: options.length,
                      separatorBuilder: (_, __) => SizedBox(height: 8.h),
                      itemBuilder: (_, i) {
                        final opt = options[i];
                        final cost = (opt['cost'] as num?)?.toDouble() ??
                            double.tryParse(opt['cost']?.toString() ?? '0') ??
                            0;
                        return ListTile(
                          tileColor: AppColors.grey50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          title: Text(
                            '${(opt['code'] ?? '').toString().toUpperCase()} · ${opt['service'] ?? opt['description'] ?? ''}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                            '${opt['etd'] ?? ''} · ${cost.toRupiah}',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          onTap: () => Navigator.pop(ctx, opt),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      if (!mounted || selected == null) return;

      final cost = (selected['cost'] as num?)?.toDouble() ??
          double.tryParse(selected['cost']?.toString() ?? '0') ??
          0;
      final selection = {
        'originId': originId,
        'destinationId': destinationId,
        'destinationLabel': destination['label']?.toString(),
        'weightGrams': weightGrams,
        'courierCode': selected['code']?.toString() ?? '',
        'serviceCode': selected['service']?.toString(),
        'serviceName': selected['description']?.toString() ??
            selected['service']?.toString(),
        'cost': cost,
      };

      context.read<CreateInvoiceCubit>().setShippingSelection(selection);
      await context.read<CreateInvoiceCubit>().refreshPreview(widget.negotiationId);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CreateInvoiceCubit>();
    final selection = cubit.state.shippingSelection;
    final preview = cubit.state.preview;
    final logisticsFee = preview?.logisticsFee ?? 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pengiriman & Ongkir',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          if (selection != null && logisticsFee > 0) ...[
            Text(
              '${selection['courierCode']?.toString().toUpperCase()} · ${selection['serviceName'] ?? ''}',
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: 4.h),
            Text(
              'Biaya ongkir: ${logisticsFee.toRupiah}',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 10.h),
          ],
          if (_error != null) ...[
            Text(
              _error!,
              style: TextStyle(fontSize: 12.sp, color: AppColors.error),
            ),
            SizedBox(height: 8.h),
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _loading
                  ? null
                  : () async {
                      final picked = await OsmLocationPickerPage.open(context);
                      if (!mounted || picked == null) return;
                      final query = picked.formattedAddress.trim();
                      if (query.isEmpty) return;
                      setState(() => _manualDestinationQuery = query);
                    },
              icon: const Icon(Icons.edit_location_alt_outlined),
              label: Text(
                _manualDestinationQuery == null
                    ? 'Pilih Lokasi Tujuan (OpenStreetMap)'
                    : 'Lokasi: $_manualDestinationQuery',
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _loading
                  ? null
                  : () async {
                      final couriers =
                          await context.read<OrderCubit>().getActiveCouriers();
                      if (!mounted || couriers.isEmpty) return;
                      final selected = await showModalBottomSheet<String>(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16.r)),
                        ),
                        builder: (ctx) => SafeArea(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              ListTile(
                                title: const Text('Semua Kurir Aktif'),
                                onTap: () => Navigator.of(ctx).pop(''),
                              ),
                              ...couriers.map(
                                (code) => ListTile(
                                  title: Text(code.toUpperCase()),
                                  onTap: () => Navigator.of(ctx).pop(code),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                      if (!mounted || selected == null) return;
                      setState(() {
                        _courierCode = selected.isEmpty ? null : selected;
                      });
                    },
              icon: const Icon(Icons.local_shipping_outlined),
              label: Text(
                _courierCode == null
                    ? 'Kurir: semua aktif'
                    : 'Kurir: ${_courierCode!.toUpperCase()}',
              ),
            ),
          ),
          CustomButton(
            text: selection == null ? 'Hitung & Pilih Ongkir' : 'Ubah Ongkir',
            onPressed: _loading ? null : _pickShipping,
            isLoading: _loading,
            isOutlined: true,
          ),
        ],
      ),
    );
  }
}
