import 'dart:convert';

class StringUtils {
  /// Extract a block from the text file, example:
  /// 
  /// [Test:Test]
  /// 
  /// test1=1
  /// 
  /// test2=1
  static String extractBlock(String content, String blockName) {
    final lines = LineSplitter.split(content).toList();
    bool inBlock = false;
    StringBuffer blockContent = StringBuffer();

    for (var line in lines) {
      if (line.trim() == blockName) {
        inBlock = true;
        continue;
      }
      if (inBlock) {
        if (line.trim().isEmpty || line.startsWith('[')) {
          break;
        }
        blockContent.writeln(line);
      }
    }

    return blockContent.toString().trim();
  }
}
