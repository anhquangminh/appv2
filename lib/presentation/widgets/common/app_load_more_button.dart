import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLoadMoreButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const AppLoadMoreButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final c = context;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Center(
        child: GestureDetector(
          onTap: isLoading ? null : onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isLoading
                  ? c.surfaceLow
                  : c.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isLoading
                    ? c.border.withValues(alpha: 0.2)
                    : c.primary.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ICON / LOADING
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isLoading
                      ? SizedBox(
                          key: const ValueKey('loading'),
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: c.primary,
                          ),
                        )
                      : Icon(
                          Icons.expand_more,
                          key: const ValueKey('icon'),
                          size: 18,
                          color: c.primary,
                        ),
                ),

                const SizedBox(width: 6),

                /// TEXT
                Text(
                  isLoading ? 'Đang tải...' : 'Tải thêm',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isLoading ? c.textSecondary : c.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}