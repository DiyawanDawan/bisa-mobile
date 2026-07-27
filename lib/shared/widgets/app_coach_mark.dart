import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class AppCoachMark {
  static const _seenKey = 'coach_mark_seen';

  static Future<bool> shouldShow() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_seenKey) ?? false);
  }

  static Future<void> markSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seenKey, true);
  }

  static Future<void> resetSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seenKey, false);
  }

  static void show({
    required BuildContext context,
    required List<TargetFocus> targets,
    VoidCallback? onFinish,
    void Function(TargetFocus target)? onClickTarget,
  }) {
    TutorialCoachMark(
      targets: targets,
      alignSkip: Alignment.bottomRight,
      textSkip: 'Lewati',
      paddingFocus: 14,
      opacityShadow: 0.7,
      onFinish: onFinish,
      onClickTarget: (target) {
        onClickTarget?.call(target);
      },
      onClickTargetWithTapPosition: (target, tapDetails) {},
      onClickOverlay: (_) {},
      onSkip: () {
        markSeen();
        onFinish?.call();
        return true;
      },
    ).show(context: context);
  }

  static TargetFocus createCircleTarget({
    required GlobalKey key,
    required String title,
    required String description,
    Alignment? alignSkip,
    ContentAlign contentAlign = ContentAlign.top,
  }) {
    return TargetFocus(
      identify: title,
      keyTarget: key,
      alignSkip: alignSkip ?? Alignment.bottomRight,
      shape: ShapeLightFocus.Circle,
      paddingFocus: 14,
      enableTargetTab: true,
      contents: [
        TargetContent(
          align: contentAlign,
          builder: (context, controller) {
            return Container(
              constraints: const BoxConstraints(maxWidth: 280),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
