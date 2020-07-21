import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Counter', () {
    test('value should start at 0', () {
      var counter = 0;
      expect(counter, 0);
    });

    test('value should be incremented', () {
      var counter = 0;

      ++counter;

      expect(counter, 1);
    });

    test('value should be decremented', () {
      var counter = 0;

      --counter;

      expect(counter, -1);
    });
  });
}
