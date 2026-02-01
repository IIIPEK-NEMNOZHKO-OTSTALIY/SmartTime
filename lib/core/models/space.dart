import 'task.dart';
import '../theme/app_theme.dart';
import 'package:flutter/material.dart';

class Space {
  final String id;
  final Color color;
  final String title;
  final List<Task> tasks;

  Space({
    required this.id,
    required this.title,
    required this.tasks,
    this.color = AppColors.primary,
  });

  factory Space.fromJson(Map<String, dynamic> json) {
    return Space(
      id: json['space_id'],
      color: json['color'] ?? AppColors.primary,
      title: json['space_title'],
      tasks: (json['tasks'] as List).map((e) => Task.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'space_id' : id,
    'space_title' : title,
    'tasks' : tasks.map((e) => e.toJson()).toList(),
    'color' : color,
  };
}