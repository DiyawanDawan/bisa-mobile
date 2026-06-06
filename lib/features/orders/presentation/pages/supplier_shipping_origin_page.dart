import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
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
      setState(() => _error = 'Ketik minimal 3 karakter (contoh: Bandung, Jawa Barat)');
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
        _error = result.errorMessage ?? 'Kuota API ongkir habis. Coba lagi besok.';
      });
      return;
    }

    setState(() {
      _loading = false;
      _results = result.items;
      if (_results.isEmpty) {
        _error = 'Lokasi tidak ditemukan. Coba kota + provinsi.';
      }
    });
  }

  Future<void> _save() async {
    final id = int.tryParse(_selected?['id']?.toString() ?? '');
    if (id == null) {
      setState(() => _error = 'Pilih lokasi asal pengiriman terlebih dahulu.');
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
      setState(() => _error = 'Gagal menyimpan asal pengiriman.');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Asal pengiriman toko berhasil disimpan.')),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BisaAppBar(
        title: 'Asal Pengiriman Toko',
        showBackButton: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Text(
            'Pilih kecamatan/kelurahan asal pengiriman untuk perhitungan ongkir RajaOngkir.',
            style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 12.h),
          if (_stored != null) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'Saat ini: ${_stored?['originLabel'] ?? _stored?['originId']}',
                style: TextStyle(fontSize: 12.sp, color: AppColors.primary),
              ),
            ),
            SizedBox(height: 12.h),
          ],
          TextField(
            controller: _queryController,
            decoration: InputDecoration(
              hintText: 'Cari lokasi (Bandung, Jawa Barat)',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: _loading ? null : _search,
              ),
            ),
            onSubmitted: (_) => _search(),
          ),
          if (_error != null) ...[
            SizedBox(height: 8.h),
            Text(_error!, style: TextStyle(color: AppColors.error, fontSize: 12.sp)),
          ],
          SizedBox(height: 12.h),
          ..._results.map(
            (item) => RadioListTile<Map<String, dynamic>>(
              value: item,
              groupValue: _selected,
              onChanged: (value) => setState(() => _selected = value),
              title: Text(item['label']?.toString() ?? item['id']?.toString() ?? ''),
            ),
          ),
          SizedBox(height: 16.h),
          CustomButton(
            text: 'Simpan asal pengiriman',
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
