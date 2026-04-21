import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class FilterSheet extends StatefulWidget {
  final List<dynamic> data;
  final List<Map<String, String>> filterFields;
  final String Function(dynamic item, String field) getFieldValue;
  final void Function(Map<String, List<String>> filters)? onApplyFilter;

  const FilterSheet({
    super.key,
    required this.data,
    required this.filterFields,
    required this.getFieldValue,
    required this.onApplyFilter,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required List<dynamic> data,
    required List<Map<String, String>> filterFields,
    required String Function(dynamic item, String field) getFieldValue,
    void Function(Map<String, List<String>> filters)? onApplyFilter,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.8,
            maxChildSize: 0.95,
            minChildSize: 0.4,
            builder:
                (context, scrollController) => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: FilterSheet(
                      data: data,
                      filterFields: filterFields,
                      getFieldValue: getFieldValue,
                      onApplyFilter: onApplyFilter,
                    ),
                  ),
                ),
          ),
    );
  }

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  final Map<String, MultiSelectController<String>> controllers = {};
  final Map<String, List<String>> dropdownData = {};
  final Map<String, Set<String>> selectedValuesMap = {};

  @override
  void initState() {
    super.initState();

    for (var filter in widget.filterFields) {
      final field = filter['field']!;
      controllers[field] = MultiSelectController<String>();
      dropdownData[field] =
          widget.data
              .map((item) => widget.getFieldValue(item, field))
              .toSet()
              .toList();
      selectedValuesMap[field] = {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bộ lọc',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: cs.onSurface),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            ...widget.filterFields.map((filter) {
              final label = filter['label']!;
              final field = filter['field']!;

              if (dropdownData[field] == null || dropdownData[field]!.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),

                  MultiDropdown<String>(
                    controller: controllers[field]!,
                    items:
                        dropdownData[field]!
                            .map((e) => DropdownItem(label: e, value: e))
                            .toList(),

                    chipDecoration: ChipDecoration(
                      wrap: true,
                      spacing: 8,
                      runSpacing: 4,
                      backgroundColor: cs.primary.withValues(alpha: 0.1),
                      labelStyle: TextStyle(color: cs.primary),
                    ),

                    fieldDecoration: FieldDecoration(
                      hintText: 'Chọn $label...',
                      hintStyle: TextStyle(color: cs.onSurfaceVariant),
                      backgroundColor: cs.surfaceContainerLow,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: cs.outline),
                      ),
                    ),

                    dropdownDecoration: DropdownDecoration(
                      maxHeight: 300,
                      marginTop: 5,
                      backgroundColor: cs.surface,
                    ),

                    onSelectionChange: (values) {
                      setState(() {
                        selectedValuesMap[field] = values.toSet();
                      });
                    },
                  ),

                  const SizedBox(height: 16),
                ],
              );
            }),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final Map<String, List<String>> filters = {};

                  for (var filter in widget.filterFields) {
                    final field = filter['field']!;
                    filters[field] =
                        selectedValuesMap[field]?.toList() ?? [];
                  }

                  widget.onApplyFilter?.call(filters);
                },
                child: const Text("Áp dụng lọc"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}