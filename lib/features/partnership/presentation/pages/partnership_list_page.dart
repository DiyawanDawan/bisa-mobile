import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/i18n/failure_messages.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../domain/entities/partnership_entity.dart';
import '../bloc/partnership_cubit.dart';
import '../widgets/partnership_status_chip.dart';

class PartnershipListPage extends StatefulWidget {
  const PartnershipListPage({super.key});

  @override
  State<PartnershipListPage> createState() => _PartnershipListPageState();
}

class _PartnershipListPageState extends State<PartnershipListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PartnershipCubit>()..loadPartnerships(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          backgroundColor: AppColors.surface,
          title: 'partnership.list_title'.tr(),
        ),
        body: BlocBuilder<PartnershipCubit, PartnershipState>(
          builder: (context, state) {
            if (state.isLoading && state.partnerships.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null && state.partnerships.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Text(
                    state.error!.localizedFailure,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            if (state.partnerships.isEmpty) {
              return _EmptyState(isSupplier: _isSupplier(context));
            }
            return RefreshIndicator(
              onRefresh: () => context.read<PartnershipCubit>().loadPartnerships(),
              child: ListView.separated(
                padding: EdgeInsets.all(AppSpacing.md),
                itemCount: state.partnerships.length,
                separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm10),
                itemBuilder: (context, index) {
                  final p = state.partnerships[index];
                  return _PartnershipCard(partnership: p, isSupplier: _isSupplier(context));
                },
              ),
            );
          },
        ),
      ),
    );
  }

  bool _isSupplier(BuildContext context) {
    return context.read<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u.role == 'SUPPLIER',
          orElse: () => false,
        );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isSupplier;

  const _EmptyState({required this.isSupplier});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.handshake, size: 56.sp, color: AppColors.grey200),
            SizedBox(height: AppSpacing.md),
            Text(
              'partnership.empty_title'.tr(),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              isSupplier
                  ? 'partnership.empty_supplier'.tr()
                  : 'partnership.empty_buyer'.tr(),
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PartnershipCard extends StatelessWidget {
  final PartnershipEntity partnership;
  final bool isSupplier;

  const _PartnershipCard({required this.partnership, required this.isSupplier});

  @override
  Widget build(BuildContext context) {
    final counterparty = isSupplier ? partnership.buyer : partnership.supplier;
    final dateFmt = DateFormat('dd MMM yyyy');

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.tile),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.tile),
        onTap: () => context.push('/partnerships/${partnership.id}'),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      partnership.title,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PartnershipStatusChip(status: partnership.status),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                counterparty.companyName?.isNotEmpty == true
                    ? counterparty.companyName!
                    : counterparty.fullName,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
              ),
              SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(LucideIcons.fileText, size: 14.sp, color: AppColors.primary),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      partnership.contractNumber,
                      style: TextStyle(fontSize: 12.sp, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                '${dateFmt.format(partnership.startDate)} – ${dateFmt.format(partnership.endDate)}',
                style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
              ),
              if (partnership.daysUntilExpiry != null &&
                  partnership.status == 'ACTIVE') ...[
                SizedBox(height: 2.h),
                Text(
                  'partnership.days_left'.tr(
                    namedArgs: {'days': '${partnership.daysUntilExpiry}'},
                  ),
                  style: TextStyle(fontSize: 11.sp, color: AppColors.warning),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
