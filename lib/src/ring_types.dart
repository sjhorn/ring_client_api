/// Type definitions for the Ring Client API
///
/// This file contains all the data classes, enums, and type definitions
/// used by the Ring API for devices, cameras, locations, and more.
library;

import 'package:json_annotation/json_annotation.dart';

part 'ring_types.g.dart';

// Type aliases
typedef Firmware = String;

/// Ring device types as string constants
class RingDeviceType {
  static const String baseStation = 'hub.redsky';
  static const String baseStationPro = 'hub.kili';
  static const String keypad = 'security-keypad';
  static const String securityPanel = 'security-panel';
  static const String contactSensor = 'sensor.contact';
  static const String motionSensor = 'sensor.motion';
  static const String floodFreezeSensor = 'sensor.flood-freeze';
  static const String freezeSensor = 'sensor.freeze';
  static const String temperatureSensor = 'sensor.temperature';
  static const String waterSensor = 'sensor.water';
  static const String tiltSensor = 'sensor.tilt';
  static const String glassbreakSensor = 'sensor.glassbreak';
  static const String rangeExtender = 'range-extender.zwave';
  static const String zigbeeAdapter = 'adapter.zigbee';
  static const String accessCodeVault = 'access-code.vault';
  static const String accessCode = 'access-code';
  static const String smokeAlarm = 'alarm.smoke';
  static const String coAlarm = 'alarm.co';
  static const String smokeCoListener = 'listener.smoke-co';
  static const String multiLevelSwitch = 'switch.multilevel';
  static const String fan = 'switch.multilevel';
  static const String multiLevelBulb = 'switch.multilevel.bulb';
  static const String switchDevice = 'switch';
  static const String beamsMotionSensor = 'motion-sensor.beams';
  static const String beamsSwitch = 'switch.beams';
  static const String beamsMultiLevelSwitch = 'switch.multilevel.beams';
  static const String beamsLightGroupSwitch = 'group.light-group.beams';
  static const String beamsTransformerSwitch = 'switch.transformer.beams';
  static const String beamsDevice = 'device.beams';
  static const String retrofitBridge = 'bridge.flatline';
  static const String retrofitZone = 'sensor.zone';
  static const String thermostat = 'temperature-control.thermostat';
  static const String sensor = 'sensor';
  static const String ringNetAdapter = 'adapter.ringnet';
  static const String codeVault = 'access-code.vault';
  static const String securityAccessCode = 'access-code';
  static const String zWaveAdapter = 'adapter.zwave';
  static const String zWaveExtender = 'range-extender.zwave';
  static const String panicButton = 'security-panic';
  static const String unknownZWave = 'unknown.zwave';
  static const String onvifCamera = 'onvif_camera';
  static const String thirdPartyGarageDoorOpener = 'third_party_gdo';
  static const String intercomHandsetAudio = 'intercom_handset_audio';
  static const String waterValve = 'valve.water';
  static const String kiddeSmokeCoAlarm = 'comp.bluejay.sensor_bluejay_wsc';
}

/// Ring device categories
class RingDeviceCategory {
  static const int outlets = 1;
  static const int lights = 2;
  static const int sensors = 5;
  static const int appliances = 7;
  static const int locks = 10;
  static const int thermostats = 11;
  static const int cameras = 12;
  static const int alarms = 15;
  static const int fans = 17;
  static const int security = 22;
  static const int unknown = 29;
  static const int sensorsMotion = 30;
  static const int controller = 31;
  static const int rangeExtenders = 32;
  static const int keypads = 33;
  static const int sirens = 34;
  static const int panicButtons = 35;
  static const int waterValves = 37;
}

