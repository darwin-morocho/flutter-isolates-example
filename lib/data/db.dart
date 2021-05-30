import 'package:isolates_example/data/user.dart';

class DB {
  List<User> _users = [];
  int get count => _users.length;

  User create() {
    return User(DateTime.now().toString(), 18);
  }

  void add(User user) {
    _users.add(user);
  }
}
