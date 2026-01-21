import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
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
    final dayTile = _controller.timeline.firstWhere((t) =>
    t.day.day == _controller.selectedDay.day &&
        t.day.month == _controller.selectedDay.month &&
        t.day.year == _controller.selectedDay.year);
    return Scaffold(
        body: Center(
          child: Column(
              children: [
                SizedBox(height: 200,),
                Text('РАСПИСАНИЕ', style: TextStyle(fontSize: 32),),
                buildWeekBar(),
                Expanded(child: ListView.builder(
                    itemCount: dayTile.tasks.length,
                    itemBuilder: (_, index) {
                      final task = dayTile.tasks[index];
                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task.taskTitle, style: TextStyle(
                                fontSize: 20),),
                            Text('${_controller.formatTime(
                                task.startTime)} - ${_controller.formatTime(
                                task.endTime)} (${task.duration
                                .toString()} минут) '),
                          ],
                        ),
                        trailing: Icon(task.isDone ? Icons.check_circle : Icons
                            .circle_outlined),
                        onTap: () {
                          setState(() {});
                        },
                      );
                    }
                ),),
              ]
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          child: Icon(Icons.home_rounded),)
    );
  }

  Widget buildWeekBar() {
    final days = _controller.getCurrentWeek();
    return (
        GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            _controller.nextWeek();
          }
          else {
            _controller.previousWeek();
          }
          setState(() {});
        },
        child: SizedBox(height: 80, child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: days.length,
          itemBuilder: (_, index) {
            final day = days[index];
            return GestureDetector(
              onTap: () {
                _controller.selectDay(day);
                setState(() {});
              },
              child: Container(
                width: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(['Пн','Вт','Ср','Чт','Пт','Сб','Вс'][index]),
                    Text(day.day.toString())
                  ],
                ),
              ),
            );
          },),)));
  }
}