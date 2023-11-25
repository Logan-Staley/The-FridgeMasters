import 'package:flutter/foundation.dart';
//Logan S

class UserProvider with ChangeNotifier {
  String? _token;

  String? get token => _token;

  setToken(String? newToken) {
    _token = newToken;
    notifyListeners();
  }
}
