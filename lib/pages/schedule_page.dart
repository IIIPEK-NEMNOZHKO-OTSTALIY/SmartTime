import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../features/schedule/schedule_controller.dart';
import '../core/models/space.dart';
import '../core/models/schedule/schedule_parameters.dart';
import '../core/theme/app_theme.dart';
import 'schedule_setup_page.dart';
import '../widgets/scheduleCard.dart';

class SchedulePage extends StatefulWidget {
  final List<Space> spaces;
  final ScheduleParameters parameters;
  const SchedulePage({Key? key, required this.spaces, required this.parameters}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late final ScheduleController _controller;
  late final PageController _weekPageController;

  @override
  void initState() {
    super.initState();
    _weekPageController = PageController(initialPage: 1000);
    _controller = ScheduleController(spaces: widget.spaces, parameters: widget.parameters);
    _controller.init();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final dayTile = _controller.timeline.firstWhereOrNull((t) =>
    t.day.day == _controller.selectedDay.day &&
        t.day.month == _controller.selectedDay.month &&
        t.day.year == _controller.selectedDay.year);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
            centerTitle: true,
            title: Text('Расписание', style: AppText.title,),
            actions: [IconButton(icon: Icon(Icons.settings), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleSetupPage(allSpaces: _controller.spaces)));
              setState(() {});
            },)
            ]
        ),
        body: Center(
          child: Column(
              children: [
                buildWeekPager(),
                dayTile == null
                    ? Padding(padding: EdgeInsets.all(16), child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('На этот день задач нет!', style: AppText.mediumtitle,)
                  ],
                ),)
                    : Expanded(
                      child: ListView.builder(
                        itemCount: dayTile.tasks.length,
                        itemBuilder: (_, index) {
                          final task = dayTile.tasks[index];
                          final taskIsDone = _controller.spaces.expand((space) => space.tasks).firstWhere((s) => s.id == task.taskId).isDone;
                          return Column( children: [
                              ScheduleTaskCard(
                                  isDone: taskIsDone,
                                  title: task.taskTitle,
                                  timeString: '${_controller.formatTime(
                                      task.startTime)} - ${_controller.formatTime(
                                      task.endTime)} (${task.duration
                                      .toString()} минут)',
                                  onTap: () {_controller.toggleTask(task.taskId); setState(() {});} ),
                              if(task.breakAfter > 0)
                                ScheduleBreakTimeRow(breakTime: task.breakAfter)
                          ]
                        );
                      })
                ),
              ],
          ),
        ),
    );
  }
  Widget buildWeekPager() {
    return SizedBox(height: 72, child: PageView.builder(
        controller: _weekPageController,
        onPageChanged: (page) {
          final difference = page - 1000;
          _controller.weekOffset = difference;
          final weekdayIndex = _controller.selectedDay.weekday - 1;
          _controller.selectDay(_controller.getCurrentWeek()[weekdayIndex]);
          setState(() {});
        },
        itemBuilder: (_, __) {
          return buildWeekBar();
        }),);
  }
  Widget buildWeekBar() {
      final days = _controller.getCurrentWeek();
      final weekNames = ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс'];
      return SizedBox(
        height: 72,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(days.length, (index) {
            final day = days[index];
            final isSelected = _controller.selectedDay.day == day.day && _controller.selectedDay.month == day.month;

            return Padding(padding: EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                _controller.selectDay(day);
                setState(() {});
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 48,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Padding(padding: EdgeInsets.all(4),
                        child: Text(
                            day.day.toString(),
                            style: AppText.cardTtle.copyWith(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                      )
                  ),
                  Text(
                      weekNames[index], style: AppText.subtitle),
                ],
              ),
            ),);
          }),
        ),
      );
    }

}