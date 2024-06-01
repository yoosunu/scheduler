import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'package:workmanager/workmanager.dart';

void main() {
  // Workmanager().executeTask();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Scheduler'),
    );
  }
}
