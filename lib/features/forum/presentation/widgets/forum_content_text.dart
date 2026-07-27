import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/features/forum/domain/entities/forum_entity.dart';

class ForumContentText extends StatelessWidget {
  final String content;
  final List<ForumProductMentionEntity> productMentions;
  final TextStyle? baseStyle;
  final int? maxLines;
  final TextOverflow overflow;
  final void Function(String tag)? onTagTap;

  const ForumContentText({
    super.key,
    required this.content,
    this.productMentions = const [],
    this.baseStyle,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.onTagTap,
  });

  static final RegExp _tokenRe =
      RegExp(r'(?<![A-Za-z0-9_])([#@])([A-Za-z0-9_-]{2,60})');

  ForumProductMentionEntity? _findMention(String slug) {
    final target = slug.toLowerCase();
    for (final m in productMentions) {
      if ((m.slug ?? '').toLowerCase() == target) return m;
    }
    return null;
  }

  static String extractPlainText(String raw) {
    if (raw.isEmpty) return raw;
    final trimmed = raw.trim();
    if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
      try {
        final doc = Document.fromJson(jsonDecode(trimmed));
        return doc.toPlainText().trim();
      } catch (_) {}
    }
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    final text = extractPlainText(content);
    final base = baseStyle ??
        TextStyle(
          fontSize: 14.sp,
          color: AppColors.textSecondary,
          height: 1.6,
        );
    final highlight = base.copyWith(
      color: AppColors.primary,
      fontWeight: FontWeight.w700,
    );

    final spans = <InlineSpan>[];
    int last = 0;
    for (final match in _tokenRe.allMatches(text)) {
      if (match.start > last) {
        spans.add(TextSpan(text: text.substring(last, match.start)));
      }
      final symbol = match.group(1)!;
      final token = match.group(2)!;
      final full = '$symbol$token';
      VoidCallback? onTap;
      if (symbol == '#') {
        final normalized = token.toLowerCase();
        onTap = () {
          if (onTagTap != null) {
            onTagTap!(normalized);
          } else {
            context.push('/forum-tag/${Uri.encodeComponent(normalized)}');
          }
        };
      } else {
        final mention = _findMention(token);
        if (mention != null) {
          onTap = () => context.push('/product/${mention.id}');
        }
      }
      spans.add(
        TextSpan(
          text: full,
          style: highlight,
          recognizer: onTap != null
              ? (TapGestureRecognizer()..onTap = onTap)
              : null,
        ),
      );
      last = match.end;
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last)));
    }

    return RichText(
      maxLines: maxLines,
      overflow: overflow,
      text: TextSpan(style: base, children: spans),
    );
  }
}
