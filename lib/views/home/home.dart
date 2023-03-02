import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_editor_flutter/models/post/post_model.dart';
import 'package:text_editor_flutter/models/text_editor/enum/bar_position.dart';
import 'package:text_editor_flutter/models/text_editor/text_editor_options.dart';
import 'package:text_editor_flutter/views/components/animation/fade_in_page.dart';
import 'package:text_editor_flutter/views/draft/draft.dart';
import 'package:text_editor_flutter/views/render/text_editor.dart';
import 'package:text_editor_flutter/views/services/database/posts_database.dart';
import 'package:text_editor_flutter/views/utils/const.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<TextEditorState> key = GlobalKey();
  String visibility = 'Private';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.secondary,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 15,
            ),

            /// TOP BAR WIDGET
            buildTopWidget(),
            SizedBox(height: MediaQuery.of(context).size.height / 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 20.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 35.0,
                            backgroundColor: Colors.blue,
                            backgroundImage:
                                AssetImage('assets/images/user.jpeg'),
                          ),
                          const SizedBox(width: 20.0),

                          ///DROPDOWN BUTTON TO SELECT IF A POST WOULD BE PRIVATE OR PUBLIC
                          SizedBox(
                            height: 40.0,
                            width: 120.0,
                            child: OutlinedButton(
                              onPressed: null,
                              style: ButtonStyle(
                                side: MaterialStateProperty.all<BorderSide>(
                                  const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return DropdownButton(
                                    underline: const SizedBox(),
                                    value: visibility,
                                    items: <String>['Public', 'Private']
                                        .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        visibility = value!;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //TOOL BAR WIDGET TO EDIT TEXT
                    Expanded(
                      child: TextEditor(
                        key: key,
                        value: '''
        Hello,How are you?. Flutter Rocks.
        ''', //
                        editorOptions: TextEditorOptions(
                          placeholder: 'Start typing',
                          // editor padding
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          // font name
                          baseFontFamily: 'sans-serif',
                          // Position of the editing bar (BarPosition.TOP or BarPosition.BOTTOM)
                          barPosition: BarPosition.TOP,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildTopWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          const Icon(
            Icons.close,
            color: Colors.white,
          ),
          const Spacer(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  FadePageRoute(
                    Drafts(),
                  ),
                ),
                child: Text(
                  'drafts'.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15.0,
                  ),
                ),
              ),
              Positioned(
                left: 53.0,
                bottom: 10,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 30.0),
          InkWell(
            onTap: () async {
              String? html = await key.currentState?.getHtml();
              Map data = {
                "postId": uuid.v4(),
                "authorId": uuid.v4(),
                "content": html,
                "title": 'Testing Editor',
                "photoUrl": 'assets/images/user.jpeg',
                "likes": 0,
                "favorites": 0,
                "username": "John Doe",
                "visibility": visibility,
                "time": DateTime.now().toString(),
              };
              PostModel post = PostModel.fromJson(jsonDecode(jsonEncode(data)));
              await PostDatabase().addToDb(post);
              dialog();
              key.currentState?.clear();
            },
            child: Container(
              height: 35.0,
              width: 80.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              child: const Center(
                child: Text(
                  'Post',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void dialog() {
    showDialog(
      context: context,
      builder: (_) => Center(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Center(
            child: Text(
              'Added to Drafts',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const <Widget>[
              Icon(
                Icons.check_circle_outline,
                size: 100.0,
                color: Colors.green,
              )
            ],
          ),
        ),
      ),
    );
  }
}
