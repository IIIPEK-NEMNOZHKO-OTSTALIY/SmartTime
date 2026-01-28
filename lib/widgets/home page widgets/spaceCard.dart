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
  static const Color color = Color(0xFF3C88EC);

  const SpaceAddButton ({
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 16,),
    child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              color,
              color.withAlpha(150),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

        ),
        child: OutlinedButton(
        style: SpaceStyle.addSpaceButton,
        onPressed: () {
          onTap();

          },
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

class GoToScheduleButton extends StatelessWidget{
  final VoidCallback onTap;
  static const Color color = Color(0xFF3C88EC);

  const GoToScheduleButton ({
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 16,),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: OutlinedButton(
                style: SpaceStyle.addSpaceButton,
                onPressed: () {
                  onTap();

                },
                child: Row(children: [
                  Text('Перейти в расписание ', style: TextStyle(color: AppColors.textSecondary, fontSize: 18, ),),
                  Icon(Icons.arrow_forward_ios_sharp , color: AppColors.textSecondary, size: 16,),
                ])))
    );
  }
}

Widget iosTextField({
  required TextEditingController controller,
  required String hint,
  TextInputType keyboardType = TextInputType.text,
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
    child: Center(
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: AppText.cardTtle,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppText.cardTtle.copyWith(
            color: Colors.grey.shade400,
          ),
          border: InputBorder.none,
          isCollapsed: true,
        ),
      ),
    ),
  );
}