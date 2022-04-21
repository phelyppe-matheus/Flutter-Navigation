// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Comment {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  Comment(this.postId, this.id, this.name, this.email, this.body);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postId': postId,
      'id': id,
      'name': name,
      'email': email,
      'body': body,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      map['postId'] as int,
      map['id'] as int,
      map['name'] as String,
      map['email'] as String,
      map['body'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(Map<String, dynamic> source) =>
      Comment.fromMap(source);
}
