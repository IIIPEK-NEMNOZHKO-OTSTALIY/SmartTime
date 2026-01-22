//import 'package:flutter/cupertino.dart';
//import 'dart:ui';

import '../../core/models/schedule.dart';
import '../../core/models/space.dart';
import '../../core/models/task.dart';

class ScheduleController {
  final Space currentSpace;
  //late List<Space> spaces;
  //late ScheduleParameters parameters;
  final isLoading = false;
  late DateTime weekStart;
  late DateTime selectedDay;

  ScheduleController ({
    required this.currentSpace,
    //spaces: Lis<Space>,
    //parameters: ScheduleParameters,
  }) {
    selectedDay = DateTime.now();
    weekStart = getWeekStart(selectedDay);
  }

  String formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2,'0');
    final m = time.minute.toString().padLeft(2,'0');
    return '$h:$m';
  }

  List<ScheduleTile> timeline = [];
  List<Task> scheduledTasks = [];

  generateSchedule() {
    timeline.clear();
    final tasks = currentSpace.tasks.where((t) => t.isDone == false).toList();
    scheduledTasks = sortTasks(tasks);
    final now = DateTime.now();

    DateTime currentTime = now.hour >= 22
        ? DateTime(now.year, now.month, now.day + 1, 9)
        : DateTime(now.year, now.month, now.day, now.hour + 1, 0);

    DateTime eveningTime = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      22,
      0,
    );

    for (final task in scheduledTasks) {
      final duration = int.parse(task.duration);

      if (duration > 13 * 60) continue;

      if (currentTime.add(Duration(minutes: duration)).isAfter(eveningTime)) {
        currentTime = DateTime(
          currentTime.year,
          currentTime.month,
          currentTime.day + 1,
          9,
          0,
        );
        eveningTime = DateTime(
          currentTime.year,
          currentTime.month,
          currentTime.day,
          22,
          0,
        );
      }

      final start = currentTime;
      final end = start.add(Duration(minutes: duration));

      final daySchedule = timeline.firstWhere((t) =>
            t.day.year == start.year &&
            t.day.month == start.month &&
            t.day.day == start.day,
        orElse: () {
          final tile = ScheduleTile(day: start, tasks: []);
          timeline.add(tile);
          return tile;
        },
      );

      daySchedule.tasks.add(
        ScheduleItem(
          taskId: task.id,
          taskTitle: task.title,
          isDone: task.isDone,
          duration: task.duration,
          priority: task.priority,
          startTime: start,
          endTime: end,
        ),
      );

      currentTime = end;
    }
  }

  List<Task> sortTasks(List<Task> tasks) {
    tasks.sort((a, b) {
      if (a.priority != b.priority) {
        return a.priority.compareTo(b.priority);
      }
      return a.duration.compareTo(b.duration);
    });
    return tasks;
  }


  DateTime getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  List<DateTime> getCurrentWeek() {
    return List.generate(7, (i)=>weekStart.add(Duration(days: i)));
  }
  void selectDay(DateTime day) {
    selectedDay = day;
  }
  void nextWeek() {
    weekStart = weekStart.add(Duration(days: 7));
    selectedDay = weekStart;
  }
  void previousWeek() {
    weekStart = weekStart.subtract(Duration(days: 7));
    selectedDay = weekStart;
  }

}
