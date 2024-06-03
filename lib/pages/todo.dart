// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'package:scheduler/database.dart';

class toDoPage extends StatefulWidget {
  const toDoPage({super.key, required this.title});

  final String title;

  @override
  State<toDoPage> createState() => _toDoPageState();
}

class _toDoPageState extends State<toDoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: Text('hello world'))
          ],
        ),
      ),
    );
  }
}
