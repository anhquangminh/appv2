import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';

class CustomDropdownFormField<T> extends StatefulWidget {
  final String label;
  final List<T> items;
  final String selectedId;
  final String Function(T) getId;
  final String Function(T) getLabel;
  final void Function(T?) onChanged;
  final bool isRequired;
  final String? errorMessage;

  final Color? fillColor;
  final Color? borderColor;
  final TextStyle? textStyle;
  final Color? dropdownColor;
  final Color? iconColor;

  const CustomDropdownFormField({
    super.key,
    required this.label,
    required this.items,
    required this.selectedId,
    required this.getId,
    required this.getLabel,
    required this.onChanged,
    this.isRequired = false,
    this.errorMessage,
    this.fillColor,
    this.borderColor,
    this.textStyle,
    this.dropdownColor,
    this.iconColor,
  });

  @override
  State<CustomDropdownFormField<T>> createState() => _CustomDropdownFormFieldState<T>();
}

class _CustomDropdownFormFieldState<T> extends State<CustomDropdownFormField<T>> {
  final TextEditingController searchCtrl = TextEditingController();
  String searchValue = "";
  List<T> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = List<T>.from(widget.items);
    searchCtrl.addListener(_handleSearchChange);
  }

  @override
  void didUpdateWidget(CustomDropdownFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _filterList(searchValue);
    }
  }

  @override
  void dispose() {
    searchCtrl.removeListener(_handleSearchChange);
    searchCtrl.dispose();
    super.dispose();
  }

  void _handleSearchChange() {
    setState(() {
      searchValue = searchCtrl.text;
      _filterList(searchValue);
    });
  }

  void _filterList(String query) {
    if (query.isEmpty) {
      filteredItems = List<T>.from(widget.items);
    } else {
      final normQuery = normalizeVietnamese(query.toLowerCase());
      filteredItems = widget.items.where((item) {
        final option = normalizeVietnamese(widget.getLabel(item).toLowerCase());
        return option.contains(normQuery);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTextStyle = widget.textStyle ?? 
        theme.textTheme.bodyMedium?.copyWith(color: context.textPrimary);
    
    final fillColor = widget.fillColor ?? context.surfaceHigh;
    final borderColor = widget.borderColor ?? context.borderStrong;
    final dropdownColor = widget.dropdownColor ?? context.surfaceHighest;

    final itemsWithEmpty = [null, ...filteredItems];

    return DropdownButtonFormField2<T?>(
      isExpanded: true,
      alignment: AlignmentDirectional.centerStart,
      // 1. Trang trí ô Input chính
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: theme.textTheme.labelLarge?.copyWith(color: context.textSecondary),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: context.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: context.error),
        ),
      ),
      // 2. Trang trí Menu đổ xuống
      dropdownStyleData: DropdownStyleData(
        maxHeight: 300,
        decoration: BoxDecoration(
          color: dropdownColor,
          borderRadius: AppRadius.lgRadius,
          border: Border.all(color: context.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        elevation: 0,
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(40),
          thickness: WidgetStateProperty.all(4),
          thumbColor: WidgetStateProperty.all(context.primary.withValues(alpha: 0.2)),
        ),
      ),
      // 3. Khắc phục lỗi hiển thị 1/3
      menuItemStyleData: const MenuItemStyleData(
        height: 48,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      ),
      iconStyleData: IconStyleData(
        icon: Icon(Icons.expand_more_rounded, color: widget.iconColor ?? context.textSecondary),
        iconSize: 22,
      ),
      // 4. Tìm kiếm nội bộ
      dropdownSearchData: DropdownSearchData(
        searchController: searchCtrl,
        searchInnerWidgetHeight: 60,
        searchInnerWidget: Container(
          height: 60,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: TextField(
            controller: searchCtrl,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(color: context.textSecondary),
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              filled: true,
              fillColor: context.surfaceLow,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: AppRadius.smRadius,
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      // 5. Hiển thị item sau khi đã chọn
      selectedItemBuilder: (context) {
        return itemsWithEmpty.map((item) {
          return Container(
            alignment: Alignment.centerLeft,
            child: Text(
              item == null ? "-- Chọn --" : widget.getLabel(item),
              style: effectiveTextStyle?.copyWith(
                color: item == null ? context.textSecondary : context.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList();
      },
      // 6. Danh sách các item trong Menu
      items: itemsWithEmpty.map((item) {
        if (item == null) {
          return DropdownMenuItem<T?>(
            value: null,
            child: Text("-- Chọn --", 
              style: effectiveTextStyle?.copyWith(color: context.textSecondary)),
          );
        }
        final label = widget.getLabel(item);
        return DropdownMenuItem<T?>(
          value: item,
          child: RichText(
            text: highlightText(label, searchValue, effectiveTextStyle!),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      value: itemsWithEmpty.firstWhere((item) {
        if (item == null) return widget.selectedId.isEmpty;
        return widget.getId(item) == widget.selectedId;
      }, orElse: () => null),
      onChanged: widget.onChanged,
      validator: (value) {
        if (widget.isRequired && value == null) {
          return widget.errorMessage ?? "Vui lòng chọn ${widget.label}";
        }
        return null;
      },
    );
  }
}

/// Highlight text khi search
InlineSpan highlightText(String text, String query, TextStyle baseStyle) {
  if (query.isEmpty) return TextSpan(text: text, style: baseStyle);
  
  final normalizedText = normalizeVietnamese(text.toLowerCase());
  final normalizedQuery = normalizeVietnamese(query.toLowerCase());
  final start = normalizedText.indexOf(normalizedQuery);
  
  if (start == -1) return TextSpan(text: text, style: baseStyle);
  
  final end = start + query.length;
  return TextSpan(
    children: [
      TextSpan(text: text.substring(0, start), style: baseStyle),
      TextSpan(
        text: text.substring(start, end),
        style: baseStyle.copyWith(fontWeight: FontWeight.w700, color: Colors.blue), // Màu highlight nhẹ
      ),
      TextSpan(text: text.substring(end), style: baseStyle),
    ],
  );
}

/// Hàm chuẩn hóa tiếng Việt
String normalizeVietnamese(String input) {
  const withDia = 'áàảãạăắằẳẵặâấầẩẫậđéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵ';
  const withoutDia = 'aaaaaaaaaaaaaaaaadeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyy';
  String result = input;
  for (int i = 0; i < withDia.length; i++) {
    result = result.replaceAll(withDia[i], withoutDia[i]);
  }
  return result;
}