/// Ring camera kinds
class RingCameraKind {
  static const String doorbot = 'doorbot';
  static const String doorbell = 'doorbell';
  static const String doorbellV3 = 'doorbell_v3';
  static const String doorbellV4 = 'doorbell_v4';
  static const String doorbellV5 = 'doorbell_v5';
  static const String doorbellOyster =
      'doorbell_oyster'; // Ring Video Doorbell 4
  static const String doorbellPortal = 'doorbell_portal';
  static const String doorbellScallop = 'doorbell_scallop';
  static const String doorbellScallopLite = 'doorbell_scallop_lite';
  static const String doorbellGrahamCracker = 'doorbell_graham_cracker';
  static const String lpdV1 = 'lpd_v1';
  static const String lpdV2 = 'lpd_v2';
  static const String lpdV4 = 'lpd_v4';
  static const String jboxV1 = 'jbox_v1';
  static const String stickupCam = 'stickup_cam';
  static const String stickupCamV3 = 'stickup_cam_v3';
  static const String stickupCamElite = 'stickup_cam_elite';
  static const String stickupCamLongfin = 'stickup_cam_longfin';
  static const String stickupCamLunar = 'stickup_cam_lunar';
  static const String spotlightwV2 = 'spotlightw_v2';
  static const String hpCamV1 = 'hp_cam_v1';
  static const String hpCamV2 = 'hp_cam_v2';
  static const String stickupCamV4 = 'stickup_cam_v4';
  static const String floodlightV1 = 'floodlight_v1';
  static const String floodlightV2 = 'floodlight_v2';
  static const String floodlightPro = 'floodlight_pro';
  static const String cocoaCamera = 'cocoa_camera'; // next gen stickup cams
  static const String cocoaDoorbell = 'cocoa_doorbell';
  static const String cocoaDoorbellV2 = 'cocoa_doorbell_v2';
  static const String cocoaDoorbellV3 = 'cocoa_doorbell_v3';
  static const String cocoaFloodlight = 'cocoa_floodlight';
  static const String cocoaSpotlight = 'cocoa_spotlight'; // Spotlight Cam Plus
  static const String stickupCamMini = 'stickup_cam_mini';
  static const String onvifCamera = 'onvif_camera';
}

/// Mapping of camera kinds to model names
class RingCameraModel {
  static const Map<String, String> models = {
    RingCameraKind.doorbot: 'Doorbell',
    RingCameraKind.doorbell: 'Doorbell',
    RingCameraKind.doorbellV3: 'Doorbell',
    RingCameraKind.doorbellV4: 'Doorbell 2',
    RingCameraKind.doorbellV5: 'Doorbell 2',
    RingCameraKind.doorbellOyster: 'Doorbell 4',
    RingCameraKind.doorbellPortal: 'Door View Cam',
    RingCameraKind.doorbellScallop: 'Doorbell 3 Plus',
    RingCameraKind.doorbellScallopLite: 'Doorbell 3',
    RingCameraKind.doorbellGrahamCracker: 'Doorbell Wired',
    RingCameraKind.lpdV1: 'Doorbell Pro',
    RingCameraKind.lpdV2: 'Doorbell Pro',
    RingCameraKind.lpdV4: 'Doorbell Pro 2',
    RingCameraKind.jboxV1: 'Doorbell Elite',
    RingCameraKind.stickupCam: 'Stick Up Cam',
    RingCameraKind.stickupCamV3: 'Stick Up Cam',
    RingCameraKind.stickupCamElite: 'Stick Up Cam',
    RingCameraKind.stickupCamLongfin: 'Spotlight Cam Pro',
    RingCameraKind.stickupCamLunar: 'Stick Up Cam',
    RingCameraKind.spotlightwV2: 'Spotlight Cam',
    RingCameraKind.hpCamV1: 'Floodlight Cam',
    RingCameraKind.hpCamV2: 'Spotlight Cam',
    RingCameraKind.stickupCamV4: 'Spotlight Cam',
    RingCameraKind.floodlightV1: 'Floodlight Cam',
    RingCameraKind.floodlightV2: 'Floodlight Cam',
    RingCameraKind.floodlightPro: 'Floodlight Pro',
    RingCameraKind.cocoaCamera: 'Stick Up Cam',
    RingCameraKind.cocoaDoorbell: 'Doorbell Gen 2',
    RingCameraKind.cocoaDoorbellV2: 'Battery Doorbell Plus',
    RingCameraKind.cocoaDoorbellV3: 'Battery Doorbell Pro',
    RingCameraKind.cocoaFloodlight: 'Floodlight Cam Plus',
    RingCameraKind.cocoaSpotlight: 'Spotlight Cam Plus',
    RingCameraKind.stickupCamMini: 'Indoor Cam',
    RingCameraKind.onvifCamera: 'ONVIF Camera',
  };
}

