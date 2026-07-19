import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import '../constants/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/home/presentation/pages/main_screen.dart';
import '../../features/marketplace/presentation/pages/product_detail_page.dart';
import '../../features/marketplace/presentation/pages/supplier_profile_page.dart';
import '../../features/marketplace/presentation/pages/supplier_directory_page.dart';
import '../../features/marketplace/presentation/pages/compare_products_page.dart';
import '../../features/marketplace/presentation/pages/bulk_product_upload_page.dart';
import '../../features/rfq/presentation/pages/rfq_create_page.dart';
import '../../features/rfq/presentation/pages/rfq_inbox_page.dart';
import '../../features/rfq/presentation/pages/rfq_list_page.dart';
import '../../features/negotiation/presentation/pages/negotiation_room_page.dart';
import '../../features/negotiation/presentation/pages/negotiation_product_page.dart';
import '../../features/negotiation/presentation/pages/negotiation_offer_preview_page.dart';
import '../../features/negotiation/domain/models/negotiation_offer_draft.dart';
import '../../features/invoice/presentation/pages/create_invoice_page.dart';
import '../../features/invoice/presentation/pages/edit_invoice_page.dart';
import '../../features/invoice/presentation/pages/review_invoice_page.dart';
import '../../features/forum/presentation/pages/forum_detail_page.dart';
import '../../features/forum/presentation/pages/my_forum_posts_page.dart';
import '../../features/forum/presentation/pages/forum_page.dart';
import '../../features/forum/presentation/pages/add_post_page.dart';
import '../../features/forum/presentation/pages/forum_groups_page.dart';
import '../../features/forum/presentation/pages/create_forum_group_page.dart';
import '../../features/forum/presentation/pages/forum_group_detail_page.dart';
import '../../features/orders/presentation/pages/direct_checkout_result_page.dart';
import '../../features/orders/presentation/pages/order_detail_page.dart';
import '../../features/orders/presentation/pages/order_batch_detail_page.dart';
import '../../features/orders/presentation/pages/sales_analytics_page.dart';
import '../../features/marketplace/presentation/pages/product_engagement_page.dart';
import '../../features/ai/presentation/pages/ai_chat_page.dart';
import '../../features/marketplace/presentation/pages/supplier_product_list_page.dart';
import '../../features/marketplace/presentation/pages/supplier_store_page.dart';
import '../../features/follow/presentation/pages/follow_list_page.dart';
import '../../features/partnership/presentation/pages/partnership_list_page.dart';
import '../../features/partnership/presentation/pages/partnership_create_page.dart';
import '../../features/partnership/presentation/pages/partnership_detail_page.dart';
import '../../features/booking/presentation/pages/booking_list_page.dart';
import '../../features/booking/presentation/pages/booking_detail_page.dart';
import '../../features/orders/presentation/pages/supplier_shipping_origin_page.dart';
import '../../features/marketplace/presentation/pages/collection_products_page.dart';
import '../../features/marketplace/presentation/pages/marketplace_page.dart';
import '../../features/marketplace/presentation/pages/product_management_detail_page.dart';
import '../../features/marketplace/presentation/pages/add_edit_product_page.dart';
import '../../features/marketplace/presentation/widgets/iot_prediction_import_sheet.dart';
import '../../features/marketplace/presentation/pages/buyer_products_page.dart';
import '../../features/marketplace/domain/entities/product_entity.dart';
import '../../features/profile/presentation/pages/profile_all_menu_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/marketplace/presentation/pages/product_reviews_page.dart';
import '../../features/profile/presentation/pages/verification_page.dart';
import '../../features/profile/presentation/pages/address_list_page.dart';
import '../../features/profile/presentation/pages/payment_methods_page.dart';
import '../../features/profile/presentation/pages/help_center_page.dart';
import '../../features/support/presentation/pages/support_ticket_list_page.dart';
import '../../features/support/presentation/pages/support_ticket_detail_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/profile/presentation/pages/important_features_page.dart';
import '../../features/stretch/presentation/pages/referral_program_page.dart';
import '../../features/stretch/presentation/pages/erp_integration_page.dart';
import '../../features/stretch/presentation/pages/live_commerce_page.dart';
import '../../features/stretch/presentation/pages/live_room_page.dart';
import '../../features/public_orders/presentation/pages/public_verify_page.dart';
import '../../features/public_orders/presentation/pages/public_track_page.dart';
import '../../features/profile/presentation/pages/change_password_page.dart';
import '../../features/profile/presentation/pages/legal_page.dart';
import '../../features/notifications/presentation/pages/notification_page.dart';
import '../../features/notifications/presentation/pages/notification_detail_page.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import '../../features/wallet/presentation/pages/wallet_transaction_history_page.dart';
import '../../features/iot/presentation/pages/iot_dashboard_page.dart';
import '../../features/iot/presentation/pages/iot_device_detail_page.dart';
import '../../features/iot/presentation/pages/iot_subscription_page.dart';
import '../../features/market/presentation/pages/market_insight_page.dart';
import '../../features/market/presentation/pages/market_trend_detail_page.dart';
import '../../features/market/presentation/pages/market_deep_analytics_page.dart';
import '../../features/market/data/models/market_trend_model.dart';
import '../../shared/widgets/pro_gate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../features/gis/presentation/pages/waste_mapping_page.dart';
import '../../features/commerce/presentation/pages/cart_page.dart';
import '../../features/commerce/presentation/pages/wishlist_page.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../shared/pages/payment_web_view_page.dart';
import '../../features/orders/presentation/pages/payment_instruction_page.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../../injection_container.dart';
import '../network/token_repository.dart';

