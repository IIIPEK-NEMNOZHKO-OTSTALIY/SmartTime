import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class TimeCodeInput extends StatelessWidget {
  final TextEditingController hour;
  final TextEditingController minute;

  const TimeCodeInput({super.key, required this.hour, required this.minute});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(4), child: Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 4,),
          box(hour, max: 23),
          const Text(" : ", style:  AppText.cardTtle),
          box(minute, max: 59),
          SizedBox(width: 4,),
        ],
      ),
    )
    );
  }

  Widget box(TextEditingController c, {required int max}) {
    return SizedBox(
      width: 24,
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        maxLength: 2,
        textAlign: TextAlign.center,
        style: AppText.cardTtle,
        decoration: InputDecoration(counterText: '', border: InputBorder.none, hintText: '00', hintStyle: AppText.cardTtle.copyWith(color: Colors.grey.shade400)),
        onChanged: (v) {
          final n = int.tryParse(v);
          if (n != null && n > max) c.text = max.toString();
        },
      ),
    );
  }
}
class PriorityInput extends StatelessWidget {
  final TextEditingController priority;
  const PriorityInput({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(4), child: Container(
      decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        children: [
          SizedBox(width: 4,),
          box(priority, max: 10),
          SizedBox(width: 4,)
        ],
      ),
    ),);
  }

  Widget box(TextEditingController c, {required int max}) {
    return SizedBox(
      width: 24,
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        maxLength: 2,
        textAlign: TextAlign.center,
        style: AppText.cardTtle,
        decoration: InputDecoration(counterText: '', border: InputBorder.none, hintText: '0', hintStyle: AppText.cardTtle.copyWith(color: Colors.grey.shade400)),
        onChanged: (v) {
          final n = int.tryParse(v);
          if (n != null && n > max) c.text = max.toString();
        },
      ),
    );
  }
}
