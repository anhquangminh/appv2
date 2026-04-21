import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/presentation/widgets/common/app_card.dart';
import 'package:flutter/material.dart';
import 'package:ducanherp/presentation/widgets/common/html_content_box.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';

import 'daduyet_task_header.dart';
import 'daduyet_expand_button.dart';

class DaDuyetTaskItem extends StatelessWidget {
  final dynamic item;
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  const DaDuyetTaskItem({
    super.key,
    required this.item,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Container(
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DaDuyetTaskHeader(item: item),

              const SizedBox(height: AppSpacing.xs),

              DaDuyetExpandButton(
                isExpanded: isExpanded,
                onTap: onToggleExpand,
              ),

              if (isExpanded) ...[
                const SizedBox(height: AppSpacing.sm),
                HtmlContentBox(content: item.content),
              ],
            ],
          ),
        ),
      ),
    );
  }
}