import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Data {
  static DateTime createdAt = DateTime.now();
  static int counter = 0;
}

class FibonacciArguments {
  final String message;
  final int n;
  FibonacciArguments(this.n, this.message);

  FibonacciArguments copyWith(int n) {
    return FibonacciArguments(n, this.message);
  }
}

int fibonacci(FibonacciArguments arguments) {
  final n = arguments.n;
  final message = arguments.message;
  print("static count fibonacci ${Data.counter}");
  print("hascode fibonacci  ${Data.createdAt.hashCode}");
  if (n < 2) {
    return n;
  }
  return fibonacci(arguments.copyWith(n - 2)) + fibonacci(arguments.copyWith(n - 1)); //recursive case
}

class ComputePage extends StatefulWidget {
  @override
  _ComputePageState createState() => _ComputePageState();
}

class _ComputePageState extends State<ComputePage> {
  int number = 0;

  void onPressed() async {
    Data.counter++;
    final result = await compute<FibonacciArguments, int>(
      fibonacci,
      FibonacciArguments(1, "meedu.app"),
    );
    this.number = result;
    print("hascode ${Data.createdAt.hashCode}");
    print("static count ${Data.counter} ");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$number"),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: this.onPressed,
      ),
    );
  }
}
