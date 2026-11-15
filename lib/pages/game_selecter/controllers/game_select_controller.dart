import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/game_model.dart';
import '../../../enums/game_emulator.dart';

class GameSelectController extends ChangeNotifier {
  late final PageController pageController;
  final FocusNode focusNode = FocusNode();

  List<List<GameModel>> columns = [];
  int currentColumn = 1000;
  int currentRow = 1; 
  final int rowsPerColumn = 3;


  GameSelectController() {
    pageController = PageController(initialPage: currentColumn, viewportFraction: 0.3);
    loadMockGames(); // Carrega jogos de teste
  }

  void loadMockGames() {
    final mockGames = [
      GameModel(id: 1, name: 'Sega Rally', coverPath: 'NO_image', executablePath: 'C:\\Games\\sega.exe'),
      GameModel(id: 2, name: 'Street Fighter V', coverPath: 'NO_image', executablePath: 'C:\\Games\\sfv.exe'),
      GameModel(id: 3, name: 'The House of the Dead 4', coverPath: 'NO_image', executablePath: 'C:\\Games\\hotd4.exe'),
      GameModel(id: 4, name: 'OutRun 2 SP', coverPath: 'NO_image', executablePath: 'C:\\Games\\outrun.exe'),
      GameModel(id: 5, name: 'Metal Slug 3', coverPath: 'NO_image', executablePath: 'C:\\Games\\mslug3.exe'),
      GameModel(id: 6, name: 'The King of Fighters XIII', coverPath: 'NO_image', executablePath: 'C:\\Games\\kof13.exe'),
      GameModel(id: 7, name: 'Guilty Gear -Strive-', coverPath: 'NO_image', executablePath: 'C:\\Games\\ggst.exe'),
      GameModel(id: 8, name: 'Tekken 7', coverPath: 'NO_image', executablePath: 'C:\\Games\\tekken7.exe'),
      GameModel(id: 9, name: 'Dead or Alive 5', coverPath: 'NO_image', executablePath: 'C:\\Games\\doa5.exe'),
      GameModel(id: 10, name: 'BlazBlue', coverPath: 'NO_image', executablePath: 'C:\\Games\\blazblue.exe'),
      GameModel(id: 11, name: 'Naruto Shippuden 4', coverPath: 'NO_image', executablePath: 'C:\\Games\\naruto.exe'),
      GameModel(id: 12, name: 'Persona 5 Royal', coverPath: 'NO_image', executablePath: 'C:\\Games\\p5r.exe'),
    ];
    initGames(mockGames);
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
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        currentColumn++;
        pageController.animateToPage(
          currentColumn,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        notifyListeners();
      }

      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        currentColumn--;
        pageController.animateToPage(
          currentColumn,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        notifyListeners();
      }
    }
  }

  void _animateToColumn() {
    pageController.animateToPage(
      currentColumn,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    notifyListeners();
  }

  void _launchSelectedGame() {
    final selectedGame = columns[currentColumn][currentRow];
    debugPrint("A iniciar o jogo: ${selectedGame.name}");
  }

  @override
  void dispose() {
    pageController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}