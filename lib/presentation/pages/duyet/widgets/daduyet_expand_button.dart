import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';

// =======================
// MAIN WIDGET
// =======================
class DaDuyetExpandButton extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const DaDuyetExpandButton({
    super.key,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return const _ExpandButtonWrapper();
  }
}

// =======================
// WRAPPER (GIỮ ALIGN + BUTTON)
// =======================
class _ExpandButtonWrapper extends StatelessWidget {
  const _ExpandButtonWrapper();

  @override
  Widget build(BuildContext context) {
    final parent = context.findAncestorWidgetOfExactType<DaDuyetExpandButton>()!;

    return Align(
      alignment: Alignment.centerRight,
      child: _ExpandButtonContent(
        isExpanded: parent.isExpanded,
        onTap: parent.onTap,
      ),
    );
  }
}

// =======================
// CONTENT BUTTON
// =======================
class _ExpandButtonContent extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const _ExpandButtonContent({
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: _buttonStyle(),
      child: _ExpandRow(isExpanded: isExpanded),
    );
  }

  ButtonStyle _buttonStyle() {
    return TextButton.styleFrom(
      minimumSize: Size.zero,
      padding: EdgeInsets.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}

// =======================
// ROW (TEXT + ICON)
// =======================
class _ExpandRow extends StatelessWidget {
  final bool isExpanded;

  const _ExpandRow({
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ExpandText(),
        const SizedBox(width: 2),
        _ExpandIcon(isExpanded: isExpanded),
      ],
    );
  }
}

// =======================
// TEXT
// =======================
class _ExpandText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Chi tiết',
      style: TextStyle(
        fontSize: 11,
        color: context.textSecondary,
      ),
    );
  }
}

// =======================
// ICON
// =======================
class _ExpandIcon extends StatelessWidget {
  final bool isExpanded;

  const _ExpandIcon({
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: isExpanded ? 0.5 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Icon(
        Icons.expand_more,
        size: 16,
        color: context.primary,
      ),
    );
  }
}