import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'game_controller.dart';
import 'package:memoriz/ui/bottom_navigation_icons.dart';
import 'package:go_router/go_router.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late GameController _controller;
  final int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(GameController(), permanent: true);
    _controller.setScreenActive(true);
    if (!_controller.finished.value) {
      _controller.resetGame();
    }
  }

  @override
  void dispose() {
    _controller.resetGame();
    _controller.setScreenActive(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 50),
              Obx(() {
                return Text(
                  'Время: ${_controller.timeElapsed.value} секунд',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }),
              const SizedBox(height: 50),
              for (int i = 0; i < 6; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int j = 0; j < 3; j++)
                        _controller.allCards[i * 3 + j],
                    ],
                  ),
                ),
            ],
          ),
          Obx(() {
            if (_controller.finished.value) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Молодец!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Вы завершили за ${_controller.timeElapsed.value} секунд.",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _controller.resetGame();
                          context.go('/start');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Вернуться на главную",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          }),
        ],
      ),
      bottomNavigationBar: BottomNavigationIcons(
        currentIndex: _currentIndex,
      ),
    );
  }
}
