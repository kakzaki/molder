import 'dart:io';
import 'package:mustache_template/mustache_template.dart';

void main() {
  final data = {
    'className': 'Person',
    'fields': [
      {'type': 'String', 'name': 'name'},
      {'type': 'int', 'name': 'age'},
    ],
  };

  final templateFile = File('template/sample_template.txt');
  final templateContent = templateFile.readAsStringSync();

  final fieldsList = (data['fields'] as List<Map<String, dynamic>>)
      .map((field) => {
            'type': field['type'],
            'name': field['name'],
            'sep': (field == (data['fields'] as List).last) ? '' : ',',
          })
      .toList();

  final template = Template(templateContent, name: 'class_template');
  final generatedCode = template
      .renderString({'className': data['className'], 'fields': fieldsList});

  final outputDirectory = Directory('output');
  if (!outputDirectory.existsSync()) {
    outputDirectory.createSync();
  }

  final outputFile = File('output/generated_code.dart');
  outputFile.writeAsStringSync(generatedCode);

  print('Code generation completed.');
}
