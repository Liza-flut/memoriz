import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final String imagePath;
  final FlipCardController controller;

  const CardItem({
    super.key,
    required this.imagePath,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      controller: controller,
      flipOnTouch: false,
      front: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 248, 247, 247),
        ),
        child: Image.asset(
          'assets/icons/pic.png',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      back: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
