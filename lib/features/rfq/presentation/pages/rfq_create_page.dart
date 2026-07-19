import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/i18n/failure_messages.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../marketplace/presentation/bloc/marketplace_cubit.dart';
import '../../data/datasources/rfq_remote_data_source.dart';

class RfqCreatePage extends StatefulWidget {
  const RfqCreatePage({super.key});

  @override
  State<RfqCreatePage> createState() => _RfqCreatePageState();
}

class _RfqCreatePageState extends State<RfqCreatePage> {
  final _titleCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController(text: '100');
  final _specCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();
  final _ds = RfqRemoteDataSource();
  bool _loading = false;
  String? _error;

  String get _productMode => MarketplaceCubit.activeProductMode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _guardAccess());
  }

  void _guardAccess() {
    final auth = context.read<AuthCubit>().state;
    final user = auth.maybeWhen(authenticated: (u) => u, orElse: () => null);
    if (user == null) {
      setState(() => _error = 'rfq.login_required'.tr());
      return;
    }
    if (user.role == 'SUPPLIER') {
      setState(() => _error = 'rfq.buyer_only'.tr());
    }
  }

  Future<void> _submit() async {
    final user = context.read<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );
    if (user == null) {
      setState(() => _error = 'rfq.login_required'.tr());
      return;
    }
    if (user.role == 'SUPPLIER') {
      setState(() => _error = 'rfq.buyer_only'.tr());
      return;
    }

    final qty = double.tryParse(_qtyCtrl.text.trim());
    if (_titleCtrl.text.trim().length < 5 || qty == null || qty <= 0) {
      setState(() => _error = 'rfq.form_invalid'.tr());
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _ds.createRfq({
        'title': _titleCtrl.text.trim(),
        'productMode': _productMode,
        'quantity': qty,
        if (_specCtrl.text.trim().isNotEmpty) 'specifications': _specCtrl.text.trim(),
        if (_budgetCtrl.text.trim().isNotEmpty)
          'budgetMax': double.tryParse(_budgetCtrl.text.trim()),
      });
      if (!mounted) return;
      showSuccessSnackBar(context, 'rfq.create_success'.tr());
      context.pop(true);
    } on DioException catch (e) {
      if (!mounted) return;
      final failure = dioExceptionToFailure(e);
      setState(() {
        _loading = false;
        _error = failure.message.localizedFailure;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _qtyCtrl.dispose();
    _specCtrl.dispose();
    _budgetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(title: 'rfq.create_title'.tr()),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.xl),
        children: [
          Text('rfq.create_hint'.tr(), style: AppTextStyles.caption()),
          SizedBox(height: AppSpacing.md),
          CustomTextField(
            label: 'rfq.field_title'.tr(),
            hint: 'rfq.field_title_hint'.tr(),
            controller: _titleCtrl,
            isRequired: true,
          ),
          SizedBox(height: AppSpacing.md12),
          CustomTextField(
            label: 'rfq.field_qty'.tr(),
            hint: '100',
            controller: _qtyCtrl,
            keyboardType: TextInputType.number,
            isRequired: true,
          ),
          SizedBox(height: AppSpacing.md12),
          CustomTextField(
            label: 'rfq.field_spec'.tr(),
            hint: 'rfq.field_spec_hint'.tr(),
            controller: _specCtrl,
            maxLines: 3,
            isOptional: true,
          ),
          SizedBox(height: AppSpacing.md12),
          CustomTextField(
            label: 'rfq.field_budget'.tr(),
            hint: 'rfq.field_budget_hint'.tr(),
            controller: _budgetCtrl,
            keyboardType: TextInputType.number,
            isOptional: true,
          ),
          if (_error != null) ...[
            SizedBox(height: AppSpacing.md12),
            Text(_error!, style: AppTextStyles.caption(color: AppColors.error)),
          ],
          SizedBox(height: AppSpacing.xl),
          CustomButton(
            text: 'rfq.submit'.tr(),
            isLoading: _loading,
            onPressed: _loading ? null : _submit,
            icon: LucideIcons.send,
          ),
        ],
      ),
    );
  }
}
