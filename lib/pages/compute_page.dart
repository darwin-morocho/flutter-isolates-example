import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
    final result = await compute<FibonacciArguments, int>(
      fibonacci,
      FibonacciArguments(40, "meedu.app"),
    );
    this.number = result;
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
