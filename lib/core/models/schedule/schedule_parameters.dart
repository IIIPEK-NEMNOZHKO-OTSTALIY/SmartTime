enum DensityMode {
  relaxed,
  balanced,
  dense,
}
class ScheduleParameters {
  final int dayStartTime;
  final int dayEndTime;
  final DensityMode densityMode;
  final bool priorityMode;
  final List<String> selectedSpacesIds;

  ScheduleParameters({
    required this.selectedSpacesIds,
    this.dayEndTime = 22*60,
    this.dayStartTime = 9*60,
    this.densityMode = DensityMode.balanced,
    this.priorityMode = true,
  });
}
