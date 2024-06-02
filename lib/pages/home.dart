import 'package:flutter/material.dart';
import 'package:scheduler/database.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper dbHelper = DatabaseHelper();

  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController(viewportFraction: 0.3);
  int _currentPage = 0;

  double _getItemOffset(int index) {
    return index * 120.0; // Item width + margin
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int page = _pageController.page!.round();
      if (_currentPage != page) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  // List<Map<String, dynamic>> _storedData = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 50, 0, 30),
        child: Column(
          children: <Widget>[
            Container(
              height: 150,
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
                          color: scale > 0.9 ? Colors.blue : Colors.grey,
                          child: Center(child: Text('Item $index')),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 600,
                color: Colors.blue[50],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Modal BottomSheet'),
                      ElevatedButton(
                        child: const Text('Close BottomSheet'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        tooltip: 'Add New',
        child: const Icon(Icons.add),
      ),
    );
  }
}
