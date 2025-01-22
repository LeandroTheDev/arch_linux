import 'dart:io';
import 'dart:ui';

import 'package:lmount/utils/string.dart';

class SystemDirectory {
  static Future<String> getHomeDirectory() async {
    final process = await Process.run('whoami', []);
    if (process.exitCode != 0) throw Exception("Cannot execute the process 'whoami': ${process.stderr}");

    final user = process.stdout.toString().trim();

    final homeDirectory = '/home/$user';

    final dir = Directory(homeDirectory);
    if (!dir.existsSync()) throw Exception("$homeDirectory does not exist");

    return homeDirectory;
  }

  static Future<String> getExecutableDirectory() async {
    String currentPath = Directory.current.path;

    final lmountPath = "$currentPath/lmount";

    final file = File(lmountPath);
    if (!await file.exists()) throw Exception("Current path is not the correct path for lmount, are you using the wrong working directory?");

    return currentPath;
  }
}

class SystemColors {
  //#region Calculations
  static late final String kdeColors;

  static Future loadSystemColors() async {
    final String homeDirectory = await SystemDirectory.getHomeDirectory();
    final File globalsFile = File("$homeDirectory/.config/kdeglobals");

    if (!await globalsFile.exists()) throw Exception("Cannot load system colors, because kdeglobals does not exist");

    kdeColors = await globalsFile.readAsString();
  }

  static Color _parseColor(String colorValue) {
    final rgb = colorValue.split(',').map((e) => int.parse(e.trim())).toList();
    if (rgb.length != 3) {
      throw Exception("Invalid color format: $colorValue");
    }
    // Aqui o valor da cor é retornado (exemplo: 0xFFRRGGBB)
    final int colorInt = (255 << 24) | (rgb[0] << 16) | (rgb[1] << 8) | rgb[2];
    return Color(colorInt);
  }

  static Color _getColorBlock(String block, String value) {
    final blockValues = StringUtils.extractBlock(kdeColors, block);

    if (blockValues.isEmpty) throw Exception("Cannot read specific color $_getColorBlock, the block value for it is empty");

    final lines = blockValues.split('\n');
    for (var line in lines) {
      if (line.startsWith(value)) {
        final colorValue = line.split('=').last.trim();
        return _parseColor(colorValue);
      }
    }

    throw Exception("No colors was found in the block: $block with the value: $value");
  }
  //#endregion

  //#region Colors
  static Color getBackgroundColor() => _getColorBlock('[Colors:Window]', 'BackgroundNormal');
  //#endregion
}
