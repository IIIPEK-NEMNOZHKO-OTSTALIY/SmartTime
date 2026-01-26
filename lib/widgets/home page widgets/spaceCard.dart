import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SpaceStyle{
  static final addSpaceButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    minimumSize: const Size(double.infinity, 64),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 0,
    side: BorderSide.none,
  );
}
class SpaceAddButton extends StatelessWidget{
  final VoidCallback onTap;

  const SpaceAddButton ({
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: OutlinedButton(
        style: SpaceStyle.addSpaceButton,
        onPressed: () {},
        child: Row(children: [
          Icon(Icons.add, color: AppColors.card, size: 28,),
          Text(' Новое пространство', style: AppText.buttonsWhiteText,)
        ])))
    );
  }
}

class SpaceCard extends StatelessWidget {
  final String title;
  final int totalTasks;
  final int completedTasks;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const SpaceCard({
    super.key,
    required this.title,
    required this.totalTasks,
    required this.completedTasks,
    required this.color,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final percent = totalTasks == 0
        ? 0
        : (completedTasks / totalTasks * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          onTap: onTap,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.mediumtitle,),
              SizedBox(height: 4,),
              Text('$percent% выполнено • $totalTasks задач', style: AppText.subtitle,),
            ],
          ),
          onLongPress: onLongPress,
          trailing: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  color,
                  color.withValues(),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
