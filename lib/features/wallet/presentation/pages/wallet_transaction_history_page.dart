import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/features/wallet/domain/entities/wallet_transaction_entity.dart';
import 'package:mobile_bisa/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:mobile_bisa/features/wallet/presentation/widgets/wallet_transaction_ui.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/bisa_filter_chip.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';

class WalletTransactionHistoryPage extends StatefulWidget {
  const WalletTransactionHistoryPage({super.key});

  @override
  State<WalletTransactionHistoryPage> createState() =>
      _WalletTransactionHistoryPageState();
}

class _WalletTransactionHistoryPageState
    extends State<WalletTransactionHistoryPage> {
  final _repository = sl<WalletRepository>();

  List<WalletTransactionEntity> _transactions = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _errorMessage;
  int _page = 1;
  bool _hasMore = true;

  String _typeFilter = 'ALL';
  String _statusFilter = 'ALL';

  static const _typeFilters = [
    {'label': 'Semua', 'value': 'ALL'},
    {'label': 'Penjualan', 'value': 'SALES'},
    {'label': 'Penarikan', 'value': 'PAYOUT'},
    {'label': 'Langganan', 'value': 'SUBSCRIPTION'},
  ];

  static const _statusFilters = [
    {'label': 'Semua Status', 'value': 'ALL'},
    {'label': 'Menunggu', 'value': 'PENDING'},
    {'label': 'Escrow', 'value': 'ESCROW_HELD'},
    {'label': 'Berhasil', 'value': 'RELEASED'},
    {'label': 'Gagal', 'value': 'FAILED'},
  ];

  @override
  void initState() {
    super.initState();
    _loadTransactions(reset: true);
  }

  Future<void> _loadTransactions({bool reset = false}) async {
    if (reset) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _page = 1;
        _hasMore = true;
      });
    } else {
      if (!_hasMore || _isLoadingMore) return;
      setState(() => _isLoadingMore = true);
    }

    final result = await _repository.getTransactions(
      page: _page,
      limit: 20,
      type: _typeFilter == 'ALL' ? null : _typeFilter,
      status: _statusFilter == 'ALL' ? null : _statusFilter,
    );

    if (!mounted) return;

    result.fold(
      (failure) => setState(() {
        _errorMessage = failure.message;
        _isLoading = false;
        _isLoadingMore = false;
      }),
      (items) => setState(() {
        if (reset) {
          _transactions = items;
        } else {
          _transactions = [..._transactions, ...items];
        }
        _hasMore = items.length >= 20;
        if (_hasMore) _page++;
        _isLoading = false;
        _isLoadingMore = false;
      }),
    );
  }

  void _applyFilter({String? type, String? status}) {
    setState(() {
      if (type != null) _typeFilter = type;
      if (status != null) _statusFilter = status;
    });
    _loadTransactions(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BisaAppBar(
        title: 'Riwayat Transaksi',
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterSection(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jenis',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _typeFilters.map((f) {
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: BisaFilterChip(
                    label: f['label']!,
                    isSelected: _typeFilter == f['value'],
                    onTap: () => _applyFilter(type: f['value']),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Status',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _statusFilters.map((f) {
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: BisaFilterChip(
                    label: f['label']!,
                    isSelected: _statusFilter == f['value'],
                    onTap: () => _applyFilter(status: f['value']),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ShimmerListPlaceholder(
        itemCount: 8,
        itemHeight: 72.h,
        scrollable: true,
        padding: EdgeInsets.all(16.w),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage!, textAlign: TextAlign.center),
              SizedBox(height: 16.h),
              CustomButton(
                text: 'coba_lagi'.tr(),
                width: 160.w,
                onPressed: () => _loadTransactions(reset: true),
              ),
            ],
          ),
        ),
      );
    }

    if (_transactions.isEmpty) {
      return Center(
        child: Text(
          'belum_ada_transaksi'.tr(),
          style: TextStyle(color: AppColors.textHint),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadTransactions(reset: true),
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        itemCount: _transactions.length + (_hasMore ? 1 : 0),
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: AppColors.grey100,
        ),
        itemBuilder: (context, index) {
          if (index >= _transactions.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Center(
                child: _isLoadingMore
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : TextButton(
                        onPressed: () => _loadTransactions(reset: false),
                        child: const Text('Muat lebih banyak'),
                      ),
              ),
            );
          }

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: WalletTransactionTile(tx: _transactions[index]),
          );
        },
      ),
    );
  }
}
