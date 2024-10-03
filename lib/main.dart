// lib/main.dart

import 'package:flutter/material.dart';
import 'package:jobaventure/pages/cover.dart';
import 'pages/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CoverPage(),
    );
  }
}
