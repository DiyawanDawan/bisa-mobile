import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../core/utils/pro_subscription.dart';
import 'bisa_app_bar.dart';
import 'pro_required_placeholder.dart';

class ProGate extends StatelessWidget {
  final Widget child;
  final IconData icon;
  final String lockedMessage;
  final String? title;

  const ProGate({
    super.key,
    required this.child,
    this.icon = LucideIcons.lock,
    this.lockedMessage = 'shared.pro_gate_default_message',
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );

        if (requiresPro(user)) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: title != null
                ? BisaAppBar(
                    title: title!,
                    backgroundColor: AppColors.surface,
                  )
                : null,
            body: SafeArea(
              child: ProRequiredPlaceholder(
                message: lockedMessage.tr(),
                icon: icon,
                onActionPressed: () => context.push('/iot-subscription'),
              ),
            ),
          );
        }

        return child;
      },
    );
  }
}
