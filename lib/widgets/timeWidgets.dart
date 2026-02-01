import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class TimeCodeInput extends StatelessWidget {
  final TextEditingController hour;
  final TextEditingController minute;

  const TimeCodeInput({super.key, required this.hour, required this.minute});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        box(hour, max: 23),
        const Text(" : ", style: TextStyle(fontSize: 24)),
        box(minute, max: 59),
      ],
    );
  }

  Widget box(TextEditingController c, {required int max}) {
    return SizedBox(
      width: 48,
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        maxLength: 2,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24),
        decoration: const InputDecoration(counterText: ''),
        onChanged: (v) {
          final n = int.tryParse(v);
          if (n != null && n > max) c.text = max.toString();
        },
      ),
    );
  }
}
