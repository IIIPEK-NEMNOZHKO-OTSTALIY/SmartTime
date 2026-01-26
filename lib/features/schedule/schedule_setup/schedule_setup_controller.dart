import '../../../core/models/schedule/schedule_parameters.dart';
import '../../../core/models/space.dart';

class ScheduleSetupController {
  List<Space> allSpaces = [];
  List<Space> selectedSpaces = [];

  List<String> get selectedSpacesIds => selectedSpaces.map((s)=>s.id).toList();

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