import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/services.dart';
import '../core/models/space.dart';
import '../core/models/schedule/schedule_parameters.dart';
import '../features/schedule/schedule_setup_controller.dart';
import 'schedule_page.dart';
import '../core/theme/app_theme.dart';
import '../widgets/home page widgets/spaceCard.dart';

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

  TextEditingController dayStartTimeController = TextEditingController();
  TextEditingController dayEndTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    DensityMode densityMode = DensityMode.balanced;
    PriorityMode priorityMode = PriorityMode.on;

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
        title: Text('Параметры', style: AppText.title,),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12,),
            Text('Настройки дня', style: AppText.mediumtitle,),
            SizedBox(height: 6,),
            iosTextField(
              keyboardType: TextInputType.number,
              //inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,],
              controller: dayStartTimeController,
              hint: 'Время начала рабочего дня'
            ),
            SizedBox(height: 20,),
            iosTextField(
              keyboardType: TextInputType.number,
              //inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,],
              controller: dayEndTimeController,
              hint: 'Время окончания рабочего дня'
            ),
            SizedBox(height: 40,),
            Text('Параметры генерации', style: AppText.mediumtitle,),
            Row(children: [Text('Плотность расписания:'),
            DropdownButton<DensityMode>(
              value: densityMode,
              items: DensityMode.values.map((mode) {
                return DropdownMenuItem(value: mode, child: Text(mode.name));
              }).toList(),
              onChanged: (v) => setState(() {
               densityMode = v!;
              }),
            )]),
            SizedBox(height: 20,),
            Row(children: [Text('Учитывать приоритет:'),
            DropdownButton<PriorityMode>(
              value: priorityMode,
              items: PriorityMode.values.map((mode) {
                return DropdownMenuItem(value: mode, child: Text(mode.name));
              }).toList(),
              onChanged: (v) => setState(() {
                priorityMode = v!;
              }),
            )]),
            Expanded(
                child: ListView.builder(
                    itemCount: _controller.allSpaces.length,
                    itemBuilder: (_, index) {
                      final space = _controller.allSpaces[index];
                      return CheckboxListTile(
                        title: Text(space.title),
                          value: _controller.isSelected(space.id),
                          onChanged: (_) {
                            setState(() {
                              _controller.toggleSpace(space.id);
                            });
                          }
                      );
                })
            ),
            ElevatedButton(
                onPressed: () {
                  final params = ScheduleParameters(
                      selectedSpacesIds: _controller.selectedSpacesIds,
                      densityMode: densityMode,
                      priorityMode: priorityMode,
                      dayStartTime: int.parse(dayStartTimeController.text),
                      dayEndTime: int.parse(dayEndTimeController.text)
                  );
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SchedulePage(spaces: _controller.selectedSpaces, parameters: params)));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonGradientColor
                ),
                child: Text('Сохранить', style: TextStyle(color: AppColors.card, fontSize: 14),)
            ),
          ],
        )
      ),
    );
  }
}