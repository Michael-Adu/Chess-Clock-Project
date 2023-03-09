import 'package:chess_clock_companion/home.dart';
import 'package:flutter/material.dart';
import "global.dart" as global;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chess Clock Companion App',
      home: Home(),
      navigatorKey: global.navigatorKey,
    );
  }
}
