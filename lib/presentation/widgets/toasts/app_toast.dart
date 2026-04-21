import 'package:flutter/material.dart';

OverlayEntry? _toastOverlay;

void showAppToast(
  BuildContext context, {
  required String message,
  IconData? icon,
  Color backgroundColor = Colors.black87,
  Color textColor = Colors.white,
  Duration duration = const Duration(seconds: 2),
  String? actionLabel,
  VoidCallback? onAction,
}) {
  /// Nếu đang có toast → remove
  _toastOverlay?.remove();
  _toastOverlay = null;

  final overlay = Overlay.of(
    context,
    rootOverlay: true, 
  );

  _toastOverlay = OverlayEntry(
    builder: (_) {
      return Positioned(
        bottom: 80, 
        left: 16,
        right: 16,
        child: _ToastWidget(
          message: message,
          icon: icon,
          backgroundColor: backgroundColor,
          textColor: textColor,
          actionLabel: actionLabel,
          onAction: onAction,
        ),
      );
    },
  );

  overlay.insert(_toastOverlay!);

  /// Auto hide
  Future.delayed(duration, () {
    _toastOverlay?.remove();
    _toastOverlay = null;
  });
}

class _ToastWidget extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _ToastWidget({
    required this.message,
    this.icon,
    required this.backgroundColor,
    required this.textColor,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor),
              const SizedBox(width: 8),
            ],
            Expanded(child: Text(message, style: TextStyle(color: textColor))),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: onAction,
                child: Text(
                  actionLabel!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
