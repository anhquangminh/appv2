import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget> actions;
  final VoidCallback onClose;

  const CustomDialog({
    super.key,
    required this.title,
    required this.body,
    required this.actions,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogTitle(title, onClose),
            const SizedBox(height: 15),
            body,
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogTitle(String title, VoidCallback onClose) {
    return Stack(
      children: [
        Positioned(
          right: 0,
          top: -10,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
            splashRadius: 20,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        
      ],
    );
  }
}
