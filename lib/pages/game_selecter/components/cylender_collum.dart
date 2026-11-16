import 'dart:math' as math;
import 'package:arcade_calestro_bar/pages/game_selecter/components/game_cover.dart';
import 'package:arcade_calestro_bar/pages/game_selecter/controllers/game_select_controller.dart';
import 'package:flutter/material.dart';

class CylinderColumn extends StatelessWidget {
  final int colIndex;
  final GameSelectController controller;

  const CylinderColumn({
    super.key,
    required this.colIndex,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.pageController,
      builder: (context, child) {
        final int totalColumns = controller.columns.length;
        if (totalColumns == 0) return const SizedBox.shrink();

        final int realColIndex = colIndex % totalColumns;

        double page = controller.currentColumn.toDouble();
        if (controller.pageController.hasClients && controller.pageController.position.haveDimensions) {
          page = controller.pageController.page ?? page;
        }

        double value = (page - colIndex) % totalColumns;
        final double half = totalColumns / 2;
        
        if (value > half) {
          value -= totalColumns;
        } else if (value < -half) {
          value += totalColumns;
        }

        final double angle = value * -0.4; 
        final double radius = 365.0; 

        final Matrix4 transform = Matrix4.identity()
          ..setEntry(3, 2, 0.0015)
          ..translate(0.0, 0.0, radius) 
          ..rotateY(angle)               
          ..translate(0.0, 0.0, -radius); 

        final bool isCurrentColumn = realColIndex == (controller.currentColumn % totalColumns);
        final double opacity = (1 - value.abs() * 0.35).clamp(0.0, 1.0);

        if (opacity <= 0.0 || value.abs() > 3.0) {
          return const SizedBox.shrink();
        }

        return Transform(
          transform: transform,
          alignment: FractionalOffset.center,
          child: Opacity(
            opacity: opacity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                controller.columns[realColIndex].length,
                (rowIndex) {
                  final game = controller.columns[realColIndex][rowIndex];
                  
                  final int safeRow = controller.currentRow < controller.columns[realColIndex].length 
                      ? controller.currentRow 
                      : controller.columns[realColIndex].length - 1;

                  final bool isSelected = isCurrentColumn && rowIndex == safeRow;

                  return GameCover(
                    game: game,
                    isSelected: isSelected,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}