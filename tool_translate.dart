import 'dart:convert';
import 'dart:io';

void main() async {
  final libDir = Directory('lib');
  final idFile = File('assets/translations/id-ID.json');
  final enFile = File('assets/translations/en-US.json');

  if (!idFile.existsSync() || !enFile.existsSync()) {
    print('Translation JSON files not found!');
    return;
  }

  Map<String, dynamic> idJson = json.decode(await idFile.readAsString());
  Map<String, dynamic> enJson = json.decode(await enFile.readAsString());

  int addedCount = 0;
  int replacedCount = 0;

  String generateKey(String text) {
    String key = text.toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '_');
    if (key.length > 30) {
      key = key.substring(0, 30);
    }
    if (key.endsWith('_')) {
      key = key.substring(0, key.length - 1);
    }
    return key.isEmpty ? 'text_${DateTime.now().millisecondsSinceEpoch}' : key;
  }

  void processFile(File file) {
    String content = file.readAsStringSync();
    String originalContent = content;
    bool needsImport = false;

    // Matches Text('...') or Text("...") without variables
    final textRegex = RegExp(r"Text\(\s*['" + '"' + r"]([^'\$" + '"' + r"\n\r]+)['" + '"' + r"]\s*(?:,\s*style:\s*[^,)]+)?\s*\)");
    // Matches label: '...'
    final labelRegex = RegExp(r"(label|hint|text):\s*['" + '"' + r"]([^'\$" + '"' + r"\n\r]+)['" + '"' + r"]");

    content = content.replaceAllMapped(textRegex, (match) {
      final originalText = match.group(1)!;
      // Skip very short strings or numeric
      if (originalText.trim().length <= 1 || double.tryParse(originalText) != null) return match.group(0)!;
      
      String key = generateKey(originalText);
      // Ensure unique key if collision happens with different text
      int counter = 1;
      while (idJson.containsKey(key) && idJson[key] != originalText) {
        key = '${generateKey(originalText)}_$counter';
        counter++;
      }

      if (!idJson.containsKey(key)) {
        idJson[key] = originalText;
        enJson[key] = originalText; // Placeholder for English
        addedCount++;
      }

      needsImport = true;
      replacedCount++;
      
      // We must reconstruct the Text widget, but regex match might include style.
      // To be safe, just replace the string part.
      return match.group(0)!.replaceFirst("'" + originalText + "'", "'" + key + "'.tr()").replaceFirst('"' + originalText + '"', "'" + key + "'.tr()");
    });

    content = content.replaceAllMapped(labelRegex, (match) {
      final prop = match.group(1)!;
      final originalText = match.group(2)!;
      if (originalText.trim().length <= 1 || double.tryParse(originalText) != null) return match.group(0)!;

      String key = generateKey(originalText);
      int counter = 1;
      while (idJson.containsKey(key) && idJson[key] != originalText) {
        key = '${generateKey(originalText)}_$counter';
        counter++;
      }

      if (!idJson.containsKey(key)) {
        idJson[key] = originalText;
        enJson[key] = originalText;
        addedCount++;
      }

      needsImport = true;
      replacedCount++;
      
      return "$prop: '$key'.tr()";
    });

    if (content != originalContent) {
      if (needsImport && !content.contains("easy_localization.dart")) {
        // Insert import at the top
        content = "import 'package:easy_localization/easy_localization.dart';\n" + content;
      }
      file.writeAsStringSync(content);
    }
  }

  void traverseDir(Directory dir) {
    for (var entity in dir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart') && !entity.path.contains('.g.dart') && !entity.path.contains('.freezed.dart')) {
        processFile(entity);
      }
    }
  }

  traverseDir(libDir);

  if (addedCount > 0) {
    const encoder = JsonEncoder.withIndent('  ');
    idFile.writeAsStringSync(encoder.convert(idJson));
    enFile.writeAsStringSync(encoder.convert(enJson));
    print('Successfully added $addedCount new keys and replaced $replacedCount usages.');
  } else {
    print('No new texts found.');
  }
}
