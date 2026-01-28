import '../../core/models/space.dart';
import '../../core/models/task.dart';
import '../../core/services/local_storage/local_storage_service.dart';

enum HomeMode {
  spaces,
  tasks
}

enum TaskFilter {
  all,
  active,
  completed,
}

class HomeController {
  HomeMode mode = HomeMode.spaces;
  TaskFilter filter = TaskFilter.all;

  final LocalStorageService lss = LocalStorageService();
  List<Space> spaces = [];
  Space? currentSpace;
  bool isLoading = false;

  double progress() {
    if (currentSpace!.tasks.length!=0) {
      return (currentSpace!.tasks.length-remainingTasks())/currentSpace!.tasks.length; }
    return 0;
  }

  void openSpace(String spaceId) {
    currentSpace = spaces.firstWhere((a)=>a.id == spaceId);
    mode = HomeMode.tasks;
  }
  void backToSpaces() {
    currentSpace = null;
    mode = HomeMode.spaces;
  }
  void addSpace(String title) {
    final newSpace = Space(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      tasks: [],
    );
    spaces.add(newSpace);
    lss.saveSpaces(spaces);
  }
  void deleteSpace(String spaceId) {
    spaces.removeWhere((b)=>b.id==spaceId);

    if (currentSpace?.id == spaceId) {
      currentSpace = null;
      mode = HomeMode.spaces;
    }
    lss.saveSpaces(spaces);
  }
  void deleteTask(String taskId) {
    currentSpace!.tasks.removeWhere((b)=>b.id==taskId);
    lss.saveSpaces(spaces);
  }

  void addTask(String title, String duration, String priority, DateTime? fixedDateTime, DateTime? deadLine) {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      duration: duration,
      priority: priority,
      title: title,
      deadLine: deadLine,
      fixedStartTime: fixedDateTime
    );
    currentSpace!.tasks.add(newTask);
    save();
  }

  Future<void> init() async {
    isLoading = true;
    spaces = await lss.loadSpaces();
    if (spaces.isNotEmpty) {
      currentSpace = spaces.first;
    }
    isLoading = false;
  }

  List<Task> get visibleTasks {
  switch (filter) {
  case TaskFilter.active:
  return currentSpace!.tasks.where((c)=>!c.isDone).toList();
  case TaskFilter.completed:
  return currentSpace!.tasks.where((c)=>c.isDone).toList();
  case TaskFilter.all:
  default:
  return currentSpace!.tasks;
  }
}

  void toggleTask(String taskId) {
    final task = currentSpace!.tasks.firstWhere(((t) => t.id == taskId));
    task.isDone = !task.isDone;
    save();
  }

  void toggleFilter(){
    switch (filter) {
      case TaskFilter.all:
        filter = TaskFilter.active;
        break;
      case TaskFilter.active:
        filter = TaskFilter.completed;
        break;
      case TaskFilter.completed:
        filter = TaskFilter.all;
        break;
    }
  }

  void switchSpace(spaceId) {
    currentSpace = spaces.firstWhere(((s)=>s.id == spaceId));
    mode = HomeMode.tasks;
  }

  Future<void> save() async{
    await lss.saveSpaces(spaces);
  }

  int remainingTasks() {
    return currentSpace!.tasks.where((t) => !t.isDone).length;
  }
}