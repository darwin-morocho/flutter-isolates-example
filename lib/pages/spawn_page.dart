import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:isolates_example/data/db.dart';
import 'package:isolates_example/data/user.dart';

class IsolateTask {
  final Completer<User> completer;
  final Isolate isolate;
  IsolateTask(this.completer, this.isolate);
}

class IsolateArguments {
  final int taskId;
  final DB db;
  final SendPort sendPort;
  IsolateArguments(this.taskId, this.db, this.sendPort);
}

class IsolateResponse {
  final int taskId;
  final User user;

  IsolateResponse(this.taskId, this.user);

  void printName() {
    print("meedu.app");
  }
}

void entryPoint(IsolateArguments arguments) async {
  await Future.delayed(Duration(seconds: 3));
  final user = arguments.db.create();
  arguments.sendPort.send(IsolateResponse(arguments.taskId, user));
}

class SpawnPage extends StatefulWidget {
  @override
  _SpawnPageState createState() => _SpawnPageState();
}

class _SpawnPageState extends State<SpawnPage> {
  String _text = "MEEDU.APP";
  DB _db = DB();

  int _taskId = 0;

  final ReceivePort _receivePort = ReceivePort();
  late StreamSubscription _subscription;

  Map<int, IsolateTask> _tasks = {};

  @override
  void initState() {
    super.initState();
    _subscription = _receivePort.listen((data) {
      if (data is IsolateResponse) {
        data.printName();
        final task = _tasks[data.taskId];
        if (task != null) {
          task.isolate.kill();
          task.completer.complete(data.user);
          _tasks.remove(data.taskId);
        }
      }
    });
  }

  void _onPressed() async {
    final user = await _addUser();
    if (user != null) {
      _db.add(user);
      setState(() {});
    }
  }

  Future<User?> _addUser() async {
    try {
      _taskId++;
      final isolate = await Isolate.spawn<IsolateArguments>(
        entryPoint,
        IsolateArguments(_taskId, _db, _receivePort.sendPort),
      );
      final Completer<User> completer = Completer();
      _tasks[_taskId] = IsolateTask(completer, isolate);
      return completer.future;
    } on IsolateSpawnException catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _tasks.forEach((key, value) {
      value.isolate.kill();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              print("tasks ${_tasks.length}");
            },
            icon: Icon(Icons.info_outline),
          )
        ],
      ),
      body: Center(
        child: Text(
          _db.count.toString(),
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: this._onPressed,
      ),
    );
  }
}
