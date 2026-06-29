import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/i18n/failure_messages.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../../shared/widgets/auth_sheet.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/product_qa_cubit.dart';

class ProductQaSection extends StatefulWidget {
  const ProductQaSection({
    super.key,
    required this.product,
    required this.cubit,
  });

  final ProductEntity product;
  final ProductQaCubit cubit;

  @override
  State<ProductQaSection> createState() => _ProductQaSectionState();
}

class _ProductQaSectionState extends State<ProductQaSection> {
  bool _expanded = false;
  final _askController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.cubit.load(widget.product.id);
  }

  @override
  void dispose() {
    _askController.dispose();
    super.dispose();
  }

  Future<void> _submitQuestion() async {
    final text = _askController.text.trim();
    if (text.length < 10) {
      showErrorSnackBar(context, 'product.qa_question_too_short'.tr());
      return;
    }
    final ok = await widget.cubit.ask(
      productId: widget.product.id,
      question: text,
    );
    if (!mounted) return;
    if (ok) {
      _askController.clear();
      showSuccessSnackBar(context, 'product.qa_ask_success'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );
    final isSupplierOwner =
        user?.role == 'SUPPLIER' && user?.id == widget.product.seller.id;

    return BlocBuilder<ProductQaCubit, ProductQaState>(
      bloc: widget.cubit,
      builder: (context, state) {
        final answered =
            state.questions.where((q) => q.isAnswered).length;
        final subtitle = state.isLoading
            ? 'product.qa_loading'.tr()
            : state.questions.isEmpty
                ? 'product.qa_empty'.tr()
                : 'product.qa_count'.tr(namedArgs: {
                    'total': '${state.questions.length}',
                    'answered': '$answered',
                  });

        return Padding(
          padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.messageCircle,
                        color: AppColors.primary,
                        size: 20.sp,
                      ),
                      SizedBox(width: AppSpacing.sm10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'product.qa_title'.tr(),
                              style: AppTextStyles.sectionTitle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              subtitle,
                              style: AppTextStyles.caption(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _expanded
                            ? LucideIcons.chevronUp
                            : LucideIcons.chevronDown,
                        color: AppColors.grey400,
                        size: 18.sp,
                      ),
                    ],
                  ),
                ),
              ),
              if (_expanded) ...[
                if (state.error != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Text(
                      localizeFailureMessage(state.error!),
                      style: AppTextStyles.caption(color: AppColors.error),
                    ),
                  ),
                if (user != null && user.role == 'BUYER') ...[
                  CustomTextField(
                    label: 'product.qa_title'.tr(),
                    hint: 'product.qa_ask_hint'.tr(),
                    controller: _askController,
                    maxLines: 3,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () {
                              if (user == null) {
                                AuthSheet.show(context);
                                return;
                              }
                              _submitQuestion();
                            },
                      child: state.isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text('product.qa_ask_submit'.tr()),
                    ),
                  ),
                ] else if (user == null)
                  TextButton(
                    onPressed: () => AuthSheet.show(context),
                    child: Text('product.qa_login_to_ask'.tr()),
                  ),
                if (state.isLoading)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                else if (state.questions.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md12),
                    child: Text(
                      'product.qa_empty_detail'.tr(),
                      style: AppTextStyles.body(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                else
                  ...state.questions.take(5).map(
                        (q) => _QuestionTile(
                          question: q,
                          canAnswer: isSupplierOwner && !q.isAnswered,
                          onAnswer: (answer) => widget.cubit.answer(
                            questionId: q.id,
                            productId: widget.product.id,
                            answer: answer,
                          ),
                          isSubmitting: state.isSubmitting,
                        ),
                      ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _QuestionTile extends StatefulWidget {
  const _QuestionTile({
    required this.question,
    required this.canAnswer,
    required this.onAnswer,
    required this.isSubmitting,
  });

  final dynamic question;
  final bool canAnswer;
  final Future<bool> Function(String answer) onAnswer;
  final bool isSubmitting;

  @override
  State<_QuestionTile> createState() => _QuestionTileState();
}

class _QuestionTileState extends State<_QuestionTile> {
  final _answerCtrl = TextEditingController();
  bool _showAnswerField = false;

  @override
  void dispose() {
    _answerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: AppSpacing.sm10),
      padding: EdgeInsets.all(AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            q.question,
            style: AppTextStyles.body(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4.h),
          Text(
            'product.qa_asked_by'.tr(namedArgs: {'name': q.askerName}),
            style: AppTextStyles.caption(color: AppColors.textHint),
          ),
          if (q.isAnswered) ...[
            SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacing.sm10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'product.qa_supplier_answer'.tr(),
                    style: AppTextStyles.caption(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(q.answer!, style: AppTextStyles.body()),
                ],
              ),
            ),
          ] else if (widget.canAnswer) ...[
            SizedBox(height: AppSpacing.sm),
            if (!_showAnswerField)
              TextButton(
                onPressed: () => setState(() => _showAnswerField = true),
                child: Text('product.qa_answer_cta'.tr()),
              )
            else ...[
              CustomTextField(
                label: 'product.qa_answer_cta'.tr(),
                hint: 'product.qa_answer_hint'.tr(),
                controller: _answerCtrl,
                maxLines: 3,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: widget.isSubmitting
                      ? null
                      : () async {
                          final ok = await widget.onAnswer(
                            _answerCtrl.text.trim(),
                          );
                          if (!context.mounted) return;
                          if (ok) {
                            _answerCtrl.clear();
                            setState(() => _showAnswerField = false);
                          }
                        },
                  child: Text('product.qa_answer_submit'.tr()),
                ),
              ),
            ],
          ] else
            Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Text(
                'product.qa_pending'.tr(),
                style: AppTextStyles.caption(color: AppColors.textHint),
              ),
            ),
        ],
      ),
    );
  }
}
