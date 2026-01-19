import 'task.dart';

class ScheduleItem {
  final Task task;
  final DateTime startTime;
  final DateTime endTime;

  ScheduleItem({
    required this.task,
    required this.startTime,
    required this.endTime,
  });
}