import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/commerce/presentation/bloc/commerce_cubit.dart';
import '../../features/follow/presentation/bloc/follow_cubit.dart';
import '../../features/notifications/presentation/bloc/notification_cubit.dart';

/// Reset state singleton saat logout / session expired.
class SessionManager {
  static void resetUserScopedState(BuildContext context) {
    context.read<CommerceCubit>().reset();
    context.read<FollowCubit>().reset();
    context.read<NotificationCubit>().reset();
  }
}
