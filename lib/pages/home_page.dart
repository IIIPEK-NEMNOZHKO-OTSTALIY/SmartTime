import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smarttime2/widgets/home%20page%20widgets/HeroTaskCard.dart';
import 'package:smarttime2/widgets/home%20page%20widgets/taskCard.dart';
import '../features/home/home_controller.dart';
import 'schedule_setup_page.dart';
import '../core/theme/app_theme.dart';
import '../widgets/home page widgets/spaceCard.dart';

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
        leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                _controller.backToSpaces();
                setState(() {});
              },
        ),
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
      ? FloatingActionButton(onPressed: () => addTaskDialog(), child: Icon(Icons.add),)
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
            Text('Добрый день, Макар', style: AppText.title, ), //заглушка для имени
            SizedBox(height: 4,),
            Text('У вас 5 задач сегодня', style: AppText.subtitle,) //заглушка для текста
          ],
        ),),
        HeroTaskCard(title: 'Алгебра', subtitle: 'Начнется через 25 минут', onDone: () {}),
        Padding(padding: EdgeInsets.all(16), child: Card( //ОБЕРУНТО В ПАДДИНГ НА ВРЕМЯ
          child: SizedBox(height: 120, child: Column(children: [
            Text('Дрысясися', style: AppText.title,),
            OutlinedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleSetupPage(allSpaces: _controller.spaces))),
                child: Text('Кнопка для перехода к расписаниям (временно)'))
          ])),
        ),),
        Padding(padding: EdgeInsets.all(16), child: Text('Мои пространства', style: AppText.title,)),
        SpaceAddButton(onTap: () => addSpaceDialog(),),
        buildSpaces()
      ],
    );
  }
  Widget taskScreenBody() {
    final space = _controller.currentSpace!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 12),
          Padding(padding: EdgeInsets.all(16), child: Stack(
            alignment: Alignment.center,
            children: [

              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Text(
                  space.title,
                  style: AppText.title,
                ),
              ),
            ],
          )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: 220,
                child: Image.asset(
                  'assets/images/first.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _controller.progress,
                    minHeight: 12,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
                Text(
                  '${(_controller.progress * 100).round()}%',
                  style: AppText.buttonsWhiteText,
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          buildTasks(),
        ],
      ),
    );
  }

  Widget buildTasks() {
    final tasks = _controller.currentSpace!.tasks;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Мои задачи', style: AppText.title,),
          SizedBox(height: 12),
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
                    color: AppColors.primary,
                    onToggle: () {
                      _controller.toggleTask(task.id);
                      setState(() {});
                    },
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
              color: AppColors.primary,
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
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Новое пространство'),
        content: TextField(
          controller: controllerText,
          decoration: InputDecoration(hintText: 'Название'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Отмена')
          ),
          ElevatedButton(
              onPressed: () {
                _controller.addSpace(controllerText.text);
                Navigator.pop(context);
                setState(() {});
              },
              child: Text('Добавить')
          )
        ],
      ),
    );
  }
  void addTaskDialog() {
    final controllerTitleText = TextEditingController();
    final controllerDurationText = TextEditingController(text: "60");
    final controllerPriorityText = TextEditingController(text: "3");

    DateTime? deadLineDate;
    DateTime? fixedTimeDate;
    bool useDeadline = false;
    bool useFixedTime = false;

    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Новая задача'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Название задачи'),
                    TextField(
                      controller: controllerTitleText,
                      decoration: InputDecoration(hintText: 'Название'),
                    ),
                    SizedBox(height: 20),

                    Text('Длительность задачи'),
                    TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      controller: controllerDurationText,
                      decoration: InputDecoration(hintText: 'Название'),
                    ),
                    SizedBox(height: 20),

                    Text('Приоритет задачи'),
                    TextField(
                      controller: controllerPriorityText,
                      decoration: InputDecoration(hintText: 'Название'),
                    ),
                    SizedBox(height: 20),

                    CheckboxListTile(
                        title: Text('Задать дэдлайн'),
                        value: useDeadline,
                        onChanged: (v) {
                          setDialogState(() {
                            useDeadline = v!;
                            if (useDeadline) {
                              useFixedTime = false;
                              fixedTimeDate = null;
                            } else {
                              deadLineDate = null;
                            }
                          });
                        },
                    ),
                    SizedBox(height: 20),
                    CheckboxListTile(
                      title: Text('Фиксированное время начала'),
                      value: useFixedTime,
                      onChanged: (v) {
                        setDialogState(() {
                          useFixedTime = v!;
                          if (useFixedTime) {
                            useDeadline = false;
                            deadLineDate = null;
                          } else {
                            fixedTimeDate = null;
                          }
                        });
                      },
                    ),
                    SizedBox(height: 20),

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
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text('Отмена')),
                ElevatedButton(onPressed: () {
                  _controller.addTask(
                      controllerTitleText.text,
                      controllerDurationText.text,
                      controllerPriorityText.text,
                      fixedTimeDate,
                      deadLineDate
                  );
                  Navigator.pop(context);
                  setState(() {});
                },
                    child: Text('Добавить'))
              ],
            );
          }
        )
    );
  }
}