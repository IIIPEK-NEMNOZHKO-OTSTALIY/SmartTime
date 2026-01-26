import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:smarttime2/pages/home_page.dart';
import '../features/schedule/schedule_controller.dart';
import '../core/models/space.dart';
import '../core/models/schedule/schedule_parameters.dart';

class SchedulePage extends StatefulWidget {
  final List<Space> spaces;
  final ScheduleParameters parameters;
  const SchedulePage({Key? key, required this.spaces, required this.parameters}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late final ScheduleController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScheduleController(spaces: widget.spaces, parameters: widget.parameters);
    _controller.generateSchedule();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final dayTile = _controller.timeline.firstWhereOrNull((t) =>
    t.day.day == _controller.selectedDay.day &&
        t.day.month == _controller.selectedDay.month &&
        t.day.year == _controller.selectedDay.year);
    return Scaffold(
        body: Center(
          child: Column(
              children: [
                SizedBox(height: 200,),
                Row( mainAxisAlignment: MainAxisAlignment.center,children: [
                  OutlinedButton(onPressed: () => {
                    _controller.previousWeek(),
                    setState(() {})
                  }, child: Icon(Icons.chevron_left)),
                  SizedBox(width: 20,),
                  Text('РАСПИСАНИЕ', style: TextStyle(fontSize: 32)),
                  SizedBox(width: 20,),
                  OutlinedButton(onPressed: () => {
                    _controller.nextWeek(),
                    setState(() {})
                    }, child: Icon(Icons.chevron_right)),
                ],
                ),
                SizedBox(height: 40),
                buildWeekBar(),
                Expanded(
                child: dayTile == null
                    ? Text('На этот день задач нет!', style: TextStyle(fontSize: 20),)
                    : ListView.builder(
                      itemCount: dayTile.tasks.length,
                      itemBuilder: (_, index) {
                        final task = dayTile.tasks[index];
                        return Column(
                          children: [
                            ListTile(
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
                              setState(() {_controller.toggleTask(task.taskId);});},
                            ),
                            if(task.breakAfter > 0)
                              Text('Перерыв ${task.breakAfter} минут', style: TextStyle(color: Colors.grey),)
                          ],
                        );
                      })
                ),
              ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())),
          child: Icon(Icons.home_rounded),),
    );
  }
  Widget buildWeekBar() {
    final days = _controller.getCurrentWeek();
    return (
        GestureDetector(
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
                color: _controller.selectedDay.day == day.day
                    ? Colors.grey
                    : null,
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