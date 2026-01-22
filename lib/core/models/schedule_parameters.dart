enum DensityMode {
  relaxed,
  balanced,
  dense,
}
enum PriorityMode {
  on,
  off,
}
class ScheduleParameters {
  final int dayStartTime;
  final int dayEndTime;
  final DensityMode densityMode;
  final PriorityMode priorityMode;
  final List<String> selectedSpacesIds;

  ScheduleParameters({
    required this.selectedSpacesIds,
    this.dayEndTime = 22*60,
    this.dayStartTime = 9*60,
    this.densityMode = DensityMode.balanced,
    this.priorityMode = PriorityMode.on,
  });
}
