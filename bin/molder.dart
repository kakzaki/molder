import 'dart:convert';
import 'dart:io';
import 'package:molder/molder.dart';

void main() {
  final data = {
    'className': 'Person',
    'fields': [
      {'type': 'String', 'name': 'name'},
      {'type': 'int', 'name': 'age'},
    ],
  };

  final generatedCode = ManualCodeGenerator.generateClass(data);

  final outputDirectory = Directory('output');
  if (!outputDirectory.existsSync()) {
    outputDirectory.createSync();
  }

  final outputFile = File('output/person.dart');
  outputFile.writeAsStringSync(generatedCode);

  print('Code generation completed.');
}
