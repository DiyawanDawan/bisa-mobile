import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_bisa/core/config/app_config.dart';

import 'core/network/api_client.dart';
import 'core/media/chunked_media_upload_service.dart';
import 'core/media/media_upload_progress_controller.dart';
import 'core/media/media_upload_queue.dart';
import 'core/media/media_upload_session_store.dart';
import 'core/network/auth_session_bridge.dart';
import 'core/network/pusher_service.dart';
import 'core/network/token_repository.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/stretch/data/datasources/stretch_remote_data_source.dart';
import 'features/marketplace/data/datasources/marketplace_remote_data_source.dart';
import 'features/marketplace/domain/repositories/marketplace_repository.dart';
import 'features/marketplace/data/repositories/marketplace_repository_impl.dart';
import 'features/orders/data/datasources/order_remote_data_source.dart';
import 'features/orders/domain/repositories/order_repository.dart';
import 'features/orders/data/repositories/order_repository_impl.dart';
import 'features/forum/data/datasources/forum_remote_data_source.dart';
import 'features/forum/data/datasources/forum_group_remote_data_source.dart';
import 'features/forum/domain/repositories/forum_repository.dart';
import 'features/forum/domain/repositories/forum_group_repository.dart';
import 'features/forum/data/repositories/forum_repository_impl.dart';
import 'features/forum/data/repositories/forum_group_repository_impl.dart';
import 'features/ai/data/datasources/ai_remote_data_source.dart';
import 'features/ai/domain/repositories/ai_repository.dart';
import 'features/ai/data/repositories/ai_repository_impl.dart';
import 'features/notifications/data/datasources/notification_remote_data_source.dart';
import 'features/notifications/domain/repositories/notification_repository.dart';
import 'features/notifications/data/repositories/notification_repository_impl.dart';
import 'features/negotiation/data/datasources/negotiation_remote_data_source.dart';
import 'features/negotiation/domain/repositories/negotiation_repository.dart';
import 'features/negotiation/data/repositories/negotiation_repository_impl.dart';
import 'features/wallet/data/datasources/wallet_remote_data_source.dart';
import 'features/wallet/domain/repositories/wallet_repository.dart';
import 'features/wallet/data/repositories/wallet_repository_impl.dart';
import 'features/iot/data/datasources/iot_remote_data_source.dart';
import 'features/iot/domain/repositories/iot_repository.dart';
import 'features/iot/data/repositories/iot_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/marketplace/presentation/bloc/marketplace_cubit.dart';
import 'features/forum/presentation/bloc/forum_cubit.dart';
import 'features/forum/presentation/bloc/forum_group_cubit.dart';
import 'features/orders/presentation/bloc/order_cubit.dart';
import 'features/profile/presentation/bloc/profile_cubit.dart';
import 'features/ai/presentation/bloc/ai_cubit.dart';
import 'features/negotiation/presentation/bloc/negotiation_cubit.dart';
import 'features/invoice/data/datasources/invoice_remote_data_source.dart';
import 'features/invoice/domain/repositories/invoice_repository.dart';
import 'features/invoice/data/repositories/invoice_repository_impl.dart';
import 'features/invoice/presentation/bloc/create_invoice_cubit.dart';
import 'features/invoice/presentation/bloc/edit_invoice_cubit.dart';
import 'features/invoice/presentation/bloc/review_invoice_cubit.dart';
import 'features/notifications/presentation/bloc/notification_cubit.dart';
import 'features/marketplace/presentation/bloc/review_cubit.dart';
import 'features/iot/presentation/bloc/iot_cubit.dart';
import 'features/iot/data/iot_device_cache.dart';
import 'features/marketplace/presentation/bloc/category_cubit.dart';
import 'features/marketplace/presentation/bloc/store_banner_cubit.dart';
import 'features/marketplace/presentation/bloc/product_management_cubit.dart';
import 'features/marketplace/data/datasources/store_banner_remote_data_source.dart';
import 'features/marketplace/data/datasources/review_remote_data_source.dart';
import 'features/marketplace/domain/repositories/review_repository.dart';
import 'features/marketplace/data/repositories/review_repository_impl.dart';
import 'features/marketplace/data/datasources/product_question_remote_data_source.dart';
import 'features/marketplace/domain/repositories/product_question_repository.dart';
import 'features/marketplace/data/repositories/product_question_repository_impl.dart';
import 'features/marketplace/presentation/bloc/product_qa_cubit.dart';
import 'features/marketplace/presentation/bloc/compare_cubit.dart';
import 'features/marketplace/presentation/utils/compare_list_store.dart';
import 'package:mobile_bisa/features/gis/data/datasources/gis_remote_data_source.dart';
import 'package:mobile_bisa/features/gis/domain/repositories/gis_repository.dart';
import 'package:mobile_bisa/features/gis/data/repositories/gis_repository_impl.dart';
import 'package:mobile_bisa/features/gis/presentation/bloc/gis_cubit.dart';
import 'package:mobile_bisa/features/wallet/presentation/bloc/wallet_cubit.dart';
import 'features/market/data/datasources/market_remote_data_source.dart';
import 'features/market/domain/repositories/market_repository.dart';
import 'features/market/data/repositories/market_repository_impl.dart';
import 'features/market/presentation/bloc/market_cubit.dart';
import 'features/commerce/data/datasources/commerce_remote_data_source.dart';
import 'features/commerce/data/repositories/commerce_repository_impl.dart';
import 'features/commerce/domain/repositories/commerce_repository.dart';
import 'features/commerce/presentation/bloc/commerce_cubit.dart';
import 'features/follow/data/datasources/follow_remote_data_source.dart';
import 'features/follow/domain/repositories/follow_repository.dart';
import 'features/follow/data/repositories/follow_repository_impl.dart';
import 'features/follow/presentation/bloc/follow_cubit.dart';
import 'features/partnership/data/datasources/partnership_remote_data_source.dart';
import 'features/partnership/domain/repositories/partnership_repository.dart';
import 'features/partnership/data/repositories/partnership_repository_impl.dart';
import 'features/partnership/presentation/bloc/partnership_cubit.dart';
import 'features/booking/data/datasources/booking_remote_data_source.dart';
import 'features/booking/domain/repositories/booking_repository.dart';
import 'features/booking/data/repositories/booking_repository_impl.dart';
import 'features/booking/presentation/bloc/booking_cubit.dart';
import 'features/support/data/datasources/support_remote_data_source.dart';
import 'features/support/presentation/bloc/support_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Cubits
  sl.registerFactory(() => AuthCubit(sl()));

  //! Features - Marketplace
  // Cubits
  sl.registerFactory(() => MarketplaceCubit(sl()));
  sl.registerFactory(() => CategoryCubit(sl()));
  sl.registerFactory(() => ProductManagementCubit(sl()));

  //! Features - Forum
  // Cubits
  sl.registerFactory(() => ForumCubit(sl()));
  sl.registerFactory(() => ForumGroupCubit(sl()));

  //! Features - Orders
  // Cubits
  sl.registerFactory(() => OrderCubit(sl()));

  //! Features - Profile
  // Cubits
  sl.registerFactory(() => ProfileCubit(sl()));

  //! Features - AI
  // Cubits
  sl.registerFactory(() => AiCubit(sl()));

  //! Features - Negotiation
  // Cubits
  sl.registerFactory(() => NegotiationCubit(sl()));
  sl.registerFactory(() => CreateInvoiceCubit(sl()));
  sl.registerFactory(() => EditInvoiceCubit(sl(), sl(), sl()));
  sl.registerFactory(() => ReviewInvoiceCubit(sl(), sl()));

  // Cubits
  sl.registerLazySingleton(() => NotificationCubit(sl()));

  //! Features - IoT
  // Cubits
  sl.registerLazySingleton(() => IotDeviceCache());
  sl.registerFactory(() => IotCubit(sl(), sl()));

  //! Features - GIS
  sl.registerFactory(() => GisCubit(sl()));

  //! Features - Wallet
  sl.registerFactory(() => WalletCubit(sl()));

  //! Features - Market
  sl.registerFactory(() => MarketCubit(sl()));

  //! Features - Q1 stretch (referral, ERP, live, e-sign helpers)
  sl.registerLazySingleton(() => StretchRemoteDataSource(sl<ApiClient>().dio));

  //! Features - Commerce (Cart & Wishlist)
  sl.registerFactory(() => CommerceCubit(sl()));
  sl.registerLazySingleton<CommerceRemoteDataSource>(
    () => CommerceRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<CommerceRepository>(
    () => CommerceRepositoryImpl(remoteDataSource: sl()),
  );

  //! Features - Follow
  sl.registerLazySingleton(() => FollowCubit(sl()));
  sl.registerLazySingleton<FollowRemoteDataSource>(
    () => FollowRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<FollowRepository>(
    () => FollowRepositoryImpl(remoteDataSource: sl()),
  );

  //! Features - Partnership (Mitra Utama)
  sl.registerFactory(() => PartnershipCubit(sl()));
  sl.registerLazySingleton<PartnershipRemoteDataSource>(
    () => PartnershipRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<PartnershipRepository>(
    () => PartnershipRepositoryImpl(remoteDataSource: sl()),
  );

  //! Features - Booking
  sl.registerFactory(() => BookingCubit(sl()));
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(remoteDataSource: sl()),
  );

  //! Features - Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      dio: sl<ApiClient>().dio,
      uploadQueue: sl<MediaUploadQueue>(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), tokenRepository: sl()),
  );

  //! Features - Marketplace
  sl.registerLazySingleton<MarketplaceRemoteDataSource>(
    () => MarketplaceRemoteDataSourceImpl(
      dio: sl<ApiClient>().dio,
      uploadQueue: sl<MediaUploadQueue>(),
    ),
  );
  sl.registerLazySingleton<MarketplaceRepository>(
    () => MarketplaceRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<StoreBannerRemoteDataSource>(
    () => StoreBannerRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerFactory(() => StoreBannerCubit(sl()));

  //! Features - Orders
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(
      dio: sl<ApiClient>().dio,
      uploadQueue: sl<MediaUploadQueue>(),
    ),
  );
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(remoteDataSource: sl()),
  );

  //! Features - Forum
  sl.registerLazySingleton<ForumRemoteDataSource>(
    () => ForumRemoteDataSourceImpl(
      dio: sl<ApiClient>().dio,
      uploadQueue: sl<MediaUploadQueue>(),
    ),
  );
  sl.registerLazySingleton<ForumRepository>(
    () => ForumRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ForumGroupRemoteDataSource>(
    () => ForumGroupRemoteDataSourceImpl(
      dio: sl<ApiClient>().dio,
      uploadQueue: sl<MediaUploadQueue>(),
    ),
  );
  sl.registerLazySingleton<ForumGroupRepository>(
    () => ForumGroupRepositoryImpl(remoteDataSource: sl()),
  );

  //! Features - AI
  sl.registerLazySingleton<AiRemoteDataSource>(
    () => AiRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<AiRepository>(
    () => AiRepositoryImpl(remoteDataSource: sl()),
  );

  //! Features - Customer Support
  sl.registerLazySingleton(() => SupportRemoteDataSource(sl<ApiClient>().dio));
  sl.registerFactory(() => SupportCubit(sl()));

  //! Features - Notifications
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remoteDataSource: sl()),
  );

  //! Features - Negotiation
  sl.registerLazySingleton<NegotiationRemoteDataSource>(
    () => NegotiationRemoteDataSourceImpl(
      dio: sl<ApiClient>().dio,
      uploadQueue: sl<MediaUploadQueue>(),
    ),
  );
  sl.registerLazySingleton<NegotiationRepository>(
    () => NegotiationRepositoryImpl(remoteDataSource: sl()),
  );

  //! Features - Invoice
  sl.registerLazySingleton<InvoiceRemoteDataSource>(
    () => InvoiceRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<InvoiceRepository>(
    () => InvoiceRepositoryImpl(
      remoteDataSource: sl(),
      negotiationRemoteDataSource: sl(),
    ),
  );

  //! Features - Wallet
  sl.registerLazySingleton<WalletRemoteDataSource>(
    () => WalletRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(remoteDataSource: sl()),
  );

  //! Features - IoT
  sl.registerLazySingleton<IotRemoteDataSource>(
    () => IotRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<IotRepository>(
    () => IotRepositoryImpl(remoteDataSource: sl()),
  );

  //! Features - Reviews
  sl.registerFactory(() => ReviewCubit(sl()));
  sl.registerLazySingleton<ReviewRemoteDataSource>(
    () => ReviewRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(remoteDataSource: sl()),
  );

  //! Features - Product Q&A (FB-4)
  sl.registerFactory(() => ProductQaCubit(sl()));
  sl.registerLazySingleton<ProductQuestionRemoteDataSource>(
    () => ProductQuestionRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<ProductQuestionRepository>(
    () => ProductQuestionRepositoryImpl(remoteDataSource: sl()),
  );

  //! Features - Compare products (FB-6)
  sl.registerLazySingleton(() => CompareListStore(sl<SharedPreferences>()));
  sl.registerLazySingleton(() => CompareCubit(sl<CompareListStore>()));

  //! Features - GIS
  sl.registerLazySingleton<GisRemoteDataSource>(
    () => GisRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<GisRepository>(
    () => GisRepositoryImpl(remoteDataSource: sl()),
  );

  //! Features - Market
  sl.registerLazySingleton<MarketRemoteDataSource>(
    () => MarketRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<MarketRepository>(
    () => MarketRepositoryImpl(remoteDataSource: sl()),
  );

  //! External (HARUS sebelum ApiClient di-resolve karena TokenRepository
  //! butuh secureStorage)
  // v10: jangan pakai encryptedSharedPreferences (deprecated).
  // migrateOnAlgorithmChange + resetOnError menangani token lama setelah update app.
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      migrateOnAlgorithmChange: true,
      resetOnError: true,
    ),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  sl.registerLazySingleton(() => secureStorage);

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  //! Core
  final tokenRepository = TokenRepository(secureStorage);
  await tokenRepository.repairStorageIfCorrupted();
  sl.registerLazySingleton<TokenRepository>(() => tokenRepository);
  sl.registerLazySingleton<AuthSessionBridge>(() => AuthSessionBridge());

  // Android Emulator: 10.0.2.2 = host machine's localhost
  // Physical Device: set API_URL via `--dart-define`
  // (e.g. --dart-define=API_URL=http://192.168.1.x:3000/api/v1)
  //
  // SEC-MOB-012: log peringatan tanpa hard-crash. Sebelum patch ini kita
  // throw StateError, yang membuat app blank/dark screen pasca splash bila
  // Config build-time tidak diisi. Sekarang fallback ke empty string;
  // semua call API akan gagal dengan DioException yang jelas, app tetap render.
  final apiUrl = AppConfig.effectiveApiUrl;
  if (apiUrl.isEmpty && !kDebugMode) {
    debugPrint(
      '[BISA] API_URL kosong. Set --dart-define=API_URL=... saat run/build.',
    );
  }
  sl.registerLazySingleton(
    () => ApiClient(
      sl<TokenRepository>(),
      apiUrl,
      sessionBridge: sl<AuthSessionBridge>(),
    ),
  );

  sl.registerLazySingleton(
    () => MediaUploadSessionStore(sl<SharedPreferences>()),
  );
  sl.registerLazySingleton(MediaUploadProgressController.new);
  sl.registerLazySingleton(
    () => ChunkedMediaUploadService(
      apiDio: sl<ApiClient>().dio,
      tokenRepository: sl<TokenRepository>(),
      sessionStore: sl<MediaUploadSessionStore>(),
    ),
  );
  sl.registerLazySingleton(
    () => MediaUploadQueue(
      uploadService: sl<ChunkedMediaUploadService>(),
      progress: sl<MediaUploadProgressController>(),
    ),
  );

  // SEC-MOB-004: inject Dio (yang sudah punya JWT interceptor) ke PusherService
  // agar private channel subscription bisa auth ke `/pusher/auth` backend.
  // Dibungkus try/catch agar kegagalan PusherService tidak menggagalkan boot app.
  try {
    PusherService().setAuthDio(sl<ApiClient>().dio);
  } catch (e, st) {
    debugPrint('[BISA] Gagal inject Dio ke PusherService: $e\n$st');
  }
}
