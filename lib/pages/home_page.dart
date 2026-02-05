import 'package:flutter/material.dart';
import 'package:smarttime2/core/models/task.dart';
import 'package:smarttime2/widgets/home%20page%20widgets/HeroTaskCard.dart';
import 'package:smarttime2/widgets/home%20page%20widgets/taskCard.dart';
import '../features/home/home_controller.dart';
import 'schedule_setup_page.dart';
import '../core/theme/app_theme.dart';
import '../widgets/home page widgets/spaceCard.dart';
import '../widgets/timeWidgets.dart';

enum TaskTimeMode {none, deadline, fixed}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _controller;


  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _controller.init().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: _controller.mode == HomeMode.tasks
      ? AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_sharp),
              onPressed: () {
                _controller.backToSpaces();
                setState(() {});
              },
        ),
        centerTitle: true,
        title: Text(_controller.currentSpace!.title, style: AppText.title,),
        actions: [IconButton(icon: Icon(Icons.filter_alt_rounded), onPressed: () {
            _controller.toggleFilter();
            setState(() {});
            },)
        ]
      )
      : null,
      body: _controller.mode == HomeMode.spaces
        ? homeBody()
        : taskScreenBody(),
      floatingActionButton: _controller.mode == HomeMode.tasks
      ? FloatingActionButton(onPressed: () => addTaskDialog(), shape: CircleBorder(), backgroundColor: _controller.currentSpace!.color, child: Icon(Icons.add, color: AppColors.card,),)
      : null
    );
  }
  Widget homeBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 64,),
        Padding(padding: EdgeInsets.all(16), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Добрый день, Макар', style: AppText.hugeTitle, ), //заглушка для имени
            SizedBox(height: 4,),
            Text('У вас 5 задач сегодня', style: AppText.subtitle,) //заглушка для текста
          ],
        ),),
        HeroTaskCard(title: 'Алгебра', subtitle: 'Начнется через 25 минут', onDone: () {}, color: AppColors.primary),
        GoToScheduleButton(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleSetupPage(allSpaces: _controller.spaces))),
        ),
        Padding(padding: EdgeInsets.all(16), child: Text('Мои пространства', style: AppText.title,)),
        SpaceAddButton(onTap: () => addSpaceDialog()),
        buildSpaces()
      ],
    );
  }
  Widget taskScreenBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.background
          ),
          height: 120,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset('assets/images/first.png', fit: BoxFit.cover),
          )

          ),
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 32, vertical: 6,), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 6,),
          Row(
            children: [
              Text('Мои задачи', style: AppText.title,),
              SizedBox(width: 100,),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${_controller.currentSpace!.tasks.length - _controller.remainingTasks()} / ${_controller.currentSpace!.tasks.length} выполнено', style: AppText.subtitle,),
                  Row(
                    children: [
                      Expanded(child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: LinearProgressIndicator(
                          value: _controller.progress(),
                          minHeight: 5,
                          backgroundColor: AppColors.background.withValues(),
                          valueColor: AlwaysStoppedAnimation(
                            _controller.currentSpace!.color,
                          ),
                        ),
                      ),),
                      Text('${(_controller.progress()*100).round()}%', style: AppText.subtitle,),
                    ],
                  ),
                ],
              ))
            ],
          ),

        ],),),

        SizedBox(height: 12),
        Expanded(child: ListView(
        children: [
          buildTasks()
        ],
      ))],
    );
  }

  Widget buildTasks() {
    final tasks = _controller.currentSpace!.tasks;
    Color color = _controller.currentSpace!.color;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            itemBuilder: (_, index) {
              final task = tasks[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 12),

                child: Card(
                  child: TaskCard(
                    title: task.title,
                    timeText: '${task.duration} мин',
                    isDone: task.isDone,
                    color: color,
                    onTap: () {
                      _controller.toggleTask(task.id);
                      setState(() {});
                    },
                    onLongPress: () {
                      _controller.deleteTask(task.id);
                      setState(() {});
                    }
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  Widget buildSpaces() {
    return Expanded(child: ListView.builder(
        itemCount: _controller.spaces.length,
        itemBuilder: (_, index) {
          final space = _controller.spaces[index];
          return SpaceCard(
              title: space.title,
              totalTasks: space.tasks.length,
              completedTasks: space.tasks.where((t) => t.isDone).length,
              color: space.color,
              onTap: () {
                _controller.openSpace(space.id);
                setState(() {});
              },
              onLongPress: () {
                _controller.deleteSpace(space.id);
                setState(() {});
              });
        })
    );
  }

  void addSpaceDialog() {
    final controllerText = TextEditingController();
    Color selectedColor = AppColors.primary;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.background,
            title: Text('Новое пространство', style: AppText.title,),
            content: SizedBox(
              height: 250,
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 6,),
                  Text('Название:', style: AppText.cardTtle,),
                  SizedBox(height: 12,),
                  iosTextField(controller: controllerText, hint: 'Название'),
                  SizedBox(height: 12,),
                  Text('Цвет:', style: AppText.cardTtle,),
                  SizedBox(height: 12,),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: AppColors.colors.map((color) {
                      final isSelected = color == selectedColor;
                      return GestureDetector(
                        onTap: () => {setDialogState(() => selectedColor = color)},
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                color,
                                color.withAlpha(-50),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(8),
                                blurRadius: 8,
                              ),
                            ],
                            border: isSelected
                                ? Border.all(color: AppColors.background, width: 2)
                                : null,
                          ),
                          child: isSelected
                              ? Icon(Icons.check,
                              color: color!=AppColors.transp
                                  ? Colors.white
                                  : Colors.grey
                          )
                              : null,
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Отмена', style: AppText.subtitle,)
              ),
              ElevatedButton(
                  onPressed: () {
                    _controller.addSpace(controllerText.text, selectedColor);
                    Navigator.pop(context);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonGradientColor
                  ),
                  child: Text('Добавить', style: TextStyle(color: AppColors.card, fontSize: 14),)
              )
            ],
          );
        },
      )
    );
  }

  DateTime? deadLineDate;
  final fixedtimeHourController = TextEditingController();
  final fixedtimeMinutesController = TextEditingController();


  final deadlineHourController = TextEditingController();
  final deadlineMinutesController = TextEditingController();

  final dateController = TextEditingController(text: 'Дата');

  void addTaskDialog() {

    final controllerTitleText = TextEditingController();
    final controllerPriorityText = TextEditingController(text: "3");

    final durationHoursController = TextEditingController();
    final durationMinutesController = TextEditingController();

    DateTime? fixedTimeDate;
    TaskTimeMode tasktimeMode = TaskTimeMode.none;

    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
          builder: (context, setDialogState) {

            return AlertDialog(
              backgroundColor: AppColors.background,
              title: Text('Новая задача', style: AppText.title,),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 6, width: double.infinity,),
                    Text('Параметры задачи:', style: AppText.mediumtitle,),
                    SizedBox(height: 12),
                    iosTextField(
                      controller: controllerTitleText,
                      hint: 'Название'
                    ),
                    SizedBox(height: 20),
                    iosForTimeContainer(children: [Row(
                      children: [
                        Text('Длительность: ', style: AppText.cardTtle,),
                        Expanded(child: Container(),),
                        TimeCodeInput(hour: durationHoursController, minute: durationMinutesController,)
                      ],
                    )]),
                    SizedBox(height: 20),
                    iosForTimeContainer(children: [Row(
                      children: [
                        Text('Приоритет: ', style: AppText.cardTtle,),
                        Expanded(child: Container(),),
                        PriorityInput(priority: controllerPriorityText,)
                      ],
                    )]),
                    SizedBox(height: 20),
                    Text('Дополнительные парамеры:', style: AppText.mediumtitle,),
                    SizedBox(height: 8,),
                    Row(children: [
                      SizedBox(width: 12,),
                      GestureDetector(
                        onTap: () => setDialogState(() => tasktimeMode = TaskTimeMode.none),
                        child: Column( children: [Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: tasktimeMode == TaskTimeMode.none ? AppColors.primary : AppColors.background,
                            border: Border.all(color: AppColors.card),
                            borderRadius: BorderRadius.circular(16)
                          ),
                          child: Icon(Icons.not_interested, color: tasktimeMode == TaskTimeMode.none ? AppColors.card : Colors.grey.shade400,),
                        ),
                        Text('нет', style: TextStyle(fontFamily: 'Inter', color: tasktimeMode == TaskTimeMode.none ? AppColors.textPrimary : AppColors.textSecondary, fontWeight: FontWeight.w500),),
                      ]),),
                      Expanded(child: Container()),
                      GestureDetector(
                          onTap: () => setDialogState(() => tasktimeMode = TaskTimeMode.deadline),
                          child: Column( children: [
                            Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: tasktimeMode == TaskTimeMode.deadline ? AppColors.primary : AppColors.background,
                                border: Border.all(color: AppColors.card),
                                borderRadius: BorderRadius.circular(16)
                            ),
                            child: Icon(Icons.priority_high, color: tasktimeMode == TaskTimeMode.deadline ? AppColors.card : Colors.grey.shade400,),
                          ),
                          Text('дедлайн', style: TextStyle(fontFamily: 'Inter', color: tasktimeMode == TaskTimeMode.deadline ? AppColors.textPrimary : AppColors.textSecondary, fontWeight: FontWeight.w500),),
                        ])
                      ),
                      Expanded(child: Container()),
                      GestureDetector(
                          onTap: () => setDialogState(() => tasktimeMode = TaskTimeMode.fixed),
                          child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: tasktimeMode == TaskTimeMode.fixed ? AppColors.primary : AppColors.background,
                                      border: Border.all(color: AppColors.card),
                                      borderRadius: BorderRadius.circular(16)
                                  ),
                                  child: Icon(Icons.lock_clock, color: tasktimeMode == TaskTimeMode.fixed ? AppColors.card : Colors.grey.shade400,),
                                ),
                                Text('фикс время', style: TextStyle(fontFamily: 'Inter', color: tasktimeMode == TaskTimeMode.fixed ? AppColors.textPrimary : AppColors.textSecondary, fontWeight: FontWeight.w500),),
                      ]),),
                      SizedBox(width: 12,),
                    ],),
                    SizedBox(height: 4,),
                    if (tasktimeMode == TaskTimeMode.deadline )
                      DeadlineEditor()
                    else
                      FixedtimeEditor(),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text('Отмена', style: AppText.subtitle,)),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonGradientColor
                    ),
                    onPressed: () {
                      DateTime? deadline;
                      DateTime? fixed;

                      if (tasktimeMode == TaskTimeMode.deadline) {
                        deadline = DateTime(
                            deadLineDate!.year,
                            deadLineDate!.month,
                            deadLineDate!.day,
                            int.parse(deadlineHourController.text),
                            int.parse(deadlineMinutesController.text)
                        );
                      }
                      else if (tasktimeMode == TaskTimeMode.fixed) {
                        fixed = DateTime(
                            fixedTimeDate!.year,
                            fixedTimeDate!.month,
                            fixedTimeDate!.day,
                            int.parse(fixedtimeHourController.text),
                            int.parse(fixedtimeMinutesController.text)
                        );
                      }
                      _controller.addTask(
                          controllerTitleText.text,
                          (int.parse(durationHoursController.text)*60+int.parse(durationMinutesController.text)).toString(),
                          controllerPriorityText.text,
                          fixed,
                          deadline
                      );
                      Navigator.pop(context);
                      setState(() {});
                    },

                    child: Text('Добавить',style: TextStyle(color: AppColors.card, fontSize: 14),),)
              ],
            );
          }
        )
    );
  }
  Widget DeadlineEditor() {
    return Column(children: [
      SizedBox(height: 20,),
      iosForTimeContainer(children: [Row(
        children: [
          Text('Время:', style: AppText.cardTtle,),
          Expanded(child: Container(),),
          TimeCodeInput(hour: deadlineHourController, minute: deadlineMinutesController)
        ],
      )]),
      SizedBox(height: 20,),
      iosForTimeContainer(children: [Row(
        children: [
          Text('Дата:', style: AppText.cardTtle,),
          Expanded(child: Container()),
          Container(width: 100, child: ListTile(
            title: Text(dateController.text),
            onTap: () async {
            final DateTime? date = await showDatePicker(
              context: context,
              confirmText: 'Применить',
              cancelText: 'Отменить',
              helpText: 'Выберите дату',
              initialDate: DateTime.now(),
              firstDate: DateTime(2025),
              lastDate: DateTime(2100),
            );
            if (date == null) return;
            deadLineDate = date;
          },))
        ],
      )],)
    ],);
  }
  Widget FixedtimeEditor() {
    return Text('фиксированное время'); //пока ничего
  }

}

/*

                    if (useFixedTime)
                      ListTile(
                        title: Text(
                          fixedTimeDate == null
                              ? 'Выбрать дату и время'
                              : fixedTimeDate.toString(),
                        ),
                        trailing: Icon(Icons.schedule),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (date == null) return;

                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time == null) return;

                          setDialogState(() {
                            fixedTimeDate = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        },
                      ),
                    if (useDeadline)
                      ListTile(
                        title: Text(
                          deadLineDate == null
                              ? 'Выбрать дату'
                              : 'Дедлайн: ${deadLineDate!.toLocal()}'.split(' ')[0],
                        ),
                        trailing: Icon(Icons.calendar_today),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setDialogState(() => deadLineDate = date);
                          }
                        },
                      ),
 */