import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mobile_bisa/firebase_options.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mobile_bisa/features/marketplace/presentation/bloc/marketplace_cubit.dart';
import 'package:mobile_bisa/features/marketplace/presentation/bloc/category_cubit.dart';
import 'package:mobile_bisa/features/forum/presentation/bloc/forum_cubit.dart';
import 'package:mobile_bisa/features/negotiation/presentation/bloc/negotiation_cubit.dart';
import 'package:mobile_bisa/features/orders/presentation/bloc/order_cubit.dart';
import 'package:mobile_bisa/features/commerce/presentation/bloc/commerce_cubit.dart';
import 'package:mobile_bisa/features/follow/presentation/bloc/follow_cubit.dart';
import 'package:mobile_bisa/features/notifications/presentation/bloc/notification_cubit.dart';
import 'package:mobile_bisa/features/marketplace/presentation/bloc/compare_cubit.dart';
import 'package:mobile_bisa/core/utils/router.dart';
import 'package:mobile_bisa/injection_container.dart' as di;
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/constants/app_text_styles.dart';
import 'package:mobile_bisa/core/i18n/bootstrap_localization.dart';
import 'package:mobile_bisa/core/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_bisa/core/config/app_config.dart';
import 'package:mobile_bisa/core/network/auth_session_bridge.dart';
import 'package:mobile_bisa/core/services/session_manager.dart';
import 'package:mobile_bisa/shared/pages/config_error_page.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set Status Bar to Transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  await AppConfig.bootstrap();
  if (kDebugMode) {
    debugPrint('══════════════════════════════════════');
    debugPrint('BISA API → ${AppConfig.effectiveApiUrl}');
    debugPrint('══════════════════════════════════════');
  }

  if (!AppConfig.isApiConfigured && !kDebugMode) {
    runApp(const ConfigErrorPage());
    return;
  }

  await di.init();
  di.sl<AuthSessionBridge>().onSessionExpired = () {
    for (final key in [rootNavigatorKey]) {
      final ctx = key.currentContext;
      if (ctx != null && ctx.mounted) {
        ctx.read<AuthCubit>().sessionExpired();
        break;
      }
    };
  };
  await EasyLocalization.ensureInitialized();
  timeago.setLocaleMessages('id', timeago.IdMessages());
  timeago.setLocaleMessages('id_short', timeago.IdMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());
  timeago.setLocaleMessages('en_short', timeago.EnShortMessages());

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(
            (await getApplicationDocumentsDirectory()).path,
          ),
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('id', 'ID')],
      path: 'assets/translations',
      fallbackLocale: const Locale('id', 'ID'),
      saveLocale: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => di.sl<AuthCubit>()..checkAuth()),
          BlocProvider(create: (context) => di.sl<MarketplaceCubit>()),
          BlocProvider(
            create: (context) => di.sl<CategoryCubit>()..getCategories(),
          ),
          BlocProvider(create: (context) => di.sl<ForumCubit>()..getPosts()),
          BlocProvider(create: (context) => di.sl<NegotiationCubit>()),
          BlocProvider(create: (context) => di.sl<OrderCubit>()),
          BlocProvider(create: (context) => di.sl<CommerceCubit>()),
          BlocProvider(create: (context) => di.sl<FollowCubit>()),
          BlocProvider(create: (context) => di.sl<NotificationCubit>()),
          BlocProvider(create: (context) => di.sl<CompareCubit>()),
        ],
        // Jangan const — agar MaterialApp ikut rebuild saat ganti locale.
        child: MyApp(),
      ),
    ),
  );

  // Non-blocking startup tasks: jangan tahan first frame aplikasi.
  unawaited(_bootstrapBackgroundServices());
}

Locale _localeFromSavedPreference(String? raw) {
  if (raw == null || raw.isEmpty) return const Locale('id', 'ID');
  final parts = raw.split('_');
  if (parts.length == 2) return Locale(parts[0], parts[1]);
  if (raw == 'en') return const Locale('en', 'US');
  if (raw == 'id') return const Locale('id', 'ID');
  return const Locale('id', 'ID');
}

Future<void> _bootstrapBackgroundServices() async {
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = _localeFromSavedPreference(prefs.getString('locale'));
    await bootstrapLocalization(savedLocale);
    await NotificationService.initialize();
    await FirebaseAnalytics.instance.logAppOpen();
  } catch (e, st) {
    debugPrint('[BISA] Startup service init gagal: $e\n$st');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (user) {
            context.read<CommerceCubit>().bootstrap();
            context.read<FollowCubit>().bootstrap(user.id);
            context.read<NotificationCubit>().bootstrap();
          },
          unauthenticated: () {
            SessionManager.resetUserScopedState(context);
          },
          orElse: () {},
        );
      },
      child: ScreenUtilInit(
      // Baseline disetel ke ukuran referensi UI agar skala font/komponen lebih proporsional.
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'app_title'.tr(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              surface: AppColors.surface,
              background: AppColors.background,
            ),
            fontFamily: 'Plus Jakarta Sans',
            textTheme: Typography.englishLike2021.apply(
              bodyColor: AppColors.textPrimary,
              displayColor: AppColors.textPrimary,
            ).copyWith(
              titleLarge: AppTextStyles.pageTitle(),
              titleMedium: AppTextStyles.sectionTitle(),
              bodyLarge: AppTextStyles.body(),
              bodyMedium: AppTextStyles.bodySm(),
              bodySmall: AppTextStyles.bodySecondary(),
              labelLarge: AppTextStyles.button(),
              labelSmall: AppTextStyles.chip(),
            ),
          ),
          routerConfig: goRouter,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: locale,
          
          
        );
      },
      ),
    );
  }
}

class CustomTextScaler extends TextScaler {
  final TextScaler parent;
  final double scaleFactor;

  const CustomTextScaler(this.parent, this.scaleFactor);

  @override
  // ignore: deprecated_member_use
  double get textScaleFactor => parent.textScaleFactor * scaleFactor;

  @override
  double scale(double fontSize) {
    return parent.scale(fontSize) * scaleFactor;
  }
}

