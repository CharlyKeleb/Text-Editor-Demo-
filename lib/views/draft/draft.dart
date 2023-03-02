import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:text_editor_flutter/models/post/post_model.dart';
import 'package:text_editor_flutter/views/services/database/posts_database.dart';

class Drafts extends StatefulWidget {
  const Drafts({Key? key}) : super(key: key);

  @override
  State<Drafts> createState() => _DraftsState();
}

class _DraftsState extends State<Drafts> {
  Key key = const ObjectKey(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drafts'),
        elevation: 1.0,
      ),
      body: FutureBuilder(
        key: key,
        future: PostDatabase().getPosts(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            List posts = snapshot.data!;
            return posts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'You have not published a post yet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  )
                : Visibility(
                    visible: posts.isNotEmpty,
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                              height: 0.3,
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: const Divider(thickness: 0.5),
                            ),
                          ),
                        );
                      },
                      itemCount: posts.length,
                      itemBuilder: (_, index) {
                        Map logs = posts[index];
                        PostModel post = PostModel.fromJson(
                          jsonDecode(jsonEncode(logs)),
                        );
                        DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
                        DateTime dateTime = dateFormat.parse(post.time!);
                        var formatDate = DateFormat('dd/MM/yyyy hh:mm a');

                        return Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(5.0),
                              leading: CircleAvatar(
                                radius: 35.0,
                                backgroundColor: Colors.blue,
                                backgroundImage: AssetImage(post.photoUrl!),
                              ),
                              title: Text(
                                post.username!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(formatDate.format(dateTime)),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: HtmlWidget(post.content!),
                            ),
                            const SizedBox(height: 10.0),
                          ],
                        );
                      },
                    ),
                  );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