/// Alarm mode states
enum AlarmMode {
  @JsonValue('all')
  all,
  @JsonValue('some')
  some,
  @JsonValue('none')
  none,
}

/// Thermostat mode states
enum ThermostatMode {
  @JsonValue('heat')
  heat,
  @JsonValue('cool')
  cool,
  @JsonValue('off')
  off,
  @JsonValue('aux')
  aux,
}

/// Message types for Socket.IO communication
enum MessageType {
  @JsonValue('RoomGetList')
  roomGetList,
  @JsonValue('SessionInfo')
  sessionInfo,
  @JsonValue('DeviceInfoDocGetList')
  deviceInfoDocGetList,
  @JsonValue('DeviceInfoSet')
  deviceInfoSet,
}

/// Message data types
enum MessageDataType {
  @JsonValue('RoomListV2Type')
  roomListV2Type,
  @JsonValue('SessionInfoType')
  sessionInfoType,
  @JsonValue('DeviceInfoDocType')
  deviceInfoDocType,
  @JsonValue('DeviceInfoSetType')
  deviceInfoSetType,
  @JsonValue('HubDisconnectionEventType')
  hubDisconnectionEventType,
}

/// Socket.IO message structure
@JsonSerializable()
class SocketIoMessage {
  final MessageType msg;
  final MessageDataType datatype;
  final String src;
  final List<dynamic> body;

  const SocketIoMessage({
    required this.msg,
    required this.datatype,
    required this.src,
    required this.body,
  });

  factory SocketIoMessage.fromJson(Map<String, dynamic> json) =>
      _$SocketIoMessageFromJson(json);

  Map<String, dynamic> toJson() => _$SocketIoMessageToJson(this);
}

/// Asset kinds
typedef AssetKind = String;

/// Asset session information
@JsonSerializable()
class AssetSession {
  final String assetUuid;
  final String connectionStatus; // 'unknown', 'cell-backup', 'online'
  final int doorbotId;
  final AssetKind kind;
  final int sessionId;

  const AssetSession({
    required this.assetUuid,
    required this.connectionStatus,
    required this.doorbotId,
    required this.kind,
    required this.sessionId,
  });

  factory AssetSession.fromJson(Map<String, dynamic> json) =>
      _$AssetSessionFromJson(json);

  Map<String, dynamic> toJson() => _$AssetSessionToJson(this);
}

/// Alarm states
enum AlarmState {
  @JsonValue('burglar-alarm')
  burglarAlarm, // Ring is Alarming
  @JsonValue('entry-delay')
  entryDelay, // Alarm will sound in X seconds
  @JsonValue('fire-alarm')
  fireAlarm, // Alarming - Smoke
  @JsonValue('co-alarm')
  coAlarm, // Alarming - CO
  @JsonValue('panic')
  panic, // Panic Triggered
  @JsonValue('user-verified-burglar-alarm')
  userVerifiedBurglarAlarm, // Alarming - User Verified Police
  @JsonValue('user-verified-co-or-fire-alarm')
  userVerifiedCoOrFireAlarm, // Alarming - User Verified Smoke or CO
  @JsonValue('burglar-accelerated-alarm')
  burglarAcceleratedAlarm, // Alarming - Police Response Requested
  @JsonValue('fire-accelerated-alarm')
  fireAcceleratedAlarm, // Alarming - Fire Department Response Requested
}

