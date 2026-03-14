// lib/constants.dart
class ApiConstants {
  // CHANGE THIS TO YOUR SERVER URL
  // For Android Emulator: http://10.0.2.2/TimeTable
  // For iOS Simulator: http://localhost/TimeTable
  // For Real Device: http://YOUR_IP/TimeTable
  static const String baseUrl = 'https://devm.cpedev.site/TimeTable'; // Removed trailing slash

  // Auth endpoints
  static const String loginUrl = '$baseUrl/login.php';
  static const String registerUrl = '$baseUrl/register.php';

  // Schedule endpoints
  static const String getSchedulesUrl = '$baseUrl/get_schedules.php';
  static const String addScheduleUrl = '$baseUrl/add_schedule.php';
  static const String updateScheduleUrl = '$baseUrl/update_schedule.php';
  static const String deleteScheduleUrl = '$baseUrl/delete_schedule.php';

  // Task endpoints
  static const String getTasksUrl = '$baseUrl/get_tasks.php';
  static const String addTaskUrl = '$baseUrl/add_task.php';
  static const String updateTaskUrl = '$baseUrl/update_task.php';
  static const String deleteTaskUrl = '$baseUrl/delete_task.php';
  static const String toggleTaskCompleteUrl = '$baseUrl/toggle_task_complete.php';
}

class HiveBoxNames {
  static const String userBox = 'userBox';
  static const String scheduleBox = 'scheduleBox';
  static const String taskBox = 'taskBox';
}

class HiveKeys {
  static const String isLoggedIn = 'isLoggedIn';
  static const String userId = 'userId';
  static const String userName = 'userName';
  static const String userEmail = 'userEmail';
}