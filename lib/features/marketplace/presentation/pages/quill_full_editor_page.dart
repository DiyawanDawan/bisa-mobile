import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../shared/widgets/custom_button.dart';

class QuillFullEditorPage extends StatefulWidget {
  final String? initialValue;
  final String title;
  final String? hint;

  const QuillFullEditorPage({
    super.key,
    this.initialValue,
    this.title = 'Edit Deskripsi',
    this.hint,
  });

  @override
  State<QuillFullEditorPage> createState() => _QuillFullEditorPageState();
}

class _QuillFullEditorPageState extends State<QuillFullEditorPage> {
  late QuillController _controller;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = QuillController.basic();
    _loadDocument();
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

  String get resultDelta =>
      jsonEncode(_controller.document.toDelta().toJson());

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.surface,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            child: QuillSimpleToolbar(
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
                showQuote: false,
                showIndent: false,
                showLink: true,
                showUndo: false,
                showRedo: false,
                showFontFamily: false,
                showFontSize: false,
                showInlineCode: false,
                showAlignmentButtons: false,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Container(
              color: AppColors.surface,
              child: QuillEditor.basic(
                controller: _controller,
                focusNode: _focusNode,
                config: QuillEditorConfig(
                  placeholder: widget.hint ?? 'Tulis di sini...',
                  padding: const EdgeInsets.all(16),
                  scrollable: true,
                  autoFocus: true,
                ),
              ),
            ),
          ),
          Container(
            color: AppColors.surface,
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.sm + safeBottom,
            ),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.grey200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'batal'.tr(),
                    variant: BisaButtonVariant.outlined,
                    size: BisaButtonSize.md,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: CustomButton(
                    text: 'simpan'.tr(),
                    useGradient: true,
                    size: BisaButtonSize.md,
                    onPressed: () => Navigator.pop(context, resultDelta),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
