import 'package:flutter_test/flutter_test.dart';
import 'package:airy/main.dart';

void main() {
  test('AiryApp dapat dibuat', () {
    const app = AiryApp();

    expect(app, isA<AiryApp>());
  });
}
