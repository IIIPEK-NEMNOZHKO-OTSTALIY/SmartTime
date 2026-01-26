import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String timeText;
  final bool isDone;
  final Color color;
  final VoidCallback onToggle;

  const TaskCard({
    super.key,
    required this.title,
    required this.timeText,
    required this.isDone,
    required this.color,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(title, style: AppText.mediumtitle),
                            const SizedBox(height: 4),
                            Text(timeText, style: AppText.subtitle,),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isDone
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isDone
                              ? AppColors.accent
                              : AppColors.textSecondary,
                        ),
                        onPressed: onToggle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}