/// All possible alarm states
const List<AlarmState> allAlarmStates = AlarmState.values;

/// Battery status
enum BatteryStatus {
  @JsonValue('full')
  full,
  @JsonValue('charged')
  charged,
  @JsonValue('ok')
  ok,
  @JsonValue('low')
  low,
  @JsonValue('none')
  none,
  @JsonValue('charging')
  charging,
}

/// Battery backup status
enum BatteryBackup {
  @JsonValue('charged')
  charged,
  @JsonValue('charging')
  charging,
  @JsonValue('inUse')
  inUse,
}

/// AC power status
enum AcStatus {
  @JsonValue('error')
  error,
  @JsonValue('ok')
  ok,
}

/// Tamper status
enum TamperStatus {
  @JsonValue('ok')
  ok,
  @JsonValue('tamper')
  tamper,
}

/// Lock status
enum LockStatus {
  @JsonValue('jammed')
  jammed,
  @JsonValue('locked')
  locked,
  @JsonValue('unlocked')
  unlocked,
  @JsonValue('unknown')
  unknown,
}

/// Siren state
enum SirenState {
  @JsonValue('on')
  on,
  @JsonValue('off')
  off,
}

/// Motion status
enum MotionStatus {
  @JsonValue('clear')
  clear,
  @JsonValue('faulted')
  faulted,
}

/// Alarm info structure
@JsonSerializable()
class AlarmInfo {
  final AlarmState state;
  final List<String>? faultedDevices;
  final int? timestamp;
  final String? uuid;

  const AlarmInfo({
    required this.state,
    this.faultedDevices,
    this.timestamp,
    this.uuid,
  });

  factory AlarmInfo.fromJson(Map<String, dynamic> json) =>
      _$AlarmInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AlarmInfoToJson(this);
}

/// Siren info structure
@JsonSerializable()
class SirenInfo {
  final SirenState state;

  const SirenInfo({required this.state});

  factory SirenInfo.fromJson(Map<String, dynamic> json) =>
      _$SirenInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SirenInfoToJson(this);
}

/// Hue and saturation for lights
@JsonSerializable()
class HueSaturation {
  final double? hue; // 0 - 1
  final double? sat; // 0 - 1

  const HueSaturation({this.hue, this.sat});

  factory HueSaturation.fromJson(Map<String, dynamic> json) =>
      _$HueSaturationFromJson(json);

  Map<String, dynamic> toJson() => _$HueSaturationToJson(this);
}

/// Component device relationship
@JsonSerializable()
class ComponentDevice {
  final String rel;
  final String zid;

  const ComponentDevice({required this.rel, required this.zid});

  factory ComponentDevice.fromJson(Map<String, dynamic> json) =>
      _$ComponentDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$ComponentDeviceToJson(this);
}

/// Main ring device data structure
@JsonSerializable()
class RingDeviceData {
  final String zid;
  final String name;
  final String deviceType;
  final int categoryId;
  final int? batteryLevel;
  final BatteryStatus batteryStatus;
  final BatteryBackup? batteryBackup;
  final AcStatus? acStatus;
  final String? manufacturerName;
  final String? serialNumber;
  final TamperStatus tamperStatus;
  final bool? faulted;
  final LockStatus? locked;
  final int? roomId;
  final double? volume;
  final String? mode; // Can be AlarmMode or ThermostatMode
  final int? transitionDelayEndTimestamp;
  final AlarmInfo? alarmInfo;
  final SirenInfo? siren;
  final String? alarmStatus;
  final Map<String, dynamic>? co;
  final Map<String, dynamic>? smoke;
  final Map<String, dynamic>? flood;
  final Map<String, dynamic>? freeze;
  final MotionStatus? motionStatus;
  final String? groupId;
  final List<String> tags;

  // Switch properties
  final bool? on;

