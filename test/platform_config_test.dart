import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lubase/core/index.dart';

/// Native settings that no Dart test would notice when they go missing.
/// Change the scheme here too when `/project-setup` renames it.
void main() {
  final androidManifest = File(
    'android/app/src/main/AndroidManifest.xml',
  ).readAsStringSync();
  final infoPlist = File('ios/Runner/Info.plist').readAsStringSync();

  test('Android release builds may use the network', () {
    // Flutter's template only adds INTERNET to the debug/profile manifests.
    expect(androidManifest, contains('android.permission.INTERNET'));
  });

  test('Android backup is off (secure storage keys cannot be restored)', () {
    expect(androidManifest, contains('android:allowBackup="false"'));
  });

  test('the deep link scheme is declared on Android and iOS', () {
    expect(androidManifest, contains('android:scheme="lubase"'));
    expect(
      infoPlist,
      matches(
        RegExp(r'CFBundleURLSchemes</key>\s*<array>\s*<string>lubase</string>'),
      ),
    );
  });

  test('every launch configuration has a valid ENV and an existing flavor', () {
    final launch =
        jsonDecode(File('.vscode/launch.json').readAsStringSync())
            as Map<String, dynamic>;
    final gradle = File('android/app/build.gradle.kts').readAsStringSync();

    for (final config
        in (launch['configurations'] as List).cast<Map<String, dynamic>>()) {
      final name = config['name'] as String;
      final args = (config['args'] as List).cast<String>();
      final defines = args
          .firstWhere((a) => a.startsWith('--dart-define-from-file='))
          .split('=')
          .last;
      final env =
          (jsonDecode(File(defines).readAsStringSync()) as Map)['ENV']
              as String;
      expect(() => AppFlavorValue.fromEnv(env), returnsNormally, reason: name);

      for (final flavor in args.where((a) => a.startsWith('--flavor='))) {
        expect(
          gradle,
          contains('create("${flavor.split('=').last}")'),
          reason: name,
        );
      }
    }
  });
}
