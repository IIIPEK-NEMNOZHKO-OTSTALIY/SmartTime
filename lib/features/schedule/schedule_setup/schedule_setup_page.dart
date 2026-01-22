import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/services.dart';
import '../../../core/models/space.dart';
import '../../../core/models/schedule_parameters.dart';
import 'schedule_setup_controller.dart';

class ScheduleSetupPage extends StatefulWidget {
  final List<Space> allSpaces;
  const ScheduleSetupPage({Key? key, required this.allSpaces}) : super(key: key);

  @override
  State<ScheduleSetupPage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<ScheduleSetupPage> {
  late final ScheduleSetupController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScheduleSetupController(allSpaces: widget.allSpaces);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int dayStartTime;
    TextEditingController _dayStartTimeController = TextEditingController();
    int dayEnsTime;
    TextEditingController _dayEndtTimeController = TextEditingController();
    DensityMode densityMode = DensityMode.balanced;
    PriorityMode priorityMode = PriorityMode.on;

    return Scaffold(
      body: Column(
        children: [
          Text('Время старта рабочего дня (в минутах)', style: TextStyle(fontSize: 20)),
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            controller: _dayStartTimeController,
          ),
          SizedBox(height: 20,),
          Text('Время окончания рабочего дня (в минутах)', style: TextStyle(fontSize: 20),),
          TextField(),

          SizedBox(height: 20,),
          Text('Плотность расписания', style: TextStyle(fontSize: 20),),
          DropdownButton<DensityMode>(
            value: densityMode,
            items: DensityMode.values.map((mode) {
              return DropdownMenuItem(value: mode, child: Text(mode.name));
            }).toList(),
            onChanged: (v) => setState(() {
             densityMode = v!;
            }),
          ),
          SizedBox(height: 20,),
          Text('Учитывать приоритет', style: TextStyle(fontSize: 20),),
          DropdownButton<PriorityMode>(
            value: priorityMode,
            items: PriorityMode.values.map((mode) {
              return DropdownMenuItem(value: mode, child: Text(mode.name));
            }).toList(),
            onChanged: (v) => setState(() {
              priorityMode = v!;
            }),
          ),

          Expanded(
              child: ListView.builder(
                  itemCount: _controller.allSpaces.length,
                  itemBuilder: (_, index) {
                    final space = _controller.allSpaces[index];
                    return CheckboxListTile(
                      title: Text(space.title, style: TextStyle(fontSize: 20),),
                        value: _controller.isSelected(space.id),
                        onChanged: (_) {
                          setState(() {
                            _controller.toggleSpace(space.id);
                          });
                        }
                    );
              })
          ),
          OutlinedButton(onPressed: () {
            final params = ScheduleParameters(
              selectedSpacesIds: _controller.selectedSpacesIds,
              densityMode: densityMode,
              priorityMode: priorityMode,
            );
          }, child:  Text('Продолжить'))
        ],
      ),
    );
  }
}