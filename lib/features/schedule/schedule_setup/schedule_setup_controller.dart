import '../../../core/models/schedule_parameters.dart';
import '../../../core/models/space.dart';

class ScheduleSetupController {
  List<Space> allSpaces = [];
  List<Space> selectedSpaces = [];

  late List<String> selectedSpacesIds = [];

  bool isSelected(String spaceId) {
    final space = allSpaces.firstWhere((t)=>t.id == spaceId);
    if (selectedSpaces.contains(space)) {
      return true;
    }
    else {
      return false;
    }
  }
  toggleSpace(String spaceId) {
    final space = allSpaces.firstWhere((t)=>t.id == spaceId);
    if (selectedSpaces.contains(space)) {
      selectedSpaces.remove(space);
    }
    else {
      selectedSpaces.add(space);
    }
  }
  ScheduleSetupController({
    required this.allSpaces,
  });
}