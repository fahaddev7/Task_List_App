import 'package:flutter/material.dart';
import 'todoui.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "TODO App",
      theme: ThemeData.dark().copyWith(
        accentColor: Colors.purple,
      ),
      home: Todoui(),
    );
  }
}