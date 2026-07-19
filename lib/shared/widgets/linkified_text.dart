import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Teks chat dengan auto-deteksi URL: biru + underline, tap membuka browser.
class LinkifiedText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Color linkColor;

  const LinkifiedText({
    super.key,
    required this.text,
    required this.style,
    required this.linkColor,
  });

  /// Cocokkan http(s)://… dan www.… (termasuk URL menempel teks, mis. `isahttps://…`).
  static final RegExp urlPattern = RegExp(
    r'(https?:\/\/[^\s<>"\]\)]+|www\.[^\s<>"\]\)]+)',
    caseSensitive: false,
  );

  @override
  State<LinkifiedText> createState() => _LinkifiedTextState();
}

class _LinkifiedTextState extends State<LinkifiedText> {
  final List<TapGestureRecognizer> _recognizers = [];
  late TextSpan _span;

  @override
  void initState() {
    super.initState();
    _span = _compose();
  }

  @override
  void didUpdateWidget(LinkifiedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.style != widget.style ||
        oldWidget.linkColor != widget.linkColor) {
      _span = _compose();
    }
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _disposeRecognizers() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
  }

  Future<void> _openUrl(String raw) async {
    var value = raw.trim();
    while (value.isNotEmpty &&
        '.,;:!?)]}>"\''.contains(value[value.length - 1])) {
      value = value.substring(0, value.length - 1);
    }
    if (!value.toLowerCase().startsWith('http')) {
      value = 'https://$value';
    }
    final uri = Uri.tryParse(value);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  TextSpan _compose() {
    _disposeRecognizers();

    final text = widget.text;
    final linkStyle = widget.style.copyWith(
      color: widget.linkColor,
      decoration: TextDecoration.underline,
      decorationColor: widget.linkColor,
      fontWeight: FontWeight.w600,
    );

    final spans = <InlineSpan>[];
    var last = 0;
    for (final match in LinkifiedText.urlPattern.allMatches(text)) {
      if (match.start > last) {
        spans.add(TextSpan(text: text.substring(last, match.start)));
      }
      final url = match.group(0)!;
      final recognizer = TapGestureRecognizer()..onTap = () => _openUrl(url);
      _recognizers.add(recognizer);
      spans.add(TextSpan(text: url, style: linkStyle, recognizer: recognizer));
      last = match.end;
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last)));
    }
    if (spans.isEmpty) {
      spans.add(TextSpan(text: text));
    }

    return TextSpan(style: widget.style, children: spans);
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(_span);
  }
}