  // Multi-level switch properties
  final double? level; // 0 - 1
  final HueSaturation? hs;
  final double? ct; // 0 - 1

  // Retrofit sensor properties
  final String? status; // 'enabled' or 'disabled'
  final String? parentZid;
  final String? rootDevice;
  final String? relToParentZid; // '1' - '8'

  // Temperature sensor properties
  final double? celsius;
  final double? faultHigh;
  final double? faultLow;

  // Thermostat properties
  final double? setPoint;
  final double? setPointMax;
  final double? setPointMin;

  // Unknown Z-Wave properties
  final int? basicValue; // 0 for off, 255 for on

  final List<ComponentDevice>? componentDevices;

  // Switch.multilevel.beam properties
  final bool? motionSensorEnabled;

  // Keypad properties
  final double? brightness; // 0 - 1

  // Water valve properties
  final String? valveState; // 'open' or 'closed'

  const RingDeviceData({
    required this.zid,
    required this.name,
    required this.deviceType,
    required this.categoryId,
    this.batteryLevel,
    required this.batteryStatus,
    this.batteryBackup,
    this.acStatus,
    this.manufacturerName,
    this.serialNumber,
    required this.tamperStatus,
    this.faulted,
    this.locked,
    this.roomId,
    this.volume,
    this.mode,
    this.transitionDelayEndTimestamp,
    this.alarmInfo,
    this.siren,
    this.alarmStatus,
    this.co,
    this.smoke,
    this.flood,
    this.freeze,
    this.motionStatus,
    this.groupId,
    required this.tags,
    this.on,
    this.level,
    this.hs,
    this.ct,
    this.status,
    this.parentZid,
    this.rootDevice,
    this.relToParentZid,
    this.celsius,
    this.faultHigh,
    this.faultLow,
    this.setPoint,
    this.setPointMax,
    this.setPointMin,
    this.basicValue,
    this.componentDevices,
    this.motionSensorEnabled,
    this.brightness,
    this.valveState,
  });

  factory RingDeviceData.fromJson(Map<String, dynamic> json) =>
      _$RingDeviceDataFromJson(json);

  Map<String, dynamic> toJson() => _$RingDeviceDataToJson(this);
}

/// Devices that support volume control
const List<String> deviceTypesWithVolume = [
  RingDeviceType.baseStation,
  RingDeviceType.keypad,
];

/// Doorbell types
class DoorbellType {
  static const int mechanical = 0;
  static const int digital = 1;
  static const int none = 2;
}

/// Chime kinds
class ChimeKind {
  static const String chime = 'chime';
  static const String chimePro = 'chime_pro';
  static const String chimeV2 = 'chime_v2';
  static const String chimeProV2 = 'chime_pro_v2';
}

/// Chime model names
class ChimeModel {
  static const Map<String, String> models = {
    ChimeKind.chime: 'Chime',
    ChimeKind.chimePro: 'Chime Pro',
    ChimeKind.chimeV2: 'Chime v2',
    ChimeKind.chimeProV2: 'Chime Pro v2',
  };
}

/// Chime sound kinds
enum ChimeSoundKind {
  @JsonValue('motion')
  motion,
  @JsonValue('ding')
  ding,
}

// NOTE: This is a partial port of ring-types.ts
// Additional types for ChimeData, CameraData, LocationData, and other
// complex structures will be added as needed during the porting process.
// The TypeScript original has ~1253 lines with many detailed interface definitions.
//
// Key remaining types to port:
// - BaseStation, BeamBridge
// - ChimeData, ChimeUpdate, RingtoneOptions
// - LocationAddress, UserLocation
// - TicketAsset
// - BaseCameraData, CameraData, OnvifCameraData
// - CameraDeviceSettingsData
// - ChimeHealth, CameraHealth
// - DingData, PushNotification
// - SnapshotTimestamp
// - And many more detailed structures
//
// For now, we'll use Map<String, dynamic> for complex nested structures
// and add specific types as we port the implementation files.
