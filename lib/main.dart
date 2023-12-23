import 'dart:async';

import 'package:custom_stream_builder/stream.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Stream<int>? stream;
  final List<int> queueOfEvents = <int>[];
  final listOfWidgets = <Widget>[];
  StreamSubscription<int>? subscription;
  Timer? timer;

  getStreamAndListen() {
    stream = NumberGenrator(endOnTick: 50, const Duration(milliseconds: 3))
        .getStream;
    subscription = stream!.listen((event) {
      queueOfEvents.add(event);
      // print("from listener: $event");
    });
    //on onDone, cancel timer when queueOfEvents is empty. Need to notify and cancel.
  }

  startTimerOperation() {
    timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (queueOfEvents.isNotEmpty) {
        print("1");
        //Could create a temp var for queueOfEvents here and use it below so that
        //queueOfEvents can be cleard here asap
        for (int number in queueOfEvents) {
          listOfWidgets.add(Text(number.toString()));
        }
        queueOfEvents.clear();
        setState(() {});
        print("2");
      }
    });
  }

  disposeResources() {
    subscription?.cancel();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print("building");
    return Scaffold(
        body: Center(
          // child: SizedBox.shrink(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: listOfWidgets,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              listOfWidgets.clear();
              disposeResources();
              getStreamAndListen();
              startTimerOperation();
            });
          },
          child: const Icon(Icons.replay_outlined),
        ));
  }
}
