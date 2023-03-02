import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:text_editor_flutter/models/text_editor/callbacks/did_html_change_listener.dart';
import 'package:text_editor_flutter/models/text_editor/callbacks/html_changed_listener.dart';
import 'package:text_editor_flutter/models/text_editor/callbacks/loaded_listener.dart';
import 'package:text_editor_flutter/models/text_editor/command_state.dart';
import 'package:text_editor_flutter/models/text_editor/enum/command_name.dart';

// A class that handles all editor-related javascript functions
class JavascriptExecutorBase {
  InAppWebViewController? _controller;

  String defaultHtml = "<p>\u200B</p>";

  String editorStateChangedCallbackScheme = "editor-state-changed-callback://";

  String defaultEncoding = "UTF-8";

  String? htmlField = "";

  var didHtmlChange = false;

  Map<CommandName, CommandState> commandStates = {};

  List<Map<CommandName, CommandState>> commandStatesChangedListeners =
      <Map<CommandName, CommandState>>[];

  List<DidHtmlChangeListener> didHtmlChangeListeners =
      <DidHtmlChangeListener>[];

  List<HtmlChangedListener> htmlChangedListeners = <HtmlChangedListener>[];

  bool isLoaded = false;

  List<LoadedListener> loadedListeners = <LoadedListener>[];

  // Initialise the controller so we don't have to
  // pass a controller into every Method
  init(InAppWebViewController? controller) {
    _controller = controller;
  }

  // Run Javascript commands in the editor using the webview controller
  executeJavascript(String command) async {
    return await _controller!.evaluateJavascript(source: 'editor.$command');
  }

  String getCachedHtml() {
    return htmlField!;
  }

  // Display HTML data in editor
  setHtml(String html) async {
    String? baseUrl;
    await executeJavascript("${"setHtml('" + encodeHtml(html)}', '$baseUrl');");
    htmlField = html;
  }

  // Get current HTML data from Editor
  getCurrentHtml() async {
    String? html = await executeJavascript('getEncodedHtml();');
    String? decodedHtml = decodeHtml(html!);
    if (decodedHtml!.startsWith('"') && decodedHtml.endsWith('"')) {
      decodedHtml = decodedHtml.substring(1, decodedHtml.length - 1);
    }
    return decodedHtml;
  }

  // Check if editor's content has been modified
  bool isDefaultTextEditorHtml(String html) {
    return defaultHtml == html;
  }

  // Text commands

  // Undo last editor command/action
  undo() async {
    await executeJavascript("undo();");
  }

  // Redo last editor command/action
  redo() async {
    await executeJavascript("redo();");
  }

  // Make selected or subsequent text Bold
  setBold() async {
    await executeJavascript("setBold();");
  }

  // Make selected or subsequent text Italic
  setItalic() async {
    await executeJavascript("setItalic();");
  }

  // Apply a font face to selected text
  setFontName(String fontName) async {
    await executeJavascript("setFontName('$fontName');");
  }

  // Apply a font size to selected text
  // (Value can only be between 1 and 7)
  setFontSize(int fontSize) async {
    if (fontSize < 1 || fontSize > 7) {
      throw ("Font size should have a value between 1-7");
    }
    await executeJavascript("setFontSize('$fontSize');");
  }

  // Apply a Heading style to selected text
  // (Value can only be between 1 and 6)
  setHeading(int heading) async {
    await executeJavascript("setHeading('$heading');");
  }

  setFormattingToParagraph() async {
    await executeJavascript("setFormattingToParagraph();");
  }

  setPreformat() async {
    await executeJavascript("setPreformat();");
  }

  // Create BlockQuote / make selected text a BlockQuote
  setBlockQuote() async {
    await executeJavascript("setBlockQuote();");
  }

  // Remove formatting from selected text
  removeFormat() async {
    await executeJavascript("removeFormat();");
  }

  // Align content left
  setJustifyLeft() async {
    await executeJavascript("setJustifyLeft();");
  }

  // Align content center
  setJustifyCenter() async {
    await executeJavascript("setJustifyCenter();");
  }

  // Align content right
  setJustifyRight() async {
    await executeJavascript("setJustifyRight();");
  }

  insertImage(String url,
      {String? alt, int? width, int? height, int? rotation}) async {
    rotation ??= 0;
    width ??= 300;
    height ??= 300;
    alt ??= '';
    await executeJavascript(
      "insertImage('$url', '$alt', '$width', '$height', $rotation);",
    );
  }

  // Editor settings commands
  // Focus on editor and bring up keyboard
  focus() async {
    await executeJavascript("focus();");
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  // Remove focus from the editor and close the keyboard
  unFocus() async {
    await executeJavascript("blurFocus();");
  }

  // Set a default editor text font family
  setBaseFontFamily(String fontFamily) async {
    await executeJavascript("setBaseFontFamily('$fontFamily');");
  }

  // Add padding to the editor's content
  setPadding(EdgeInsets? padding) async {
    String left = padding!.left.toString();
    String top = padding.top.toString();
    String right = padding.right.toString();
    String bottom = padding.bottom.toString();
    await executeJavascript(
        "setPadding('${left}px', '${top}px', '${right}px', '${bottom}px');");
  }

  // Set a hint when the editor is empty
  // Doesn't actually work for now
  setPlaceholder(String placeholder) async {
    await executeJavascript("setPlaceholder('$placeholder');");
  }

  // Set editor's width in pixels
  setEditorWidth(int px) async {
    await executeJavascript("setWidth('${px}px');");
  }

  // Set editor's height in pixels
  setEditorHeight(int px) async {
    await executeJavascript("setHeight('${px}px');");
  }

  // Enable text input on editor
  setInputEnabled(bool inputEnabled) async {
    await executeJavascript("setInputEnabled($inputEnabled);");
  }

  decodeHtml(String html) {
    return Uri.decodeFull(html);
  }

  encodeHtml(String html) {
    return Uri.encodeFull(html);
  }
}
