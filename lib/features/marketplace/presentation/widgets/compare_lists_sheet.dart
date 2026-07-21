import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/safe_area_utils.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/app_feedback.dart';
import '../bloc/compare_cubit.dart';

class CompareListsSheet extends StatefulWidget {
  const CompareListsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => const CompareListsSheet(),
    );
  }

  @override
  State<CompareListsSheet> createState() => _CompareListsSheetState();
}

class _CompareListsSheetState extends State<CompareListsSheet> {
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveList() async {
    final err = await context.read<CompareCubit>().saveCurrentAsNamedList(
      _nameCtrl.text,
    );
    if (!mounted) return;
    if (err != null) {
      showErrorSnackBar(context, err);
      return;
    }
    _nameCtrl.clear();
    showSuccessSnackBar(context, 'product.compare_list_saved'.tr());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 48.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xlPx.r),
        ),
      ),
      padding: bisaSheetPadding(context),
      child: BlocBuilder<CompareCubit, CompareState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.md12),
                Text(
                  'product.compare_sheet_title'.tr(),
                  style: AppTextStyles.sheetTitle(),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'product.compare_sheet_hint'.tr(),
                  style: AppTextStyles.caption(color: AppColors.textSecondary),
                ),
                SizedBox(height: AppSpacing.md),
                if (state.products.isEmpty)
                  Text(
                    'product.compare_empty'.tr(),
                    style: AppTextStyles.caption(
                      color: AppColors.textSecondary,
                    ),
                  )
                else ...[
                  ...state.products.map(
                    (p) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(LucideIcons.package, size: 20.sp),
                      title: Text(
                        p.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: Icon(LucideIcons.x, size: 18.sp),
                        onPressed: () =>
                            context.read<CompareCubit>().remove(p.id),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.md12),
                  TextField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      labelText: 'product.compare_list_name'.tr(),
                      hintText: 'product.compare_list_name_hint'.tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.md12),
                  FilledButton.icon(
                    onPressed: _saveList,
                    icon: Icon(LucideIcons.bookmark, size: 18.sp),
                    label: Text('product.compare_list_save'.tr()),
                  ),
                ],
                if (state.savedLists.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.lg),
                  Text(
                    'product.compare_saved_lists'.tr(),
                    style: AppTextStyles.body(fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  ...state.savedLists.map((list) {
                    return Card(
                      margin: EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ListTile(
                        leading: Icon(LucideIcons.list, size: 20.sp),
                        title: Text(list.name),
                        subtitle: Text(
                          'product.compare_saved_meta'.tr(
                            namedArgs: {'count': '${list.products.length}'},
                          ),
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (v) async {
                            if (v == 'load') {
                              context.read<CompareCubit>().loadSavedList(
                                list.id,
                              );
                              if (!context.mounted) return;
                              Navigator.pop(context);
                              context.push('/compare-products');
                            } else if (v == 'delete') {
                              await context
                                  .read<CompareCubit>()
                                  .deleteSavedList(list.id);
                            }
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: 'load',
                              child: Text('product.compare_list_load'.tr()),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text(
                                'product.compare_list_delete'.tr(),
                                style: const TextStyle(color: AppColors.error),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
                SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () => context.read<CompareCubit>().clear(),
                  child: Text('product.compare_clear'.tr()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
