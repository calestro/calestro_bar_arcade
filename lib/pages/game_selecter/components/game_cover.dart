import 'dart:io';
import 'package:arcade_calestro_bar/models/game_model.dart';
import 'package:flutter/material.dart';

class GameCover extends StatelessWidget {
  final GameModel game;
  final bool isSelected;

  const GameCover({
    super.key,
    required this.game,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasValidImage =
        game.coverPath != 'NO_image';
    final double screenHeight = MediaQuery.of(context).size.height;

    // REDUZIMOS AS PERCENTAGENS AQUI:
    // A soma (0.26 + 0.13 + 0.13 + margens) agora fica dentro dos 63% disponíveis no centro.
    final double selectedHeight = screenHeight * 0.26;
    final double unselectedHeight = screenHeight * 0.13;

    final double selectedWidth = selectedHeight * 0.75;
    final double unselectedWidth = unselectedHeight * 0.75;
    final double dynamicMargin = screenHeight * 0.008; // Margem reduzida

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      margin: EdgeInsets.symmetric(vertical: dynamicMargin),
      width: isSelected ? selectedWidth : unselectedWidth,
      height: isSelected ? selectedHeight : unselectedHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.orangeAccent : Colors.transparent,
          width: isSelected ? 4 : 0,
        ),
        boxShadow: isSelected
            ? [
                const BoxShadow(
                    color: Colors.orangeAccent,
                    blurRadius: 30,
                    spreadRadius: 5),
                const BoxShadow(
                    color: Colors.redAccent, blurRadius: 40, spreadRadius: 8),
              ]
            : [
                const BoxShadow(
                    color: Colors.black54, blurRadius: 10, spreadRadius: 2),
                const BoxShadow(
                    color: Colors.transparent, blurRadius: 0, spreadRadius: 0),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            hasValidImage
                ? Image.file(File(game.getCoverPath()), fit: BoxFit.cover)
                : Container(
                    color: Colors.grey[900],
                    child: const Icon(Icons.image_not_supported,
                        size: 40, color: Colors.white24),
                  ),
          ],
        ),
      ),
    );
  }
}