import 'package:flutter/material.dart';
import '../../features/auth/domain/entities/user.dart';

class SessionManager extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  

  void clear() {
    _currentUser = null;
    notifyListeners();
  }
}
