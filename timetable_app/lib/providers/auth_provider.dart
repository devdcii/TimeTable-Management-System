// lib/providers/auth_provider.dart

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  int? _userId;
  String? _userName;
  String? _userEmail;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  int? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _loadUserFromLocal();
  }

  // Load user data from Hive
  Future<void> _loadUserFromLocal() async {
    final box = Hive.box(HiveBoxNames.userBox);
    _isLoggedIn = box.get(HiveKeys.isLoggedIn, defaultValue: false);
    _userId = box.get(HiveKeys.userId);
    _userName = box.get(HiveKeys.userName);
    _userEmail = box.get(HiveKeys.userEmail);
    notifyListeners();
  }

  // Save user data to Hive
  Future<void> _saveUserToLocal(int id, String name, String email) async {
    final box = Hive.box(HiveBoxNames.userBox);
    await box.put(HiveKeys.isLoggedIn, true);
    await box.put(HiveKeys.userId, id);
    await box.put(HiveKeys.userName, name);
    await box.put(HiveKeys.userEmail, email);
  }

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        _isLoggedIn = true;
        _userId = data['user']['id'];
        _userName = data['user']['name'];
        _userEmail = data['user']['email'];

        await _saveUserToLocal(_userId!, _userName!, _userEmail!);

        _isLoading = false;
        notifyListeners();

        return {'success': true, 'message': data['message']};
      } else {
        _isLoading = false;
        notifyListeners();
        return {'success': false, 'message': data['message']};
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // Register
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        _isLoggedIn = true;
        _userId = data['user']['id'];
        _userName = data['user']['name'];
        _userEmail = data['user']['email'];

        await _saveUserToLocal(_userId!, _userName!, _userEmail!);

        _isLoading = false;
        notifyListeners();

        return {'success': true, 'message': data['message']};
      } else {
        _isLoading = false;
        notifyListeners();
        return {'success': false, 'message': data['message']};
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // Logout
  Future<void> logout() async {
    final box = Hive.box(HiveBoxNames.userBox);
    await box.clear();

    _isLoggedIn = false;
    _userId = null;
    _userName = null;
    _userEmail = null;

    notifyListeners();
  }
}