Widget _buildCheckoutRoute(Object? extra) {
  if (extra is Map) {
    final orders = DirectCheckoutResultPage.ordersFromExtra(extra);
    if (orders.isNotEmpty) {
      return DirectCheckoutResultPage(
        orders: orders,
        selectedPaymentCode:
            DirectCheckoutResultPage.selectedPaymentCodeFromExtra(extra),
      );
    }
    final rawIds = extra['selectedItemIds'];
    if (rawIds is List && rawIds.isNotEmpty) {
      return CartPage(
        checkoutMode: true,
        initialSelectedIds: rawIds.map((e) => e.toString()).toSet(),
      );
    }
  }
  return const CartPage(checkoutMode: true);
}

/// Navigator root — dipakai navigasi dari bottom sheet agar tidak route kosong.
final rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/splash',
  redirect: (context, state) async {
    final tokenRepository = sl<TokenRepository>();
    final hasToken = await tokenRepository.hasToken();

    final location = state.uri.path;

    final isPublic =
        location == '/' ||
        location.startsWith('/splash') ||
        location.startsWith('/onboarding') ||
        location.startsWith('/login') ||
        location.startsWith('/register') ||
        location.startsWith('/forgot-password') ||
        location.startsWith('/otp-verification') ||
        location.startsWith('/reset-password') ||
        location.startsWith('/market-insight') ||
        location.startsWith('/market-detail/') ||
        location.startsWith('/waste-mapping') ||
        location.startsWith('/product/') ||
        location.startsWith('/product-reviews/') ||
        location.startsWith('/supplier/') ||
        location.startsWith('/collection-products') ||
        location.startsWith('/forum-detail/') ||
        location == '/forum-groups' ||
        (location.startsWith('/forum-groups/') &&
            !location.startsWith('/forum-groups/create')) ||
        location.startsWith('/forum-tag/') ||
        location.startsWith('/ai-chat') ||
        location.startsWith('/help-center') ||
        location.startsWith('/terms') ||
        location.startsWith('/privacy') ||
        location.startsWith('/verify') ||
        location.startsWith('/track') ||
        location.startsWith('/important-features');

    if (!hasToken && !isPublic) {
      return '/login';
    }

    final isLoggingIn = location == '/login';

    // Hanya blokir login jika sudah punya token; /register tetap boleh (token basi / daftar akun baru).
    if (hasToken && isLoggingIn) {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    // Main App Shell
    GoRoute(
      path: '/',
      builder: (context, state) {
        final tab = int.tryParse(state.uri.queryParameters['tab'] ?? '') ?? 0;
        return MainScreen(initialTab: tab.clamp(0, 4));
      },
      routes: [
        // AI Chat
        GoRoute(
          path: 'ai-chat',
          builder: (context, state) => const AiChatPage(),
        ),
        // Marketplace
        GoRoute(
          path: 'product/:id',
          builder: (context, state) =>
              ProductDetailPage(productId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: 'supplier/:id',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return SupplierProfilePage(
              supplierId: state.pathParameters['id']!,
              supplierName:
                  extra?['name'] ?? 'marketplace.supplier_fallback'.tr(),
              previewAsOwner: extra?['preview'] == true,
            );
          },
        ),
        GoRoute(
          path: 'collection-products',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final title = extra?['title']?.toString();
            if (title == null || title.isEmpty) {
              return const MarketplacePage();
            }
            return CollectionProductsPage(
              title: title,
              collectionSlug: extra?['collectionSlug'] as String?,
              sortBy: extra?['sortBy'] as String?,
              sortOrder: extra?['sortOrder'] as String?,
              productMode: extra?['productMode'] as String?,
            );
          },
        ),
        GoRoute(
          path: 'product-reviews/:id',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return ProductReviewsPage(
              productId: state.pathParameters['id']!,
              productName:
                  extra?['name'] ?? 'marketplace.product_reviews_title'.tr(),
            );
          },
        ),
        GoRoute(
          path: 'negotiation-offer-preview',
          builder: (context, state) {
            final extra = state.extra;
            if (extra is! NegotiationOfferDraft) {
              return const _InvalidNegotiationDraftPage();
            }
            return NegotiationOfferPreviewPage(draft: extra);
          },
        ),
        // Negotiation
        GoRoute(
          path: 'negotiation/:id',
          builder: (context, state) => NegotiationRoomPage(
            negotiationId: state.pathParameters['id']!,
            chatMode: state.uri.queryParameters['mode'],
          ),
          routes: [
            GoRoute(
              path: 'create-invoice',
              builder: (context, state) =>
                  CreateInvoicePage(negotiationId: state.pathParameters['id']!),
            ),
            GoRoute(
              path: 'review-invoice',
              builder: (context, state) =>
                  ReviewInvoicePage(negotiationId: state.pathParameters['id']!),
            ),
            GoRoute(
              path: 'edit-invoice',
              builder: (context, state) =>
                  EditInvoicePage(negotiationId: state.pathParameters['id']!),
            ),
            GoRoute(
              path: 'product',
              builder: (context, state) => NegotiationProductPage(
                negotiationId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
        // Forum
        GoRoute(
          path: 'forum-detail/:id',
          builder: (context, state) =>
              ForumDetailPage(postId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: 'add-post',
          builder: (context, state) => const AddPostPage(),
        ),
        GoRoute(
          path: 'my-forum-posts',
          builder: (context, state) => const MyForumPostsPage(),
        ),
        GoRoute(
          path: 'forum-groups',
          builder: (context, state) => const ForumGroupsPage(),
        ),
        GoRoute(
          path: 'forum-groups/create',
          builder: (context, state) => const CreateForumGroupPage(),
        ),
        GoRoute(
          path: 'forum-groups/:id',
          builder: (context, state) =>
              ForumGroupDetailPage(groupId: state.pathParameters['id']!),
        ),
        GoRoute(
          // Buka ForumPage stand-alone dengan filter tag awal. Dipakai dari
          // chip #tag di post card / rich text content. Kalau user buka dari
          // tab bar (`/main`), filter ini tidak aktif.
          path: 'forum-tag/:tag',
          builder: (context, state) {
            final tag = Uri.decodeComponent(state.pathParameters['tag']!);
            return ForumPage(initialTag: tag);
          },
        ),
        // Orders — checkout-result hanya di root (lihat /checkout-result di bawah)
        GoRoute(
          path: 'order-batch/:id',
          builder: (context, state) =>
              OrderBatchDetailPage(anchorOrderId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: 'order/:id',
          builder: (context, state) {
            final extra = state.extra;
            final queryAutoPay = state.uri.queryParameters['autoPay'] == '1';
            final autoPay =
                queryAutoPay || (extra is Map && extra['autoPay'] == true);
            final paymentCode = state.uri.queryParameters['paymentCode'] ??
                (extra is Map ? extra['paymentCode']?.toString() : null);
            final paymentName = state.uri.queryParameters['paymentName'] ??
                (extra is Map ? extra['paymentName']?.toString() : null);
            return OrderDetailPage(
              orderId: state.pathParameters['id']!,
              autoStartPayment: autoPay,
              initialPaymentCode: paymentCode,
              initialPaymentName: paymentName,
            );
          },
        ),
        GoRoute(
          path: 'sales-analytics',
          builder: (context, state) => const SalesAnalyticsPage(),
        ),
        GoRoute(
          path: 'product-engagement',
          builder: (context, state) => const ProductEngagementPage(),
        ),
        GoRoute(
          path: 'wallet',
          builder: (context, state) => const WalletPage(),
          routes: [
            GoRoute(
              path: 'transactions',
              builder: (context, state) => const WalletTransactionHistoryPage(),
            ),
          ],
        ),
        GoRoute(
          path: 'profile/all-menu',
          builder: (context, state) => const ProfileAllMenuPage(),
        ),
        GoRoute(
          path: 'edit-profile',
          builder: (context, state) =>
              EditProfilePage(user: state.extra as UserEntity),
        ),
        // ... (other routes remain same)
        GoRoute(
          path: 'verification',
          builder: (context, state) => const VerificationPage(),
        ),
        GoRoute(
          path: 'addresses',
          builder: (context, state) => const AddressListPage(),
        ),
        GoRoute(
          path: 'payment-methods',
          builder: (context, state) => const PaymentMethodsPage(),
        ),
        GoRoute(
          path: 'help-center',
          builder: (context, state) => const HelpCenterPage(),
        ),
        GoRoute(
          path: 'support',
          builder: (context, state) => const SupportTicketListPage(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) => SupportTicketDetailPage(
                ticketId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'change-password',
          builder: (context, state) => const ChangePasswordPage(),
        ),
        GoRoute(
          path: 'terms',
          builder: (context, state) => LegalPage(
            policyKey: 'terms',
            fallbackTitle: 'profile.menu_terms'.tr(),
          ),
        ),
        GoRoute(
          path: 'privacy',
          builder: (context, state) => LegalPage(
            policyKey: 'privacy',
            fallbackTitle: 'profile.menu_privacy'.tr(),
          ),
        ),
        GoRoute(
          path: 'notifications',
          builder: (context, state) => const NotificationPage(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) => NotificationDetailPage(
                notificationId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'follows',
          builder: (context, state) {
            final tab = state.uri.queryParameters['tab'] == 'followers' ? 1 : 0;
            return FollowListPage(initialTab: tab);
          },
        ),
        GoRoute(
          path: 'bookings',
          builder: (context, state) => const BookingListPage(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) =>
                  BookingDetailPage(bookingId: state.pathParameters['id']!),
            ),
          ],
        ),
        GoRoute(
          path: 'partnerships',
          builder: (context, state) => const PartnershipListPage(),
          routes: [
            GoRoute(
              path: 'create/:supplierId',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                return PartnershipCreatePage(
                  supplierId: state.pathParameters['supplierId']!,
                  supplierName: extra?['name'] as String? ?? 'Supplier',
                  negotiationId: extra?['negotiationId'] as String?,
                );
              },
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) => PartnershipDetailPage(
                partnershipId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'store-management',
          builder: (context, state) => const SupplierStorePage(),
        ),
        GoRoute(
          path: 'product-management',
          builder: (context, state) => const SupplierProductListPage(),
        ),
        GoRoute(
          path: 'product-manage/:id',
          builder: (context, state) => ProductManagementDetailPage(
            productId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: 'buyer-products',
          builder: (context, state) => const BuyerProductsPage(),
        ),
        GoRoute(
          path: 'supplier-shipping-origin',
          builder: (context, state) => const SupplierShippingOriginPage(),
        ),
        GoRoute(
          path: 'add-product',
          builder: (context, state) => AddEditProductPage(
            predictionSeed: state.extra is IotPredictionImportResult
                ? state.extra as IotPredictionImportResult
                : null,
          ),
        ),
        GoRoute(
          path: 'edit-product',
          builder: (context, state) =>
              AddEditProductPage(product: state.extra as ProductEntity),
        ),
        GoRoute(
          path: 'payment-webview',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return PaymentWebViewPage(
              url: extra['url'],
              title: extra['title'] ?? 'orders.payment_fallback',
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/verify',
      builder: (context, state) => const PublicVerifyPage(),
      routes: [
        GoRoute(
          path: ':orderNumber',
          builder: (context, state) => PublicVerifyPage(
            orderNumber: state.pathParameters['orderNumber'],
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/track',
      builder: (context, state) => const PublicTrackPage(),
      routes: [
        GoRoute(
          path: ':orderNumber',
          builder: (context, state) =>
              PublicTrackPage(orderNumber: state.pathParameters['orderNumber']),
        ),
      ],
    ),
    // Auth
    GoRoute(
      path: '/important-features',
      builder: (context, state) => const ImportantFeaturesPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/otp-verification',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return OtpVerificationPage(email: extra['email'], type: extra['type']);
      },
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return ResetPasswordPage(token: extra['token']);
      },
    ),
    // V2 Features
    GoRoute(
      path: '/iot-dashboard',
      builder: (context, state) => const IotDashboardPage(),
    ),
    GoRoute(
      path: '/iot-device/:deviceId',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return IotDeviceDetailPage(
          deviceId: state.pathParameters['deviceId']!,
          deviceName: extra?['name'] as String?,
        );
      },
    ),
    GoRoute(
      path: '/iot-subscription',
      builder: (context, state) => const IotSubscriptionPage(),
    ),
    GoRoute(
      path: '/referral',
      builder: (context, state) => const ReferralProgramPage(),
    ),
    GoRoute(
      path: '/erp-integration',
      builder: (context, state) => const ErpIntegrationPage(),
    ),
    GoRoute(
      path: '/live',
      builder: (context, state) => const LiveCommercePage(),
      routes: [
        GoRoute(
          path: ':sessionId',
          builder: (context, state) =>
              LiveRoomPage(sessionId: state.pathParameters['sessionId']!),
        ),
      ],
    ),
    GoRoute(
      path: '/market-insight',
      builder: (context, state) => const MarketInsightPage(),
    ),
    GoRoute(
      path: '/market-deep-analytics',
      builder: (context, state) => ProGate(
        title: 'market.deep_analytics_title'.tr(),
        icon: LucideIcons.sparkles,
        lockedMessage: 'market.deep_analytics_pro_locked',
        child: const MarketDeepAnalyticsPage(),
      ),
    ),
    GoRoute(
      path: '/market-detail/:id',
      builder: (context, state) {
        final trend = state.extra as MarketTrendModel;
        return MarketTrendDetailPage(trend: trend);
      },
    ),
    GoRoute(
      path: '/waste-mapping',
      builder: (context, state) => const WasteMappingPage(),
    ),
    GoRoute(
      path: '/payment-webview',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return PaymentWebViewPage(
          url: extra['url'],
          title: extra['title'] ?? 'orders.payment_fallback',
        );
      },
    ),
    GoRoute(
      path: '/payment-instruction',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return PaymentInstructionPage(
          orderId: extra['orderId'] as String,
          orderNumber: extra['orderNumber'] as String,
          amount: extra['amount'] as num,
          paymentResult: extra['paymentResult'] as Map<String, dynamic>,
          batchOrderIds:
              (extra['batchOrderIds'] as List?)
                  ?.map((e) => e.toString())
                  .toList() ??
              const [],
          orderCreatedAt: extra['orderCreatedAt'] as DateTime?,
          paymentStatus: extra['paymentStatus'] as String?,
        );
      },
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartPage()),
    GoRoute(
      path: '/checkout-result',
      builder: (context, state) => _buildCheckoutRoute(state.extra),
    ),
    GoRoute(
      path: '/wishlist',
      builder: (context, state) => const WishlistPage(),
    ),
    GoRoute(
      path: '/supplier-directory',
      builder: (context, state) => const SupplierDirectoryPage(),
    ),
    GoRoute(
      path: '/compare-products',
      builder: (context, state) => const CompareProductsPage(),
    ),
    GoRoute(
      path: '/bulk-product-upload',
      builder: (context, state) => const BulkProductUploadPage(),
    ),
    GoRoute(path: '/rfq', builder: (context, state) => const RfqListPage()),
    GoRoute(
      path: '/rfq/create',
      builder: (context, state) => const RfqCreatePage(),
    ),
    GoRoute(
      path: '/rfq/inbox',
      builder: (context, state) => const RfqInboxPage(),
    ),
  ],
);

class _InvalidNegotiationDraftPage extends StatelessWidget {
  const _InvalidNegotiationDraftPage();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Center(child: Text('router.invalid_offer_data'.tr())),
    );
  }
}
