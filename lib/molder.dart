import 'dart:io';

class ManualCodeGenerator {
  static String generateClass(Map<String, dynamic> data) {
    final template = '''
class {{className}} {
{{#fields}}
  {{#type}}
  final {{type}} {{name}};
  {{/type}}
{{/fields}}
  
  {{className}}({{#fields}}{{this.}}{{name}}, {{/fields}});
}
''';

    final fieldsList = (data['fields'] as List<Map<String, dynamic>>)
        .map((field) => {
              'type': field['type'] == null
                  ? null
                  : {'type': field['type'], 'name': field['name']},
              'name': field['name'],
            })
        .toList();

    final renderedContent = _renderTemplate(template, {
      'className': data['className'],
      'fields': fieldsList,
    });

    return renderedContent;
  }
}

String _renderTemplate(String template, Map<String, dynamic> data) {
  final lines = template.split('\n');
  final renderedLines = <String>[];
  final stack = <String>[];

  for (final line in lines) {
    if (line.trim() == '{{#fields}}') {
      stack.add('fields');
    } else if (line.trim() == '{{/fields}}') {
      stack.removeLast();
    } else if (stack.isNotEmpty && stack.last == 'fields') {
      renderedLines.add(_replacePlaceholders(line, data['fields'][0]));
    } else {
      renderedLines.add(_replacePlaceholders(line, data));
    }
  }

  return renderedLines.join('\n');
}

String _replacePlaceholders(String line, Map<String, dynamic> data) {
  for (final entry in data.entries) {
    final placeholder = '{{${entry.key}}}';
    final replacement = entry.value.toString();
    line = line.replaceAll(placeholder, replacement);
  }
  return line;
}
