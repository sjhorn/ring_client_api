/// Ring device class for Z-Wave and other connected devices
///
/// Provides functionality for managing Ring devices such as keypads,
/// base stations, and other Z-Wave devices connected to a Ring Alarm system.
library;

import 'package:rxdart/rxdart.dart';
import 'ring_types.dart';
import 'subscribed.dart';
import 'util.dart';

// TODO: Import Location class when location.dart is ported
// import 'location.dart';

/// Represents a Ring device (Z-Wave or other connected device)
///
/// Ring devices include keypads, base stations, contact sensors, motion sensors,
/// and other devices that are part of the Ring Alarm system.
class RingDevice extends Subscribed {
  /// Stream of device data updates
  final BehaviorSubject<RingDeviceData> onData;

  /// Z-Wave device ID
  final String zid;

  /// Device ID (same as zid)
  final String id;

  /// Type of device
  final String deviceType;

  /// Device category ID
  final int categoryId;

  /// Stream of component devices (devices with this device as parent)
  late final Stream<List<RingDevice>> onComponentDevices;

  /// Initial device data
  final RingDeviceData initialData;

  /// Location this device belongs to
  final dynamic
  location; // TODO: Change to Location type when location.dart is available

  /// Asset ID of the location
  final String assetId;

  /// Create a new RingDevice
  ///
  /// [initialData] - Initial device data from the API
  /// [location] - The location this device belongs to
  /// [assetId] - Asset ID of the location
  RingDevice({
    required this.initialData,
    required this.location,
    required this.assetId,
  }) : onData = BehaviorSubject<RingDeviceData>.seeded(initialData),
       zid = initialData.zid,
       id = initialData.zid,
       deviceType = initialData.deviceType,
       categoryId = initialData.categoryId {
    // Set up component devices stream
    // TODO: Implement when Location class is available
    // This should filter devices from location.onDevices where parentZid == this.id
    onComponentDevices = const Stream.empty();

    // Subscribe to device data updates from the location
    // TODO: Implement when Location class is available
    // addSubscription(
    //   location.onDeviceDataUpdate
    //       .where((update) => update.zid == zid)
    //       .listen((update) => updateData(update)),
    // );
  }

  /// Update device data with partial update
  ///
  /// Merges the [update] data with the current data by converting to JSON,
  /// merging, and converting back. This mimics the Object.assign behavior
  /// from the TypeScript implementation.
  void updateData(RingDeviceData update) {
    final currentJson = data.toJson();
    final updateJson = update.toJson();

    // Merge the update into current data
    final mergedJson = <String, dynamic>{...currentJson, ...updateJson};

    // Convert back to RingDeviceData
    final mergedData = RingDeviceData.fromJson(mergedJson);
    onData.add(mergedData);
  }

  /// Get current device data
  RingDeviceData get data => onData.value;

  /// Get device name
  String get name => data.name;

  /// Check if this device supports volume control
  bool get supportsVolume {
    return deviceTypesWithVolume.contains(data.deviceType) &&
        data.volume != null;
  }

  /// Set the volume for this device
  ///
  /// [volume] - Volume level between 0.0 and 1.0
  /// Throws [ArgumentError] if volume is out of range or device doesn't support volume
  Future<void> setVolume(double volume) {
    if (volume.isNaN || volume < 0 || volume > 1) {
      throw ArgumentError('Volume must be between 0 and 1');
    }

    if (!supportsVolume) {
      throw ArgumentError(
        'Volume can only be set on ${deviceTypesWithVolume.join(', ')}',
      );
    }

    return setInfo({
      'device': {
        'v1': {'volume': volume},
      },
    });
  }

  /// Set device information
  ///
  /// [body] - The information to set (will be merged with device ID)
  Future<void> setInfo(Map<String, dynamic> body) {
    // TODO: Implement when Location class is available
    // return location.sendMessage({
    //   'msg': 'DeviceInfoSet',
    //   'datatype': 'DeviceInfoSetType',
    //   'dst': assetId,
    //   'body': [
    //     {
    //       'zid': zid,
    //       ...body,
    //     },
    //   ],
    // });
    throw UnimplementedError('Location.sendMessage not yet implemented');
  }

  /// Send a command to this device
  ///
  /// [commandType] - Type of command to send
  /// [data] - Optional data for the command
  void sendCommand(String commandType, [Map<String, dynamic> data = const {}]) {
    setInfo({
      'command': {
        'v1': [
          {'commandType': commandType, 'data': data},
        ],
      },
    }).catchError((error) {
      logError(error);
    });
  }

  /// Convert device to JSON string
  @override
  String toString() {
    return toJson();
  }

  /// Convert device to JSON string with formatting
  String toJson() {
    return stringify({'data': data.toJson()});
  }

  /// Disconnect and clean up resources
  void disconnect() {
    unsubscribe();
    onData.close();
  }
}
