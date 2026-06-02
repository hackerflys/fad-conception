import 'package:flutter_test/flutter_test.dart';

import 'package:fad_conception/core/design/fad_colors.dart';

void main() {
  test('brand palette exposes light and dark variants', () {
    expect(FadColors.dark.isDark, true);
    expect(FadColors.light.isDark, false);
  });
}
