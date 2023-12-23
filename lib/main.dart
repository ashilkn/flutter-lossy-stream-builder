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
  final listOfWidgets = <Widget>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: StreamBuilder(
                key: ValueKey(stream.hashCode),
                stream: stream,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    listOfWidgets.add(Text(snapshot.data.toString()));
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: listOfWidgets,
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }))),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              stream =
                  NumberGenrator(endOnTick: 10, const Duration(milliseconds: 8))
                      .getStream;
              listOfWidgets.clear();
            });
          },
          child: const Icon(Icons.replay_outlined),
        ));
  }
}
