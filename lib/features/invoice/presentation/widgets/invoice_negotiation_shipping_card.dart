import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/extensions.dart';
import 'package:mobile_bisa/features/invoice/presentation/bloc/create_invoice_cubit.dart';
import 'package:mobile_bisa/features/orders/presentation/bloc/order_cubit.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';

/// Pilih ongkir RajaOngkir — hanya setelah alamat tujuan pembeli lengkap.
class InvoiceNegotiationShippingCard extends StatefulWidget {
  final String negotiationId;

  const InvoiceNegotiationShippingCard({
    super.key,
    required this.negotiationId,
  });

  @override
  State<InvoiceNegotiationShippingCard> createState() =>
      _InvoiceNegotiationShippingCardState();
}

class _InvoiceNegotiationShippingCardState
    extends State<InvoiceNegotiationShippingCard> {
  bool _loading = false;
  String? _error;
  String? _courierCode;

  Future<int?> _resolveOriginId(
    OrderCubit orderCubit,
    CreateInvoiceCubit cubit,
  ) async {
    final state = cubit.state;
    if (state.sellerOriginId != null) return state.sellerOriginId;

    final stored = await orderCubit.getShippingOrigin();
    final storedId = int.tryParse(stored?['originId']?.toString() ?? '');
    if (storedId != null) return storedId;

    final snap = state.sellerShippingSnapshot;
    final queries = <String?>[
      state.sellerOriginLabel,
      if (snap != null)
        [
          snap['regency']?.toString(),
          snap['province']?.toString(),
        ].where((e) => e != null && e.trim().isNotEmpty).join(', '),
      snap?['regency']?.toString(),
      snap?['address']?.toString(),
    ];
    for (final q in queries) {
      if (q == null || q.trim().length < 3) continue;
      final search = await orderCubit.searchShippingDestinations(
        search: q.trim(),
        limit: 8,
      );
      if (search.quotaExceeded) {
        throw Exception(
          search.errorMessage ?? 'Kuota harian API ongkir habis. Coba lagi besok.',
        );
      }
      if (search.items.isEmpty) continue;
      final id = int.tryParse(search.items.first['id']?.toString() ?? '');
      if (id != null) return id;
    }
    return null;
  }

  Future<void> _pickShipping() async {
    final cubit = context.read<CreateInvoiceCubit>();
    final draft = cubit.state.draft;
    if (!CreateInvoiceCubit.isDestinationReady(draft)) {
      setState(() {
        _error =
            'Lengkapi alamat tujuan di atas (min. 10 karakter + kab/kota atau provinsi) sebelum hitung ongkir.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final orderCubit = context.read<OrderCubit>();
      final originId = await _resolveOriginId(orderCubit, cubit);
      if (originId == null) {
        throw Exception(
          'Asal pengiriman tidak ditemukan. Lengkapi alamat bisnis/toko di Profil '
          'atau atur lokasi ongkir di menu Pengiriman.',
        );
      }

      final snapshot = draft!.toShippingSnapshot();
      final destQuery = [
        snapshot['regency']?.toString(),
        snapshot['province']?.toString(),
        snapshot['address']?.toString(),
      ].where((e) => e != null && e.trim().isNotEmpty).join(', ');
      if (destQuery.length < 3) {
        throw Exception(
          'Alamat tujuan belum lengkap. Isi kab/kota atau provinsi di bagian alamat pengiriman.',
        );
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
        throw Exception('Lokasi tujuan ongkir tidak ditemukan. Periksa kab/kota tujuan.');
      }
      final destination = destinationSearch.items.first;
      final destinationId = int.tryParse(destination['id']?.toString() ?? '');
      if (destinationId == null) {
        throw Exception('ID tujuan ongkir tidak valid.');
      }

      final qty = draft.quantity;
      final weightGrams = (qty * 1000).ceil().clamp(1000, 500000);
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
                  SizedBox(height: 8.h),
                  Text(
                    'Tujuan: $destQuery',
                    style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

      cubit.setShippingSelection(selection);
      await cubit.refreshPreview(widget.negotiationId);
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
    final draft = cubit.state.draft;
    final selection = cubit.state.shippingSelection;
    final preview = cubit.state.preview;
    final logisticsFee = preview?.logisticsFee ?? 0;
    final destinationReady = CreateInvoiceCubit.isDestinationReady(draft);
    final sellerSnap = cubit.state.sellerShippingSnapshot;
    final originReady = cubit.state.sellerOriginId != null ||
        (sellerSnap?['regency']?.toString().trim().isNotEmpty ?? false) ||
        (sellerSnap?['province']?.toString().trim().isNotEmpty ?? false);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: destinationReady ? AppColors.grey200 : AppColors.warning.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pengiriman & Ongkir BISA',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            destinationReady
                ? 'Langkah 2: hitung ongkir berdasarkan alamat tujuan di atas.'
                : 'Langkah 2: isi alamat tujuan di atas terlebih dahulu (min. 10 karakter + kab/kota atau provinsi).',
            style: TextStyle(
              fontSize: 11.sp,
              color: destinationReady ? AppColors.textHint : AppColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (cubit.state.sellerOriginLabel != null &&
              cubit.state.sellerOriginLabel!.trim().isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              'Asal ongkir: ${cubit.state.sellerOriginLabel}',
              style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
            ),
          ],
          if (destinationReady && draft != null) ...[
            SizedBox(height: 6.h),
            Text(
              'Tujuan: ${[
                draft.regency,
                draft.province,
              ].where((e) => e.trim().isNotEmpty).join(', ')}',
              style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
            ),
          ],
          if (!originReady) ...[
            SizedBox(height: 6.h),
            Text(
              'Asal toko belum terdeteksi — lengkapi alamat bisnis di Profil supplier.',
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          SizedBox(height: 10.h),
          if (selection != null && logisticsFee > 0) ...[
            Text(
              'BISA',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 4.h),
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
          if (destinationReady)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _loading
                    ? null
                    : () async {
                        final couriers =
                            await context.read<OrderCubit>().getActiveCouriers();
                        if (!context.mounted || couriers.isEmpty) return;
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
                        if (!context.mounted || selected == null) return;
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
            onPressed: (!destinationReady || _loading) ? null : _pickShipping,
            isLoading: _loading,
            isOutlined: true,
          ),
        ],
      ),
    );
  }
}
