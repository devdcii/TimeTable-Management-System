import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ScheduleProvider with ChangeNotifier {
  List<Map<String, dynamic>> _schedules = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get schedules => _schedules;
  bool get isLoading => _isLoading;

  Future<void> fetchSchedules(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/get_schedules.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _schedules = List<Map<String, dynamic>>.from(data['schedules']);
        } else {
          _schedules = [];
        }
      }
    } catch (e) {
      debugPrint('Error fetching schedules: $e');
      _schedules = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addSchedule({
    required int userId,
    required String subjectName,
    required String dayOfWeek,
    required String startTime,
    required String endTime,
    String? roomNumber,
    String? teacherName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/add_schedule.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'subject_name': subjectName,
          'day_of_week': dayOfWeek,
          'start_time': startTime,
          'end_time': endTime,
          'room_number': roomNumber,
          'teacher_name': teacherName,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          await fetchSchedules(userId);
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error adding schedule: $e');
      return false;
    }
  }

  Future<bool> updateSchedule({
    required int scheduleId,
    required int userId,
    required String subjectName,
    required String dayOfWeek,
    required String startTime,
    required String endTime,
    String? roomNumber,
    String? teacherName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/update_schedule.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'schedule_id': scheduleId,
          'user_id': userId,
          'subject_name': subjectName,
          'day_of_week': dayOfWeek,
          'start_time': startTime,
          'end_time': endTime,
          'room_number': roomNumber,
          'teacher_name': teacherName,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          await fetchSchedules(userId);
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error updating schedule: $e');
      return false;
    }
  }

  Future<bool> deleteSchedule(int scheduleId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/delete_schedule.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'schedule_id': scheduleId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _schedules.removeWhere((schedule) => schedule['id'] == scheduleId);
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting schedule: $e');
      return false;
    }
  }

  List<Map<String, dynamic>> getSchedulesForDay(String day) {
    return _schedules
        .where((schedule) => schedule['day_of_week'] == day)
        .toList()
      ..sort((a, b) => a['start_time'].compareTo(b['start_time']));
  }

  Map<String, List<Map<String, dynamic>>> getWeeklySchedules() {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final weeklySchedules = <String, List<Map<String, dynamic>>>{};

    for (var day in days) {
      weeklySchedules[day] = getSchedulesForDay(day);
    }

    return weeklySchedules;
  }
}