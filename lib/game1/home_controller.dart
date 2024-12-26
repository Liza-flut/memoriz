import 'package:flip_card/flip_card_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memoriz/game1/card_item.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
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
  var turns = 0.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
              turns.value++;
            } else if (index != selected1 && selected2 == 99) {
              selected2 = index;
              controllers[index].toggleCard();
              isMoving = true;
              turns.value++;
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
                  await _updateMinTurns();
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
    update();
  }

  Future<void> _updateMinTurns() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('account').doc(user.uid).get();
      var userData = snapshot.data() as Map<String, dynamic>;

      int minTurns = userData['minTurns'] ?? 1000;
      if (turns.value < minTurns) {
        await _firestore.collection('account').doc(user.uid).update({
          'minTurns': turns.value,
        });
      }
    }
  }

  void resetGame() {
    finished.value = false;
    turns.value = 0;
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
    turns.value = 0;
    finished.value = false;
    selected1 = 99;
    selected2 = 99;
    allCards = [];
  }
}
