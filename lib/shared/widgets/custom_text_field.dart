import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_layout.dart';
import '../../core/constants/app_text_styles.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.onChanged,
    this.inputFormatters,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppSpacing.xs),
          child: Text(
            widget.label,
            style: AppTextStyles.fieldLabel(),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Focus(
          onFocusChange: (focused) => setState(() => _isFocused = focused),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: _isFocused ? AppColors.softShadow : [],
            ),
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.isPassword && _obscureText,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              enabled: widget.enabled,
              maxLines: widget.maxLines,
              onChanged: widget.onChanged,
              inputFormatters: widget.inputFormatters,
              style: AppTextStyles.fieldValue(),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: AppTextStyles.fieldHint(),
                prefixIcon: widget.prefixIcon != null 
                    ? Icon(widget.prefixIcon, size: 22.sp, color: _isFocused ? AppColors.primary : AppColors.grey400) 
                    : null,
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: 20.sp,
                          color: AppColors.grey400,
                        ),
                        onPressed: () => setState(() => _obscureText = !_obscureText),
                      )
                    : widget.suffixIcon,
                filled: true,
                fillColor: widget.enabled ? AppColors.surface : AppColors.grey50,
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  borderSide: BorderSide(color: AppColors.grey200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  borderSide: BorderSide(color: AppColors.grey200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  borderSide: const BorderSide(color: AppColors.error, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  borderSide: const BorderSide(color: AppColors.error, width: 1.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
