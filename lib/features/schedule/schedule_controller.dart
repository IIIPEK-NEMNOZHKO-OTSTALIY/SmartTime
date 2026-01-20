//import 'package:flutter/cupertino.dart';
//import 'dart:ui';

import '../../core/models/schedule.dart';
import '../../core/models/space.dart';
import '../../core/models/task.dart';

class ScheduleController {
  final Space currentSpace;
  final isLoading = false;
  DateTime weekStart;
  DateTime selectedDay;

  List<DateTime> getCurrentWeekdays() {
    return List.generate(7, (i) => weekStart.add(Duration(days: i)));
  }
  init () {

  }

  String formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2,'0');
    final m = time.minute.toString().padLeft(2,'0');
    return '$h:$m';
  }

  List<ScheduleTile> timeline = [];
  List<Task> scheduledTasks = [];

  ScheduleController ({
    required this.currentSpace,
    DateTime selectedDay = DateTime.now(),
    DateTime weekStart = getWeekStart(DateTime.now()),
  });

  generateSchedule() {
    timeline.clear();
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
        currentTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          currentTime.day + 1,
          9,
          0,
        );
      }
      if (task.duration > 13*60) {
        break; //пока что скип, позже разбивается на несклько
      }

      ScheduleTile currentDaySchedule = timeline.firstWhere((t) =>
      t.day.day == currentTime.day && t.day.month == currentTime.month && t.day.year == currentTime.year,
          orElse: () {
            var newScheduleTile = ScheduleTile(tasks: [], day: currentTime);
            timeline.add(newScheduleTile);
            return newScheduleTile;
          } );

      currentDaySchedule.tasks.add(
          ScheduleItem(
            taskId: task.id,
            isDone: task.isDone,
            taskTitle: task.title,
            duration: task.duration,
            priority: task.priority,
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


  DateTime getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }
}
