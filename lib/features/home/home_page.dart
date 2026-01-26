import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_controller.dart';
import '../schedule/schedule_setup/schedule_setup_page.dart';

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
      appBar: AppBar(
        title: Text(
          _controller.mode == HomeMode.spaces
              ? 'Пространства'
              : _controller.currentSpace!.title,
        ),
        leading: _controller.mode == HomeMode.tasks
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                _controller.backToSpaces();
                setState(() {});
              },
        )
            : null,
        actions: _controller.mode == HomeMode.tasks
        ? [
          IconButton(icon: Icon(Icons.filter_alt_rounded), onPressed: () {
            _controller.toggleFilter();
            setState(() {});
            },
          )
        ]
          : null,
        ),
      body: _controller.mode == HomeMode.spaces
        ? buildSpaces()
        : buildTasks(),
      floatingActionButton: _controller.mode == HomeMode.tasks
      ? FloatingActionButton(onPressed: () => addTaskDialog(), child: Icon(Icons.add),)
      : Row(mainAxisAlignment: MainAxisAlignment.center, children: [FloatingActionButton(onPressed: () => addSpaceDialog(), child: Icon(Icons.add)),
        FloatingActionButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleSetupPage(allSpaces: _controller.spaces))), child: Icon(Icons.calendar_today_outlined),)
      ],)
    );
  }

  Widget buildSpaces() {
    return ListView.builder(
      itemCount: _controller.spaces.length,
      itemBuilder: (_, index) {
        final space = _controller.spaces[index];
        return ListTile(
          title: Text(space.title),
          onTap: () {
            _controller.openSpace(space.id);
            setState(() {});
          },
          onLongPress: () {
            _controller.deleteSpace(space.id);
            setState(() {});
          },
        );
      }
    );
  }
  Widget buildTasks() {
    final tasks = _controller.currentSpace!.tasks;
    return Column(
      children: [
        Text('Задач всего: ${_controller.currentSpace!.tasks.length} '),
        Text('Выполнено задач: ${_controller.currentSpace!.tasks.length-_controller.remainingTasks()} '),
        Text('Задач оосталось: ${_controller.remainingTasks()} '),
        Expanded(child:
          ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (_, index) {
              final task = tasks[index];
              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(task.title, style: TextStyle(fontSize: 20),), Row( children: [ Text('Длительность: ${task.duration.toString()} '), Text(' Приоритет: ${task.priority.toString()}')])],
                ),
                trailing: Icon(task.isDone ? Icons.check_circle : Icons.circle_outlined),
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