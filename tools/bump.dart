// ignore_for_file: avoid_print

import 'dart:io';

void main(List<String> args) {
  // Check if pubspec.yaml exists
  if (!File('pubspec.yaml').existsSync()) {
    print('Error: pubspec.yaml not found!');
    exit(1);
  }

  print('pubspec.yaml found.');

  // Read the contents of pubspec.yaml
  final pubspecContent = File('pubspec.yaml').readAsStringSync();

  // Extract the current version and build number
  final versionPattern =
      RegExp(r'version:\s*(\d+\.\d+\.\d+)\+(\d+)', multiLine: true);
  final Match? match = versionPattern.firstMatch(pubspecContent);

  if (match == null) {
    print('Error: Could not find version and build number in pubspec.yaml!');
    exit(1);
  }

  final currentVersion = match.group(1)!;
  final currentBuild = int.parse(match.group(2)!);

  print('Current version: $currentVersion');
  print('Current build number: $currentBuild');

  if (args.isEmpty || args.length > 2) {
    print(
        'Error: Please provide a valid version part to increment (build, patch, minor, major).');
    exit(1);
  }

  final versionPart = args[0].toLowerCase();
  final newVersion =
      incrementVersion(currentVersion, versionPart, currentBuild);

  // Replace the old version with the new one in pubspec.yaml
  final newPubspecContent = pubspecContent.replaceAll(
    versionPattern,
    'version: $newVersion',
  );

  File('pubspec.yaml').writeAsStringSync(newPubspecContent);

  print('Updated pubspec.yaml with the new version: $newVersion');
}

String incrementVersion(
    String currentVersion, String versionPart, int currentBuild) {
  final parts = currentVersion.split('+')[0].split('.').map(int.parse).toList();
  switch (versionPart) {
    case 'build':
      final newBuild = currentBuild + 1;
      return '${parts[0]}.${parts[1]}.${parts[2]}+$newBuild';
    case 'patch':
      final newPatch = parts[2] + 1;
      return '${parts[0]}.${parts[1]}.$newPatch+$currentBuild';
    case 'minor':
      final newMinor = parts[1] + 1;
      return '${parts[0]}.$newMinor.0+$currentBuild';
    case 'major':
      final newMajor = parts[0] + 1;
      return '$newMajor.0.0+$currentBuild';
    default:
      throw ArgumentError('Invalid version part: $versionPart');
  }
}
