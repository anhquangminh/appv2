import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';

class HtmlContentBox extends StatelessWidget {
  final String content;
  final double maxHeight;

  const HtmlContentBox({
    super.key,
    required this.content,
    this.maxHeight = 280,
  });

  @override
  Widget build(BuildContext context) {
    final bgTable = context.surface;
    final bgHeader = context.surfaceLow;
    final textColor = context.textPrimary;
    final subTextColor = context.textSecondary;
    final borderColor = context.opacity(context.border, 0.5);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Html(
            data: """
              <style>
                table {
                  border-collapse: collapse;
                  font-size: 12px;
                }
                th, td {
                  border: 0.5px solid #cccccc;
                  padding: 4px 6px;
                  text-align: left;
                  vertical-align: top;
                }
                th {
                  font-weight: 600;
                }
                p {
                  margin: 0;
                  padding: 0;
                  font-size: 13px;
                  line-height: 1.4;
                }
              </style>
            ${content
                .replaceAll('<h3>', '<p>')
                .replaceAll('</h3>', '</p><br>')}
            """,
            extensions: const [TableHtmlExtension()],
            style: {
              "body": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontSize: FontSize(12),
                color: textColor,
              ),
              "p": Style(
                margin: Margins.only(bottom: 4),
                padding: HtmlPaddings.zero,
                fontSize: FontSize(13),
                fontWeight: FontWeight.w500,
                lineHeight: LineHeight.number(1.4),
                color: textColor,
              ),
              "table": Style(
                backgroundColor: bgTable,
                border: Border.all(color: borderColor),
              ),
              "th": Style(
                backgroundColor: bgHeader,
                color: context.textPrimary,
                fontSize: FontSize(12),
                padding: HtmlPaddings.all(6),
              ),
              "td": Style(
                fontSize: FontSize(12),
                color: subTextColor,
                padding: HtmlPaddings.all(6),
              ),
            },
          ),
        ),
      ),
    );
  }
}