import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/i18n/failure_messages.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../data/datasources/rfq_remote_data_source.dart';

class RfqDetailPage extends StatefulWidget {
  final String rfqId;

  const RfqDetailPage({super.key, required this.rfqId});

  @override
  State<RfqDetailPage> createState() => _RfqDetailPageState();
}

class _RfqDetailPageState extends State<RfqDetailPage> {
  final _ds = RfqRemoteDataSource();
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _ds.getRfqDetail(widget.rfqId);
      if (!mounted) return;
      setState(() {
        _data = data;
        _loading = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = dioExceptionToFailure(e).message.localizedFailure;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  String _loc(Map<String, dynamic> user) {
    final parts = <String>[
      if ((user['regency'] as String?)?.trim().isNotEmpty == true)
        user['regency'].toString(),
      if ((user['province'] as String?)?.trim().isNotEmpty == true)
        user['province'].toString(),
    ];
    return parts.isEmpty ? 'rfq.location_unknown'.tr() : parts.join(', ');
  }

  String _company(Map<String, dynamic> user) {
    final profile = user['profile'];
    if (profile is Map) {
      final name = profile['companyName']?.toString().trim();
      if (name != null && name.isNotEmpty) return name;
    }
    return user['fullName']?.toString() ?? '-';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(title: 'rfq.detail_title'.tr()),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_error!, textAlign: TextAlign.center),
                        SizedBox(height: AppSpacing.md),
                        TextButton(onPressed: _load, child: Text('rfq.retry'.tr())),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: EdgeInsets.all(16.w),
                    children: [
                      _infoCard(),
                      SizedBox(height: AppSpacing.md12),
                      _howItWorks(),
                      SizedBox(height: AppSpacing.md12),
                      _recipientsSection(),
                    ],
                  ),
                ),
    );
  }

  Widget _infoCard() {
    final d = _data!;
    final qty = d['quantity'];
    final budget = d['budgetMax'];
    final responses = (d['responses'] as List?)?.length ?? 0;
    final matched = d['matchedSuppliers'] ?? (d['recipients'] as List?)?.length ?? 0;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${d['title']}',
            style: AppTextStyles.body(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: AppSpacing.sm),
          _metaRow('rfq.detail_status'.tr(), '${d['status']}'),
          _metaRow('rfq.detail_qty'.tr(), '$qty'),
          _metaRow('rfq.detail_mode'.tr(), '${d['productMode']}'),
          if (d['specifications'] != null &&
              d['specifications'].toString().trim().isNotEmpty)
            _metaRow('rfq.detail_spec'.tr(), '${d['specifications']}'),
          if (budget != null) _metaRow('rfq.detail_budget'.tr(), '$budget'),
          _metaRow(
            'rfq.detail_sent_to'.tr(),
            'rfq.detail_sent_count'.tr(namedArgs: {'count': '$matched'}),
          ),
          _metaRow(
            'rfq.detail_responses'.tr(),
            'rfq.detail_response_count'.tr(namedArgs: {'count': '$responses'}),
          ),
        ],
      ),
    );
  }

  Widget _metaRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110.w,
            child: Text(
              label,
              style: AppTextStyles.caption(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.caption(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _howItWorks() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.info, size: 18.sp, color: AppColors.primary),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'rfq.detail_how_it_works'.tr(),
              style: AppTextStyles.caption(height: 1.45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recipientsSection() {
    final recipients = (_data!['recipients'] as List?) ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'rfq.recipients_title'.tr(),
          style: AppTextStyles.body(fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 4.h),
        Text(
          'rfq.recipients_subtitle'.tr(),
          style: AppTextStyles.caption(color: AppColors.textSecondary),
        ),
        SizedBox(height: AppSpacing.sm10),
        if (recipients.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.md12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Text('rfq.recipients_empty'.tr()),
          )
        else
          ...recipients.map((raw) {
            final r = Map<String, dynamic>.from(raw as Map);
            final hasResponded = r['hasResponded'] == true;
            final response = r['response'];
            final negotiationId = response is Map
                ? response['negotiationId']?.toString()
                : null;
            final avatar = r['avatarUrl']?.toString();

            return Container(
              margin: EdgeInsets.only(bottom: AppSpacing.sm),
              padding: EdgeInsets.all(AppSpacing.md12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: hasResponded
                      ? AppColors.success.withValues(alpha: 0.35)
                      : AppColors.grey200,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: AppColors.primaryLight,
                    child: avatar != null && avatar.isNotEmpty
                        ? ClipOval(
                            child: BisaNetworkImage(
                              imageUrl: avatar,
                              width: 40.w,
                              height: 40.w,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(LucideIcons.store, size: 18.sp),
                  ),
                  SizedBox(width: AppSpacing.sm10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _company(r),
                          style: AppTextStyles.bodySm(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          r['fullName']?.toString() ?? '-',
                          style: AppTextStyles.caption(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          _loc(r),
                          style: AppTextStyles.caption(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          hasResponded
                              ? 'rfq.recipient_responded'.tr()
                              : 'rfq.recipient_waiting'.tr(),
                          style: AppTextStyles.caption(
                            color: hasResponded
                                ? AppColors.success
                                : AppColors.warning,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hasResponded &&
                      negotiationId != null &&
                      negotiationId.isNotEmpty)
                    IconButton(
                      tooltip: 'rfq.open_chat'.tr(),
                      onPressed: () => context.push('/negotiation/$negotiationId'),
                      icon: Icon(LucideIcons.messageSquare, color: AppColors.primary),
                    ),
                ],
              ),
            );
          }),
      ],
    );
  }
}
