import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class QuillEditorField extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final String? hint;
  final double? minHeight;

  const QuillEditorField({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.hint,
    this.minHeight,
  });

  @override
  State<QuillEditorField> createState() => _QuillEditorFieldState();

  static String deltaToPlainText(String deltaJson) {
    try {
      final doc = Document.fromJson(jsonDecode(deltaJson));
      return doc.toPlainText().trim();
    } catch (_) {
      return deltaJson;
    }
  }
}

class _QuillEditorFieldState extends State<QuillEditorField> {
  late QuillController _controller;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = QuillController.basic();
    _loadDocument();
    _controller.addListener(_onChange);
  }

  void _loadDocument() {
    final value = widget.initialValue;
    if (value == null || value.isEmpty) return;
    try {
      final decoded = jsonDecode(value);
      if (decoded is List && decoded.isNotEmpty) {
        _controller.document = Document.fromJson(decoded);
      } else {
        _controller.document = Document()..insert(0, value);
      }
    } catch (_) {
      _controller.document = Document()..insert(0, value);
    }
  }

  void _onChange() {
    final json = jsonEncode(_controller.document.toDelta().toJson());
    widget.onChanged(json);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          QuillSimpleToolbar(
            controller: _controller,
            config: const QuillSimpleToolbarConfig(
              multiRowsDisplay: false,
              showBoldButton: true,
              showItalicButton: true,
              showUnderLineButton: true,
              showStrikeThrough: false,
              showColorButton: false,
              showBackgroundColorButton: false,
              showClearFormat: true,
              showHeaderStyle: false,
              showListNumbers: true,
              showListBullets: true,
              showListCheck: false,
              showCodeBlock: false,
              showQuote: true,
              showIndent: false,
              showLink: true,
              showUndo: false,
              showRedo: false,
              showDirection: false,
              showSearchButton: false,
              showSubscript: false,
              showSuperscript: false,
              showFontFamily: false,
              showFontSize: false,
              showInlineCode: false,
              showAlignmentButtons: false,
              showClipboardCut: false,
              showClipboardCopy: false,
              showClipboardPaste: false,
            ),
          ),
          const Divider(height: 1),
          QuillEditor.basic(
            controller: _controller,
            focusNode: _focusNode,
            config: QuillEditorConfig(
              placeholder: widget.hint ?? '',
              minHeight: widget.minHeight ?? 120,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              scrollable: true,
              autoFocus: false,
            ),
          ),
        ],
      ),
    );
  }
}
