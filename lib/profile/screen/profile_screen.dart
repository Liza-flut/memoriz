import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../../ui/bottom_navigation_icons.dart';
import '../../ui/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Профиль',
          style: TextStyle(
            color: AppColors.textOnPrimary,
          ),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.email == null) {
            return const Center(child: Text('Нет данных пользователя'));
          }

          var userData = {
            'email': state.email ?? 'Не указано',
            'avatar': state.avatar ?? '',
            'minTurns': state.minTurns ?? 'Не установлено',
            'minTime': state.minTime ?? 'Не установлено',
          };
          const SizedBox(height: 20);
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: state.avatar?.isNotEmpty ?? false
                          ? NetworkImage(state.avatar!)
                          : const NetworkImage(
                              'https://avatars.mds.yandex.net/i?id=67ab9b97693119cff7dbf5fc7648ed2a_l-12799296-images-thumbs&n=13',
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: const Icon(Icons.edit, color: Colors.white),
                        ),
                        onPressed: () => context.go('/edit-profile'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  userData['email']!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textOnPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          border:
                              Border.all(color: AppColors.primary, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/moves_icon.png',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Мин. ходы: ${userData['minTurns']}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textOnPrimary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          border:
                              Border.all(color: AppColors.primary, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/gotcha.png',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Мин. время: ${userData['minTime']}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textOnPrimary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => context.go('/edit-profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Редактировать профиль',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await context.read<ProfileCubit>().signOut();
                    context.go('/auth');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Выйти',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavigationIcons(currentIndex: 2),
    );
  }
}
