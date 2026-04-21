import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import '../core/models/space.dart';
import '../core/models/schedule/schedule_parameters.dart';
import '../features/schedule/schedule_setup_controller.dart';
import 'schedule_page.dart';
import '../core/theme/app_theme.dart';
import '../widgets/home page widgets/spaceCard.dart';
import '../widgets/scheduleCard.dart';

class ScheduleSetupPage extends StatefulWidget {
  final List<Space> allSpaces;
  ScheduleParameters savedParams;
  bool isFirstTimeOpen;
  ScheduleSetupPage({Key? key, required this.allSpaces, required this.savedParams, this.isFirstTimeOpen = true}) : super(key: key);

  @override
  State<ScheduleSetupPage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<ScheduleSetupPage> {
  late final ScheduleSetupController _controller;

  TextEditingController dayStartTimeController = TextEditingController();
  TextEditingController dayEndTimeController = TextEditingController();
  DensityMode densityMode = DensityMode.balanced;
  bool priorityMode = true;
  List<String> firstSelectedSpaces = [];
  @override
  void initState() {
    super.initState();
    _controller = ScheduleSetupController(allSpaces: widget.allSpaces);

    if (widget.savedParams.dayStartTime != 9*60) {
      dayStartTimeController = TextEditingController(text: widget.savedParams.dayStartTime.toString());
      dayEndTimeController = TextEditingController(text: widget.savedParams.dayEndTime.toString());
      densityMode = widget.savedParams.densityMode;
      priorityMode = widget.savedParams.priorityMode;
      _controller.selectedSpacesIds.clear();
      _controller.selectedSpacesIds.addAll(widget.savedParams.selectedSpacesIds);
      firstSelectedSpaces = widget.savedParams.selectedSpacesIds;
      for (String i in firstSelectedSpaces) {
        _controller.toggleSpace(i);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final params = ScheduleParameters(
                selectedSpacesIds: _controller.selectedSpacesIds,
                densityMode: densityMode,
                priorityMode: priorityMode,
                dayStartTime: int.parse(dayStartTimeController.text),
                dayEndTime: int.parse(dayEndTimeController.text)
            );
            Navigator.push(context, MaterialPageRoute(builder: (context) => SchedulePage(spaces: _controller.selectedSpaces, allHomeSpaces: widget.allSpaces, parameters: params)));
          },
          backgroundColor: widget.isFirstTimeOpen == true
          ? AppColors.buttonGradientColor
          : Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), ),
          label: widget.isFirstTimeOpen == true
          ? Text('Сохранить', style: TextStyle(color: AppColors.card, fontSize: 18),)
          : Text('Пересоздать', style: TextStyle(color: AppColors.card, fontSize: 18),)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
              hint: 'Время начала рабочего дня (в мин)'
            ),
            SizedBox(height: 20,),
            iosTextField(
              keyboardType: TextInputType.number,
              //inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,],
              controller: dayEndTimeController,
              hint: 'Время окончания рабочего дня (в мин)'
            ),
            SizedBox(height: 40,),
            Text('Параметры генерации', style: AppText.mediumtitle,),
            SizedBox(height: 6,),
            iosContainer(
              children: [
                Row(children: [
                  Text('Учитывать приоритет', style: AppText.cardTtle,),
                  Expanded(child: SizedBox(
                  )),
                  Switch(
                      value: priorityMode,
                      activeThumbColor: AppColors.primary ,
                      inactiveThumbColor: AppColors.textSecondary,
                      inactiveTrackColor: AppColors.lightGray,
                      onChanged: (v) {
                        setState(() {priorityMode = v;});
                      }),]),
              ]
            ),
            SizedBox(height: 20,),
              iosContainer(children:
              [
              Row(
                children: [
                  Text('День', style: AppText.cardTtle,),
                  Expanded(child: SizedBox()),
                  DropdownButton<DensityMode>(
                    value: densityMode,
                    items: DensityMode.values.map((mode) {
                      return DropdownMenuItem(value: mode, child: Text(mode.label, style: AppText.cardTtle,));
                    }).toList(),
                    dropdownColor: AppColors.card,
                    barrierDismissible: true,
                    onChanged: (v) => setState(() {
                      densityMode = v!;
                    }),
                  ),
                ]
              ),
              ]
            ),
            SizedBox(height: 40,),
            Text('Используемые пространства',style: AppText.mediumtitle,),
            SizedBox(height: 6,),
            Expanded(
                child: ListView.builder(
                    itemCount: _controller.allSpaces.length,
                    itemBuilder: (_, index) {
                      final space = _controller.allSpaces[index];
                      return SpaceListCard(
                        title: space.title,
                        onChanged: (_) {
                          setState(() {
                            _controller.toggleSpace(space.id);
                          });
                        },
                        value: _controller.isSelected(space.id),
                      );
                })
            ),
          ],
        )
      ),
    );

  }
}