import 'dart:io';
import 'package:arcade_calestro_bar/models/game_model.dart';
import 'package:path/path.dart' as p;
import 'package:window_manager/legacy.dart';
import 'package:window_manager/window_manager.dart';

enum GameEmulator { windowsNative, mame, teknoparrot }

extension GameEmulatorExtension on GameEmulator {
  Future<void> initGame(GameModel game) async {
    final workingDir = p.dirname(game.executablePath);

    // 1. Escudo ativado: Cobre a tela para esconder o CMD do TeknoParrot
    await windowManager.setAlwaysOnTop(true);

    switch (this) {
      case GameEmulator.windowsNative:
        await Process.start(
          game.executablePath,
          game.extraArgs,
          workingDirectory: workingDir,
          runInShell: false,
          mode: ProcessStartMode.detached,
        );
        break;

      case GameEmulator.mame:
        await Process.start(
          game.executablePath,
          [
            if (game.romOrProfile.isNotEmpty) game.romOrProfile,
            ...game.extraArgs,
          ],
          workingDirectory: workingDir,
          runInShell: false,
          mode: ProcessStartMode.detached,
        );
        break;

      case GameEmulator.teknoparrot:
        await Process.start(
          game.executablePath,
          [
            if (game.romOrProfile.isNotEmpty) '--profile=${game.romOrProfile}',
            '--minimized',
            ...game.extraArgs,
          ],
          workingDirectory: workingDir,
          runInShell: false,
          mode: ProcessStartMode.detached,
        );
        break;
    }

    await Future.delayed(const Duration(seconds: 8));

    await windowManager.setAlwaysOnTop(false);
 
  }
}