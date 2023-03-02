import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:text_editor_flutter/models/post/post_model.dart';

class PostDatabase {
  //add to posts hive database
  addToDb(PostModel posts) async {
    var box = await Hive.openBox<Map>('posts');
    Map item = jsonDecode(jsonEncode(posts.toJson()));
    await box.add(item);
  }

  //get all posts
  Future<List> getPosts() async {
    final box = await Hive.openBox<Map>('posts');
    return box.values.toList();
  }

  //delete posts from database
  deletePost(index) async {
    final box = Hive.box<Map>('posts');
    List posts = box.values.toList();
    await box.deleteAt(index);
  }

  //clear posts from hive database
  clearPosts() async {
    final box = Hive.box<Map>('posts');
    await box.clear();
  }
}
