import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/auth_sheet.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../bloc/commerce_cubit.dart';

class ProductLikeButton extends StatelessWidget {
  final String productId;
  final double size;
  final Color? backgroundColor;

  const ProductLikeButton({
    super.key,
    required this.productId,
    this.size = 32,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommerceCubit, CommerceState>(
      builder: (context, state) {
        final liked = state.likedIds.contains(productId);
        return Material(
          color: backgroundColor ?? Colors.white.withValues(alpha: 0.92),
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
              final nowLiked = await context.read<CommerceCubit>().toggleLike(productId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      nowLiked ? 'Ditambahkan ke favorit' : 'Dihapus dari favorit',
                    ),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
            child: Padding(
              padding: EdgeInsets.all(6.r),
              child: Icon(
                liked ? LucideIcons.heart : LucideIcons.heart,
                size: size.sp,
                color: liked ? AppColors.error : AppColors.grey600,
                fill: liked ? 1.0 : 0.0,
              ),
            ),
          ),
        );
      },
    );
  }
}
