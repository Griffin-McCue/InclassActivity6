import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class Counter with ChangeNotifier {
  int value = 0;

  void increment(int inc) {
    value += inc;
    if (value > 99) {
      value = 99;
    }
    if (value < 0) {
      value = 0;
    }
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  String getMessage(int age) {
    if (age <= 12) {
      return "You're a child!";
    } else if (age <= 19) {
      return "Teenager time!";
    } else if (age <= 30) {
      return "You're a young adult!";
    } else if (age <= 50) {
      return "You're an adult now!";
    } else {
      return "Golden years!";
    }
  }

  Color getBackgroundColor(int age) {
    if (age <= 12) {
      return Colors.lightBlue;
    } else if (age <= 19) {
      return Colors.lightGreen;
    } else if (age <= 30) {
      return Colors.lightYellow;
    } else if (age <= 50) {
      return Colors.orange;
    } else {
      return Colors.lightGray;
    }
  }

  Color getProgressColor(int age) {
    if (age <= 33) {
      return Colors.green;
    } else if (age <= 66) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(
      builder: (context, counter, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Age Milestones'),
        ),
        backgroundColor: getBackgroundColor(counter.value),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getMessage(counter.value),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'Age: ${counter.value}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Slider(
                value: counter.value.toDouble(),
                min: 0,
                max: 99,
                onChanged: (double value) {
                  counter.increment(value.toInt() - counter.value);
                },
              ),
              LinearProgressIndicator(
                value: counter.value / 99,
                color: getProgressColor(counter.value),
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                counter.increment(1);
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
             FloatingActionButton(
              onPressed: () {
                counter.increment(-1);
              },
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
    );
  }
}