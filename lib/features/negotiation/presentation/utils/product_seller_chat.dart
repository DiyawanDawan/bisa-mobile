import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Buka tab Chat untuk membalas pembeli.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      MainShellScope.maybeOf(context)?.selectTab(1);
      return;
    }

    if (user.role != 'BUYER') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hanya pembeli yang dapat memulai chat ke penjual.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

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
      builder: (ctx) => const PopScope(
        canPop: false,
        child: Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 12),
                  Text('Membuka chat...'),
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
        (failure) async => _showError(context, failure.message),
        (roomId) async {
          if (roomId != null && roomId.isNotEmpty) {
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
                  (_) => _showError(context, failure.message),
                  (id) {
                    if (id != null && id.isNotEmpty) {
                      context.push('/negotiation/$id?mode=inquiry');
                    } else {
                      _showError(context, failure.message);
                    }
                  },
                );
                return;
              }
              _showError(context, failure.message);
            },
            (negotiation) {
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
