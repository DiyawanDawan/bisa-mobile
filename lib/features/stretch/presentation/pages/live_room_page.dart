import 'dart:io' show Platform;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../data/datasources/stretch_remote_data_source.dart';

class LiveRoomPage extends StatefulWidget {
  final String sessionId;
  const LiveRoomPage({super.key, required this.sessionId});

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  Map<String, dynamic>? _session;
  final _commentCtrl = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    sl<StretchRemoteDataSource>().recordLiveViewer(widget.sessionId);
  }

  Future<void> _load() async {
    try {
      final data = await sl<StretchRemoteDataSource>().getLiveSession(widget.sessionId);
      if (mounted) setState(() => _session = data);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: _session?['title']?.toString() ?? 'live.room_title'.tr(),
        backgroundColor: AppColors.surface,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _streamArea(),
                Expanded(child: _pinnedProducts()),
                _commentBar(),
              ],
            ),
    );
  }

  bool get _isWebViewSupported {
    if (kIsWeb) return false;
    try {
      return Platform.isAndroid || Platform.isIOS || Platform.isMacOS;
    } catch (_) {
      return false;
    }
  }

  Widget _streamArea() {
    final url = _session?['streamUrl']?.toString();
    if (url != null && url.isNotEmpty) {
      if (_isWebViewSupported) {
        final controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(url));
        return SizedBox(height: 220.h, child: WebViewWidget(controller: controller));
      } else {
        return Container(
          height: 220.h,
          width: double.infinity,
          color: AppColors.grey900,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.radio, color: AppColors.primary, size: 40.sp),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Stream URL: $url',
                style: TextStyle(color: AppColors.surface, fontSize: 11.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.surface,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                ),
                onPressed: () async {
                  final uri = Uri.tryParse(url);
                  if (uri != null && await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                icon: Icon(LucideIcons.externalLink, size: 14.sp),
                label: const Text('Buka Stream di Browser'),
              ),
            ],
          ),
        );
      }
    }
    return Container(
      height: 220.h,
      width: double.infinity,
      color: AppColors.grey900,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.radio, color: AppColors.surface, size: 40.sp),
          SizedBox(height: AppSpacing.sm),
          Text('live.no_stream'.tr(), style: TextStyle(color: AppColors.surface, fontSize: 12.sp)),
        ],
      ),
    );
  }

  Widget _pinnedProducts() {
    final products = (_session?['pinnedProducts'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (products.isEmpty) {
      return Center(child: Text('live.no_products'.tr(), style: TextStyle(color: AppColors.textSecondary)));
    }
    return ListView.separated(
      padding: EdgeInsets.all(AppSpacing.md12),
      itemCount: products.length,
      separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, i) {
        final p = products[i];
        return ListTile(
          tileColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
          title: Text(p['name']?.toString() ?? '—'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/product/${p['id']}'),
        );
      },
    );
  }

  Widget _commentBar() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentCtrl,
                decoration: InputDecoration(
                  hintText: 'live.comment_hint'.tr(),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.lg), borderSide: BorderSide.none),
                ),
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            IconButton(
              onPressed: () async {
                final msg = _commentCtrl.text.trim();
                if (msg.isEmpty) return;
                try {
                  await sl<StretchRemoteDataSource>().postLiveComment(widget.sessionId, msg);
                  _commentCtrl.clear();
                  await _load();
                } catch (_) {}
              },
              icon: Icon(LucideIcons.send, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
