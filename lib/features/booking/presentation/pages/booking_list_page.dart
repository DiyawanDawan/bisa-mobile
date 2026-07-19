import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/i18n/failure_messages.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../shared/widgets/seller_identity_row.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../domain/entities/booking_entity.dart';
import '../bloc/booking_cubit.dart';
import '../widgets/booking_status_chip.dart';

class BookingListPage extends StatefulWidget {
  const BookingListPage({super.key});

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  @override
  Widget build(BuildContext context) {
    final isSupplier = context.read<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u.role == 'SUPPLIER',
          orElse: () => false,
        );

    return BlocProvider(
      create: (_) {
        final cubit = sl<BookingCubit>();
        if (isSupplier) {
          cubit.loadIncomingBookings();
        } else {
          cubit.loadMyBookings();
        }
        return cubit;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          backgroundColor: AppColors.surface,
          title: 'booking.list_title'.tr(),
        ),
        body: BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            if (state.isLoading && state.bookings.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null && state.bookings.isEmpty) {
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
            if (state.bookings.isEmpty) {
              return _EmptyState(isSupplier: isSupplier);
            }
            return RefreshIndicator(
              onRefresh: () => isSupplier
                  ? context.read<BookingCubit>().loadIncomingBookings()
                  : context.read<BookingCubit>().loadMyBookings(),
              child: ListView.separated(
                padding: EdgeInsets.all(AppSpacing.md),
                itemCount: state.bookings.length,
                separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm10),
                itemBuilder: (context, index) {
                  final b = state.bookings[index];
                  return _BookingCard(booking: b, isSupplier: isSupplier);
                },
              ),
            );
          },
        ),
      ),
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
            Icon(LucideIcons.calendarClock, size: 56.sp, color: AppColors.grey200),
            SizedBox(height: AppSpacing.md),
            Text(
              'booking.empty_title'.tr(),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              isSupplier
                  ? 'booking.empty_supplier'.tr()
                  : 'booking.empty_buyer'.tr(),
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingEntity booking;
  final bool isSupplier;

  const _BookingCard({required this.booking, required this.isSupplier});

  @override
  Widget build(BuildContext context) {
    final counterparty = isSupplier ? booking.buyer : booking.supplier;
    final counterpartyName = counterparty.companyName?.trim().isNotEmpty == true
        ? counterparty.companyName!
        : counterparty.fullName;
    final dateFmt = DateFormat('dd MMM yyyy, HH:mm');

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.tile),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.tile),
        onTap: () => context.push('/bookings/${booking.id}'),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    child: SizedBox(
                      width: 72.w,
                      height: 72.w,
                      child: BisaNetworkImage(
                        imageUrl: booking.product.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.grey100,
                          child: Icon(
                            LucideIcons.package,
                            color: AppColors.grey400,
                            size: 28.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                booking.product.name,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            BookingStatusChip(status: booking.status),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          booking.bookingNumber,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        SellerIdentityRow(
                          displayName: counterpartyName,
                          avatarUrl: counterparty.avatarUrl,
                          isVerified: counterparty.isVerified,
                          avatarRadius: 12.r,
                          fallbackIcon: isSupplier
                              ? LucideIcons.user
                              : LucideIcons.store,
                          nameStyle: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm10),
              Row(
                children: [
                  Text(
                    '${booking.quantity} ${booking.unit}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    formatMoneyDisplay(booking.subtotalSnapshot),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              if (booking.canCheckout && !booking.isExpired) ...[
                SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Icon(LucideIcons.timer, size: 14.sp, color: AppColors.warning),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        'booking.expires_at'.tr(namedArgs: {
                          'date': dateFmt.format(booking.expiresAt),
                        }),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
