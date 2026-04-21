import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';

// Thay đổi: CustomDropdownFormField hỗ trợ filter, căn trái tuyệt đối kể cả khi đã chọn.
// Cam kết: Item chọn xong luôn căn sát lề trái, realtime filter OK, full AppColors và filter không bị lỗi sau khi xoá text.

class CustomDropdownFormField<T> extends StatefulWidget {
  final String label;
  final List<T> items;
  final String selectedId;
  final String Function(T) getId;
  final String Function(T) getLabel;
  final void Function(T?) onChanged;
  final bool isRequired;
  final String? errorMessage;

  // Style tuỳ chọn
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
  State<CustomDropdownFormField<T>> createState() =>
      _CustomDropdownFormFieldState<T>();
}

class _CustomDropdownFormFieldState<T>
    extends State<CustomDropdownFormField<T>> {
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
    // Nếu list gốc thay đổi thì update filter lại
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
    final v = searchCtrl.text;
    setState(() {
      searchValue = v;
      _filterList(v);
    });
  }

  void _filterList(String query) {
    if (query.isEmpty) {
      filteredItems = List<T>.from(widget.items);
    } else {
      final normQuery = normalizeVietnamese(query.toLowerCase());
      filteredItems =
          widget.items.where((item) {
            final option = normalizeVietnamese(
              widget.getLabel(item).toLowerCase(),
            );
            return option.contains(normQuery);
          }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final fillColor = widget.fillColor ?? context.surfaceLow;
    final borderColor = widget.borderColor ?? context.border;
    final textStyle =
        widget.textStyle ?? TextStyle(color: context.textPrimary, fontSize: 15);
    final iconColor = widget.iconColor ?? context.textSecondary;
    final dropdownColor = widget.dropdownColor ?? context.surface;

    final itemsWithEmpty = [null, ...filteredItems];

    return DropdownButtonFormField2<T?>(
      isExpanded: true,
      alignment: AlignmentDirectional.centerStart,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          color: context.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: context.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: context.error, width: 1.2),
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 260,
        decoration: BoxDecoration(
          color: dropdownColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: context.opacity(context.textPrimary, 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        useRootNavigator: true,
      ),
      iconStyleData: IconStyleData(
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: iconColor),
        iconSize: 20,
        openMenuIcon: Icon(Icons.arrow_drop_up_rounded, color: iconColor),
      ),

      // SEARCH
      dropdownSearchData: DropdownSearchData(
        searchController: searchCtrl,
        searchInnerWidget: Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: searchCtrl,
            style: textStyle.copyWith(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Tìm kiếm...',
              hintStyle: textStyle.copyWith(
                color: context.textSecondary,
                fontWeight: FontWeight.normal,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: context.surfaceLow,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
            ),
          ),
        ),
        searchInnerWidgetHeight: 50,
        searchMatchFn: (item, _) {
          if (item.value == null) return false;
          final option = normalizeVietnamese(
            widget.getLabel(item.value as T).toLowerCase(),
          );
          final q = normalizeVietnamese(searchValue.toLowerCase());
          return option.contains(q);
        },
      ),

      selectedItemBuilder: (context) {
        return itemsWithEmpty.map((item) {
          if (item == null) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "-- Chọn --",
                style: textStyle.copyWith(
                  color: context.textSecondary,
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
              ),
            );
          }
          final label = widget.getLabel(item);
          return Align(
            alignment: Alignment.centerLeft,
            child: RichText(text: highlightText(label, '', textStyle)),
          );
        }).toList();
      },

      items:
          itemsWithEmpty.map((item) {
            if (item == null) {
              return DropdownMenuItem<T?>(
                value: null,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Text(
                      "-- Chọn --",
                      style: textStyle.copyWith(
                        color: context.textSecondary,
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              );
            }
            final label = widget.getLabel(item);
            return DropdownMenuItem<T?>(
              value: item,
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: RichText(
                    text: highlightText(label, searchValue, textStyle),
                  ),
                ),
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

/// BOLD highlight có căn trái
InlineSpan highlightText(String text, String query, TextStyle baseStyle) {
  if (query.isEmpty) {
    return TextSpan(text: text, style: baseStyle);
  }
  final normalizedText = normalizeVietnamese(text.toLowerCase());
  final normalizedQuery = normalizeVietnamese(query.toLowerCase());
  final start = normalizedText.indexOf(normalizedQuery);
  if (start == -1) {
    return TextSpan(text: text, style: baseStyle);
  }
  final end = start + query.length;
  return TextSpan(
    children: [
      TextSpan(text: text.substring(0, start), style: baseStyle),
      TextSpan(
        text: text.substring(start, end),
        style: baseStyle.copyWith(fontWeight: FontWeight.bold),
      ),
      TextSpan(text: text.substring(end), style: baseStyle),
    ],
  );
}

/// Bỏ dấu tiếng Việt
String normalizeVietnamese(String input) {
  const withDia =
      'áàảãạăắằẳẵặâấầẩẫậđéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵ';
  const withoutDia =
      'aaaaaaaaaaaaaaaaadeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyy';
  return input.split('').map((ch) {
    final index = withDia.indexOf(ch);
    if (index != -1) return withoutDia[index];
    return ch;
  }).join();
}
