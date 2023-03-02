import 'package:text_editor_flutter/models/text_editor/enum/command_name.dart';

import 'command_state.dart';

class EditorState {
  bool? didHtmlChange;
  String? html;
  Map<CommandName, CommandState>? commandStates;

  EditorState({
    this.didHtmlChange = false,
    this.html = '',
    this.commandStates = const <CommandName, CommandState>{},
  });

  EditorState.fromJson(Map<String, dynamic> json) {
    didHtmlChange = json['didHtmlChange'];
    html = json['html'];
    commandStates = json['commandStates'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['didHtmlChange'] = didHtmlChange;
    data['html'] = html;
    data['commandStates'] = commandStates;
    return data;
  }
}
