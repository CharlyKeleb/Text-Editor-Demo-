import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:text_editor_flutter/views/utils/editor/js_executor.dart';
import 'package:text_editor_flutter/views/widget/font_size_dialog.dart';
import 'package:text_editor_flutter/views/widget/fonts_dialog.dart';
import 'package:text_editor_flutter/views/widget/heading_dialog.dart';
import 'package:text_editor_flutter/views/widget/insert_image_dialog.dart';

class EditorToolBar extends StatelessWidget {
  final Function(File image)? getImageUrl;
  final JavascriptExecutorBase javascriptExecutor;

  const EditorToolBar(
      {super.key, this.getImageUrl, required this.javascriptExecutor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54.0,
      child: Column(
        children: [
          Flexible(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                IconButton(
                  tooltip: 'Bold',
                  icon: const Icon(Icons.format_bold),
                  onPressed: () async {
                    await javascriptExecutor.setBold();
                  },
                ),
                IconButton(
                  tooltip: 'Italic',
                  icon: const Icon(Icons.format_italic),
                  onPressed: () async {
                    await javascriptExecutor.setItalic();
                  },
                ),
                IconButton(
                  tooltip: 'Insert Image',
                  icon: const Icon(Icons.image),
                  onPressed: () async {
                    var link = await showDialog(
                      context: context,
                      builder: (_) {
                        return  const InsertImageDialog();
                      },
                    );
                    if (link != null) {
                      if (getImageUrl != null && link[2]) {
                        link[0] = await getImageUrl!(File(link[0]));
                      }
                      await javascriptExecutor.insertImage(
                        link[0],
                        alt: link[1],
                      );
                    }
                  },
                ),

                IconButton(
                  tooltip: 'Undo',
                  icon: const Icon(Icons.undo),
                  onPressed: () async {
                    await javascriptExecutor.undo();
                  },
                ),
                IconButton(
                  tooltip: 'Redo',
                  icon: const Icon(Icons.redo),
                  onPressed: () async {
                    await javascriptExecutor.undo();
                  },
                ),

                IconButton(
                  tooltip: 'Font format',
                  icon: const Icon(Icons.text_format),
                  onPressed: () async {
                    var command = await showDialog(
                      // isScrollControlled: true,
                      context: context,
                      builder: (_) {
                        return HeadingDialog();
                      },
                    );
                    if (command != null) {
                      if (command == 'p') {
                        await javascriptExecutor.setFormattingToParagraph();
                      } else if (command == 'pre') {
                        await javascriptExecutor.setPreformat();
                      } else if (command == 'blockquote') {
                        await javascriptExecutor.setBlockQuote();
                      } else {
                        await javascriptExecutor
                            .setHeading(int.tryParse(command)!);
                      }
                    }
                  },
                ),
                // TODO: Show font button on iOS
                Visibility(
                  visible: (!kIsWeb && Platform.isAndroid),
                  child: IconButton(
                    tooltip: 'Font face',
                    icon: const Icon(Icons.font_download),
                    onPressed: () async {
                      var command = await showDialog(
                        // isScrollControlled: true,
                        context: context,
                        builder: (_) {
                          return const FontsDialog();
                        },
                      );
                      if (command != null) {
                        await javascriptExecutor.setFontName(command);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.format_size),
                  tooltip: 'Font Size',
                  onPressed: () async {
                    String? command = await showDialog(
                      // isScrollControlled: true,
                      context: context,
                      builder: (_) {
                        return FontSizeDialog();
                      },
                    );
                    if (command != null) {
                      await javascriptExecutor
                          .setFontSize(int.tryParse(command)!);
                    }
                  },
                ),
                IconButton(
                  tooltip: 'Align Left',
                  icon: const Icon(Icons.format_align_left_outlined),
                  onPressed: () async {
                    await javascriptExecutor.setJustifyLeft();
                  },
                ),
                IconButton(
                  tooltip: 'Align Center',
                  icon: const Icon(Icons.format_align_center),
                  onPressed: () async {
                    await javascriptExecutor.setJustifyCenter();
                  },
                ),
                IconButton(
                  tooltip: 'Align Right',
                  icon: const Icon(Icons.format_align_right),
                  onPressed: () async {
                    await javascriptExecutor.setJustifyRight();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
