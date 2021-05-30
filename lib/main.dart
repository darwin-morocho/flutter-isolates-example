import 'package:flutter/material.dart';
import 'package:isolates_example/pages/compute_page.dart';

import 'pages/spawn_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: SpawnPage(),
    );
  }
}
