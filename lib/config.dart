



import 'dart:io';

import 'package:arcade_calestro_bar/enums/game_emulator.dart';
import 'package:arcade_calestro_bar/models/game_model.dart';

class Config{


  String get rootPath => File(Platform.resolvedExecutable).parent.path;

  static String teknoparrotPath = 'C:\\Users\\cales\\repo\\arcade_calestro_bar\\build\\windows\\x64\\runner\\Release\\emulators\\teknoparrot\\TeknoParrotUi.exe';
  static List<GameModel> games = [
 
      GameModel(
  id: 2, 
  name: 'Ultra Street Fighter IV', 
  coverPath: 'USF4.jpg', 
  executablePath: 'C:\\Users\\cales\\repo\\arcade_calestro_bar\\build\\windows\\x64\\runner\\Release\\emulators\\teknoparrot\\TeknoParrotUi.exe', 
  romOrProfile: 'UltraStreetFighterIV.xml', 
  emulatorIndex: GameEmulator.teknoparrot.index, 
),
 GameModel(
  id: 3, 
  name: 'Ultra Street Fighter IV', 
  coverPath: 'USF4.jpg', 
  executablePath: 'C:\\Users\\cales\\repo\\arcade_calestro_bar\\build\\windows\\x64\\runner\\Release\\emulators\\teknoparrot\\TeknoParrotUi.exe', 
  romOrProfile: 'UltraStreetFighterIV.xml', 
  emulatorIndex: GameEmulator.teknoparrot.index, 
),
 GameModel(
  id: 4, 
  name: 'Ultra Street Fighter IV', 
  coverPath: 'USF4.jpg', 
  executablePath: 'C:\\Users\\cales\\repo\\arcade_calestro_bar\\build\\windows\\x64\\runner\\Release\\emulators\\teknoparrot\\TeknoParrotUi.exe', 
  romOrProfile: 'UltraStreetFighterIV.xml', 
  emulatorIndex: GameEmulator.teknoparrot.index, 
),

 GameModel(
  id: 5, 
  name: 'Ultra Street Fighter IV', 
  coverPath: 'USF4.jpg', 
  executablePath: 'C:\\Users\\cales\\repo\\arcade_calestro_bar\\build\\windows\\x64\\runner\\Release\\emulators\\teknoparrot\\TeknoParrotUi.exe', 
  romOrProfile: 'UltraStreetFighterIV.xml', 
  emulatorIndex: GameEmulator.teknoparrot.index, 
),
 GameModel(
  id: 6, 
  name: 'Ultra Street Fighter IV', 
  coverPath: 'USF4.jpg', 
  executablePath: 'C:\\Users\\cales\\repo\\arcade_calestro_bar\\build\\windows\\x64\\runner\\Release\\emulators\\teknoparrot\\TeknoParrotUi.exe', 
  romOrProfile: 'UltraStreetFighterIV.xml', 
  emulatorIndex: GameEmulator.teknoparrot.index, 
),
 GameModel(
  id: 7, 
  name: 'Ultra Street Fighter IV', 
  coverPath: 'USF4.jpg', 
  executablePath: 'C:\\Users\\cales\\repo\\arcade_calestro_bar\\build\\windows\\x64\\runner\\Release\\emulators\\teknoparrot\\TeknoParrotUi.exe', 
  romOrProfile: 'UltraStreetFighterIV.xml', 
  emulatorIndex: GameEmulator.teknoparrot.index, 
),

 GameModel(
  id: 8, 
  name: 'Ultra Street Fighter IV', 
  coverPath: 'USF4.jpg', 
  executablePath: 'C:\\Users\\cales\\repo\\arcade_calestro_bar\\build\\windows\\x64\\runner\\Release\\emulators\\teknoparrot\\TeknoParrotUi.exe', 
  romOrProfile: 'UltraStreetFighterIV.xml', 
  emulatorIndex: GameEmulator.teknoparrot.index, 
),

 GameModel(
  id: 9, 
  name: 'Ultra Street Fighter IV', 
  coverPath: 'USF4.jpg', 
  executablePath: 'C:\\Users\\cales\\repo\\arcade_calestro_bar\\build\\windows\\x64\\runner\\Release\\emulators\\teknoparrot\\TeknoParrotUi.exe', 
  romOrProfile: 'UltraStreetFighterIV.xml', 
  emulatorIndex: GameEmulator.teknoparrot.index, 
),
     
  ];


}