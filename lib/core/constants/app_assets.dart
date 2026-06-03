/// Centralized asset paths for mobile_bisa
abstract class AppAssets {
  // ── Base paths ────────────────────────────────────────────────────────────
  static const String _images = 'assets/images';
  static const String _icons = 'assets/icons';
  static const String _animations = 'assets/animations';

  // ── Images ───────────────────────────────────────────────────────────────
  static const String logo = '$_icons/logo.png';
  static const String logoWhite = '$_icons/logo.png';
  static const String splashFull = '$_icons/splash_full.png';
  static const String splashIcon = '$_icons/splash_icon.png';
  static const String splashBranding = '$_icons/splash_branding.png';
  static const String placeholder = '$_images/placeholder.png';
  static const String emptyState = '$_images/empty_state.png';
  static const String errorState = '$_images/error_state.png';
  /// Urutan onboarding: marketplace → nego → insight → pembayaran/escrow
  static const String onboardingMarketplace =
      '$_images/busines_to_busines_onbaording.jpg';
  static const String onboardingNegotiate =
      '$_images/onboarding_negosiate.jpg';
  static const String onboardingInsight =
      '$_images/onbaorading_impect.jpg';
  static const String onboardingPayment =
      '$_images/onbaordning_payment.jpg';

  @Deprecated('Use onboardingMarketplace')
  static const String onboarding1 = onboardingMarketplace;
  @Deprecated('Use onboardingNegotiate')
  static const String onboarding2 = onboardingNegotiate;
  @Deprecated('Use onboardingInsight')
  static const String onboarding3 = onboardingInsight;
  @Deprecated('Use onboardingPayment')
  static const String onboarding4 = onboardingPayment;
  static const String defaultAvatar = '$_images/default_avatar.png';
  static const String flagIndonesia = '$_images/merah_putih.png';

  // ── Icons ────────────────────────────────────────────────────────────────
  static const String iconHome = '$_icons/ic_home.svg';
  static const String iconProfile = '$_icons/ic_profile.svg';
  static const String iconNotification = '$_icons/ic_notification.svg';
  static const String iconSettings = '$_icons/ic_settings.svg';

  // ── Animations (Lottie) ───────────────────────────────────────────────────
  static const String animLoading = '$_animations/loading.json';
  static const String animSuccess = '$_animations/success.json';
  static const String animError = '$_animations/error.json';
  static const String animEmpty = '$_animations/empty.json';
}
