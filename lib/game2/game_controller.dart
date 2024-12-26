import 'package:flip_card/flip_card_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memoriz/game1/card_item.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class GameController extends GetxController {
  List<String> arr = List.generate(18, (index) {
    var val = index % 9 + 1;
    return 'assets/item$val.jpg';
  });

  var isMoving = false;
  var finished = false.obs;
  List<bool> isDone = [];
  List<FlipCardController> controllers = [];
  List<Widget> allCards = [];
  var selected1 = 99;
  var selected2 = 99;
  var timeElapsed = 0.obs;
  var minTime = double.infinity.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Timer? _timer;
  var elapsedTime = 0.obs;
  var isScreenActive = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeGame();
  }

  void _initializeGame() {
    isDone = List.generate(18, (index) => false);
    controllers = List.generate(18, (index) => FlipCardController());
    arr.shuffle();
    allCards = List.generate(18, (index) {
      return InkWell(
        onTap: () async {
          if (!isDone[index] && !isMoving) {
            if (selected1 == 99 && selected2 == 99) {
              selected1 = index;
              controllers[index].toggleCard();
            } else if (index != selected1 && selected2 == 99) {
              selected2 = index;
              controllers[index].toggleCard();
              isMoving = true;
              await Future.delayed(const Duration(milliseconds: 1000));
              isMoving = false;
              if (arr[selected1] != arr[selected2]) {
                controllers[selected1].toggleCard();
                controllers[selected2].toggleCard();
              } else {
                isDone[selected1] = true;
                isDone[selected2] = true;
                if (isDone.every((element) => element)) {
                  finished.value = true;
                  _stopTimer();
                  await _updateMinTime();
                }
              }
              selected1 = 99;
              selected2 = 99;
            }
          }
        },
        child: CardItem(
          controller: controllers[index],
          imagePath: arr[index],
        ),
      );
    });

    Future.delayed(Duration(seconds: 1), () async {
      for (var controller in controllers) {
        controller.toggleCard();
      }
      await Future.delayed(Duration(seconds: 5));
      for (var controller in controllers) {
        if (controller.state?.isFront == false) {
          controller.toggleCard();
        }
      }
      await Future.delayed(Duration(milliseconds: 500));
      elapsedTime.value = 0;
      if (isScreenActive.value) {
        _startTimer();
      }
    });
    update();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      elapsedTime.value++;
      timeElapsed.value = elapsedTime.value;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  Future<void> _updateMinTime() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot snapshot =
            await _firestore.collection('account').doc(user.uid).get();
        if (!snapshot.exists) {
          print("Документ не найден для пользователя ${user.uid}");
          return;
        }
        var userData = snapshot.data() as Map<String, dynamic>;

        int minTime = userData['minTime'] ?? 1000;
        if (timeElapsed.value < minTime) {
          print(
              "Обновление минимального времени на ${timeElapsed.value} секунд");
          await _firestore.collection('account').doc(user.uid).update({
            'minTime': timeElapsed.value,
          });
        }
      } catch (e) {
        print("Ошибка при обновлении данных Firestore: $e");
      }
    }
  }

  void resetGame() {
    finished.value = false;
    timeElapsed.value = 0;
    elapsedTime.value = 0;
    selected1 = 99;
    selected2 = 99;
    isMoving = false;

    for (int i = 0; i < isDone.length; i++) {
      isDone[i] = false;
    }

    for (var controller in controllers) {
      if (controller.state?.isFront == false) {
        controller.toggleCard();
      }
    }

    _initializeGame();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    elapsedTime.value = 0;
    finished.value = false;
    selected1 = 99;
    selected2 = 99;
    allCards = [];
    isScreenActive.value = false;
  }

  void setScreenActive(bool value) {
    isScreenActive.value = value;
  }
}
