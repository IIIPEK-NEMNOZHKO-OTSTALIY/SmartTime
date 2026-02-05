class StoredSchedule {
  final DateTime generatedAt;
  final List<StoredDay> days;

  StoredSchedule({
    required this.generatedAt,
    required this.days,
  });

  Map<String, dynamic> toJson() => {
    'generatedAt': generatedAt.toIso8601String(),
    'days': days.map((d) => d.toJson()).toList(),
  };

  factory StoredSchedule.fromJson(Map<String, dynamic> json) {
    return StoredSchedule(
      generatedAt: DateTime.parse(json['generatedAt']),
      days: (json['days'] as List)
          .map((d) => StoredDay.fromJson(d))
          .toList(),
    );
  }
}

class StoredDay {
  final DateTime date;
  final List<StoredScheduleItem> tasks;

  StoredDay({required this.date, required this.tasks});

  Map<String, dynamic> toJson() => {
    'date': DateTime(date.year, date.month, date.day).toIso8601String(),
    'tasks': tasks.map((t) => t.toJson()).toList(),
  };

  factory StoredDay.fromJson(Map<String, dynamic> json) {
    return StoredDay(
      date: DateTime.parse(json['date']).toLocal(),
      tasks: (json['tasks'] as List)
          .map((t) => StoredScheduleItem.fromJson(t))
          .toList(),
    );
  }
}

class StoredScheduleItem {
  final String taskId;
  final DateTime start;
  final DateTime end;
  final int breakAfter;

  final String title;
  final String spaceId;

  StoredScheduleItem({
    required this.taskId,
    required this.start,
    required this.end,
    required this.breakAfter,
    required this.title,
    required this.spaceId,
  });

  Map<String, dynamic> toJson() => {
    'taskId': taskId,
    'start': start.toIso8601String(),
    'end': end.toIso8601String(),
    'breakAfter': breakAfter,
    'snapshot': {
      'title': title,
      'spaceId': spaceId,
    }
  };

  factory StoredScheduleItem.fromJson(Map<String, dynamic> json) {
    return StoredScheduleItem(
      taskId: json['taskId'],
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
      breakAfter: json['breakAfter'],
      title: json['snapshot']['title'],
      spaceId: json['snapshot']['spaceId'],
    );
  }
}
