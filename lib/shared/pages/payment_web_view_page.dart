import 'dart:io' show Platform;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mobile_bisa/core/config/app_config.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/i18n/failure_messages.dart';
import 'package:mobile_bisa/core/utils/payment_status_utils.dart';

/// SEC-MOB-005 + SEC-MOB-014:
/// Payment WebView dengan domain allowlist. Mencegah:
/// - URL phishing (mis. backend ter-compromise atau MITM)
/// - Status payment "sukses" palsu dari domain selain Xendit/BISA callback
///
/// Catatan: deteksi success/failed via URL substring tetap dipertahankan untuk UX,
/// tetapi server-side payment status poll (di parent page) adalah otoritas
/// kebenaran sebenarnya — UI mobile harus selalu re-validate ke `/orders/:id` atau
/// `/transactions/:id` sebelum menampilkan invoice sebagai "paid".
class PaymentWebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const PaymentWebViewPage({
    super.key,
    required this.url,
    this.title = 'orders.payment_fallback',
  });

  /// Host yang boleh di-load di WebView pembayaran.
  /// Tambahkan host baru di sini ketika menambah PSP / domain callback baru.
  static const Set<String> _allowedHosts = {
    // Xendit hosted checkout & payment widget
    'checkout.xendit.co',
    'invoice.xendit.co',
    'xendit.co',
    // QRIS / Indonesia payment intermediaries umum (tambah seperlunya)
    'pay.xendit.co',
    // Backend BISA — callback success/failed
    'api.bisa.id',
    'bisa.id',
  };

  static Set<String> _runtimeAllowedHosts() {
    final hosts = Set<String>.from(_allowedHosts);
    final apiUri = Uri.tryParse(AppConfig.effectiveApiUrl);
    if (apiUri != null && apiUri.host.isNotEmpty) {
      hosts.add(apiUri.host.toLowerCase());
    }
    final publicUri = Uri.tryParse(AppConfig.publicWebUrl);
    if (publicUri != null && publicUri.host.isNotEmpty) {
      hosts.add(publicUri.host.toLowerCase());
    }
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      hosts.addAll({'localhost', '127.0.0.1', '10.0.2.2'});
    }
    return hosts;
  }

  static bool isAllowedHost(Uri uri) {
    if (uri.scheme != 'https' && uri.scheme != 'http') return false;
    final host = uri.host.toLowerCase();
    return _runtimeAllowedHosts().any(
      (allowed) => host == allowed || host.endsWith('.$allowed'),
    );
  }

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  WebViewController? _controller;
  bool _isLoading = true;
  String? _initError;
  bool _useWebView = false;

  bool get _isWebViewSupported {
    if (kIsWeb) return false;
    try {
      return Platform.isAndroid || Platform.isIOS || Platform.isMacOS;
    } catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _useWebView = _isWebViewSupported;
    final initialUri = Uri.tryParse(widget.url);
    if (initialUri == null || !PaymentWebViewPage.isAllowedHost(initialUri)) {
      _initError = 'orders.payment_invalid_url'.tr();
      _isLoading = false;
      return;
    }

    if (_useWebView) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) => setState(() => _isLoading = true),
            onPageFinished: (url) => setState(() => _isLoading = false),
            onNavigationRequest: (request) {
              final reqUri = Uri.tryParse(request.url);
              if (reqUri == null) return NavigationDecision.prevent;

              // Deteksi success/failed redirect dari backend BISA (host sah).
              if (PaymentWebViewPage.isAllowedHost(reqUri)) {
                if (request.url.contains('/payment/success') ||
                    request.url.contains('status=PAID')) {
                  context.pop(PaymentWebViewExit.callbackDetected);
                  return NavigationDecision.prevent;
                }
                if (request.url.contains('/payment/failed') ||
                    request.url.contains('status=FAILED')) {
                  context.pop(PaymentWebViewExit.failed);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              }

              // Domain tidak ada di allowlist → block navigasi.
              // Tetap di halaman saat ini agar user bisa keluar manual.
              return NavigationDecision.prevent;
            },
          ),
        )
        ..loadRequest(initialUri);
    } else {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localizeFailureMessage(widget.title)),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: _initError != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _initError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            )
          : Stack(
              children: [
                if (_useWebView && _controller != null)
                  WebViewWidget(controller: _controller!)
                else
                  _buildFallbackPayment(),
                if (_isLoading && _useWebView)
                  const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
              ],
            ),
    );
  }

  Widget _buildFallbackPayment() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.payment_rounded,
              color: AppColors.primary,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Halaman Pembayaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Platform ini tidak mendukung tampilan pembayaran langsung di dalam aplikasi. Silakan klik tombol di bawah untuk membayar melalui browser web Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.surface,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final uri = Uri.tryParse(widget.url);
                if (uri != null && await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.open_in_browser_rounded),
              label: const Text('Buka Halaman Pembayaran'),
            ),
          ],
        ),
      ),
    );
  }
}
