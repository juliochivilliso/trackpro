import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthProvider with ChangeNotifier {
  static const _boxName = 'auth';
  static const _keyLoggedIn = 'isLoggedIn';

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> init() async {
    final box = await Hive.openBox(_boxName);
    _isLoggedIn = box.get(_keyLoggedIn, defaultValue: false) as bool;
    notifyListeners();
  }

  Future<void> login() async {
    final box = Hive.box(_boxName);
    await box.put(_keyLoggedIn, true);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    final box = Hive.box(_boxName);
    await box.put(_keyLoggedIn, false);
    _isLoggedIn = false;
    notifyListeners();
  }
}
