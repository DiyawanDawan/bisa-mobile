import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ok
                    ? 'Ditambahkan ke keranjang'
                    : 'Gagal menambahkan ke keranjang',
              ),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
              backgroundColor: ok ? AppColors.success : AppColors.error,
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(6.r),
          child: Icon(
            LucideIcons.shoppingCart,
            size: size.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
