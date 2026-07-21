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

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab.clamp(0, 4);
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
              child: FloatingActionButton(
                onPressed: () => context.push('/ai-chat'),
                backgroundColor: AppColors.transparent,
                elevation: 0,
                child: Container(
                  height: 56.r,
                  width: 56.r,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    LucideIcons.bot,
                    color: AppColors.surface,
                    size: 28.sp,
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endFloat,
            bottomNavigationBar: FloatingBottomNav(
              currentIndex: _currentIndex,
              onTap: (index) => _onTabTapped(index, isAuthenticated),
              items: [
                FloatingBottomNavItem(
                  icon: LucideIcons.store,
                  label: isSupplier ? 'nav.store'.tr() : 'nav.catalog'.tr(),
                ),
                FloatingBottomNavItem(
                  icon: LucideIcons.messageSquare,
                  label: 'nav.chat'.tr(),
                ),
                FloatingBottomNavItem(
                  icon: LucideIcons.users,
                  label: 'forum'.tr(),
                ),
                FloatingBottomNavItem(
                  icon: LucideIcons.shoppingBag,
                  label: 'nav.orders'.tr(),
                ),
                FloatingBottomNavItem(
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
