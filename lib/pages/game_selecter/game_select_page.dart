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
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [Color(0xFF2A2A2A), Color(0xFF050505)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: screenHeight * 0.15,
              left: 200,
              right: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: screenHeight * 0.8,
                    width: screenWidth * 0.28,
                    child: CustomPaint(
                      painter: const CylinderBordersPainter(
                        rimHeight: 28,
                        curvature: 20,
                        showSideBorders: true,
                      ),
                    ),
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
                              child: CircularProgressIndicator(color: Colors.orange),
                            );
                          }

                          double page = widget.controller.currentColumn.toDouble();
                          if (widget.controller.pageController.hasClients && 
                              widget.controller.pageController.position.haveDimensions) {
                            page = widget.controller.pageController.page ?? page;
                          }

                          final int totalCols = widget.controller.columns.length;
                          
                          List sortedColumns = List.generate(totalCols, (colIndex) {
                            double value = (page - colIndex) % totalCols;
                            double half = totalCols / 2;
                            if (value > half) {
                              value -= totalCols;
                            } else if (value < -half) {
                              value += totalCols;
                            }
                            
                            return {
                              'distance': value.abs(),
                              'widget': CylinderColumn(
                                colIndex: colIndex,
                                controller: widget.controller,
                              )
                            };
                          });

                          sortedColumns.sort((a, b) => b['distance'].compareTo(a['distance']));

                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned.fill(
                                child: Opacity(
                                  opacity: 0.0,
                                  child: PageView.builder(
                                    controller: widget.controller.pageController,
                                    onPageChanged: widget.controller.updateColumnFromScroll,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) => const SizedBox.shrink(),
                                  ),
                                ),
                              ),
                              ...sortedColumns.map((item) => item['widget'] as Widget),
                            ],
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
                        if (widget.controller.columns.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        final int realColIndex = widget.controller.currentColumn % widget.controller.columns.length;
                        
                        int safeRow = widget.controller.currentRow;
                        if (safeRow >= widget.controller.columns[realColIndex].length) {
                          safeRow = widget.controller.columns[realColIndex].length - 1;
                        }

                        final selectedGame = widget.controller.columns[realColIndex][safeRow];
                        return _buildRightPanel(selectedGame, screenHeight);
                      },
                    ),
                  ),
                ],
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
                BoxShadow(color: Colors.black54, blurRadius: 20, spreadRadius: 5),
                BoxShadow(color: Colors.blueAccent, blurRadius: 40, spreadRadius: -10),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: game.coverPath != 'NO_image' && File(game.coverPath).existsSync()
                      ? Image.file(File(game.coverPath), fit: BoxFit.cover)
                      : Container(
                          color: Colors.grey[900],
                          child: const Center(
                            child: Icon(Icons.videogame_asset, size: 80, color: Colors.white24),
                          ),
                        ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white.withOpacity(0.05), Colors.transparent],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text(game.name, style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          const Text("Jogadores: 2", style: TextStyle(color: Colors.white70, fontSize: 22)),
          const SizedBox(height: 5),
          const Text("Lançamento: 1991 - Capcom", style: TextStyle(color: Colors.white70, fontSize: 22)),
          const SizedBox(height: 5),
          const Text("Gênero: Luta", style: TextStyle(color: Colors.orangeAccent, fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}