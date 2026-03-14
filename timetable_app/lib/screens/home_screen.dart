import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/schedule_provider.dart';
import '../providers/task_provider.dart';
import 'settings_screen.dart';
import 'welcome_screen.dart';
import 'add_schedule_screen.dart';
import 'add_task_screen.dart';
import 'weekly_view_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedDay = 0;
  int _selectedTab = 0;
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    _loadSchedules();
    _loadTasks();
    _setCurrentDay();
  }

  void _setCurrentDay() {
    final now = DateTime.now();
    setState(() {
      _selectedDay = now.weekday - 1;
    });
  }

  int _getCurrentDayIndex() {
    final now = DateTime.now();
    return now.weekday - 1;
  }

  Future<void> _loadSchedules() async {
    final scheduleProvider = Provider.of<ScheduleProvider>(
        context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await scheduleProvider.fetchSchedules(authProvider.userId!);
  }

  Future<void> _loadTasks() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await taskProvider.fetchTasks(authProvider.userId!);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.settings_solid, size: 28),
          onPressed: () => _showSettingsSheet(context),
        ),
        middle: const Text(
            'CpE Timetable', style: TextStyle(fontWeight: FontWeight.w600)),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add, size: 28),
          onPressed: () => _showAddOptions(context),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              color: CupertinoColors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      onPressed: () => setState(() => _selectedTab = 0),
                      child: Text(
                        'Schedule',
                        style: TextStyle(
                          color: _selectedTab == 0
                              ? CupertinoColors.activeBlue
                              : CupertinoColors.systemGrey,
                          fontWeight: _selectedTab == 0
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      onPressed: () => setState(() => _selectedTab = 1),
                      child: Text(
                        'Tasks',
                        style: TextStyle(
                          color: _selectedTab == 1
                              ? CupertinoColors.activeBlue
                              : CupertinoColors.systemGrey,
                          fontWeight: _selectedTab == 1
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (_selectedTab == 0) ...[
              Container(
                color: CupertinoColors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_days.length, (index) {
                    final isSelected = _selectedDay == index;
                    final isCurrentDay = _getCurrentDayIndex() == index;
                    final isDisabled = !isCurrentDay;
                    final dayShort = _days[index].substring(0, 3);

                    return GestureDetector(
                      onTap: isDisabled ? null : () =>
                          setState(() => _selectedDay = index),
                      child: Opacity(
                        opacity: isDisabled ? 0.3 : 1.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? CupertinoColors.activeBlue
                                : CupertinoColors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            dayShort,
                            style: TextStyle(
                              color: isSelected
                                  ? CupertinoColors.white
                                  : CupertinoColors.black,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              Expanded(
                child: scheduleProvider.isLoading
                    ? const Center(child: CupertinoActivityIndicator())
                    : _buildScheduleList(scheduleProvider),
              ),
            ],

            if (_selectedTab == 1) ...[
              Expanded(
                child: taskProvider.isLoading
                    ? const Center(child: CupertinoActivityIndicator())
                    : _buildTaskList(taskProvider),
              ),
            ],

            Container(
              padding: const EdgeInsets.all(16),
              color: CupertinoColors.white,
              child: CupertinoButton(
                color: CupertinoColors.activeBlue,
                borderRadius: BorderRadius.circular(12),
                padding: const EdgeInsets.symmetric(vertical: 14),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const WeeklyViewScreen(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(CupertinoIcons.today_fill, size: 20,
                      color: CupertinoColors.white,),
                    SizedBox(width: 8),
                    Text('View Weekly Schedule', style: TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleList(ScheduleProvider scheduleProvider) {
    final todaySchedules = scheduleProvider.getSchedulesForDay(
        _days[_selectedDay]);

    if (todaySchedules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.calendar_badge_plus,
              size: 64,
              color: CupertinoColors.systemGrey,
            ),
            const SizedBox(height: 16),
            Text(
              'No classes on ${_days[_selectedDay]}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: todaySchedules.length,
      itemBuilder: (context, index) {
        final schedule = todaySchedules[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Dismissible(
            key: Key(schedule['id'].toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              final scheduleProvider = Provider.of<ScheduleProvider>(
                  context, listen: false);
              await scheduleProvider.deleteSchedule(schedule['id']);
              _loadSchedules();
            },
            background: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemRed,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(
                CupertinoIcons.delete,
                color: CupertinoColors.white,
                size: 28,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1565C0).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) =>
                          AddScheduleScreen(schedule: schedule),
                    ),
                  ).then((_) => _loadSchedules());
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _formatTime12Hr(schedule['start_time']),
                              style: const TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _getAmPm(schedule['start_time']),
                              style: const TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              schedule['subject_name'],
                              style: const TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (schedule['room_number'] != null &&
                                schedule['room_number']
                                    .toString()
                                    .isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'Room ${schedule['room_number']}',
                                  style: const TextStyle(
                                    color: CupertinoColors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            if (schedule['teacher_name'] != null &&
                                schedule['teacher_name']
                                    .toString()
                                    .isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  schedule['teacher_name'],
                                  style: TextStyle(
                                    color: CupertinoColors.white.withOpacity(
                                        0.9),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (_isCurrentClass(schedule))
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: CupertinoColors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Now',
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskList(TaskProvider taskProvider) {
    final tasks = taskProvider.tasks;

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              CupertinoIcons.checkmark_circle,
              size: 64,
              color: CupertinoColors.systemGrey,
            ),
            SizedBox(height: 16),
            Text(
              'No tasks yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isCompleted = (task['is_completed'] == 1 ||
            task['is_completed'] == true);
        final dueDate = task['due_date'] != null ? DateTime.parse(
            task['due_date']) : null;
        final dueDateIndicator = _getDueDateIndicator(dueDate);
        final dueDateColor = _getDueDateColor(dueDate);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Dismissible(
            key: Key(task['id'].toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              final taskProvider = Provider.of<TaskProvider>(
                  context, listen: false);
              await taskProvider.deleteTask(task['id']);
              _loadTasks();
            },
            background: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemRed,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(
                CupertinoIcons.delete,
                color: CupertinoColors.white,
                size: 28,
              ),
            ),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => AddTaskScreen(task: task),
                  ),
                ).then((_) => _loadTasks());
              },
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemGrey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _toggleTaskComplete(task);
                        },
                        child: Icon(
                          isCompleted
                              ? CupertinoIcons.checkmark_circle_fill
                              : CupertinoIcons.circle,
                          size: 28,
                          color: isCompleted
                              ? CupertinoColors.activeBlue
                              : CupertinoColors.systemGrey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task['task_name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: CupertinoColors.black,
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            if (task['subject_name'] != null &&
                                task['subject_name']
                                    .toString()
                                    .isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  task['subject_name'],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: CupertinoColors.systemGrey,
                                  ),
                                ),
                              ),
                            if (dueDateIndicator.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons
                                          .exclamationmark_circle_fill,
                                      size: 14,
                                      color: CupertinoColors.activeBlue,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      dueDateIndicator,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: CupertinoColors.activeBlue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (task['due_date'] != null && task['due_date']
                          .toString()
                          .isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: CupertinoColors.activeBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _formatTaskDate(task['due_date']),
                            style: const TextStyle(
                              fontSize: 12,
                              color: CupertinoColors.activeBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getDueDateIndicator(DateTime? dueDate) {
    if (dueDate == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (due.isBefore(today)) return 'Overdue';
    if (due.isAtSameMomentAs(today)) return 'Due Today';

    final difference = due
        .difference(today)
        .inDays;
    if (difference > 0 && difference <= 3) return 'Due Soon';

    return '';
  }

  Color _getDueDateColor(DateTime? dueDate) {
    if (dueDate == null) return CupertinoColors.activeBlue;
    final indicator = _getDueDateIndicator(dueDate);

    if (indicator == 'Overdue') return CupertinoColors.systemRed;
    if (indicator == 'Due Today') return CupertinoColors.systemRed;  // Changed from systemOrange
    if (indicator == 'Due Soon') return CupertinoColors.systemRed;   // Changed from systemYellow

    return CupertinoColors.activeBlue;
  }

  String _formatTaskDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  bool _isCurrentClass(Map<String, dynamic> schedule) {
    final now = DateTime.now();
    final start = _parseTime(schedule['start_time']);
    final end = _parseTime(schedule['end_time']);

    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
  }

  DateTime _parseTime(String time) {
    final parts = time.split(':');
    return DateTime(2024, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
  }

  void _showAddOptions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) =>
          CupertinoActionSheet(
            title: const Text(
              'Add Daily Planner',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  _navigateToAddSchedule(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      CupertinoIcons.calendar_badge_plus,
                      color: CupertinoColors.activeBlue,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Add Schedule',
                      style: TextStyle(
                        fontSize: 20,
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                  ],
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  _navigateToAddTask(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      CupertinoIcons.today_fill,
                      color: CupertinoColors.activeBlue,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Add Task',
                      style: TextStyle(
                        fontSize: 20,
                        color: CupertinoColors.activeBlue,
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

  void _navigateToAddSchedule(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const AddScheduleScreen(),
      ),
    ).then((_) => _loadSchedules());
  }

  void _navigateToAddTask(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const AddTaskScreen(),
      ),
    ).then((_) => _loadTasks());
  }

  Future<bool> _confirmDelete(BuildContext context,
      Map<String, dynamic> schedule) async {
    return await showCupertinoDialog<bool>(
      context: context,
      builder: (context) =>
          CupertinoAlertDialog(
            title: const Text('Delete Schedule'),
            content: Text(
                'Are you sure you want to delete ${schedule['subject_name']}?'),
            actions: [
              CupertinoDialogAction(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Delete'),
                onPressed: () async {
                  final scheduleProvider = Provider.of<ScheduleProvider>(
                      context, listen: false);
                  await scheduleProvider.deleteSchedule(schedule['id']);
                  Navigator.of(context).pop(true);
                  _loadSchedules();
                },
              ),
            ],
          ),
    ) ?? false;
  }

  Future<bool> _confirmDeleteTask(BuildContext context,
      Map<String, dynamic> task) async {
    return await showCupertinoDialog<bool>(
      context: context,
      builder: (context) =>
          CupertinoAlertDialog(
            title: const Text('Delete Task'),
            content: Text(
                'Are you sure you want to delete ${task['task_name']}?'),
            actions: [
              CupertinoDialogAction(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Delete'),
                onPressed: () async {
                  final taskProvider = Provider.of<TaskProvider>(
                      context, listen: false);
                  await taskProvider.deleteTask(task['id']);
                  Navigator.of(context).pop(true);
                  _loadTasks();
                },
              ),
            ],
          ),
    ) ?? false;
  }

  String _formatTime12Hr(String time24) {
    final parts = time24.split(':');
    int hour = int.parse(parts[0]);
    final minute = parts[1];

    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }

    return '$hour:$minute';
  }

  String _getAmPm(String time24) {
    final parts = time24.split(':');
    int hour = int.parse(parts[0]);
    return hour >= 12 ? 'PM' : 'AM';
  }

  void _toggleTaskComplete(Map<String, dynamic> task) async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final isCurrentlyCompleted = (task['is_completed'] == 1 ||
        task['is_completed'] == true);
    final newStatus = !isCurrentlyCompleted;

    await taskProvider.toggleTaskComplete(
      task['id'].toString(),
      newStatus,
    );
    _loadTasks();
  }

  void _showSettingsSheet(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }
}