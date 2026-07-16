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
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../domain/entities/booking_entity.dart';
import '../bloc/booking_cubit.dart';
import '../widgets/booking_status_chip.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';

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
                children: [
                  Expanded(
                    child: Text(
                      booking.product.name,
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  BookingStatusChip(status: booking.status),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                booking.bookingNumber,
                style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                counterparty.companyName?.isNotEmpty == true
                    ? counterparty.companyName!
                    : counterparty.fullName,
                style: TextStyle(fontSize: 13.sp),
              ),
              SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Text(
                    '${booking.quantity} ${booking.unit}',
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    formatMoneyDisplay(booking.subtotalSnapshot),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
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
                    Text(
                      'booking.expires_at'.tr(namedArgs: {
                        'date': dateFmt.format(booking.expiresAt),
                      }),
                      style: TextStyle(fontSize: 11.sp, color: AppColors.warning),
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
