import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../features/marketplace/presentation/pages/marketplace_page.dart';
import '../../../../features/marketplace/presentation/pages/store_management_page.dart';
import '../../../../features/forum/presentation/pages/forum_page.dart';
import '../../../../features/orders/presentation/pages/orders_page.dart';
import '../../../../features/profile/presentation/pages/profile_page.dart';
import '../../../../features/negotiation/presentation/pages/negotiation_list_page.dart';
import '../../../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../../../features/marketplace/presentation/bloc/marketplace_cubit.dart';
import '../../../../features/orders/presentation/bloc/order_cubit.dart';
import '../../../../shared/widgets/floating_bottom_nav.dart';
import '../../../../shared/widgets/app_coach_mark.dart';

class MainShellScope extends InheritedWidget {
  const MainShellScope({
    super.key,
    required this.selectTab,
    required super.child,
  });

  final void Function(int index) selectTab;

  static MainShellScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MainShellScope>();
  }

  @override
  bool updateShouldNotify(MainShellScope oldWidget) => false;
}

class MainScreen extends StatefulWidget {
  final int initialTab;

  const MainScreen({super.key, this.initialTab = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  String _activeProductMode = MarketplaceCubit.activeProductMode;

  final _tabKeys = List.generate(5, (_) => GlobalKey());
  final _fabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab.clamp(0, 4);
    _maybeShowCoachMark();
  }

  Future<void> _maybeShowCoachMark() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    final shouldShow = await AppCoachMark.shouldShow();
    if (!mounted) return;
    if (shouldShow) {
      _showCoachMark(onFinish: () => AppCoachMark.markSeen());
    }
  }

  void _showCoachMark({VoidCallback? onFinish}) {
    final isSupplier = context.read<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u.role == 'SUPPLIER',
          orElse: () => false,
        );

    AppCoachMark.show(
      context: context,
      onFinish: onFinish,
      onClickTarget: (target) {
        final idx = int.tryParse(target.identify?.toString() ?? '');
        if (idx != null && idx >= 0 && idx <= 4) {
          _selectTab(idx);
        }
      },
      targets: [
        AppCoachMark.createCircleTarget(
          key: _tabKeys[0],
          title: isSupplier ? 'Toko Anda' : 'Katalog',
          description: isSupplier
              ? 'Kelola produk dan lihat performa toko'
              : 'Jelajahi ribuan produk supplier',
        ),
        AppCoachMark.createCircleTarget(
          key: _tabKeys[1],
          title: 'Chat & Negosiasi',
          description: 'Diskusi harga dan syarat dengan penjual/pembeli',
        ),
        AppCoachMark.createCircleTarget(
          key: _tabKeys[2],
          title: 'Forum Komunitas',
          description: 'Berbagi tips dan diskusi dengan komunitas tani',
        ),
        AppCoachMark.createCircleTarget(
          key: _tabKeys[3],
          title: 'Pesanan',
          description: 'Pantau status pesanan, pembayaran, pengiriman',
        ),
        AppCoachMark.createCircleTarget(
          key: _tabKeys[4],
          title: 'Profil',
          description: 'Atur akun, verifikasi, dan riwayat transaksi',
        ),
        AppCoachMark.createCircleTarget(
          key: _fabKey,
          title: 'AI Assistant',
          description: 'Tanya BISA AI untuk rekomendasi dan bantuan',
          alignSkip: Alignment.topRight,
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      final tab = widget.initialTab.clamp(0, 4);
      setState(() => _currentIndex = tab);
      if (tab == 3) _refreshOrdersList();
    }
  }

  void _refreshOrdersList() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final user = context.read<AuthCubit>().state.maybeWhen(
            authenticated: (u) => u,
            orElse: () => null,
          );
      if (user == null) return;
      final orderCubit = context.read<OrderCubit>();
      if (user.role == 'SUPPLIER') {
        orderCubit.getMySales();
      } else {
        orderCubit.getMyPurchases();
      }
    });
  }

  void _onProductModeChanged(String newMode) {
    if (_activeProductMode != newMode) {
      setState(() {
        _activeProductMode = newMode;
      });
    }
  }

  List<Widget> _getPages(bool isSupplier) => [
        isSupplier
            ? const StoreManagementPage()
            : MarketplacePage(onProductModeChanged: _onProductModeChanged),
        NegotiationListPage(activeProductMode: _activeProductMode),
        const ForumPage(),
        OrdersPage(activeProductMode: _activeProductMode),
        ProfilePage(activeProductMode: _activeProductMode),
      ];

  void _selectTab(int index) {
    final tab = index.clamp(0, 4);
    if (_currentIndex == tab) return;
    setState(() => _currentIndex = tab);
    final currentQuery =
        GoRouterState.of(context).uri.queryParameters['tab'];
    if (currentQuery != tab.toString()) {
      context.go('/?tab=$tab');
    }
    if (tab == 3) _refreshOrdersList();
  }

  void _onTabTapped(int index, bool isAuthenticated) {
    _selectTab(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state.maybeWhen(
          authenticated: (user) => user,
          orElse: () => null,
        );
        final isAuthenticated = user != null;
        final isSupplier = user?.role == 'SUPPLIER';

        return MainShellScope(
          selectTab: _selectTab,
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: IndexedStack(
              index: _currentIndex,
              children: _getPages(isSupplier),
            ),
            extendBody: false,
            // Scaffold sudah meletakkan FAB di atas bottom nav; jangan double-add system inset.
            floatingActionButton: Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await AppCoachMark.resetSeen();
                      if (context.mounted) {
                        _showCoachMark(onFinish: () => AppCoachMark.markSeen());
                      }
                    },
                    child: Container(
                      width: 34.r,
                      height: 34.r,
                      margin: EdgeInsets.only(bottom: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.help_outline,
                        size: 18.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    key: _fabKey,
                    onPressed: () => context.push('/ai-chat'),
                    backgroundColor: AppColors.transparent,
                    elevation: 0,
                    child: Container(
                      height: 44.r,
                      width: 44.r,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        LucideIcons.bot,
                        color: AppColors.surface,
                        size: 22.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endFloat,
            bottomNavigationBar: FloatingBottomNav(
              currentIndex: _currentIndex,
              onTap: (index) => _onTabTapped(index, isAuthenticated),
              items: [
                FloatingBottomNavItem(
                  key: _tabKeys[0],
                  icon: LucideIcons.store,
                  label: isSupplier ? 'nav.store'.tr() : 'nav.catalog'.tr(),
                ),
                FloatingBottomNavItem(
                  key: _tabKeys[1],
                  icon: LucideIcons.messageSquare,
                  label: 'nav.chat'.tr(),
                ),
                FloatingBottomNavItem(
                  key: _tabKeys[2],
                  icon: LucideIcons.users,
                  label: 'forum'.tr(),
                ),
                FloatingBottomNavItem(
                  key: _tabKeys[3],
                  icon: LucideIcons.shoppingBag,
                  label: 'nav.orders'.tr(),
                ),
                FloatingBottomNavItem(
                  key: _tabKeys[4],
                  icon: LucideIcons.user,
                  label: 'profil'.tr(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
