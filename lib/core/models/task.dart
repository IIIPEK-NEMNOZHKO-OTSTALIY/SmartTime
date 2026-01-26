class Task {
  final String id;
  final String title;
  bool isDone;
  final String duration;
  final String priority;

  final DateTime? deadLine;
  final DateTime? fixedStartTime;

  Task({
    required this.id,
    required this.title,
    this.isDone = false,
    this.duration = '60',
    this.priority = '3',

    this.fixedStartTime = null,
    this.deadLine = null,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isDone: json['isDone'] ?? false,
      duration: json['duration'] ?? "60",
      priority: json['priority'] ?? "3",
      fixedStartTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'])
          : null,
      deadLine: json['deadLine'] != null
          ? DateTime.parse(json['deadLine'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isDone': isDone,
    'priority': priority,
    'duration': duration,
    'deadLine': deadLine?.toIso8601String(),
    'startTime': fixedStartTime?.toIso8601String(),
  };

  Task copyWith({
    String? id,
    String? title,
    bool? isDone,
    String? duration,
    String? priority,
    DateTime? fixedStartTime,
    DateTime? deadLine,

  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      duration: duration ?? this.duration,
      priority: priority ?? this.priority,
      deadLine: deadLine ?? this.deadLine,
      fixedStartTime: fixedStartTime ?? this.fixedStartTime,
    );
  }
}