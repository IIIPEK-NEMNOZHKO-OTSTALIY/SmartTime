class ScheduleItem {
  final String taskId;
  final String taskTitle;
  final int duration;
  final int priority;
  final bool isDone;
  DateTime? deadLine;
  final DateTime startTime;
  final DateTime endTime;

  ScheduleItem({
    required this.taskId,
    required this.taskTitle,
    required this.duration,
    required this.priority,
    this.deadLine,
    required this.isDone, //позже мб уберется
    required this.startTime,
    required this.endTime,
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