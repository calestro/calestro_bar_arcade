




import 'package:arcade_calestro_bar/pages/game_selecter/controllers/game_select_controller.dart';
import 'package:arcade_calestro_bar/pages/game_selecter/game_select_page.dart';
import 'package:flutter/material.dart';

void main(){
    runApp(
      MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calestro Emulator',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1A24), // Fundo escuro do bar
      ),
      home:  GameSelectPage(controller: GameSelectController()),
    
    ));
}