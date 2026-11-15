import 'dart:math' as math; // Necessário para o math.cos()
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
        double value = 0.0;
        if (controller.pageController.position.haveDimensions) {
          value = controller.pageController.page! - colIndex;
        } else {
          value = (controller.currentColumn - colIndex).toDouble();
        }

        final double angle = value * 0.70;
        final double radius = 300.0;

        final Matrix4 transform = Matrix4.identity()
          ..setEntry(3, 2, 0.0015)
          ..rotateY(angle)
          ..translate(0.0, 0.0, -radius * (1 - math.cos(angle).abs()));

        final bool isCurrentColumn = colIndex == controller.currentColumn;

        return Transform(
          transform: transform,
          alignment: FractionalOffset.center,
          child: Opacity(
            opacity: (1 - value.abs() * 0.5).clamp(0.2, 1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                controller.columns[colIndex].length,
                (rowIndex) {
                  final game = controller.columns[colIndex][rowIndex];
                  final bool isSelected =
                      isCurrentColumn && rowIndex == controller.currentRow;
                  
                  // Aqui ele chama o widget GameCover que transformamos na pergunta anterior
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