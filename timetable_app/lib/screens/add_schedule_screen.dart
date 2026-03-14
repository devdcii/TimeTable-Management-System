import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/schedule_provider.dart';

class AddScheduleScreen extends StatefulWidget {
  final Map<String, dynamic>? schedule;

  const AddScheduleScreen({Key? key, this.schedule}) : super(key: key);

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _subjectController = TextEditingController();
  final _roomController = TextEditingController();
  final _teacherController = TextEditingController();

  int _selectedDayIndex = 0;
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(hours: 1));

  final List<String> _days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  bool get isEditing => widget.schedule != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadScheduleData();
    }
  }

  void _loadScheduleData() {
    _subjectController.text = widget.schedule!['subject_name'];
    _roomController.text = widget.schedule!['room_number'] ?? '';
    _teacherController.text = widget.schedule!['teacher_name'] ?? '';
    _selectedDayIndex = _days.indexOf(widget.schedule!['day_of_week']);

    final startParts = widget.schedule!['start_time'].split(':');
    _startTime = DateTime(2024, 1, 1, int.parse(startParts[0]), int.parse(startParts[1]));

    final endParts = widget.schedule!['end_time'].split(':');
    _endTime = DateTime(2024, 1, 1, int.parse(endParts[0]), int.parse(endParts[1]));
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _roomController.dispose();
    _teacherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        middle: Text(isEditing ? 'Edit Schedule' : 'Add Schedule'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 20),

            // Subject Name
            _buildSection(
              title: 'Subject Name',
              child: CupertinoTextField(
                controller: _subjectController,
                placeholder: 'e.g., CpE Laws',
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            // Day of Week
            _buildSection(
              title: 'Day of Week',
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CupertinoButton(
                  padding: const EdgeInsets.all(16),
                  onPressed: () => _showDayPicker(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _days[_selectedDayIndex],
                        style: const TextStyle(color: CupertinoColors.black),
                      ),
                      const Icon(
                        CupertinoIcons.chevron_down,
                        color: CupertinoColors.systemGrey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Time Section
            _buildSection(
              title: 'Time',
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.all(16),
                      onPressed: () => _showTimePicker(true),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Start Time',
                            style: TextStyle(color: CupertinoColors.black),
                          ),
                          Text(
                            _formatTime12Hour(_startTime),
                            style: const TextStyle(color: CupertinoColors.activeBlue),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 0.5,
                      color: CupertinoColors.separator,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.all(16),
                      onPressed: () => _showTimePicker(false),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'End Time',
                            style: TextStyle(color: CupertinoColors.black),
                          ),
                          Text(
                            _formatTime12Hour(_endTime),
                            style: const TextStyle(color: CupertinoColors.activeBlue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Room Number
            _buildSection(
              title: 'Room Number (Optional)',
              child: CupertinoTextField(
                controller: _roomController,
                placeholder: 'e.g., CpE Lab',
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            // Teacher Name
            _buildSection(
              title: 'Teacher Name (Optional)',
              child: CupertinoTextField(
                controller: _teacherController,
                placeholder: 'e.g., Doc Gi',
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Save Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CupertinoButton(
                color: CupertinoColors.activeBlue,
                borderRadius: BorderRadius.circular(12),
                onPressed: _saveSchedule,
                child: Text(
                  isEditing ? 'Update Schedule' : 'Add Schedule',
                  style: const TextStyle(color: CupertinoColors.white, fontSize: 17, fontWeight: FontWeight.w400),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 4),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  void _showDayPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 44,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text('Done'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 40,
                scrollController: FixedExtentScrollController(
                  initialItem: _selectedDayIndex,
                ),
                onSelectedItemChanged: (index) {
                  setState(() => _selectedDayIndex = index);
                },
                children: _days.map((day) => Center(child: Text(day))).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimePicker(bool isStartTime) {
    final initialTime = isStartTime ? _startTime : _endTime;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 44,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text('Done'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: initialTime,
                use24hFormat: false,
                onDateTimeChanged: (dateTime) {
                  setState(() {
                    if (isStartTime) {
                      _startTime = dateTime;
                    } else {
                      _endTime = dateTime;
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime12Hour(DateTime time) {
    int hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    String period;

    if (hour == 0) {
      hour = 12;
      period = 'AM';
    } else if (hour < 12) {
      period = 'AM';
    } else if (hour == 12) {
      period = 'PM';
    } else {
      hour -= 12;
      period = 'PM';
    }

    return '$hour:$minute $period';
  }

  String _formatTime24(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  bool _isTimeInValidRange(DateTime time) {
    final hour = time.hour;
    return hour >= 7 && hour < 21;
  }

  Future<void> _saveSchedule() async {
    if (_subjectController.text.trim().isEmpty) {
      _showErrorDialog('Please enter a subject name');
      return;
    }

    if (_endTime.isBefore(_startTime) || _endTime.isAtSameMomentAs(_startTime)) {
      _showErrorDialog('End time must be after start time');
      return;
    }

    // Validate time range (7 AM to 9 PM)
    if (!_isTimeInValidRange(_startTime)) {
      _showErrorDialog('Start time must be between 7:00 AM and 9:00 PM');
      return;
    }

    if (!_isTimeInValidRange(_endTime) || _endTime.hour > 21) {
      _showErrorDialog('End time must be between 7:00 AM and 9:00 PM');
      return;
    }

    // Additional check for end time at exactly 9 PM
    if (_endTime.hour == 21 && _endTime.minute > 0) {
      _showErrorDialog('End time cannot be after 9:00 PM');
      return;
    }

    final scheduleProvider = Provider.of<ScheduleProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    _showLoadingDialog();

    bool success;
    if (isEditing) {
      success = await scheduleProvider.updateSchedule(
        scheduleId: widget.schedule!['id'],
        userId: authProvider.userId!,
        subjectName: _subjectController.text.trim(),
        dayOfWeek: _days[_selectedDayIndex],
        startTime: _formatTime24(_startTime),
        endTime: _formatTime24(_endTime),
        roomNumber: _roomController.text.trim().isEmpty ? null : _roomController.text.trim(),
        teacherName: _teacherController.text.trim().isEmpty ? null : _teacherController.text.trim(),
      );
    } else {
      success = await scheduleProvider.addSchedule(
        userId: authProvider.userId!,
        subjectName: _subjectController.text.trim(),
        dayOfWeek: _days[_selectedDayIndex],
        startTime: _formatTime24(_startTime),
        endTime: _formatTime24(_endTime),
        roomNumber: _roomController.text.trim().isEmpty ? null : _roomController.text.trim(),
        teacherName: _teacherController.text.trim().isEmpty ? null : _teacherController.text.trim(),
      );
    }

    if (!mounted) return;
    Navigator.pop(context);

    if (success) {
      Navigator.pop(context);
    } else {
      _showErrorDialog('Failed to save schedule. Please try again.');
    }
  }

  void _showLoadingDialog() {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CupertinoActivityIndicator(radius: 20),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}