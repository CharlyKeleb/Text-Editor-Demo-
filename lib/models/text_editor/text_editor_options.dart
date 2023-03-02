import 'package:flutter/material.dart';
import 'package:text_editor_flutter/models/text_editor/enum/bar_position.dart';

class TextEditorOptions {
  EdgeInsets? padding;
  String? placeholder;
  String? baseFontFamily;
  BarPosition? barPosition;
  bool? enableVideo;

  TextEditorOptions({
    EdgeInsets? padding,
    String? placeholder,
    String? baseFontFamily,
    BarPosition? barPosition,
    bool? enableVideo = true,
  }) {
    this.padding = padding;
    this.placeholder = placeholder;
    this.baseFontFamily = baseFontFamily;
    this.barPosition = barPosition;
    this.enableVideo = enableVideo;
  }
}
