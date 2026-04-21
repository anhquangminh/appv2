import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';

class SelectionInfoCard extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onCancel;

  const SelectionInfoCard({
    super.key,
    required this.selectedCount,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.opacity(context.primary, 0.08),
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Text(
              'Đã chọn $selectedCount mục',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: context.textPrimary,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: onCancel,
              style: TextButton.styleFrom(
                foregroundColor: context.primary,
              ),
              child: const Text('Hủy'),
            ),
          ],
        ),
      ),
    );
  }
}