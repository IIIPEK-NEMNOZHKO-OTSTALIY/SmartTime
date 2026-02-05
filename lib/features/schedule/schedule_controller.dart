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

  late DateTime generatedDay;

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
    print('3,1415926535 8979323846 2643383279 5028841971 6939937510 5820974944 5923078164 0628620899 8628034825 3421170679 8214808651 3282306647 0938446095 5058223172 5359408128 4811174502 8410270193 8521105559 6446229489 5493038196 4428810975 6659334461 2847564823 3786783165 2712019091 4564856692 3460348610 4543266482 1339360726 0249141273 7245870066 0631558817 4881520920 9628292540 9171536436 7892590360 0113305305 4882046652 1384146951 9415116094 3305727036 5759591953 0921861173 8193261179 3105118548 0744623799 6274956735 1885752724 8912279381 8301194912 9833673362 4406566430 8602139494 6395224737 1907021798 6094370277 0539217176 2931767523 8467481846 7669405132 0005681271 4526356082 7785771342 7577896091 7363717872 1468440901 2249534301 4654958537 1050792279 6892589235 4201995611 2129021960 8640344181 5981362977 4771309960 5187072113 4999999837 2978049951 0597317328 1609631859 5024459455 3469083026 4252230825 3344685035 2619311881 7101000313 7838752886 5875332083 8142061717 7669147303 5982534904 2875546873 1159562863 8823537875 9375195778 1857780532 1712268066 1300192787 6611195909 2164201989');
    final task = spaces.expand((space) => space.tasks).firstWhere((s) => s.id == taskId);
    task.isDone = !task.isDone;

  }

  void generateSchedule() {
    timeline.clear();

    final allTasks = spaces.expand((s) => s.tasks).where((t) => !t.isDone).toList();

    final fixedTasks = allTasks
        .where((t) => t.fixedStartTime != null)
        .toList()
      ..sort((a, b) => a.fixedStartTime!.compareTo(b.fixedStartTime!));

    final deadlineTasks = allTasks
        .where((t) => t.deadLine != null && t.fixedStartTime == null)
        .toList()
      ..sort((a, b) => a.deadLine!.compareTo(b.deadLine!));

    final freeTasks = allTasks
        .where((t) => t.deadLine == null && t.fixedStartTime == null)
        .toList()
      ..sort((a, b) {
        if (parameters.priorityMode && a.priority != b.priority) {
          return a.priority.compareTo(b.priority);
        }
        return a.duration.compareTo(b.duration);
      });

    final now = DateTime.now();
    DateTime day = DateTime(now.year, now.month, now.day);
    DateTime cursor = _dayStart(day);

    if (now.isAfter(cursor)) {
      cursor = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        (now.minute ~/ 10) * 10,
      );
    }
    cursor = cursor.add(Duration(minutes: 30));

    DateTime dayEnd = _dayEnd(day);
    final breakMinutes = getBreakDuration(parameters.densityMode);

    for (final task in fixedTasks) {
      final start = task.fixedStartTime!;
      final end = start.add(Duration(minutes: int.parse(task.duration)));
      _add(task, start, end, 0);
    }

    void nextDay() {
      day = day.add(const Duration(days: 1));
      cursor = _dayStart(day);
      dayEnd = _dayEnd(day);
    }

    void place(Task task) {
      final duration = int.parse(task.duration);

      while (true) {
        if (cursor.add(Duration(minutes: duration)).isAfter(dayEnd)) {
          nextDay();
          continue;
        }

        final overlap = _overlap(cursor, duration);
        if (overlap != null) {
          cursor = overlap;
          continue;
        }

        final start = cursor;
        final end = start.add(Duration(minutes: duration));
        final last = end.add(Duration(minutes: breakMinutes)).isAfter(dayEnd);
        final pause = last ? 0 : breakMinutes;

        _add(task, start, end, pause);
        cursor = end.add(Duration(minutes: pause));
        break;
      }
    }

    for (final task in deadlineTasks) {
      place(task);
    }

    for (final task in freeTasks) {
      place(task);
    }
  }

  DateTime _dayStart(DateTime d) =>
      DateTime(d.year, d.month, d.day, parameters.dayStartTime ~/ 60, parameters.dayStartTime % 60);

  DateTime _dayEnd(DateTime d) =>
      DateTime(d.year, d.month, d.day, parameters.dayEndTime ~/ 60, parameters.dayEndTime % 60);

  DateTime? _overlap(DateTime start, int duration) {
    final end = start.add(Duration(minutes: duration));
    for (final t in timeline) {
      for (final i in t.tasks) {
        if (start.isBefore(i.endTime) && end.isAfter(i.startTime)) {
          return i.endTime;
        }
      }
    }
    return null;
  }

  void _add(Task task, DateTime start, DateTime end, int breakAfter) {
    final tile = timeline.firstWhere(
          (t) => isSameDay(t.day, start),
      orElse: () {
        final n = ScheduleTile(day: start, tasks: []);
        timeline.add(n);
        return n;
      },
    );

    tile.tasks.add(
      ScheduleItem(
        taskId: task.id,
        taskTitle: task.title,
        spaceId: findSpaceId(task),
        duration: task.duration,
        priority: task.priority,
        isDone: task.isDone,
        startTime: start,
        endTime: end,
        breakAfter: breakAfter,
      ),
    );
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
