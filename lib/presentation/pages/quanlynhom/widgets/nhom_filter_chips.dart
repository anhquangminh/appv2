import 'package:flutter/material.dart';

class NhomFilterChips extends StatelessWidget {
  final Map<String, List<String>> filters;
  final VoidCallback onClear;

  const NhomFilterChips({
    super.key,
    required this.filters,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final activeFilters =
        filters.entries.where((e) => e.value.isNotEmpty).toList();

    if (activeFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(left: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...activeFilters
                      .take(3)
                      .map(
                        (e) => Chip(
                          label: Text(
                            e.value.join(', '),
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor:
                              Theme.of(context).chipTheme.backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(color: Colors.transparent),
                          ),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                      ),
                  if (activeFilters.length > 3)
                    Chip(
                      label: const Text('...', style: TextStyle(fontSize: 12)),
                      backgroundColor:
                          Theme.of(context).chipTheme.backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Colors.transparent),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: 'Xóa lọc',
            onPressed: onClear,
          ),
        ],
      ),
    );
  }
}
