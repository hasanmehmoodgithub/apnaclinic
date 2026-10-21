import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/apna_clinic_ai_ui_config.dart';

/// Small markdown subset used by assistant replies: paragraphs, bold, lists.
class ApnaClinicAiMarkdownText extends StatelessWidget {
  const ApnaClinicAiMarkdownText({
    super.key,
    required this.text,
    required this.style,
  });

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final blocks = _blocks(text);
    if (blocks.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < blocks.length; i++) ...[
          if (i > 0) SizedBox(height: 8.h),
          blocks[i],
        ],
      ],
    );
  }

  List<Widget> _blocks(String source) {
    final widgets = <Widget>[];
    final paragraph = <String>[];
    var list = <_ListItem>[];

    void flushParagraph() {
      if (paragraph.isEmpty) return;
      widgets.add(
        Text.rich(_inline(paragraph.join(' '), style), style: style),
      );
      paragraph.clear();
    }

    void flushList() {
      if (list.isEmpty) return;
      widgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < list.length; i++)
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(list[i].ordered ? '${i + 1}. ' : '• ', style: style),
                    Expanded(
                      child: Text.rich(_inline(list[i].text, style), style: style),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
      list = [];
    }

    for (final raw in source.split('\n')) {
      final line = raw.trim();
      final bullet = RegExp(r'^[-*•]\s+(.*)$').firstMatch(line);
      final numbered = RegExp(r'^\d+[.)]\s+(.*)$').firstMatch(line);
      if (bullet != null || numbered != null) {
        flushParagraph();
        final ordered = numbered != null;
        if (list.isNotEmpty && list.first.ordered != ordered) flushList();
        list.add(
          _ListItem(ordered: ordered, text: (bullet ?? numbered)!.group(1)!),
        );
      } else if (line.isEmpty) {
        flushParagraph();
        flushList();
      } else {
        flushList();
        paragraph.add(line);
      }
    }
    flushParagraph();
    flushList();
    return widgets;
  }

  TextSpan _inline(String source, TextStyle base) {
    final pattern = RegExp(r'\*\*[^*]+\*\*|`[^`]+`|\*[^*\s][^*]*\*');
    final children = <InlineSpan>[];
    var start = 0;
    for (final match in pattern.allMatches(source)) {
      if (match.start > start) {
        children.add(TextSpan(text: source.substring(start, match.start)));
      }
      final token = match.group(0)!;
      if (token.startsWith('**')) {
        children.add(
          TextSpan(
            text: token.substring(2, token.length - 2),
            style: base.copyWith(fontWeight: FontWeight.w700),
          ),
        );
      } else if (token.startsWith('`')) {
        children.add(
          TextSpan(
            text: token.substring(1, token.length - 1),
            style: base.copyWith(
              fontFamily: 'monospace',
              backgroundColor: ApnaClinicAiUiConfig.card,
            ),
          ),
        );
      } else {
        children.add(
          TextSpan(
            text: token.substring(1, token.length - 1),
            style: base.copyWith(fontStyle: FontStyle.italic),
          ),
        );
      }
      start = match.end;
    }
    if (start < source.length) {
      children.add(TextSpan(text: source.substring(start)));
    }
    return TextSpan(style: base, children: children);
  }
}

class _ListItem {
  const _ListItem({required this.ordered, required this.text});

  final bool ordered;
  final String text;
}
