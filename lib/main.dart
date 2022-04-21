import 'package:flutter/material.dart';
import 'package:flutter_navigation/screens/posts.dart';
import 'package:flutter_navigation/screens/comments.dart';

void main() => runApp(const NavigationApp());

class NavigationApp extends StatelessWidget {
  const NavigationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/posts',
      home: Posts(),
      routes: {
        '/posts': (context) => Posts(),
        '/comments': (context) => Comments()
      },
    );
  }
}
