import '../../../../core/utils/media_url_utils.dart';

class ForumMediaItem {
  final String url;
  final String type;

  const ForumMediaItem({required this.url, this.type = 'image'});

  bool get isVideo => type == 'video';
  bool get isImage => type != 'video';

  factory ForumMediaItem.fromJson(Map<String, dynamic> json) {
    return ForumMediaItem(
      url: json['url']?.toString() ?? '',
      type: json['type']?.toString() ?? 'image',
    );
  }

  Map<String, dynamic> toJson() => {'url': url, 'type': type};

  ForumMediaItem withResolvedUrl() => ForumMediaItem(
        url: resolveMediaField(url) ?? url,
        type: type,
      );
}

List<ForumMediaItem> resolveForumMediaList(List<ForumMediaItem> items) =>
    items.map((m) => m.withResolvedUrl()).toList();

List<ForumMediaItem>? parseForumMediaList(dynamic raw) {
  if (raw == null) return null;
  if (raw is! List) return null;
  return raw
      .map((e) => ForumMediaItem.fromJson(Map<String, dynamic>.from(e as Map)))
      .where((m) => m.url.isNotEmpty)
      .toList();
}

List<Map<String, dynamic>>? forumMediaToJson(List<ForumMediaItem>? items) {
  if (items == null || items.isEmpty) return null;
  return items.map((e) => e.toJson()).toList();
}

class ForumMediaAttachment {
  final String localPath;
  final String type;

  const ForumMediaAttachment({required this.localPath, required this.type});

  bool get isVideo => type == 'video';
}
