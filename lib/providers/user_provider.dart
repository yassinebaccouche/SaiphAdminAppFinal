import 'package:flutter/widgets.dart';



import '../models/user.dart';
import '../resources/auth-methode.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethodes _authMethods = AuthMethodes();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}