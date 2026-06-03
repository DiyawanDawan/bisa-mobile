import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_version.dart';

class AppVersionLabel extends StatelessWidget {
  const AppVersionLabel({
    super.key,
    this.showBuildNumber = true,
    this.prefix = 'BISA',
  });

  final bool showBuildNumber;
  final String prefix;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: showBuildNumber ? AppVersion.fullLabel : AppVersion.shortLabel,
      builder: (context, snapshot) {
        final version = snapshot.data ?? '...';
        return Text(
          '$prefix · $version',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textHint,
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }
}
