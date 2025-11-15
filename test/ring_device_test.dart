/// Tests for RingDevice functionality
///
/// Tests the full RingDevice implementation including Location integration,
/// component devices stream, and device data updates.
library;

import 'package:test/test.dart';
import 'package:ring_client_api/src/ring_device.dart';
import 'package:ring_client_api/src/ring_types.dart';
import 'package:ring_client_api/src/location.dart';
import 'package:ring_client_api/src/rest_client.dart';

void main() {
  group('RingDevice', () {
    test('should have correct properties from initial data', () {
      final deviceData = RingDeviceData(
        zid: 'test-zid-123',
        deviceType: 'security-keypad',
        name: 'Test Keypad',
        categoryId: 1,
        batteryStatus: BatteryStatus.ok,
        tamperStatus: TamperStatus.ok,
        tags: const [],
      );

      final mockLocation = _createMockLocation();
      final device = RingDevice(
        initialData: deviceData,
        location: mockLocation,
        assetId: 'asset-123',
      );

      expect(device.zid, equals('test-zid-123'));
      expect(device.id, equals('test-zid-123'));
      expect(device.deviceType, equals('security-keypad'));
      expect(device.name, equals('Test Keypad'));
      expect(device.categoryId, equals(1));
      expect(device.assetId, equals('asset-123'));

      device.disconnect();
      mockLocation.disconnect();
    });

    test('should update data when updateData is called', () {
      final deviceData = RingDeviceData(
        zid: 'test-zid-123',
        deviceType: 'security-keypad',
        name: 'Test Keypad',
        batteryLevel: 80,
        batteryStatus: BatteryStatus.ok,
        tamperStatus: TamperStatus.ok,
        tags: const [],
      );

      final mockLocation = _createMockLocation();
      final device = RingDevice(
        initialData: deviceData,
        location: mockLocation,
        assetId: 'asset-123',
      );

      expect(device.data.batteryLevel, equals(80));

      final update = RingDeviceData(
        zid: 'test-zid-123',
        deviceType: 'security-keypad',
        name: 'Test Keypad',
        batteryLevel: 60,
        batteryStatus: BatteryStatus.charging,
        tamperStatus: TamperStatus.ok,
        tags: const [],
      );

      device.updateData(update);

      expect(device.data.batteryLevel, equals(60));
      expect(device.data.name, equals('Test Keypad'));

      device.disconnect();
      mockLocation.disconnect();
    });

    test('should support volume control for compatible devices', () {
      final deviceData = RingDeviceData(
        zid: 'test-zid-123',
        deviceType: 'security-keypad',
        name: 'Test Keypad',
        volume: 0.5,
        batteryStatus: BatteryStatus.ok,
        tamperStatus: TamperStatus.ok,
        tags: const [],
      );

      final mockLocation = _createMockLocation();
      final device = RingDevice(
        initialData: deviceData,
        location: mockLocation,
        assetId: 'asset-123',
      );

      expect(device.supportsVolume, isTrue);

      device.disconnect();
      mockLocation.disconnect();
    });

    test('should clean up resources on disconnect', () {
      final deviceData = RingDeviceData(
        zid: 'test-zid-123',
        deviceType: 'security-keypad',
        name: 'Test Keypad',
        batteryStatus: BatteryStatus.ok,
        tamperStatus: TamperStatus.ok,
        tags: const [],
      );

      final mockLocation = _createMockLocation();
      final device = RingDevice(
        initialData: deviceData,
        location: mockLocation,
        assetId: 'asset-123',
      );

      expect(device.onData.isClosed, isFalse);

      device.disconnect();

      expect(device.onData.isClosed, isTrue);

      mockLocation.disconnect();
    });
  });
}

/// Create a minimal mock Location for testing
Location _createMockLocation() {
  final mockRestClient = RingRestClient(
    RefreshTokenAuth(refreshToken: 'test-token'),
  );

  final locationDetails = UserLocation(
    locationId: 'test-location',
    name: 'Test Location',
    geoCoordinates: const GeoCoordinates(latitude: '0', longitude: '0'),
    geoServiceVerified: 'address_only',
    userVerified: false,
    ownerId: 123456,
  );

  final location = Location(
    locationDetails: locationDetails,
    cameras: [],
    chimes: [],
    intercoms: [],
    options: const LocationOptions(hasHubs: false, hasAlarmBaseStation: false),
    restClient: mockRestClient,
  );

  return location;
}
