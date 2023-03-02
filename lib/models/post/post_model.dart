import 'package:text_editor_flutter/models/post/enum/type.dart';

class PostModel {
  String? postId;
  String? authorId;
  String? content;
  String? title;
  String? photoUrl;
  int? likes;
  int? favorites;
  String? time;
  String? username;
  PostVisibility? visibility;

  PostModel(
      {this.postId,
      this.authorId,
      this.content,
      this.title,
      this.likes,
      this.favorites,
      this.time,
      this.username,
      this.visibility,
      this.photoUrl});

  PostModel.fromJson(Map<String, dynamic> json) {
    photoUrl = json['photoUrl'];
    postId = json['postId'];
    authorId = json['authorId'];
    content = json['content'];
    title = json['title'];
    likes = json['likes'];
    time = json['time'];
    username = json['username'];
    favorites = json['favorites'];
    if (json['visibility'] == 'public') {
      visibility = PostVisibility.PUBLIC;
    } else {
      visibility = PostVisibility.PRIVATE;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['postId'] = postId;
    data['photoUrl'] = photoUrl;
    data['authorId'] = authorId;
    data['content'] = content;
    data['title'] = title;
    data['likes'] = likes;
    data['time'] = time;
    data['username'] = username;
    data['favorites'] = favorites;
    if (visibility == PostVisibility.PUBLIC) {
      data['visibility'] = 'Public';
    } else {
      data['visibility'] = 'Private';
    }
    return data;
  }
}
