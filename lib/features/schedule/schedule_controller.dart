import 'package:flutter/cupertino.dart';

import '../../core/models/scheduleTask.dart';
import '../../core/models/space.dart';
import '../../core/models/task.dart';

class ScheduleController {
  final Space currentSpace;
  final isLoading = false;

  String formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2,'0');
    final m = time.minute.toString().padLeft(2,'0');
    return '$h:$m';
  }

  List<ScheduleItem> timeline = [];
  List<Task> scheduledTasks = [];

  ScheduleController ({
    required this.currentSpace
  });

  generateSchedule() {
    final tasks = currentSpace.tasks.where((t) => t.isDone == false).toList();
    scheduledTasks = sortTasks(tasks);
    DateTime currentTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      9,
      0,
    );
    DateTime eveningTime = currentTime.add(Duration(hours: 13));

    for (final task in scheduledTasks) {
      final start = currentTime;
      final end = start.add(Duration(minutes: task.duration));

      if (end.isAfter(eveningTime)) {
        break;
      }
      
      timeline.add(
          ScheduleItem(
            task: task,
            startTime: start,
            endTime: end,
          )
      );
      currentTime = end;
    }
  }

  List<Task> sortTasks(List<Task> tasks) {
    tasks.sort((a, b) {
      if (a.priority != b.priority) {
        return b.priority.compareTo(a.priority);
      }
      return a.duration.compareTo(b.duration);
    });
    return tasks;
  }

}
