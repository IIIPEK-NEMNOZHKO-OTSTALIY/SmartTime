enum DensityMode {
  relaxed,
  balanced,
  dense,
}
extension DensityModeExtension on DensityMode {
  String get label {
    switch (this) {
      case DensityMode.relaxed:
        return 'Спокойный';
      case DensityMode.balanced:
        return 'Сбалансированный';
      case DensityMode.dense:
        return 'Плотный';
    }
  }
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
