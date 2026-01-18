import 'package:flutter/material.dart';
import 'home_controller.dart';

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
      : FloatingActionButton(onPressed: () => addSpaceDialog(), child: Icon(Icons.add)),
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
                title: Text(task.title),
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
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Новая задача'),
          content: TextField(
            controller: controllerTitleText,
            decoration: InputDecoration(hintText: 'Название'),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Отмена')
            ),
            ElevatedButton(
                onPressed: () {
                  _controller.addTask(controllerTitleText.text);
                  Navigator.pop(context);
                  setState(() {});
                },
                child: Text('Добавить')
            )
          ],
        ),
    );
  }
}

