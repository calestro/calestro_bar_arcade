




import 'package:arcade_calestro_bar/enums/game_emulator.dart';

class GameModel {
  String name;
  String description;
  String imageUrl;
  String gameUrl;
  GameEmulator emulator;

  GameModel({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.gameUrl,
    required this.emulator,
  });
}