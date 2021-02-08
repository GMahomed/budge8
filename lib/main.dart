import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Budge8"),
            backgroundColor: const Color(0xFFDA9FF9),
          ),
          body: Center(
          ),
      ),
    );
  }
}
