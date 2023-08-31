import 'dart:io';

///example
/// void main() {
///   addDependency('http', '^0.13.3'); // Replace with your desired package and version
/// }
Future<void> addDependencyIfNotExists(
    String packageName, String version) async {
  final pubspecFile = File('pubspec.yaml');
  if (await pubspecFile.exists()) {
    var pubspecContent = await pubspecFile.readAsString();

    // Check if the dependency already exists
    if (pubspecContent.contains('$packageName:')) {
      print('Dependency $packageName already exists.');
      return;
    }

    final updatedContent =
        _updatePubspecContent(pubspecContent, packageName, version);
    await pubspecFile.writeAsString(updatedContent);

    // Run 'pub get' command
    final result = await Process.run('dart', ['pub', 'get']);
    if (result.exitCode == 0) {
      print('Package added successfully.');
    } else {
      print('Failed to add package.');
      print(result.stderr);
    }
  } else {
    print('pubspec.yaml file not found.');
  }
}

String _updatePubspecContent(
    String content, String packageName, String version) {
  final updatedContent = StringBuffer();
  final lines = content.split('\n');
  bool inDependencies = false;

  for (var line in lines) {
    if (line.trim() == 'dependencies:') {
      inDependencies = true;
    }

    updatedContent.writeln(line);

    if (inDependencies && line.trim().endsWith(':')) {
      updatedContent.writeln('  $packageName: $version');
      inDependencies = false;
    }
  }

  return updatedContent.toString();
}
