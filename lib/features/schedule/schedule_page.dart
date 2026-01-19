import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smarttime2/features/home/home_page.dart';
import 'schedule_controller.dart';
import '../../core/models/space.dart';

class SchedulePage extends StatefulWidget {
  final Space space;
  const SchedulePage({Key? key, required this.space}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late final ScheduleController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScheduleController(currentSpace: widget.space);
    _controller.generateSchedule();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
              children: [
                SizedBox(height: 50,),
                Text('РАСПИСАНИЕ', style: TextStyle(fontSize: 32),),
                Expanded(child: ListView.builder(
                    itemCount: _controller.timeline.length,
                    itemBuilder: (_, index) {
                      final task = _controller.timeline[index];
                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task.task.title, style: TextStyle(fontSize: 20),),
                            Text('${_controller.formatTime(task.startTime)} - ${_controller.formatTime(task.endTime)} (${task.task.duration
                                .toString()} минут) '),
                          ],
                        ),
                        trailing: Icon(task.task.isDone ? Icons.check_circle : Icons
                            .circle_outlined),
                        onTap: () {
                          setState(() {});
                        },
                      );
                    }
                ),)
              ]
          ),
        ),
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.pop(context), child: Icon(Icons.home_rounded),)
    );
  }
}
/*
  Widget buildSchedule() {
    final tasks = _controller.currentSpace!.tasks;
    return Column(
        children: [
          Text('Задач всего: ${_controller.currentSpace!.tasks.length} '),
          Text('Выполнено задач: ${_controller.currentSpace!.tasks.length -
              _controller.remainingTasks()} '),
          Text('Задач оосталось: ${_controller.remainingTasks()} '),
          Expanded(child:
          ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, index) {
                final task = tasks[index];
                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.title, style: TextStyle(fontSize: 20),),
                      Row(children: [ Text('Длительность: ${task.duration
                          .toString()} '), Text(' Приоритет: ${task.priority
                          .toString()}')
                      ])
                    ],
                  ),
                  trailing: Icon(
                      task.isDone ? Icons.check_circle : Icons.circle_outlined),
                  onTap: () {
                    _controller.toggleTask(task.id);
                    setState(() {});
                  },
                  onLongPress: () {
                    _controller.deleteTask(task.id);
                    setState(() {});
                  },
                );
              }
          ),
          ),
        ]
    );
  } */
