import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:leans_bindings/utils/string.dart';

class LeansSystemDirectory {
  /// Get the user home directory: /home/user
  static Future<String> getHomeDirectory() async {
    final process = await Process.run('whoami', []);
    if (process.exitCode != 0) throw Exception("Cannot execute the process 'whoami': ${process.stderr}");

    final user = process.stdout.toString().trim();

    final homeDirectory = '/home/$user';

    final dir = Directory(homeDirectory);
    if (!dir.existsSync()) throw Exception("$homeDirectory does not exist");

    return homeDirectory;
  }

  /// Gets the actual directory from the executable running
  static Future<String> getExecutableDirectory() async {
    String currentPath = Directory.current.path;
    String executableName = Platform.executable.split('/').last;

    final lmountPath = "$currentPath/$executableName";

    final file = File(lmountPath);
    if (!await file.exists()) return Platform.executable;

    return Platform.executable;
  }

  /// Gets the preference directory for the executable running
  static Future<String> getPreferencesDirectory() async => "${await getExecutableDirectory()}/Configurations";

  /// Gets the logs directory for the executable running
  static Future<String> getLogsDirectory() async => "${await getExecutableDirectory()}/Logs";
}

class LeansSystemColors {
  //#region Calculations
  static late final String kdeColors;

  static Future loadSystemColors() async {
    final String homeDirectory = await LeansSystemDirectory.getHomeDirectory();
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

class LeansSystemExecutablePreferences {
  static late final Map<String, Map<String, dynamic>> _systemExecutablePreferences;
  static late final Directory preferencesDirectory;

  static Future loadSystemExecutablePreferences() async {
    preferencesDirectory = Directory(await LeansSystemDirectory.getPreferencesDirectory());
    if (!await preferencesDirectory.exists()) preferencesDirectory.create(recursive: true);

    List<File> lcfgFiles = [];
    await for (var file in preferencesDirectory.list()) {
      if (file is File && file.path.endsWith('.lcfg')) {
        lcfgFiles.add(file);
      }
    }

    for (var file in lcfgFiles) {
      try {
        String fileName = file.uri.pathSegments.last.substring(0, file.uri.pathSegments.last.lastIndexOf('.'));

        LeansSystemLogs.debug("Loading preference: $fileName");

        String content = await file.readAsString();

        Map<String, dynamic> jsonMap = jsonDecode(content);
        _systemExecutablePreferences[fileName] = jsonMap;
      } catch (e) {
        LeansSystemLogs.error("Cannot read preference in ${file.path}: $e");
      }
    }
  }

  // Get the preference by the identificator
  static dynamic getPreference(String file, String preference) async {
    return _systemExecutablePreferences[file]?[preference];
  }

  // Save preference by the identificator
  static Future savePreference(String file, String preference, dynamic data) async {
    if (_systemExecutablePreferences[file] == null) {
      // Checking existance
      _systemExecutablePreferences[file] = {};
    }
    _systemExecutablePreferences[file]![preference] = data;

    // Create folder if not exist
    if (!await preferencesDirectory.exists()) preferencesDirectory.create(recursive: true);

    // Saving preference
    final File filePreference = File("${preferencesDirectory.path}$file.lcfg");
    if (!await filePreference.exists()) filePreference.create();
    return filePreference.writeAsString(jsonEncode(_systemExecutablePreferences[file]));
  }
}

class LeansSystemLogs {
  static late final File _infoLogFile;
  static late final File _debugLogFile;
  static late final File _errorLogFile;

  static Future loadLogFiles() async {
    // Logs Directory
    Directory logDirectory = Directory(await LeansSystemDirectory.getLogsDirectory());
    if (!await logDirectory.exists()) logDirectory.create(recursive: true);

    // Saving previously logs into the last folders
    String currentDateTime = DateTime.now().toString().replaceAll(RegExp(r'[^\w\s]+'), '_');
    Directory previouslyLogsDirectory = Directory('${logDirectory.path}/$currentDateTime');
    await for (var file in logDirectory.list()) {
      if (file is File) {
        String newFilePath = '${previouslyLogsDirectory.path}/${file.uri.pathSegments.last}';
        await file.rename(newFilePath);
      }
    }

    // Logs creation
    _infoLogFile = File("$logDirectory/Info.txt");
    _debugLogFile = File("$logDirectory/Debug.txt");
    _errorLogFile = File("$logDirectory/Error.txt");
    await Future.wait([
      _infoLogFile.create(),
      _debugLogFile.create(),
      _errorLogFile.create(),
    ]);
  }

  static void debug(String message) => _debugLogFile.writeAsStringSync('\n$message', mode: FileMode.append, flush: true);

  static void info(String message) => _infoLogFile.writeAsStringSync('\n$message', mode: FileMode.append, flush: true);

  static void error(String message) => _errorLogFile.writeAsStringSync('\n$message', mode: FileMode.append, flush: true);
}
