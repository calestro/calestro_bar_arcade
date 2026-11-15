import 'dart:math';
import 'dart:io';

import 'package:arcade_calestro_bar/pages/game_selecter/components/cylender_collum.dart';
import 'package:arcade_calestro_bar/pages/game_selecter/components/game_cover.dart';
import 'package:flutter/material.dart';

import 'controllers/game_select_controller.dart';
import '../../models/game_model.dart';

class GameSelectPage extends StatefulWidget {
  final GameSelectController controller;

  const GameSelectPage({Key? key, required this.controller}) : super(key: key);

  @override
  State<GameSelectPage> createState() => _GameSelectPageState();
}

class _GameSelectPageState extends State<GameSelectPage> {
  @override
  void initState() {
    super.initState();
    if (widget.controller.columns.isEmpty) {
      widget.controller.loadMockGames();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        // Fundo escuro com leve gradiente
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [Color(0xFF2A2A2A), Color(0xFF050505)],
          ),
        ),
        child: Stack(
          children: [
            // 1. TOPO: Logo e Emulador
            Positioned(
              top: screenHeight * 0.04,
              left: 40,
              right: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight * 0.15,
                    child: SizedBox.shrink(), //////////LOGO AQUI
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "EMULADOR",
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "MAME & WINDOWS",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Positioned(
              top: screenHeight * 0.22,
              bottom: screenHeight * 0.15,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  // ESQUERDA: Cilindro 3D
                  Expanded(
                    flex: 1,
                    child: RawKeyboardListener(
                      focusNode: widget.controller.focusNode,
                      onKey: widget.controller.handleKeyEvent,
                      child: AnimatedBuilder(
                        animation: widget.controller,
                        builder: (context, child) {
                          if (widget.controller.columns.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.orange,
                              ),
                            );
                          }
                          return PageView.builder(
                            controller: widget.controller.pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.controller.columns.length,
                            itemBuilder: (context, colIndex) {
                              return CylinderColumn(
                                colIndex: colIndex,
                                controller: widget.controller, // ou a variável que contém seu controller
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: AnimatedBuilder(
                      animation: widget.controller,
                      builder: (context, child) {
                        if (widget.controller.columns.isEmpty)
                          return const SizedBox.shrink();
                        final selectedGame =
                            widget.controller.columns[widget
                                .controller
                                .currentColumn][widget.controller.currentRow];
                        return _buildRightPanel(selectedGame, screenHeight);
                      },
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: screenHeight * 0.12,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  border: Border(
                    top: BorderSide(color: Colors.orangeAccent, width: 3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                   
                   
                  ],
                ),
              ),
            ),
          ],
        ),
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
                ), // Brilho interno simulando tela
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child:
                      game.coverPath != 'NO_image' &&
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
