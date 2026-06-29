import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../shared/widgets/auth_sheet.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../marketplace/domain/entities/product_entity.dart';
import '../bloc/commerce_cubit.dart';

class ProductAddToCartButton extends StatelessWidget {
  const ProductAddToCartButton({
    super.key,
    required this.product,
    this.size = 16,
  });

  final ProductEntity product;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () async {
          final isAuth = context.read<AuthCubit>().state.maybeWhen(
                authenticated: (_) => true,
                orElse: () => false,
              );
          if (!isAuth) {
            AuthSheet.show(context);
            return;
          }

          final ok = await context.read<CommerceCubit>().addToCart(
                product.id,
                product.minOrder,
              );
          if (!context.mounted) return;
          if (ok) {
            showSuccessSnackBar(
              context,
              'commerce.add_to_cart_success',
              duration: const Duration(seconds: 1),
            );
          } else {
            showErrorSnackBar(
              context,
              'commerce.add_to_cart_failed',
              duration: const Duration(seconds: 1),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.all(6.r),
          child: Icon(
            LucideIcons.shoppingCart,
            size: size.sp,
            color: AppColors.surface,
          ),
        ),
      ),
    );
  }
}
