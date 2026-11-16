import 'dart:math' as math;
import 'package:arcade_calestro_bar/pages/game_selecter/components/game_cover.dart';
import 'package:arcade_calestro_bar/pages/game_selecter/controllers/game_select_controller.dart';
import 'package:flutter/material.dart';

class CylinderColumn extends StatelessWidget {
  final int colIndex;
  final GameSelectController controller;

  /// Posição animada do cilindro (ex.: 10000.0 → 10001.0 durante a transição)
  final double page;
  final double screenWidth;

  /// Largura de cada coluna (capa + respiro)
  static const double columnWidth = 150;

  /// Quantas colunas aparecem ao redor da central
  static const int visibleSide = 2;

  const CylinderColumn({
    super.key,
    required this.colIndex,
    required this.controller,
    required this.page,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final int totalColumns = controller.columns.length;
    if (totalColumns == 0) return const SizedBox.shrink();

    final int realColIndex = colIndex % totalColumns;

    // distância (com sinal) da coluna até a coluna central
    double value = (colIndex - page) % totalColumns;
    final double half = totalColumns / 2;
    if (value > half) value -= totalColumns;
    if (value < -half) value += totalColumns;

    final double absValue = value.abs();
    if (absValue > visibleSide + 0.5) return const SizedBox.shrink();

    // --- geometria do cilindro ---
    const double stepAngle = 0.55; // rad entre colunas
    final double angle = value * stepAngle;
    final double radius = columnWidth / (2 * math.tan(stepAngle / 2));

    final double dx = radius * math.sin(angle);
    final double dz = radius * (1 - math.cos(angle));

    final Matrix4 transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..translate(dx, 0.0, -dz)
      ..rotateY(-angle);

    final bool isCurrentColumn =
        realColIndex == (controller.currentColumn % totalColumns);

    final double scale = (1 - absValue * 0.12).clamp(0.6, 1.0);
    final double opacity = (1 - absValue * 0.45).clamp(0.0, 1.0);

    final column = controller.columns[realColIndex];
    final int safeRow = controller.currentRow < column.length
        ? controller.currentRow
        : column.length - 1;

    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: SizedBox(
            width: columnWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(column.length, (rowIndex) {
                final bool isSelected = isCurrentColumn && rowIndex == safeRow;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  child: GameCover(
                    game: column[rowIndex],
                    isSelected: isSelected,
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}