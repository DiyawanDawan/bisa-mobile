import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/core.dart';
import 'package:mobile_bisa/core/utils/media_url_utils.dart';
import 'package:mobile_bisa/shared/widgets/bisa_media_skeleton.dart';
import 'package:mobile_bisa/features/marketplace/presentation/widgets/horizontal_product_section.dart';
import '../../../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../../../injection_container.dart';
import '../bloc/negotiation_cubit.dart';
import '../../../../shared/widgets/notification_bell_button.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/bisa_search_field.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../shared/widgets/guest_placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_bisa/features/marketplace/presentation/widgets/vertical_product_grid_section.dart';
import '../utils/negotiation_status_ui.dart';
import '../../domain/entities/negotiation_entity.dart';
import '../../domain/entities/negotiation_entity_extensions.dart';
import '../../domain/enums/negotiation_chat_purpose.dart';
import '../../../../shared/widgets/bisa_filter_chip.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/shimmer_loading.dart';

class NegotiationListPage extends StatefulWidget {
  final String activeProductMode;

  const NegotiationListPage({
    super.key,
    required this.activeProductMode,
  });

  @override
  State<NegotiationListPage> createState() => _NegotiationListPageState();
}

class _NegotiationListPageState extends State<NegotiationListPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatus = 'ALL';
  late final TabController _roomTabController;
  late final NegotiationCubit _negotiationCubit;

  NegotiationChatPurpose get _activeRoomType =>
      _roomTabController.index == 0
          ? NegotiationChatPurpose.inquiry
          : NegotiationChatPurpose.negotiation;

  final List<Map<String, String>> _statusFilters = [
    {'label': 'Semua', 'value': 'ALL'},
    {'label': 'Aktif', 'value': 'OPEN_NEGOTIATION'},
    {'label': 'Menunggu', 'value': 'OFFER_SUBMITTED'},
    {'label': 'Diterima', 'value': 'OFFER_ACCEPTED'},
    {'label': 'Ditolak', 'value': 'OFFER_REJECTED'},
    {'label': 'Tagihan', 'value': 'LOCKED'},
    {'label': 'Kedaluwarsa', 'value': 'EXPIRED'},
    {'label': 'Dibatalkan', 'value': 'CANCELLED'},
  ];

  @override
  void initState() {
    super.initState();
    _negotiationCubit = sl<NegotiationCubit>();
    _roomTabController = TabController(length: 2, vsync: this, initialIndex: 1);
    _roomTabController.addListener(_onRoomTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _reloadList();
    });
  }

  void _scheduleListLoadIfNeeded() {
  final needsLoad = _negotiationCubit.state.maybeWhen(
      loaded: (_) => false,
      loading: () => false,
      orElse: () => true,
    );
    if (!needsLoad) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _reloadList();
    });
  }

  void _onRoomTabChanged() {
    if (_roomTabController.indexIsChanging) return;
    setState(() {
      if (_roomTabController.index == 0) {
        _selectedStatus = 'ALL';
      }
    });
    _reloadList();
  }

  bool get _isInquiryTab => _roomTabController.index == 0;

  void _reloadList() {
    final user = context.read<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );
    if (user == null) return;

    if (user.role == 'SUPPLIER') {
      _negotiationCubit.getIncomingOffers(roomType: _activeRoomType);
    } else {
      _negotiationCubit.getMyOffers(roomType: _activeRoomType);
    }
  }

  @override
  void dispose() {
    _roomTabController.removeListener(_onRoomTabChanged);
    _roomTabController.dispose();
    _negotiationCubit.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final user = authState.maybeWhen(
      authenticated: (user) => user,
      orElse: () => null,
    );
    final isSupplier = user?.role == 'SUPPLIER';
    final isBuyer = user?.role == 'BUYER';

    return BlocProvider.value(
      value: _negotiationCubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          backgroundColor: AppColors.surface,
          centerTitle: false,
          titleWidget: AnimatedBuilder(
            animation: _roomTabController,
            builder: (_, __) => Text(
              _roomTabController.index == 0 ? 'Pesan' : 'Negosiasi Harga',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          actions: const [
            NotificationBellButton(),
          ],
        ),
        body: user == null
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const GuestPlaceholder(
                      title: 'Akses Terbatas',
                      subtitle:
                          'Silakan masuk untuk melakukan negosiasi harga dengan supplier pilihan Anda.',
                      icon: Icons.handshake_rounded,
                    ),
                    SizedBox(height: 20.h),
                    HorizontalProductSection(
                      title: widget.activeProductMode == 'ORGANIC_PRODUCE'
                          ? 'Hasil Tani Baru Untuk Anda'
                          : 'Rekomendasi Biomassa Baru',
                      sortBy: 'createdAt',
                      sortOrder: 'desc',
                      limit: 10,
                      productMode: widget.activeProductMode,
                      onShowAll: () => context.go('/marketplace'),
                    ),
                    VerticalProductGridSection(
                      title: widget.activeProductMode == 'ORGANIC_PRODUCE'
                          ? 'Semua Hasil Tani Organik'
                          : 'Semua Produk Biomassa',
                      sortBy: 'createdAt',
                      sortOrder: 'desc',
                      productMode: widget.activeProductMode,
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              )
            : BlocBuilder<NegotiationCubit, NegotiationState>(
                builder: (context, state) {
                  _scheduleListLoadIfNeeded();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildListChrome(),
                      Expanded(
                        child: state.maybeWhen(
                          loading: () => ShimmerListPlaceholder(
                            itemCount: 6,
                            itemHeight: 100.h,
                            scrollable: true,
                            padding: EdgeInsets.all(16.w),
                          ),
                          error: (msg) => Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline_rounded,
                                    size: 48.sp,
                                    color: AppColors.error,
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    msg,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  CustomButton(
                                    text: 'coba_lagi'.tr(),
                                    onPressed: _reloadList,
                                    width: 160.w,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          loaded: (negotiations) => _buildLoadedListBody(
                            negotiations: negotiations,
                            isSupplier: isSupplier,
                            isBuyer: isBuyer,
                            user: user,
                          ),
                          orElse: () => ShimmerListPlaceholder(
                            itemCount: 6,
                            itemHeight: 100.h,
                            scrollable: true,
                            padding: EdgeInsets.all(16.w),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Widget _buildListChrome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: AppColors.surface,
          child: TabBar(
            controller: _roomTabController,
            onTap: (_) => setState(() {}),
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
            tabs: const [
              Tab(text: 'Chat biasa'),
              Tab(text: 'Nego harga'),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
            16.w,
            12.h,
            16.w,
            _isInquiryTab ? 12.h : 8.h,
          ),
          color: AppColors.surface,
          child: BisaSearchField(
            controller: _searchController,
            hint: _isInquiryTab
                ? 'Cari toko atau produk...'
                : 'Cari supplier atau produk...',
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
            onClear: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
              });
            },
          ),
        ),
        if (!_isInquiryTab)
          Container(
            height: 48.h,
            color: AppColors.surface,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _statusFilters.length,
              itemBuilder: (context, index) {
                final filter = _statusFilters[index];
                final isSelected = _selectedStatus == filter['value'];

                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: Center(
                    child: BisaFilterChip(
                      label: filter['label']!,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedStatus = filter['value']!;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildLoadedListBody({
    required List<NegotiationEntity> negotiations,
    required bool isSupplier,
    required bool isBuyer,
    required dynamic user,
  }) {
    final filteredList = negotiations.where((n) {
      final matchesRoom =
          _isInquiryTab ? n.isInquiryChat : n.isNegotiationChat;
      if (!matchesRoom) return false;

      final String name = isSupplier
          ? n.buyer.name.toLowerCase()
          : (n.seller.companyName?.toLowerCase() ??
                n.seller.name.toLowerCase());
      final String productName = n.product.name.toLowerCase();
      final bool matchesSearch =
          name.contains(_searchQuery) || productName.contains(_searchQuery);

      if (_isInquiryTab) return matchesSearch;

      final bool matchesStatus =
          _selectedStatus == 'ALL' || n.status == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => _reloadList(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            if (negotiations.isEmpty)
              _buildEmptyState(inquiry: _isInquiryTab)
            else if (filteredList.isEmpty)
              Padding(
                padding: EdgeInsets.only(top: 100.h),
                child: Text('data_tidak_ditemukan'.tr()),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final n = filteredList[index];
                  return _buildNegotiationCard(
                    context,
                    n,
                    isSupplier,
                    user,
                  );
                },
              ),
            if (isBuyer && !_isInquiryTab) ...[
              SizedBox(height: 32.h),
              const Divider(),
              SizedBox(height: 24.h),
              VerticalProductGridSection(
                title: widget.activeProductMode == 'ORGANIC_PRODUCE'
                    ? 'Rekomendasi Hasil Tani'
                    : 'Rekomendasi Untuk Anda',
                sortBy: 'createdAt',
                sortOrder: 'desc',
                productMode: widget.activeProductMode,
              ),
            ],
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _buildNegotiationCard(
    BuildContext context,
    NegotiationEntity n,
    bool isSupplier,
    dynamic currentUser,
  ) {
    final otherParty = isSupplier ? n.buyer : n.seller;
    final String name = isSupplier
        ? n.buyer.name
        : (n.seller.companyName ?? n.seller.name);

    final lastMessage = n.messages != null && n.messages!.isNotEmpty
        ? n.messages!.last
        : null;
    final bool isMeLast = lastMessage?.senderId == currentUser?.id;

    return Column(
      children: [
        Material(
          color: AppColors.surface,
          child: InkWell(
            onTap: () => NegotiationStatusDisplay.openFromList(context, n),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar Section
                  Container(
                    width: 52.r,
                    height: 52.r,
                    margin: EdgeInsets.only(top: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(26.r),
                      child: hasResolvableMediaUrl(otherParty.avatarUrl)
                          ? BisaNetworkImage(
                              imageUrl: otherParty.avatarUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => BisaMediaSkeleton.circle(
                                radius: 26.r,
                              ),
                            )
                          : Center(
                              child: Text(
                                name.substring(0, 1).toUpperCase(),
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  // Info Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.3,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            if (n.isInquiryChat)
                              _buildInquiryBadge()
                            else
                              _buildStatusBadge(
                                n.status,
                                orderStatus: n.order?.status,
                              ),
                            if (lastMessage != null) ...[
                              SizedBox(width: 6.w),
                              Text(
                                lastMessage.createdAt.toTime,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: AppColors.textHint,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 2.h),
                        GestureDetector(
                          onTap: () {
                            if (isSupplier) {
                              context.push('/negotiation/${n.id}/product');
                            } else {
                              context.push('/product/${n.productId}');
                            }
                          },
                          child: Text(
                            n.product.name,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            if (lastMessage != null && isMeLast) ...[
                              Icon(
                                lastMessage.isRead
                                    ? Icons.done_all_rounded
                                    : Icons.done_rounded,
                                size: 14.sp,
                                color: lastMessage.isRead
                                    ? AppColors.secondary
                                    : AppColors.textHint,
                              ),
                              SizedBox(width: 4.w),
                            ],
                            Expanded(
                              child: Text(
                                lastMessage?.content ?? 'Belum ada pesan',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: AppColors.grey200.withValues(alpha: 0.5),
          indent: 82.w,
        ),
      ],
    );
  }

  Widget _buildInquiryBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        'Chat',
        style: TextStyle(
          color: AppColors.info,
          fontSize: 9.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(
    String status, {
    String? orderStatus,
  }) {
    final display = NegotiationStatusDisplay.forList(
      status,
      orderStatus: orderStatus,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: display.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        display.label,
        style: TextStyle(
          color: display.color,
          fontSize: 9.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildEmptyState({required bool inquiry}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 60.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(28.r),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              inquiry
                  ? Icons.forum_outlined
                  : Icons.handshake_outlined,
              size: 56.sp,
              color: AppColors.grey300,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            inquiry ? 'Belum ada pesan' : 'belum_ada_negosiasi'.tr(),
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            inquiry
                ? 'Chat tanya produk dari halaman detail produk akan muncul di sini.'
                : 'penawaran_muncul_di_sini'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textHint, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}
