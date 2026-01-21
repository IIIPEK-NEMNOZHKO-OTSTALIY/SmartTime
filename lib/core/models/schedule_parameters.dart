import 'dart:io';

enum densityMode {
  relaxed,
  balanced,
  dense
}
enum priorityMode {
  priorityModeOn,
  priorityModeOff,

}
class ScheduleParameters {
  final int dayStartTime;
  final int dayEndTime;
  final List<String> selectedSpacesIds;

  ScheduleParameters({
    required this.selectedSpacesIds,
    this.dayEndTime = 22*60,
    this.dayStartTime = 9*60
  });
}
