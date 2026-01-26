class ScheduleItem {
  final String taskId;
  final String taskTitle;
  final String spaceId;
  final String duration;
  final String priority;
  final bool isDone;
  final int breakAfter;
  DateTime? deadLine;
  final DateTime startTime;
  final DateTime endTime;

  ScheduleItem({
    required this.taskId,
    required this.taskTitle,
    required this.spaceId,
    required this.duration,
    required this.priority,
    this.deadLine,
    required this.isDone, //позже мб уберется
    required this.startTime,
    required this.endTime,
    this.breakAfter = 0,
  });
}

class ScheduleTile{
  final List<ScheduleItem> tasks;
  final DateTime day;

  ScheduleTile({
    required this.tasks,
    required this.day,
  });
}