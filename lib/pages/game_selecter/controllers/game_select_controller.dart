import 'package:arcade_calestro_bar/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/game_model.dart';
import '../../../enums/game_emulator.dart';

class GameSelectController extends ChangeNotifier {
  final FocusNode focusNode = FocusNode();

  List<List<GameModel>> columns = [];
  int currentColumn = 10000;
  int currentRow = 0;
  final int rowsPerColumn = 3;

  GameSelectController() {
    loadMockGames();
  }

  void loadMockGames() {
    initGames(Config.games);
  }

  void initGames(List<GameModel> allGames) {
    columns.clear();
    for (var i = 0; i < allGames.length; i += rowsPerColumn) {
      columns.add(allGames.sublist(
        i,
        i + rowsPerColumn > allGames.length ? allGames.length : i + rowsPerColumn,
      ));
    }
    notifyListeners();
    focusNode.requestFocus();
  }

  void handleKeyEvent(RawKeyEvent event) {
    if (event is! RawKeyDownEvent) return;
    if (columns.isEmpty) return;

    final int totalColumns = columns.length;
    final int realColIndex = currentColumn % totalColumns;

    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      currentColumn++;
      _adjustRow();
      notifyListeners();
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      currentColumn--;
      _adjustRow();
      notifyListeners();
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (currentRow < columns[realColIndex].length - 1) {
        currentRow++;
        notifyListeners();
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (currentRow > 0) {
        currentRow--;
        notifyListeners();
      }
    } else if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      _launchSelectedGame();
    }
  }

  void _adjustRow() {
    final int realCol = currentColumn % columns.length;
    if (currentRow >= columns[realCol].length) {
      currentRow = columns[realCol].length - 1;
    }
  }

  void _launchSelectedGame() {
    final int realCol = currentColumn % columns.length;
    final selectedGame = columns[realCol][currentRow];
    debugPrint("A iniciar o jogo: ${selectedGame.name}");
    GameEmulator.values[selectedGame.emulatorIndex].initGame(selectedGame);
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
}