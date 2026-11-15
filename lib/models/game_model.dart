class GameModel {
  int id;
  String name;
  String coverPath;
  String executablePath;
  String arguments;
  int emulatorIndex;

  GameModel({
    this.id = 0,
    required this.name,
    required this.coverPath,
    required this.executablePath,
    this.arguments = '',
    this.emulatorIndex = 0,
  });
}