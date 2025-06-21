import 'package:elgassos/core/ui/app_colors.dart';
import 'package:elgassos/core/ui/app_styles_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  String? errorText;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  final int? maxLines;
  final bool obscureText;
  final bool showLabel;
  final FocusNode? focusNode;
  final bool readOnly;
  final bool isValidator;
  final TextStyle? labelStyle;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final double? borderRadius;
  final EdgeInsetsGeometry? prefixPadding;
  final TextStyle? hintStyle;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  int? minLines;
  CustomTextField(
      {super.key,
      this.hintText,
      this.prefixIcon,
      this.initialValue,
      this.suffixIcon,
      this.controller,
      this.onTap,
      this.showLabel = false,
      this.obscureText = false,
      this.maxLines = 1,
      this.readOnly = false,
      this.errorText,
      this.prefixIconColor,
      this.onChanged,
      this.isValidator = false,
      this.focusNode,
      this.suffixIconColor,
      this.borderRadius,
      this.prefixPadding,
      this.keyboardType,
      this.inputFormatters,
      this.validator,
      this.minLines,
      this.labelStyle,
      this.onFieldSubmitted,
      this.hintStyle});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.right,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      onTap: onTap,
      minLines: minLines,
      focusNode: focusNode,
      initialValue: initialValue,
      readOnly: readOnly,
      controller: controller,
      maxLines: obscureText ? 1 : maxLines,
      validator: validator ??
          (value) {
            if (isValidator) {
              if (value == null || value.trim().isEmpty) {
                return "هذا الحقل مطلوب.";
              } else {
                return null;
              }
            }
            return null;
          },
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }
        if (errorText != null) {
          errorText = null;
        }
      },
      onFieldSubmitted: onFieldSubmitted,
      obscureText: obscureText,
      obscuringCharacter: "*",
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      decoration: InputDecoration(
        hintTextDirection: TextDirection.rtl,
        labelStyle: labelStyle,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
        errorText: errorText,
        labelText: showLabel && controller != null ? hintText : null,
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 14.r),
          borderSide: const BorderSide(color: AppColors.secondaryColor),
        ),
        prefixIcon: prefixIcon,
        prefix: prefixIcon == null
            ? const SizedBox(
                width: 10,
              )
            : null,
        filled: true,
        prefixIconColor: prefixIconColor ?? AppColors.secondaryColor,
        suffixIcon: suffixIcon,
        suffixIconColor: suffixIconColor ?? AppColors.secondaryColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          borderSide: const BorderSide(color: AppColors.secondaryColor),
        ),
      ),
    );
  }
}
