//import 'package:flutter/cupertino.dart';
//import 'dart:ui';

import 'package:smarttime2/core/models/schedule/scheduleItems.dart';
import '../../core/models/space.dart';
import '../../core/models/task.dart';
import '../../core/models/schedule/schedule_parameters.dart';
import '../../core/models/schedule/schedule_storage.dart';

class ScheduleController {
  final List<Space> spaces;
  final ScheduleParameters parameters;
  final isLoading = false;
  late DateTime weekStart;
  late DateTime selectedDay;

  List<ScheduleTile> timeline = [];
  List<Task> scheduledTasks = [];
  List<Task> fixedTasks = [];
  List<Task> deadLineTasks = [];

  ScheduleController ({
    required this.spaces,
    required this.parameters
  }) {
    selectedDay = DateTime.now();
    weekStart = getWeekStart(selectedDay);
  }

  String formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2,'0');
    final m = time.minute.toString().padLeft(2,'0');
    return '$h:$m';
  }
  toggleTask(String taskId) {
    final task = spaces.expand((space) => space.tasks).firstWhere((s) => s.id == taskId);
    task.isDone = !task.isDone;
    generateSchedule();
  }

  generateSchedule() {
    timeline.clear();

    final fixedTasks = spaces
        .expand((s) => s.tasks)
        .where((t) => t.fixedStartTime != null && !t.isDone)
        .toList();

    fixedTasks.sort((a, b) =>
        a.fixedStartTime!.compareTo(b.fixedStartTime!)
    );

    for (final task in fixedTasks) {
      final start = task.fixedStartTime!;
      final end = start.add(Duration(minutes: int.parse(task.duration)));

      final tile = timeline.firstWhere(
            (t) => isSameDay(t.day, start),
        orElse: () {
          final newTile = ScheduleTile(day: start, tasks: []);
          timeline.add(newTile);
          return newTile;
        },
      );

      tile.tasks.add(
        ScheduleItem(
          taskId: task.id,
          taskTitle: task.title,
          spaceId: findSpaceId(task),
          startTime: start,
          endTime: end,
          duration: task.duration,
          priority: task.priority,
          isDone: task.isDone,
          breakAfter: 0,
        ),
      );
    }
    deadLineTasks = spaces.expand((space) => space.tasks.where((t)=>t.deadLine != null && t.fixedStartTime==null)).toList();
    deadLineTasks.sort((a,b)=>a.deadLine!.compareTo(b.deadLine!));
    final tasks = spaces.expand((space) => space.tasks.where((t) => t.isDone == false && t.deadLine == null && t.fixedStartTime == null)).toList();

    final scheduledTasks = sortTasks(tasks);
    final now = DateTime.now();

    DateTime currentTime = DateTime(
      now.year,
      now.month,
      now.day,
      parameters.dayStartTime ~/ 60,
      parameters.dayStartTime % 60,
    );

    if (now.isAfter(currentTime)) {
      currentTime = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        (now.minute ~/ 10 + 1) * 10,
      );
    }

    DateTime eveningTime = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      parameters.dayEndTime~/60,
      parameters.dayEndTime%60,
    );

    final int breakMinutes = getBreakDuration(parameters.densityMode);

    for (final task in deadLineTasks) {

      final duration = int.parse(task.duration);

      if (duration > 13 * 60) continue;

      if (currentTime.add(Duration(minutes: duration)).isAfter(eveningTime)) {
        currentTime = DateTime(
          currentTime.year,
          currentTime.month,
          currentTime.day + 1,
          parameters.dayStartTime~/60,
          parameters.dayStartTime%60,
        );
        eveningTime = DateTime(
          currentTime.year,
          currentTime.month,
          currentTime.day,
          parameters.dayEndTime~/60,
          parameters.dayEndTime%60,
        );
      }

      final start = currentTime;
      final end = start.add(Duration(minutes: duration));

      if (overlapsFixed(start, end)) {
        currentTime = end;
        continue;
      }

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

      final bool isLastTaskOfDay = end.add(Duration(minutes: breakMinutes)).isAfter(eveningTime);
      final int dayBreak = isLastTaskOfDay ? 0 : breakMinutes;


      daySchedule.tasks.add(
        ScheduleItem(
          taskId: task.id,
          taskTitle: task.title,
          isDone: task.isDone,
          duration: task.duration,
          priority: task.priority,
          spaceId: findSpaceId(task), 
          startTime: start,
          endTime: end,
          breakAfter: dayBreak
        ),
      );

      currentTime = end.add(Duration(minutes: dayBreak));
    }
    for (final task in scheduledTasks) {
      final duration = int.parse(task.duration);

      if (duration > 13 * 60) continue;

      if (currentTime.add(Duration(minutes: duration)).isAfter(eveningTime)) {
        currentTime = DateTime(
          currentTime.year,
          currentTime.month,
          currentTime.day + 1,
          parameters.dayStartTime~/60,
          parameters.dayStartTime%60,
        );
        eveningTime = DateTime(
          currentTime.year,
          currentTime.month,
          currentTime.day,
          parameters.dayEndTime~/60,
          parameters.dayEndTime%60,
        );
      }

      final start = currentTime;
      final end = start.add(Duration(minutes: duration));

      if (overlapsFixed(start, end)) {
        currentTime = end;
        continue;
      }

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

      final bool isLastTaskOfDay = end.add(Duration(minutes: breakMinutes)).isAfter(eveningTime);
      final int dayBreak = isLastTaskOfDay ? 0 : breakMinutes;


      daySchedule.tasks.add(
        ScheduleItem(
          taskId: task.id,
          taskTitle: task.title,
          isDone: task.isDone,
          duration: task.duration,
          priority: task.priority,
          spaceId: findSpaceId(task),
          startTime: start,
          endTime: end,
          breakAfter: dayBreak
        ),
      );

      currentTime = end.add(Duration(minutes: dayBreak));
    }
  }
  List<Task> sortTasks(List<Task> tasks) {
    tasks.sort((a, b) {
      if ((a.priority != b.priority) && (parameters.priorityMode == true)) {
        return a.priority.compareTo(b.priority);
      }
      return a.duration.compareTo(b.duration);
    });
    return tasks;
  }

  int weekOffset = 0;
  DateTime getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }
  List<DateTime> getCurrentWeek() {
    final now = DateTime.now().add(Duration(days: weekOffset*7));
    final monday = now.subtract(Duration(days: now.weekday - 1));

    return List.generate(7, (i)=>monday.add(Duration(days: i)));
  }
  void selectDay(DateTime day) {
    selectedDay = day;
  }
  void nextWeek() {
    weekOffset++;
  }
  void previousWeek() {
    weekOffset--;
  }

  int getBreakDuration(DensityMode mode) {
    switch (mode) {
      case DensityMode.relaxed:
        return 20;
      case DensityMode.balanced:
        return 10;
      case DensityMode.dense:
        return 5;
    }
  }
  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String findSpaceId(Task task) {
    return spaces.firstWhere((s) => s.tasks.any((t) => t.id == task.id)).id;
  }
  bool overlapsFixed(DateTime start, DateTime end) {
    return timeline.any((tile) =>
        tile.tasks.any((t) =>
        start.isBefore(t.endTime) && end.isAfter(t.startTime)
        )
    );
  }
  StoredSchedule exportSchedule() {
    return StoredSchedule(
      generatedAt: DateTime.now(),
      days: timeline.map((tile) {
        return StoredDay(
          date: tile.day,
          tasks: tile.tasks.map((task) {
            return StoredScheduleItem(
              taskId: task.taskId,
              start: task.startTime,
              end: task.endTime,
              breakAfter: task.breakAfter,
              title: task.taskTitle,
              spaceId: task.spaceId,
            );
          }).toList(),
        );
      }).toList(),
    );
  }

}
