import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';

class CustomTextArea extends StatelessWidget {
  final String label;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final String? initialValue;
  final bool enabled;

  const CustomTextArea({
    super.key,
    required this.label,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.surface,
      child: TextFormField(
        initialValue: initialValue,
        maxLines: 4,
        enabled: enabled,
        style: TextStyle(color: context.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: context.textSecondary),
          alignLabelWithHint: true,
          filled: true,
          fillColor: context.surfaceLow,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: context.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: context.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: context.primary),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: context.border),
          ),
        ),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}