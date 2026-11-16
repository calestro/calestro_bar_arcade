import 'package:arcade_calestro_bar/config.dart';
import 'package:arcade_calestro_bar/enums/game_emulator.dart';
import 'package:flutter/material.dart';

class GameModel {
  int id;
  String name;
  String coverPath;
  String executablePath;
  String romOrProfile;
  String arguments;
  int emulatorIndex;

  GameModel({
    this.id = 0,
    required this.name,
    required this.coverPath,
    required this.executablePath,
    this.romOrProfile = '', 
    this.arguments = '',
    this.emulatorIndex = 0,
  });

  List<String> get extraArgs {
    if (arguments.trim().isEmpty) return [];
    return arguments.trim().split(RegExp(r'\s+'));
  }


  String  getCoverPath () {
    debugPrint('${Config().rootPath}\\media\\$coverPath');
   return '${Config().rootPath}\\media\\$coverPath';
  }


  factory GameModel.teknoParrot({
    required int id,
    required String name,
    required String coverPath,
    required String romOrProfile,
  }){

    return GameModel(
      id: id,
      name: name,
      coverPath: coverPath,
      executablePath: Config.teknoparrotPath,
      romOrProfile: romOrProfile,
      emulatorIndex: GameEmulator.teknoparrot.index,
    );


  }


}