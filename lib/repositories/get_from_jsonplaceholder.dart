import 'dart:convert';

import 'package:flutter_navigation/entities/comment.dart';
import 'package:flutter_navigation/entities/post.dart';
import 'package:http/http.dart' as http;

class GetPostsOnJsonPlaceholder {
  final int _limit;
  final int _page;

  GetPostsOnJsonPlaceholder(this._limit, this._page);

  Future<List<Post>> call() async {
    String uri =
        'https://jsonplaceholder.typicode.com/posts?_limit=$_limit&_page=$_page';
    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      List<dynamic> listPosts = jsonDecode(response.body);
      return List.generate(
          listPosts.length, (index) => Post.fromJson(listPosts[index]));
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class GetCommentsOnJsonPlaceholder {
  final int postId;
  final int _limit;
  final int _page;

  GetCommentsOnJsonPlaceholder(this._limit, this._page, this.postId);

  Future<List<Comment>> call() async {
    String uri =
        'https://jsonplaceholder.typicode.com/comments?_limit=$_limit&_page=$_page&postId=$postId';
    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      List<dynamic> listPosts = jsonDecode(response.body);
      return generateMethodList(listPosts);
    } else {
      throw Exception('Failed to load album');
    }
  }

  List<Comment> generateMethodList(List<dynamic> listPosts) {
    return List.generate(
        listPosts.length, (index) => Comment.fromJson(listPosts[index]));
  }
}
