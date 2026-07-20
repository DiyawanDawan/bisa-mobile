import 'package:easy_localization/easy_localization.dart';
import 'package:share_plus/share_plus.dart';

import '../../features/forum/domain/entities/forum_entity.dart';
import 'contract_verify_url.dart';

/// Bagikan postingan forum lewat sheet native (WhatsApp, Telegram, dll).
abstract class ForumShareHelper {
  static String postUrl(String postId) {
    final encoded = Uri.encodeComponent(postId.trim());
    return '${ContractVerifyUrl.baseUrl()}/forum-detail/$encoded';
  }

  static String buildListShareText(ForumPostEntity post) {
    return 'forum.share_list'.tr(namedArgs: {
      'title': post.title,
      'content': post.contentPreview ?? post.content,
      'url': postUrl(post.id),
    });
  }

  static String buildDetailShareText(ForumPostEntity post) {
    return 'forum.share_detail'.tr(namedArgs: {
      'title': post.title,
      'content': post.contentPreview ?? post.content,
      'url': postUrl(post.id),
    });
  }

  static Future<void> sharePost(
    ForumPostEntity post, {
    bool fromDetail = false,
  }) async {
    final text = fromDetail
        ? buildDetailShareText(post)
        : buildListShareText(post);

    await Share.share(text, subject: post.title);
  }
}
