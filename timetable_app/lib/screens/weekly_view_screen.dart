import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';
import '../providers/auth_provider.dart';
import 'add_schedule_screen.dart';

class WeeklyViewScreen extends StatefulWidget {
  const WeeklyViewScreen({Key? key}) : super(key: key);

  @override
  State<WeeklyViewScreen> createState() => _WeeklyViewScreenState();
}

class _WeeklyViewScreenState extends State<WeeklyViewScreen> {
  static const double hourHeight = 80.0; // Height per hour
  static const int startHour = 7; // 7 AM
  static const int endHour = 21; // 9 PM

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    final scheduleProvider = Provider.of<ScheduleProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.userId != null) {
      await scheduleProvider.fetchSchedules(authProvider.userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final weeklySchedules = scheduleProvider.getWeeklySchedules();

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        middle: const Text('Weekly View', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      child: SafeArea(
        child: scheduleProvider.isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : _buildWeeklyView(weeklySchedules),
      ),
    );
  }

  Widget _buildWeeklyView(Map<String, List<Map<String, dynamic>>> weeklySchedules) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final timeSlots = _generateTimeSlots();

    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time column
              Column(
                children: [
                  const SizedBox(height: 60),
                  ...timeSlots.map((time) => _buildTimeCell(time)),
                ],
              ),
              // Day columns
              ...days.map((day) {
                final daySchedules = weeklySchedules[day] ?? [];
                // Filter schedules within 7 AM to 9 PM
                final filteredSchedules = daySchedules.where((schedule) {
                  final startHour24 = _parseTime24(schedule['start_time']);
                  final endHour24 = _parseTime24(schedule['end_time']);
                  return startHour24 >= startHour && endHour24 <= endHour;
                }).toList();
                return _buildDayColumn(day, filteredSchedules, timeSlots);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeCell(String time) {
    return Container(
      width: 60,
      height: hourHeight,
      alignment: Alignment.topRight,
      padding: const EdgeInsets.only(right: 8, top: 4),
      child: Text(
        time,
        style: const TextStyle(
          fontSize: 10,
          color: CupertinoColors.systemGrey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDayColumn(String day, List<Map<String, dynamic>> schedules, List<String> timeSlots) {
    final isToday = _isToday(day);

    return Container(
      width: 90,
      margin: const EdgeInsets.only(left: 2),
      child: Column(
        children: [
          // Day header
          Container(
            height: 60,
            alignment: Alignment.center,
            child: Text(
              day,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                color: isToday ? CupertinoColors.activeBlue : CupertinoColors.black,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Schedule grid with positioned cells
          SizedBox(
            height: hourHeight * timeSlots.length,
            child: Stack(
              children: [
                // Background grid
                ...timeSlots.asMap().entries.map((entry) {
                  final index = entry.key;
                  return Positioned(
                    top: index * hourHeight,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: hourHeight,
                      margin: const EdgeInsets.only(bottom: 2),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
                // Schedule cells positioned absolutely
                ...schedules.map((schedule) {
                  return _buildPositionedScheduleCell(schedule, timeSlots);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionedScheduleCell(Map<String, dynamic> schedule, List<String> timeSlots) {
    final startTime = schedule['start_time'];
    final endTime = schedule['end_time'];

    // Calculate position and height
    final startHour24 = _parseTime24(startTime);
    final startMinutes = _parseMinutes(startTime);
    final endHour24 = _parseTime24(endTime);
    final endMinutes = _parseMinutes(endTime);

    // Calculate total minutes from start of display (7 AM)
    final startTotalMinutes = (startHour24 - startHour) * 60 + startMinutes;
    final endTotalMinutes = (endHour24 - startHour) * 60 + endMinutes;
    final durationMinutes = endTotalMinutes - startTotalMinutes;

    // Calculate position and height in pixels
    final top = (startTotalMinutes / 60.0) * hourHeight;
    final height = (durationMinutes / 60.0) * hourHeight - 2; // -2 for margin

    return Positioned(
      top: top,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () => _showScheduleOptions(schedule),
        child: Container(
          height: height,
          margin: const EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1565C0).withOpacity(0.3),
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                schedule['subject_name'],
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              if (schedule['room_number'] != null && schedule['room_number'].toString().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    'Room ${schedule['room_number']}',
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                '${_formatTimeShort(startTime)} - ${_formatTimeShort(endTime)}',
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _generateTimeSlots() {
    final slots = <String>[];
    for (int hour = startHour; hour <= endHour; hour++) {
      int displayHour;
      String period;

      if (hour == 12) {
        displayHour = 12;
        period = 'PM';
      } else if (hour > 12) {
        displayHour = hour - 12;
        period = 'PM';
      } else {
        displayHour = hour;
        period = 'AM';
      }

      slots.add('$displayHour:00 $period');
    }
    return slots;
  }

  int _parseTimeSlot(String timeSlot) {
    final parts = timeSlot.split(' ');
    final timeParts = parts[0].split(':');
    var hour = int.parse(timeParts[0]);
    final period = parts[1];

    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return hour;
  }

  int _parseTime24(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]);
  }

  int _parseMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[1]);
  }

  String _formatTimeShort(String time24) {
    final parts = time24.split(':');
    int hour = int.parse(parts[0]);
    final minute = parts[1];

    String period = hour >= 12 ? 'PM' : 'AM';

    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }

    return '$hour:$minute $period';
  }

  bool _isToday(String day) {
    final now = DateTime.now();
    final weekday = now.weekday;
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1] == day;
  }

  void _showScheduleOptions(Map<String, dynamic> schedule) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          schedule['subject_name'],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        message: Text(
          '${schedule['day_of_week']} • ${_formatTimeShort(schedule['start_time'])} - ${_formatTimeShort(schedule['end_time'])}',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _navigateToEditSchedule(schedule);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  CupertinoIcons.pencil,
                  color: CupertinoColors.activeBlue,
                  size: 24,
                ),
                SizedBox(width: 10),
                Text(
                  'Edit Schedule',
                  style: TextStyle(
                    fontSize: 20,
                    color: CupertinoColors.activeBlue,
                  ),
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _confirmDeleteSchedule(schedule);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  CupertinoIcons.delete,
                  color: CupertinoColors.systemRed,
                  size: 24,
                ),
                SizedBox(width: 10),
                Text(
                  'Delete Schedule',
                  style: TextStyle(
                    fontSize: 20,
                    color: CupertinoColors.systemRed,
                  ),
                ),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToEditSchedule(Map<String, dynamic> schedule) async {
    final result = await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => AddScheduleScreen(schedule: schedule),
      ),
    );

    if (result == true) {
      _loadSchedules();
    }
  }

  Future<void> _confirmDeleteSchedule(Map<String, dynamic> schedule) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Schedule'),
        content: Text(
          'Are you sure you want to delete ${schedule['subject_name']}?',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final scheduleProvider = Provider.of<ScheduleProvider>(context, listen: false);
      await scheduleProvider.deleteSchedule(schedule['id']);
      _loadSchedules();
    }
  }
}