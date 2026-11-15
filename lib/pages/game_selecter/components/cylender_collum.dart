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

        final double angle = value * 0.70;
        final double radius = 300.0;

        final Matrix4 transform = Matrix4.identity()
          ..setEntry(3, 2, 0.0015)
          ..rotateY(angle)
          ..translate(0.0, 0.0, -radius * (1 - math.cos(angle).abs()));

        final bool isCurrentColumn = colIndex == (controller.currentColumn % totalColumns);
        final double opacity = (1 - value.abs() * 0.5).clamp(0.0, 1.0);

        if (opacity <= 0.0 || value.abs() > 2.0) {
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
                controller.columns[colIndex].length,
                (rowIndex) {
                  final game = controller.columns[colIndex][rowIndex];
                  final bool isSelected = isCurrentColumn && rowIndex == controller.currentRow;

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