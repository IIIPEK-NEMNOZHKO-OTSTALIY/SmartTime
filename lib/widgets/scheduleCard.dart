import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

Widget iosContainer({
  required List<Widget> children,
}) {
  return Container(
    height: 52,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(10),
          blurRadius: 12,
          offset: Offset(0,4),
        ),
      ],
    ),
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: [
        ...children
      ],
    ),
  );
}

class SpaceListCard extends StatelessWidget {
  final String title;
  final value;
  final onChanged;

  const SpaceListCard({
    super.key,
    required this.title,
    required this.onChanged,
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: CheckboxListTile(
          onChanged: onChanged,
          activeColor: AppColors.primary,
          checkColor: AppColors.card,
          side: BorderSide(
            color: AppColors.textSecondary,
            width: 2
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          value: value,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.cardTtle,),
            ],
          ),
        ),
    );
  }
}


ScheduleTaskCard({
  required isDone,
  required title,
  required duration,
  required timeString,
  required onTap,
}) {
  return IntrinsicHeight(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Card(
        child: Row(
              children: [
                Container(
                  width: 6,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(16),
                    ),
                  ),
                ),
                SizedBox(width: 16,),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text(title, style: AppText.title,),
                    Text(timeString, style: AppText.subtitle,),
                    SizedBox(height: 20,)
                  ],
                )),
                Padding(
                  padding: EdgeInsets.all(16),
                  child:  Icon(isDone? Icons.check_circle : Icons.circle_outlined),
                ),
              ],
        )
      )
    )
  );
}

ScheduleBreakTimeRow({
  required breakTime,
}) {
  return Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Row(
    children: [
      SizedBox(width: 4,),
      Icon(Icons.lock_clock, color: AppColors.textSecondary,),
      Text('Перерыв $breakTime минут', style: AppText.subtitle, )
    ],)
  );
}


