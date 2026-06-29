import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/constants/app_colors.dart';

/// Lightweight HTML5 video player (recorded product video, not live stream).
class ProductVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final double? height;

  const ProductVideoPlayer({
    super.key,
    required this.videoUrl,
    this.height,
  });

  @override
  State<ProductVideoPlayer> createState() => _ProductVideoPlayerState();

  static Future<void> openFullscreen(BuildContext context, String videoUrl) {
    return showDialog<void>(
      context: context,
      barrierColor: AppColors.textPrimary,
      builder: (ctx) => Dialog.fullscreen(
        backgroundColor: AppColors.black,
        child: Stack(
          children: [
            ProductVideoPlayer(videoUrl: videoUrl),
            Positioned(
              top: MediaQuery.paddingOf(ctx).top + 8,
              right: 12,
              child: IconButton(
                icon: Icon(LucideIcons.x, color: AppColors.surface, size: 24.sp),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductVideoPlayerState extends State<ProductVideoPlayer> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.black)
      ..setNavigationDelegate(
        NavigationDelegate(onPageFinished: (_) {
          if (mounted) setState(() => _loading = false);
        }),
      )
      ..loadHtmlString('''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  html, body { width: 100%; height: 100%; background: #000; }
  video { width: 100%; height: 100%; object-fit: contain; background: #000; }
</style>
</head>
<body>
  <video controls playsinline preload="metadata" src="${widget.videoUrl.replaceAll('"', '&quot;')}"></video>
</body>
</html>
''');
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.height ?? 220.h;
    return SizedBox(
      height: h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          WebViewWidget(controller: _controller),
          if (_loading)
            Container(
              color: AppColors.black,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 12.h),
                  Text(
                    'marketplace.video_loading'.tr(),
                    style: TextStyle(color: AppColors.surface, fontSize: 12.sp),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
