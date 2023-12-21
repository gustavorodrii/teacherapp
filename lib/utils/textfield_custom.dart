import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teacherapp/utils/custom_colors.dart';

class TextFieldCustom extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final Color? prefixIconColor;
  final String? labelText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final Widget? label;
  const TextFieldCustom({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.prefixIconColor,
    this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        fillColor: constLight,
        prefixIcon: prefixIcon,
        prefixIconColor: prefixIconColor,
        label: label,
        hintText: hintText,
        labelText: labelText,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1,
            color: lowBlue,
          ),
        ),
      ),
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
    );
  }
}
