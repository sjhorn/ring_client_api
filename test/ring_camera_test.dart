import 'package:ring_client_api/src/ring_camera.dart';
import 'package:test/test.dart';

void main() {
  group('Ring Camera', () {
    group('battery level', () {
      test('should handle string battery life', () {
        expect(
          getBatteryLevel({'battery_life': '49'}),
          equals(49.0),
        );
      });

      test('should handle null battery life', () {
        expect(
          getBatteryLevel({'battery_life': null}),
          equals(null),
        );
      });

      test('should handle right battery only', () {
        expect(
          getBatteryLevel({
            'battery_life': null,
            'battery_life_2': 24,
          }),
          equals(24.0),
        );
      });

      test('should handle left battery only', () {
        expect(
          getBatteryLevel({
            'battery_life': 76,
            'battery_life_2': null,
          }),
          equals(76.0),
        );
      });

      test('should handle dual batteries', () {
        // Should return the minimum of the two batteries
        expect(
          getBatteryLevel({
            'battery_life': '92',
            'battery_life_2': 84,
          }),
          equals(84.0),
        );
        expect(
          getBatteryLevel({
            'battery_life': '92',
            'battery_life_2': 100,
          }),
          equals(92.0),
        );
      });
    });

    group('cleanSnapshotUuid', () {
      test('should return the original uuid if it is already clean', () {
        expect(
          cleanSnapshotUuid('c2a0a397-3538-422d-bb4e-51837a56b870'),
          equals('c2a0a397-3538-422d-bb4e-51837a56b870'),
        );
      });

      test('should remove anything after :', () {
        expect(
          cleanSnapshotUuid('c2a0a397-3538-422d-bb4e-51837a56b870:122429140'),
          equals('c2a0a397-3538-422d-bb4e-51837a56b870'),
        );
      });

      test('should handle falsy values', () {
        expect(cleanSnapshotUuid(null), equals(null));
      });
    });
  });
}
