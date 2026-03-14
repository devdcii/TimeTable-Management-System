import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  final Map<String, dynamic>? task;

  const AddTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _taskNameController = TextEditingController();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _dueDate;
  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadTaskData();
    }
  }

  void _loadTaskData() {
    _taskNameController.text = widget.task!['task_name'];
    _subjectController.text = widget.task!['subject_name'] ?? '';
    _descriptionController.text = widget.task!['description'] ?? '';
    if (widget.task!['due_date'] != null) {
      _dueDate = DateTime.parse(widget.task!['due_date']);
    }
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Check if task is overdue
  bool _isOverdue() {
    if (_dueDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(_dueDate!.year, _dueDate!.month, _dueDate!.day);
    return due.isBefore(today);
  }

  // Check if task is due today
  bool _isDueToday() {
    if (_dueDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(_dueDate!.year, _dueDate!.month, _dueDate!.day);
    return due.isAtSameMomentAs(today);
  }

  // Check if task is due soon (within 3 days)
  bool _isDueSoon() {
    if (_dueDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(_dueDate!.year, _dueDate!.month, _dueDate!.day);
    final difference = due.difference(today).inDays;
    return difference > 0 && difference <= 3;
  }

  Color _getDueDateColor() {
    if (_isOverdue()) return CupertinoColors.systemRed;
    if (_isDueToday()) return CupertinoColors.systemOrange;
    if (_isDueSoon()) return CupertinoColors.systemYellow;
    return CupertinoColors.activeBlue;
  }

  String _getDueDateIndicator() {
    if (_isOverdue()) return 'Overdue';
    if (_isDueToday()) return 'Due Today';
    if (_isDueSoon()) return 'Due Soon';
    return '';
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
        middle: Text(isEditing ? 'Edit Task' : 'Add Task'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 20),

            // Task Name
            _buildSection(
              title: 'Task Name',
              child: CupertinoTextField(
                controller: _taskNameController,
                placeholder: 'e.g., Mobile App',
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            // Subject
            _buildSection(
              title: 'Subject (Optional)',
              child: CupertinoTextField(
                controller: _subjectController,
                placeholder: 'e.g., Mobile Dev',
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            // Due Date
            _buildSection(
              title: 'Due Date (Optional)',
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CupertinoButton(
                  padding: const EdgeInsets.all(16),
                  onPressed: _showDatePicker,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _dueDate == null
                            ? 'Select due date'
                            : _formatDate(_dueDate!),
                        style: TextStyle(
                          color: _dueDate == null
                              ? CupertinoColors.systemGrey
                              : CupertinoColors.black,
                        ),
                      ),
                      const Icon(
                        CupertinoIcons.calendar,
                        color: CupertinoColors.systemGrey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Description
            _buildSection(
              title: 'Description (Optional)',
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CupertinoTextField(
                  controller: _descriptionController,
                  placeholder: 'Add details...',
                  padding: const EdgeInsets.all(16),
                  minLines: 4,
                  maxLines: 6,
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                onPressed: _saveTask,
                child: Text(
                  isEditing ? 'Update Task' : 'Add Task',
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

  void _showDatePicker() {
    final initialDate = _dueDate ?? DateTime.now();
    final minimumDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

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
                mode: CupertinoDatePickerMode.date,
                initialDateTime: initialDate,
                minimumDate: minimumDate,
                onDateTimeChanged: (dateTime) {
                  setState(() => _dueDate = dateTime);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _getDateOnly(DateTime? date) {
    if (date == null) return '';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _saveTask() async {
    if (_taskNameController.text.trim().isEmpty) {
      _showErrorDialog('Please enter a task name');
      return;
    }

    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.userId == null) {
      _showErrorDialog('User not authenticated');
      return;
    }

    _showLoadingDialog();

    bool success;
    if (isEditing) {
      success = await taskProvider.updateTask(
        taskId: widget.task!['id'].toString(),
        userId: authProvider.userId.toString(),
        taskName: _taskNameController.text.trim(),
        subjectName: _subjectController.text.trim().isEmpty ? null : _subjectController.text.trim(),
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        dueDate: _dueDate?.toIso8601String(),
      );
    } else {
      success = await taskProvider.addTask(
        userId: authProvider.userId.toString(),
        taskName: _taskNameController.text.trim(),
        subjectName: _subjectController.text.trim().isEmpty ? null : _subjectController.text.trim(),
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        dueDate: _dueDate?.toIso8601String(),
      );
    }

    if (!mounted) return;
    Navigator.pop(context);

    if (success) {
      Navigator.pop(context);
    } else {
      _showErrorDialog('Failed to save task. Please try again.');
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