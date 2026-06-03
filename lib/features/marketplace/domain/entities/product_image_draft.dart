import 'dart:convert';
import 'dart:io';

import 'product_entity.dart';

/// Unified image item for add/edit/manage product flows.
class ProductImageDraft {
  final String? id;
  final String? remoteUrl;
  final File? localFile;

  const ProductImageDraft({
    this.id,
    this.remoteUrl,
    this.localFile,
  }) : assert(
          (remoteUrl != null) ^ (localFile != null),
          'Either remoteUrl or localFile must be set',
        );

  bool get isRemote => remoteUrl != null;

  String get stableKey => id ?? localFile!.path;

  factory ProductImageDraft.fromExisting(ProductImageEntity image) {
    return ProductImageDraft(id: image.id, remoteUrl: image.url);
  }

  factory ProductImageDraft.fromFile(File file) {
    return ProductImageDraft(localFile: file);
  }

  ProductImageDraft copyWithFile(File file) {
    return ProductImageDraft(localFile: file);
  }

  static List<ProductImageDraft> fromProductImages(List<ProductImageEntity>? images) {
    if (images == null || images.isEmpty) return [];
    final sorted = List<ProductImageEntity>.from(images)
      ..sort((a, b) {
        if (a.order != b.order) return a.order.compareTo(b.order);
        if (a.isPrimary != b.isPrimary) return a.isPrimary ? -1 : 1;
        return 0;
      });
    return sorted.map(ProductImageDraft.fromExisting).toList();
  }

  static ProductImagePayload buildPayload(List<ProductImageDraft> drafts) {
    final order = <Map<String, dynamic>>[];
    final newPaths = <String>[];
    var newIndex = 0;

    for (final draft in drafts) {
      if (draft.isRemote) {
        order.add({'type': 'existing', 'url': draft.remoteUrl});
      } else {
        order.add({'type': 'new', 'index': newIndex});
        newPaths.add(draft.localFile!.path);
        newIndex++;
      }
    }

    return ProductImagePayload(
      imageOrderJson: jsonEncode(order),
      newImagePaths: newPaths,
      syncImages: drafts.isNotEmpty,
    );
  }
}

class ProductImagePayload {
  final String imageOrderJson;
  final List<String> newImagePaths;
  final bool syncImages;

  const ProductImagePayload({
    required this.imageOrderJson,
    required this.newImagePaths,
    required this.syncImages,
  });
}
