import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/features/marketplace/presentation/widgets/horizontal_product_section.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/order_cubit.dart';
import '../widgets/grouped_orders_list.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../../shared/widgets/notification_bell_button.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/guest_placeholder.dart';
import '../../domain/entities/order_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_bisa/features/marketplace/presentation/widgets/vertical_product_grid_section.dart';
import '../../../../shared/widgets/bisa_filter_chip.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../widgets/order_card_skeleton.dart';

class OrdersPage extends StatefulWidget {
  final String activeProductMode;

  const OrdersPage({
    super.key,
    required this.activeProductMode,
  });

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String _selectedStatus = 'ALL';
  String _searchQuery = '';
  final _searchController = TextEditingController();
  bool _isSearching = false;
  String? _lastLoadedProductMode;
  Timer? _searchDebounce;

  final List<Map<String, String>> _statuses = [
    {'label': 'Semua', 'value': 'ALL'},
    {'label': 'Menunggu', 'value': 'PENDING'},
    {'label': 'Diproses', 'value': 'PROCESSING'},
    {'label': 'Dikirim', 'value': 'SHIPPED'},
    {'label': 'Selesai', 'value': 'COMPLETED'},
    {'label': 'Dibatalkan', 'value': 'CANCELLED'},
    {'label': 'Sengketa', 'value': 'DISPUTED'},
    {'label': 'Refund', 'value': 'REFUNDED'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshOrders());
  }

