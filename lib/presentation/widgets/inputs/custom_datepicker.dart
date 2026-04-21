import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';

class CustomDatePicker extends StatelessWidget {
  final String label;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;

  final Color? fillColor;
  final Color? borderColor;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final Color? iconColor;

  const CustomDatePicker({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
    this.fillColor,
    this.borderColor,
    this.textStyle,
    this.labelStyle,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime aFirstDate = firstDate ?? DateTime(2000);
    final DateTime aLastDate = lastDate ?? DateTime(2101);

    final fillClr = fillColor ?? context.surfaceLow;
    final borderClr = borderColor ?? context.border;

    final valueTextStyle = textStyle ??
        TextStyle(
          color: enabled ? context.textPrimary : context.textSecondary,
          fontSize: 15,
        );

    final labelTxtStyle = labelStyle ??
        TextStyle(
          color: context.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        );

    final iconClr = iconColor ?? context.textSecondary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: !enabled
            ? null
            : () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: aFirstDate,
                  lastDate: aLastDate,
                  builder: (context, child) => Theme(
                    data: context.theme.copyWith(
                      colorScheme: context.cs,
                      dialogTheme: DialogTheme(
                        backgroundColor: context.surface,
                      ),
                    ),
                    child: child!,
                  ),
                );

                if (picked != null && picked != selectedDate) {
                  onDateSelected(picked);
                }
              },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: labelTxtStyle,
            filled: true,
            fillColor: fillClr,
            enabled: enabled,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderClr),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderClr),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.primary,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.border,
              ),
            ),
            suffixIcon: Icon(
              Icons.calendar_today_rounded,
              color: iconClr,
              size: 22,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          child: Text(
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
            style: valueTextStyle,
          ),
        ),
      ),
    );
  }
}