import 'package:flutter/material.dart';
import 'package:scheduler/database.dart';
import 'todo.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper dbHelper = DatabaseHelper();

  DateTime? _selectedDate;
  TimeOfDay? selectedTime;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  double _getItemOffset(int index) {
    return index * 120.0; // Item width + margin
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  List<Map<String, dynamic>> _storedData = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                itemCount: 10, // Number of items
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _scrollController,
                    builder: (context, child) {
                      double itemOffset = _getItemOffset(index);
                      double centerPosition = _scrollController.offset +
                          MediaQuery.of(context).size.width / 2;
                      double distanceFromCenter =
                          (itemOffset - centerPosition).abs();
                      double scale =
                          (1 - (distanceFromCenter / 500)).clamp(0.8, 1.0);

                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          color:
                              scale > 0.9 ? Colors.blue[300] : Colors.blue[100],
                          child: Center(child: Text('Item $index')),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: SizedBox(
                height: 192,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Icon(Icons.event),
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'What are you gonna do?',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Icon(Icons.access_time),
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                              child: Text(
                            selectedTime != null
                                ? selectedTime!.format(context)
                                : 'When?',
                          )),
                          ElevatedButton(
                            onPressed: () async {
                              final TimeOfDay? time = await showTimePicker(
                                  context: context,
                                  initialTime: selectedTime ?? TimeOfDay.now());
                              if (time != null) {
                                setState(() {
                                  selectedTime = time;
                                });
                              }
                            },
                            child: const Text('Set Time'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        child: const Text('Save'),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const toDoPage(title: 'toDo page'),
            ),
          );
        },
        tooltip: 'Add New',
        child: const Icon(Icons.list),
      ),
    );
  }
}
