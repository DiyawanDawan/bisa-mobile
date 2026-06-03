import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Menunda [Navigator.pop] ke frame berikutnya agar tidak memicu
/// `!_debugLocked` saat pop dipanggil dari callback picker / PopScope.
void safeNavigatorPop<T>(BuildContext context, [T? result]) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop(result);
    }
  });
}

/// Menunda [GoRouter.pop] ke frame berikutnya (sama seperti [safeNavigatorPop]).
void safeRouterPop<T>(BuildContext context, [T? result]) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    if (context.canPop()) {
      context.pop(result);
    }
  });
}