  @override
  void didUpdateWidget(OrdersPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeProductMode != widget.activeProductMode) {
      _refreshOrders();
    }
  }

  void _refreshOrders() {
    if (!mounted) return;
    final user = context.read<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );
    if (user == null) return;
    if (_lastLoadedProductMode == widget.activeProductMode) return;
    _lastLoadedProductMode = widget.activeProductMode;
    _fetchOrders();
  }

  void _fetchOrders({String? search}) {
    if (!mounted) return;
    final user = context.read<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );
    if (user == null) return;
    final q = search?.trim();
    final apiSearch = q != null && q.isNotEmpty ? q : null;
    if (user.role == 'SUPPLIER') {
      context.read<OrderCubit>().getMySales(search: apiSearch);
    } else {
      context.read<OrderCubit>().getMyPurchases(search: apiSearch);
    }
  }

  void _onSearchChanged(String val) {
    setState(() => _searchQuery = val);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      _fetchOrders(search: val);
    });
  }

  void _closeSearch() {
    _searchDebounce?.cancel();
    setState(() {
      _isSearching = false;
      _searchQuery = '';
      _searchController.clear();
    });
    _fetchOrders();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  String _selectedDateFilter = 'ALL';

  bool get _hasActiveFilters =>
      _selectedStatus != 'ALL' ||
      _selectedDateFilter != 'ALL' ||
      _searchQuery.isNotEmpty;

  void _resetFilters() {
    _searchDebounce?.cancel();
    setState(() {
      _selectedStatus = 'ALL';
      _selectedDateFilter = 'ALL';
      _searchQuery = '';
      _searchController.clear();
      _isSearching = false;
    });
    _fetchOrders();
  }

  void _showSearchSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: 72.h),
          child: StatefulBuilder(
            builder: (context, setModalState) => Container(
            padding: EdgeInsets.fromLTRB(
              24.w,
              12.h,
              24.w,
              20.h + MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                SizedBox(height: 24.h),
                Text(
                  'Filter Pesanan',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Status Pesanan',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 4.h,
                  children: _statuses.map((status) {
                    return _buildStatusChipInSheet(
                      status['label']!,
                      status['value']!,
                      setModalState,
                    );
                  }).toList(),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Rentang Waktu',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 8.w,
                  children: [
                    _buildDateChip('Semua', 'ALL', setModalState),
                    _buildDateChip('Hari Ini', 'TODAY', setModalState),
                    _buildDateChip('Minggu Ini', 'WEEK', setModalState),
                    _buildDateChip('Bulan Ini', 'MONTH', setModalState),
                  ],
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  text: 'Terapkan Filter',
                  height: 44.h,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
        );
      },
    );
  }

  Widget _buildStatusChipInSheet(
    String label,
    String value,
    StateSetter setModalState,
  ) {
    final isSelected = _selectedStatus == value;
    return BisaFilterChip(
      label: label,
      isSelected: isSelected,
      onTap: () {
        setModalState(() => _selectedStatus = value);
        setState(() => _selectedStatus = value);
      },
    );
  }

  Widget _buildDateChip(String label, String value, StateSetter setModalState) {
    final isSelected = _selectedDateFilter == value;
    return BisaFilterChip(
      label: label,
      isSelected: isSelected,
      onTap: () {
        setModalState(() => _selectedDateFilter = value);
        setState(() => _selectedDateFilter = value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<AuthCubit>().state;
    final user = userState.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );
    final isSupplier = user?.role == 'SUPPLIER';

    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          backgroundColor: AppColors.white,
          showBackButton: false,
          centerTitle: false,
          actions: [
            const NotificationBellButton(),
            BisaAppBarAction(
              icon: _isSearching ? LucideIcons.x : LucideIcons.search,
              onTap: () {
                if (_isSearching) {
                  _closeSearch();
                } else {
                  setState(() => _isSearching = true);
                }
              },
            ),
          ],
          titleWidget: _isSearching
              ? AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'No. pesanan, produk, toko, tracking...',
                      hintStyle: TextStyle(
                        color: AppColors.textHint,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      prefixIcon: Icon(
                        LucideIcons.search,
                        size: 18.sp,
                        color: AppColors.textHint,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 11.h),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isSupplier ? 'Penjualan Saya' : 'Pesanan Saya',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      isSupplier
                          ? 'Kelola transaksi sebagai Supplier'
                          : 'Pantau status belanja Anda',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        ),
        body: user == null
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const GuestPlaceholder(
                      title: 'Pesanan Tidak Ditemukan',
                      subtitle:
                          'Silakan masuk untuk melihat list pesanan Anda.',
                      icon: LucideIcons.shoppingBag,
                    ),
                    SizedBox(height: 20.h),
                    HorizontalProductSection(
                      title: widget.activeProductMode == 'ORGANIC_PRODUCE'
                          ? 'Hasil Tani Rekomendasi'
                          : 'Produk Rekomendasi',
                      sortBy: 'createdAt',
                      sortOrder: 'desc',
                      limit: 10,
                      productMode: widget.activeProductMode,
                      onShowAll: () => context.go('/marketplace'),
                    ),
                    HorizontalProductSection(
                      title: widget.activeProductMode == 'ORGANIC_PRODUCE'
                          ? 'Hasil Tani Terlaris'
                          : 'Produk Terlaris',
                      sortBy: 'averageRating',
                      sortOrder: 'desc',
                      limit: 10,
                      productMode: widget.activeProductMode,
                      onShowAll: () => context.go('/marketplace'),
                    ),
                    VerticalProductGridSection(
                      title: widget.activeProductMode == 'ORGANIC_PRODUCE'
                          ? 'Semua Hasil Tani'
                          : 'Semua Produk',
                      sortBy: 'createdAt',
                      sortOrder: 'desc',
                      productMode: widget.activeProductMode,
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              )
            : BlocBuilder<OrderCubit, OrderState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    initial: () => const SizedBox.shrink(),
                    loading: () => _buildOrdersLoadingSkeleton(),
                    error: (message) => Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.circleAlert,
                              color: AppColors.error,
                              size: 48.sp,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            CustomButton(
                              text: 'coba_lagi'.tr(),
                              width: 160.w,
                              onPressed: () => _fetchOrders(
                                search: _searchQuery.trim().isEmpty
                                    ? null
                                    : _searchQuery,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    loaded: (orders) {
                      final filteredOrders = _filterOrders(orders);

                      return RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: () async {
                          _fetchOrders(
                            search: _searchQuery.trim().isEmpty
                                ? null
                                : _searchQuery,
                          );
                          await Future<void>.delayed(
                            const Duration(milliseconds: 300),
                          );
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          child: Column(
                            children: [
                              _buildStatusFilter(),
                              if (filteredOrders.isNotEmpty)
                                _buildOrdersSummary(filteredOrders.length),
                              if (filteredOrders.isEmpty)
                                _buildEmptyState()
                              else
                                GroupedOrdersList(
                                  orders: filteredOrders,
                                  isSupplierView: isSupplier,
                                ),
                              if (user?.role == 'BUYER') ...[
                                SizedBox(height: 32.h),
                                const Divider(),
                                SizedBox(height: 24.h),
                                VerticalProductGridSection(
                                  title: widget.activeProductMode == 'ORGANIC_PRODUCE'
                                      ? 'Hasil Tani Untuk Anda'
                                      : 'Mungkin Anda Tertarik',
                                  sortBy: 'averageRating',
                                  sortOrder: 'desc',
                                  productMode: widget.activeProductMode,
                                ),
                              ],
                              SizedBox(height: 100.h),
                            ],
                          ),
                        ),
                      );
                    },
                    orElse: () => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                },
              ),
    );
  }

  Widget _buildOrdersLoadingSkeleton() {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        _fetchOrders(
          search: _searchQuery.trim().isEmpty ? null : _searchQuery,
        );
        await Future<void>.delayed(const Duration(milliseconds: 300));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatusFilter(),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              child: const ShimmerOrderListPlaceholder(itemCount: 4),
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersSummary(int count) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 4.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '$count pesanan',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),
          if (_hasActiveFilters) ...[
            SizedBox(width: 8.w),
            InkWell(
              onTap: _resetFilters,
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: AppColors.grey100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.x, size: 12.sp, color: AppColors.textSecondary),
                    SizedBox(width: 4.w),
                    Text(
                      'Reset filter',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const Spacer(),
          if (_selectedDateFilter != 'ALL')
            Text(
              _dateFilterLabel(_selectedDateFilter),
              style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
            ),
        ],
      ),
    );
  }

  String _dateFilterLabel(String value) {
    switch (value) {
      case 'TODAY':
        return 'Hari ini';
      case 'WEEK':
        return '7 hari';
      case 'MONTH':
        return '30 hari';
      default:
        return '';
    }
  }

  Widget _buildStatusFilter() {
    final filterActive = _hasActiveFilters;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: AppColors.softShadow,
      ),
      padding: EdgeInsets.only(top: 8.h, bottom: 8.h, right: 8.w),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 36.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: _statuses.length,
                itemBuilder: (context, index) {
                  final status = _statuses[index];
                  final isSelected = _selectedStatus == status['value'];
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Center(
                      child: BisaFilterChip(
                        label: status['label']!,
                        isSelected: isSelected,
                        onTap: () =>
                            setState(() => _selectedStatus = status['value']!),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            width: 1,
            height: 24.h,
            color: AppColors.grey200,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
          ),
          Material(
            color: filterActive
                ? AppColors.primary.withValues(alpha: 0.1)
                : AppColors.grey50,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: _showSearchSheet,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: Icon(
                  LucideIcons.slidersHorizontal,
                  size: 18.sp,
                  color: filterActive ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<OrderEntity> _filterOrders(List<OrderEntity> orders) {
    var filtered = orders;

    // Filter by status
    if (_selectedStatus != 'ALL') {
      filtered = filtered
          .where((o) => _matchesStatusFilter(o.status, _selectedStatus))
          .toList();
    }

    // Filter by search query (client-side untuk status/tanggal setelah hasil API)
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      filtered = filtered.where(_orderMatchesSearchQuery(query)).toList();
    }

    // Filter by date
    if (_selectedDateFilter != 'ALL') {
      final now = DateTime.now();
      filtered = filtered.where((o) {
        final orderDate = o.createdAt;
        switch (_selectedDateFilter) {
          case 'TODAY':
            return orderDate.year == now.year &&
                orderDate.month == now.month &&
                orderDate.day == now.day;
          case 'WEEK':
            final weekAgo = now.subtract(const Duration(days: 7));
            return orderDate.isAfter(weekAgo);
          case 'MONTH':
            final monthAgo = now.subtract(const Duration(days: 30));
            return orderDate.isAfter(monthAgo);
          default:
            return true;
        }
      }).toList();
    }

    return filtered;
  }

  bool Function(OrderEntity) _orderMatchesSearchQuery(String query) {
    return (OrderEntity o) {
      if (o.orderNumber.toLowerCase().contains(query)) return true;
      if (o.displayOrderNumber.toLowerCase().contains(query)) return true;
      final batch = o.checkoutBatchNumber?.toLowerCase() ?? '';
      if (batch.isNotEmpty && batch.contains(query)) return true;
      if (o.seller.name.toLowerCase().contains(query)) return true;
      if (o.buyer.name.toLowerCase().contains(query)) return true;
      final tracking = o.shipment?.trackingNumber?.toLowerCase() ?? '';
      if (tracking.isNotEmpty && tracking.contains(query)) return true;
      final awb = o.shipment?.awbNumber?.toLowerCase() ?? '';
      if (awb.isNotEmpty && awb.contains(query)) return true;
      return o.items.any(
        (item) => item.productName.toLowerCase().contains(query),
      );
    };
  }

  bool _matchesStatusFilter(String orderStatus, String filterValue) {
    final status = orderStatus.toUpperCase();
    switch (filterValue) {
      case 'PROCESSING':
        // Backend pakai PROCESSING setelah bayar; PAID/CONFIRMED = alias lama.
        return status == 'PROCESSING' ||
            status == 'PAID' ||
            status == 'CONFIRMED';
      default:
        return status == filterValue;
    }
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 48.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(28.r),
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: AppColors.softShadow,
            ),
            child: Icon(
              LucideIcons.shoppingBag,
              size: 52.sp,
              color: AppColors.grey200,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            _hasActiveFilters ? 'Pesanan tidak ditemukan' : 'Belum ada pesanan',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17.sp,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            _hasActiveFilters
                ? 'Coba ubah filter atau kata kunci pencarian Anda.'
                : 'Transaksi yang Anda lakukan akan muncul di sini.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13.sp,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          if (_hasActiveFilters) ...[
            SizedBox(height: 20.h),
            CustomButton(
              text: 'Reset Filter',
              width: 180.w,
              isOutlined: true,
              onPressed: _resetFilters,
            ),
          ],
        ],
      ),
    );
  }
}
