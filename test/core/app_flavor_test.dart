import 'package:flutter_test/flutter_test.dart';
import 'package:lubase/core/index.dart';

void main() {
  test('ENV selects the flavor', () {
    expect(AppFlavorValue.fromEnv('development'), AppFlavorValue.development);
    expect(AppFlavorValue.fromEnv('staging'), AppFlavorValue.staging);
    expect(AppFlavorValue.fromEnv('production'), AppFlavorValue.production);
  });

  test('an unknown ENV fails instead of falling back to a server', () {
    expect(() => AppFlavorValue.fromEnv('prod'), throwsArgumentError);
  });
}
