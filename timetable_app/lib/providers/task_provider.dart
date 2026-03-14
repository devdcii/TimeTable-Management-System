import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

class TaskProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = false;
  String? _userId;

  List<Map<String, dynamic>> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get userId => _userId;

  Future<void> fetchTasks(dynamic userId) async {
    _isLoading = true;
    _userId = userId.toString();
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/get_tasks.php?user_id=$userId'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          _tasks = List<Map<String, dynamic>>.from(jsonResponse['data'] ?? []);
        }
      }
    } catch (e) {
      print('Error fetching tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTask({
    required String userId,
    required String taskName,
    String? subjectName,
    String? description,
    String? dueDate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/add_task.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'task_name': taskName,
          'subject_name': subjectName,
          'description': description,
          'due_date': dueDate,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          await fetchTasks(userId);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error adding task: $e');
      return false;
    }
  }

  Future<bool> updateTask({
    required String taskId,
    required String userId,
    required String taskName,
    String? subjectName,
    String? description,
    String? dueDate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/update_task.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'task_id': taskId,
          'task_name': taskName,
          'subject_name': subjectName,
          'description': description,
          'due_date': dueDate,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          await fetchTasks(userId);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error updating task: $e');
      return false;
    }
  }

  Future<bool> deleteTask(String taskId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/delete_task.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'task_id': taskId}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          if (_userId != null) {
            await fetchTasks(_userId!);
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error deleting task: $e');
      return false;
    }
  }

  Future<bool> toggleTaskComplete(String taskId, bool isCompleted) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/toggle_task_complete.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'task_id': taskId,
          'is_completed': isCompleted,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          if (_userId != null) {
            await fetchTasks(_userId!);
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error toggling task complete: $e');
      return false;
    }
  }
}