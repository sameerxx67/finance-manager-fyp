import 'package:flutter/material.dart';
import 'package:zenthory/core/core.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final bool required;
  final double paddingBottom;
  final Widget? suffix;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;
  final Widget? prefix;
  final Widget? prefixIcon;
  final BoxConstraints? suffixIconConstraints;
  final EdgeInsetsGeometry? contentPadding;
  final String? initialValue;
  final bool hiddenLabel;
  final bool autofocus;
  final FocusNode? focusNode;

  const CustomTextFormField({
    super.key,
    required this.label,
    this.required = true,
    this.suffixIconConstraints,
    this.paddingBottom = AppDimensions.inputBottomMargin,
    this.maxLines = 1,
    this.maxLength,
    this.suffix,
    this.suffixIcon,
    this.contentPadding,
    this.keyboardType,
    this.errorText,
    this.hintText,
    this.controller,
    this.prefix,
    this.prefixIcon,
    this.initialValue,
    this.hiddenLabel = false,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: paddingBottom),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        initialValue: initialValue,
        autofocus: autofocus,
        decoration: InputDecoration(
          contentPadding: contentPadding,
          hintText: hintText,
          label: hiddenLabel
              ? null
              : Row(
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: errorText != null ? context.colors.error : null,
                      ),
                    ),
                    if (required)
                      Text(" *", style: TextStyle(color: context.colors.error)),
                  ],
                ),
          errorText: errorText,
          suffix: suffix,
          suffixIcon: suffixIcon,
          prefix: prefix,
          prefixIcon: prefixIcon,
          suffixIconConstraints: suffixIconConstraints,
        ),
        maxLines: maxLines,
        maxLength: maxLength,
        buildCounter:
            (
              _, {
              required currentLength,
              required isFocused,
              required maxLength,
            }) => null,
      ),
    );
  }
}
