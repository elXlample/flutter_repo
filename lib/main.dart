import 'package:flutter/material.dart';

import 'package:playground/playground/http_ui.dart';
import 'package:playground/playground/navigation.dart';
import 'package:playground/playground/playground.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {'/http': (context) => httpUI()}, home: Nav());
  }
}
