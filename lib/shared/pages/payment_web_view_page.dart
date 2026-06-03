import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';

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
    this.title = 'Pembayaran',
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

  static bool isAllowedHost(Uri uri) {
    if (uri.scheme != 'https') return false;
    final host = uri.host.toLowerCase();
    return _allowedHosts.any((allowed) => host == allowed || host.endsWith('.$allowed'));
  }

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _initError;

  @override
  void initState() {
    super.initState();
    final initialUri = Uri.tryParse(widget.url);
    if (initialUri == null || !PaymentWebViewPage.isAllowedHost(initialUri)) {
      _initError =
          'URL pembayaran tidak valid atau domain tidak diizinkan. '
          'Silakan hubungi support BISA.';
      _isLoading = false;
      // Build berlanjut menampilkan error screen.
      _controller = WebViewController();
      return;
    }

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
                context.pop(true);
                return NavigationDecision.prevent;
              }
              if (request.url.contains('/payment/failed') ||
                  request.url.contains('status=FAILED')) {
                context.pop(false);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
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
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
              ],
            ),
    );
  }
}
