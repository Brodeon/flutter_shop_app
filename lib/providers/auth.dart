import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shop_flutter_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment';
    final authBody = json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });
    try {
      var res = await http.post(url, body: authBody);
      print(res.body);
      final responseData = json.decode(res.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));

      final storage = new FlutterSecureStorage();
      storage.write(key: 'userData', value: json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      }));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final storage = new FlutterSecureStorage();
    final userData = await storage.read(key: 'userData');
    if (userData!= null) {
      final result = json.decode(userData);
      final expiryDate = DateTime.parse(result['expiryDate']);
      if (DateTime.now().isAfter(expiryDate)) {
        return false;
      }

      _token = result['token'];
      _userId = result['userId'];
      _expiryDate = expiryDate;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null && _token != null && _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    if (token != null) {
      return _userId;
    }
    return null;
  }

  void logout() {
    final storage = new FlutterSecureStorage();
    storage.delete(key: 'userData');
    _token = null;
    _expiryDate = null;
    _userId = null;

    notifyListeners();
  }

}