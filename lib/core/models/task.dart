class Task {
  final String id;
  final String title;
  bool isDone;
  DateTime? dueTime;
  DateTime? deadLine;
  final String duration;
  final String priority;

  Task({
    required this.id,
    required this.title,
    this.isDone = false,
    this.dueTime,
    this.duration = '60',
    this.priority = '3',
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isDone: json['isDone'] ?? false,
      duration: json['duration'] ?? "60",
      priority: json['priority'] ?? "3",
      dueTime: json['dueTime'] != null
        ? DateTime.parse(json['dueTime'])
        : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isDone': isDone,
    'priority': priority,
    'duration': duration,
    'dueTime': dueTime?.toIso8601String(),
  };

  Task copyWith({
    String? id,
    String? title,
    bool? isDone,
    String? duration,
    String? priority,

  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      duration: duration ?? this.duration,
      priority: priority ?? this.priority,
    );
  }
}