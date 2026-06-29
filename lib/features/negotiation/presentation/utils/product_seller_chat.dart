import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_bisa/core/i18n/failure_messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/readiness/readiness_gate.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../home/presentation/pages/main_screen.dart';
import '../../../marketplace/domain/entities/product_entity.dart';
import '../../../../shared/widgets/auth_sheet.dart';
import '../../domain/enums/negotiation_chat_purpose.dart';
import '../../domain/repositories/negotiation_repository.dart';

/// Buka chat tanya produk ke penjual (jenis ruang dipilih di tab daftar Chat).
class ProductSellerChat {
  ProductSellerChat._();

  static Future<void> open({
    required BuildContext context,
    required ProductEntity product,
  }) async {
    final user = context.read<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );

    if (user == null) {
      AuthSheet.show(context);
      return;
    }

    if (user.id == product.seller.id) {
      showWarningSnackBar(context, 'negotiation.seller_chat_use_tab');
      MainShellScope.maybeOf(context)?.selectTab(1);
      return;
    }

    if (user.role != 'BUYER') {
      showWarningSnackBar(context, 'negotiation.seller_chat_buyer_only');
      return;
    }

    if (!await ReadinessGate.ensureBuyerReady(context)) return;

    await _openInquiryRoom(context, product);
  }

  static Future<void> _openInquiryRoom(
    BuildContext context,
    ProductEntity product,
  ) async {
    if (!context.mounted) return;

    // Jangan await showDialog — Future selesai baru saat dialog di-pop,
    // sehingga kode di bawahnya tidak pernah jalan (loading stuck).
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (ctx) => PopScope(
        canPop: false,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 12),
                  Text('negotiation.opening_chat'.tr()),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    try {
      const purpose = NegotiationChatPurpose.inquiry;
      final repo = sl<NegotiationRepository>();

      final roomResult = await repo.findRoomByProductId(
        product.id,
        purpose: purpose,
      );

      if (!context.mounted) return;

      await roomResult.fold(
        (failure) async => _showError(context, failure.message.localizedFailure),
        (roomId) async {
          if (roomId != null && roomId.isNotEmpty) {
            if (!context.mounted) return;
            context.push('/negotiation/$roomId?mode=inquiry');
            return;
          }

          final createResult = await repo.createOffer(
            productId: product.id,
            quantity: product.minOrder,
            pricePerUnit: product.pricePerUnit,
            purpose: purpose,
          );

          if (!context.mounted) return;

          await createResult.fold(
            (failure) async {
              if (failure.message.contains('chat tanya') ||
                  failure.message.contains('belum dijawab') ||
                  failure.message.contains('409')) {
                final retry = await repo.findRoomByProductId(
                  product.id,
                  purpose: purpose,
                );
                if (!context.mounted) return;
                retry.fold(
                  (_) {
                    if (!context.mounted) return;
                    _showError(context, failure.message.localizedFailure);
                  },
                  (id) {
                    if (!context.mounted) return;
                    if (id != null && id.isNotEmpty) {
                      context.push('/negotiation/$id?mode=inquiry');
                    } else {
                      _showError(context, failure.message.localizedFailure);
                    }
                  },
                );
                return;
              }
              if (!context.mounted) return;
              _showError(context, failure.message.localizedFailure);
            },
            (negotiation) {
              if (!context.mounted) return;
              context.push('/negotiation/${negotiation.id}?mode=inquiry');
            },
          );
        },
      );
    } finally {
      _dismissLoading(context);
    }
  }

  static void _dismissLoading(BuildContext context) {
    if (!context.mounted) return;
    final rootNav = Navigator.of(context, rootNavigator: true);
    if (rootNav.canPop()) {
      rootNav.pop();
    }
  }

  static void _showError(BuildContext context, String message) {
    showErrorSnackBar(context, message);
  }
}
