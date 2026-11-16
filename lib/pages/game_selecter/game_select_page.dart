import 'dart:io';

import 'package:arcade_calestro_bar/pages/game_selecter/components/cylender_collum.dart';
import 'package:arcade_calestro_bar/pages/game_selecter/components/cylinder_borders_painter.dart';
import 'package:flutter/material.dart';

import 'controllers/game_select_controller.dart';
import '../../models/game_model.dart';

class GameSelectPage extends StatefulWidget {
  final GameSelectController controller;

  const GameSelectPage({super.key, required this.controller});

  @override
  State<GameSelectPage> createState() => _GameSelectPageState();
}

class _GameSelectPageState extends State<GameSelectPage> {
  // Medidas do cilindro (moldura e capas compartilham a mesma caixa)
  static const double _cylinderLeft = 100;
  static const double _rimHeight = 28;
  static const double _curvature = 20;

  @override
  void initState() {
    super.initState();
    if (widget.controller.columns.isEmpty) {
      widget.controller.loadMockGames();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    final double cylinderWidth = screenWidth * 0.35;
    final double cylinderHeight = screenHeight * 0.75;
    final double cylinderTop = screenHeight * 0.15;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [Color(0xFF2A2A2A), Color(0xFF050505)],
          ),
        ),
        child: Stack(
          children: [
            // ---------------------------------------------------------------
            // CILINDRO: moldura metálica + capas dentro da MESMA caixa,
            // assim o centro das capas é sempre o centro do cilindro.
            // ---------------------------------------------------------------
            Positioned(
              top: cylinderTop,
              left: _cylinderLeft,
              width: cylinderWidth *.7,
              height: cylinderHeight,
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: CustomPaint(
                      painter: CylinderBordersPainter(
                        rimHeight: _rimHeight,
                        curvature: _curvature,
                        showSideBorders: true,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      // mantém as capas entre o aro de cima e o de baixo
                      padding: const EdgeInsets.symmetric(
                        vertical: _curvature + _rimHeight * 1.1,
                        horizontal: 6,
                      ),
                      child: ClipRect(
                        child: _buildCylinderContent(cylinderWidth),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ---------------------------------------------------------------
            // PAINEL DIREITO
            // ---------------------------------------------------------------
            Positioned(
              top: screenHeight * 0.2,
              bottom: screenHeight * 0.15,
              left: _cylinderLeft + cylinderWidth,
              right: 0,
              child: AnimatedBuilder(
                animation: widget.controller,
                builder: (context, child) {
                  final c = widget.controller;
                  if (c.columns.isEmpty) return const SizedBox.shrink();

                  final int realColIndex = c.currentColumn % c.columns.length;
                  final col = c.columns[realColIndex];
                  final int safeRow =
                      c.currentRow >= col.length ? col.length - 1 : c.currentRow;

                  return _buildRightPanel(col[safeRow], screenHeight);
                },
              ),
            ),

            // ---------------------------------------------------------------
            // LOGO centralizada acima do cilindro
            // ---------------------------------------------------------------
            Positioned(
              top: -screenHeight * .11,
              left: _cylinderLeft *.25,
              width: cylinderWidth,
              child: Center(
                child: SizedBox(
                  width: cylinderWidth * 0.7,
                  height: size.height * 0.4,
                  child: Image.asset(
                    'assets/logo_small.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Colunas 3D + captura de teclado + PageView invisível (scroll/arrastar)
  Widget _buildCylinderContent(double cylinderWidth) {
    return RawKeyboardListener(
      focusNode: widget.controller.focusNode,
      onKey: widget.controller.handleKeyEvent,
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          final c = widget.controller;

          if (c.columns.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }

          final int totalCols = c.columns.length;

          // A página anima sozinha até a coluna atual. Mudar só a linha
          // (cima/baixo) não altera o destino, então não anima nada.
          return TweenAnimationBuilder<double>(
            tween: Tween<double>(end: c.currentColumn.toDouble()),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            builder: (context, page, _) {
              // distância (sem sinal) de cada coluna até a central
              double distanceTo(int i) {
                double v = (i - page) % totalCols;
                if (v > totalCols / 2) v -= totalCols;
                if (v < -totalCols / 2) v += totalCols;
                return v.abs();
              }

              // quem está mais longe é pintado primeiro; a central fica por cima
              final order = List<int>.generate(totalCols, (i) => i)
                ..sort((a, b) => distanceTo(b).compareTo(distanceTo(a)));

              return Stack(
                alignment: Alignment.center,
                children: [
                  for (final i in order)
                    CylinderColumn(
                      key: ValueKey(i),
                      colIndex: i,
                      controller: c,
                      page: page,
                      screenWidth: cylinderWidth,
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRightPanel(GameModel game, double screenHeight) {
    return Padding(
      padding: const EdgeInsets.only(right: 60.0, left: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: screenHeight * 0.40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade800, width: 8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: Colors.blueAccent,
                  blurRadius: 40,
                  spreadRadius: -10,
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: game.coverPath != 'NO_image' &&
                          File(game.coverPath).existsSync()
                      ? Image.file(File(game.coverPath), fit: BoxFit.cover)
                      : Container(
                          color: Colors.grey[900],
                          child: const Center(
                            child: Icon(
                              Icons.videogame_asset,
                              size: 80,
                              color: Colors.white24,
                            ),
                          ),
                        ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.05),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            game.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Jogadores: 2",
            style: TextStyle(color: Colors.white70, fontSize: 22),
          ),
          const SizedBox(height: 5),
          const Text(
            "Lançamento: 1991 - Capcom",
            style: TextStyle(color: Colors.white70, fontSize: 22),
          ),
          const SizedBox(height: 5),
          const Text(
            "Gênero: Luta",
            style: TextStyle(
              color: Colors.orangeAccent,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}