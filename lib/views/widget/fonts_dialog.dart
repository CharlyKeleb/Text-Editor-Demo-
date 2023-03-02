import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:text_editor_flutter/models/text_editor/system_font.dart';
import 'package:text_editor_flutter/views/utils/editor/parse_font_list.dart';

import 'html_text.dart';

class FontsDialog extends StatelessWidget {
  const FontsDialog({super.key});

  List<SystemFont> getSystemFonts() {
    return ParseFontList().getSystemFonts();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (SystemFont font in getSystemFonts())
              InkWell(
                child: HtmlText(
                  html: '<p style="font-family:${font.name}">'
                      '${basename(font.path!)}</p>',
                ),
                onTap: () {
                  Navigator.pop(context, font.name);
                },
              )
          ],
        ),
      ),
    );
  }
}
