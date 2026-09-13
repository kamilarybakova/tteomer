import 'package:flutter_test/flutter_test.dart';
import 'package:tteomer/core/utils/app_config.dart';

void main() {
  test('Android update URL points to the published Google Play app', () {
    expect(
      AppConfig.androidPlayStoreUrl,
      'https://play.google.com/store/apps/details?id=com.kasoft.tteomer.app',
    );
  });
}
