import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/schedule/schedule_storage.dart';

class ScheduleStorageService {
  static const key = 'stored_schedule';

  static Future<void> save(StoredSchedule schedule) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(schedule.toJson()));
  }

  static Future<StoredSchedule?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return null;
    return StoredSchedule.fromJson(jsonDecode(raw));
  }
}
