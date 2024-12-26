import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_colors.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BottomNavigationIcons extends StatelessWidget {
  final int currentIndex;

  const BottomNavigationIcons({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    int safeIndex = currentIndex.clamp(0, 2);
    return BottomNavigationBar(
      currentIndex: safeIndex,
      onTap: (index) {
        if (index == 0) {
          context.go('/profile');
        } else if (index == 1) {
          context.go('/start');
        } else if (index == 2) {
          context.go('/ranking');
        }
      },
      backgroundColor: AppColors.primary,
      elevation: 0,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.7),
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            MdiIcons.pokeball,
            size: 24,
            color: Colors.white,
          ),
          label: 'Профиль',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            MdiIcons.swordCross,
            size: 24,
            color: Colors.white,
          ),
          label: 'Режимы',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events),
          label: 'Рейтинг',
        ),
      ],
    );
  }
}
