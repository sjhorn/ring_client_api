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
  @JsonValue('SubscriptionTopicsInfo')
  subscriptionTopicsInfo,
  @JsonValue('DataUpdate')
  dataUpdate,
  @JsonValue('Passthru')
  passthru,
  @JsonValue('')
  empty,
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
  @JsonValue('SubscriptionTopicType')
  subscriptionTopicType,
  @JsonValue('PassthruType')
  passthruType,
}

/// Socket.IO message structure
@JsonSerializable()
class SocketIoMessage {
  final MessageType? msg;
  final MessageDataType? datatype;
  final String? src;
  final List<dynamic>? body;
  final int? seq;
  final int? sessionId;
  final int? status;
  final Map<String, dynamic>? context;

  const SocketIoMessage({
    this.msg,
    this.datatype,
    this.src,
    this.body,
    this.seq,
    this.sessionId,
    this.status,
    this.context,
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
  final int? doorbotId;
  final AssetKind kind;
  final int? sessionId;

  const AssetSession({
    required this.assetUuid,
    required this.connectionStatus,
    this.doorbotId,
    required this.kind,
    this.sessionId,
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
  final int? categoryId;
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
    this.categoryId,
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

/// Base station data structure
@JsonSerializable()
class BaseStation {
  final String? address;
  final List<dynamic>? alerts;
  final String? description;
  @JsonKey(name: 'device_id')
  final String? deviceId;
  final dynamic features;
  @JsonKey(name: 'firmware_version')
  final Firmware? firmwareVersion;
  final int? id;
  final String? kind;
  final double? latitude;
  @JsonKey(name: 'location_id')
  final String? locationId;
  final double? longitude;
  final bool? owned;
  final BaseStationOwner? owner;
  @JsonKey(name: 'ring_id')
  final dynamic ringId;
  final dynamic settings;
  final bool? stolen;
  @JsonKey(name: 'time_zone')
  final String? timeZone;

  const BaseStation({
    this.address,
    this.alerts,
    this.description,
    this.deviceId,
    this.features,
    this.firmwareVersion,
    this.id,
    this.kind,
    this.latitude,
    this.locationId,
    this.longitude,
    this.owned,
    this.owner,
    required this.ringId,
    this.settings,
    this.stolen,
    this.timeZone,
  });

  factory BaseStation.fromJson(Map<String, dynamic> json) =>
      _$BaseStationFromJson(json);

  Map<String, dynamic> toJson() => _$BaseStationToJson(this);
}

/// Base station owner information
@JsonSerializable()
class BaseStationOwner {
  final int? id;
  final String? email;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;

  const BaseStationOwner({this.id, this.email, this.firstName, this.lastName});

  factory BaseStationOwner.fromJson(Map<String, dynamic> json) =>
      _$BaseStationOwnerFromJson(json);

  Map<String, dynamic> toJson() => _$BaseStationOwnerToJson(this);
}

/// Beam bridge device data
@JsonSerializable()
class BeamBridge {
  @JsonKey(name: 'created_at')
  final String createdAt;
  final String description;
  @JsonKey(name: 'hardware_id')
  final String hardwareId;
  final int id;
  final String kind;
  @JsonKey(name: 'location_id')
  final String locationId;
  final BeamBridgeMetadata metadata;
  @JsonKey(name: 'owner_id')
  final int ownerId;
  final String role;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const BeamBridge({
    required this.createdAt,
    required this.description,
    required this.hardwareId,
    required this.id,
    required this.kind,
    required this.locationId,
    required this.metadata,
    required this.ownerId,
    required this.role,
    required this.updatedAt,
  });

  factory BeamBridge.fromJson(Map<String, dynamic> json) =>
      _$BeamBridgeFromJson(json);

  Map<String, dynamic> toJson() => _$BeamBridgeToJson(this);
}

/// Beam bridge metadata
@JsonSerializable()
class BeamBridgeMetadata {
  final bool ethernet;
  @JsonKey(name: 'legacy_fw_migrated')
  final bool legacyFwMigrated;

  const BeamBridgeMetadata({
    required this.ethernet,
    required this.legacyFwMigrated,
  });

  factory BeamBridgeMetadata.fromJson(Map<String, dynamic> json) =>
      _$BeamBridgeMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$BeamBridgeMetadataToJson(this);
}

/// Chime settings structure
@JsonSerializable()
class ChimeSettings {
  final int? volume;
  @JsonKey(name: 'ding_audio_user_id')
  final String? dingAudioUserId;
  @JsonKey(name: 'ding_audio_id')
  final String? dingAudioId;
  @JsonKey(name: 'motion_audio_user_id')
  final String? motionAudioUserId;
  @JsonKey(name: 'motion_audio_id')
  final String? motionAudioId;

  const ChimeSettings({
    this.volume,
    this.dingAudioUserId,
    this.dingAudioId,
    this.motionAudioUserId,
    this.motionAudioId,
  });

  factory ChimeSettings.fromJson(Map<String, dynamic> json) =>
      _$ChimeSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$ChimeSettingsToJson(this);
}

/// Chime features structure
@JsonSerializable()
class ChimeFeatures {
  @JsonKey(name: 'ringtones_enabled')
  final bool? ringtonesEnabled;

  const ChimeFeatures({this.ringtonesEnabled});

  factory ChimeFeatures.fromJson(Map<String, dynamic> json) =>
      _$ChimeFeaturesFromJson(json);

  Map<String, dynamic> toJson() => _$ChimeFeaturesToJson(this);
}

/// Chime alerts structure
@JsonSerializable()
class ChimeAlerts {
  final String? connection;
  final String? rssi;

  const ChimeAlerts({this.connection, this.rssi});

  factory ChimeAlerts.fromJson(Map<String, dynamic> json) =>
      _$ChimeAlertsFromJson(json);

  Map<String, dynamic> toJson() => _$ChimeAlertsToJson(this);
}

/// Chime do not disturb structure
@JsonSerializable()
class ChimeDoNotDisturb {
  @JsonKey(name: 'seconds_left')
  final int? secondsLeft;

  const ChimeDoNotDisturb({this.secondsLeft});

  factory ChimeDoNotDisturb.fromJson(Map<String, dynamic> json) =>
      _$ChimeDoNotDisturbFromJson(json);

  Map<String, dynamic> toJson() => _$ChimeDoNotDisturbToJson(this);
}

/// Chime owner information
@JsonSerializable()
class ChimeOwner {
  final int? id;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  final String? email;

  const ChimeOwner({this.id, this.firstName, this.lastName, this.email});

  factory ChimeOwner.fromJson(Map<String, dynamic> json) =>
      _$ChimeOwnerFromJson(json);

  Map<String, dynamic> toJson() => _$ChimeOwnerToJson(this);
}

/// Chime data structure
@JsonSerializable()
class ChimeData {
  final int? id;
  final String? description;
  @JsonKey(name: 'device_id')
  final String? deviceId;
  @JsonKey(name: 'time_zone')
  final String? timeZone;
  @JsonKey(name: 'firmware_version')
  final Firmware? firmwareVersion;
  final String? kind;
  final double? latitude;
  final double? longitude;
  final String? address;
  final ChimeSettings? settings;
  final ChimeFeatures? features;
  final bool? owned;
  final ChimeAlerts? alerts;
  @JsonKey(name: 'do_not_disturb')
  final ChimeDoNotDisturb? doNotDisturb;
  final bool? stolen;
  @JsonKey(name: 'location_id')
  final String? locationId;
  @JsonKey(name: 'ring_id')
  final dynamic ringId;
  final ChimeOwner? owner;

  const ChimeData({
    this.id,
    this.description,
    this.deviceId,
    this.timeZone,
    this.firmwareVersion,
    this.kind,
    this.latitude,
    this.longitude,
    this.address,
    this.settings,
    this.features,
    this.owned,
    this.alerts,
    this.doNotDisturb,
    this.stolen,
    this.locationId,
    required this.ringId,
    this.owner,
  });

  factory ChimeData.fromJson(Map<String, dynamic> json) =>
      _$ChimeDataFromJson(json);

  Map<String, dynamic> toJson() => _$ChimeDataToJson(this);
}

/// Chime update request structure
@JsonSerializable()
class ChimeUpdate {
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? address;
  final ChimeUpdateSettings? settings;

  const ChimeUpdate({
    this.description,
    this.latitude,
    this.longitude,
    this.address,
    this.settings,
  });

  factory ChimeUpdate.fromJson(Map<String, dynamic> json) =>
      _$ChimeUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$ChimeUpdateToJson(this);
}

/// Chime update settings structure
@JsonSerializable()
class ChimeUpdateSettings {
  final int? volume;
  final String? dingAudioUserId;
  final String? dingAudioId;
  final String? motionAudioUserId;
  final String? motionAudioId;

  const ChimeUpdateSettings({
    this.volume,
    this.dingAudioUserId,
    this.dingAudioId,
    this.motionAudioUserId,
    this.motionAudioId,
  });

  factory ChimeUpdateSettings.fromJson(Map<String, dynamic> json) =>
      _$ChimeUpdateSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$ChimeUpdateSettingsToJson(this);
}

/// Ringtone audio structure
@JsonSerializable()
class RingtoneAudio {
  @JsonKey(name: 'user_id')
  final String userId;
  final String id;
  final String description;
  final String kind;
  final String url;
  final String checksum;
  final String available;

  const RingtoneAudio({
    required this.userId,
    required this.id,
    required this.description,
    required this.kind,
    required this.url,
    required this.checksum,
    required this.available,
  });

  factory RingtoneAudio.fromJson(Map<String, dynamic> json) =>
      _$RingtoneAudioFromJson(json);

  Map<String, dynamic> toJson() => _$RingtoneAudioToJson(this);
}

/// Ringtone options structure
@JsonSerializable()
class RingtoneOptions {
  @JsonKey(name: 'default_ding_user_id')
  final String defaultDingUserId;
  @JsonKey(name: 'default_ding_id')
  final String defaultDingId;
  @JsonKey(name: 'default_motion_user_id')
  final String defaultMotionUserId;
  @JsonKey(name: 'default_motion_id')
  final String defaultMotionId;
  final List<RingtoneAudio> audios;

  const RingtoneOptions({
    required this.defaultDingUserId,
    required this.defaultDingId,
    required this.defaultMotionUserId,
    required this.defaultMotionId,
    required this.audios,
  });

  factory RingtoneOptions.fromJson(Map<String, dynamic> json) =>
      _$RingtoneOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$RingtoneOptionsToJson(this);
}

/// Location address structure
@JsonSerializable()
class LocationAddress {
  final String? address1;
  final String? address2;
  @JsonKey(name: 'cross_street')
  final String? crossStreet;
  final String? city;
  final String? state;
  final String? timezone;
  @JsonKey(name: 'zip_code')
  final String? zipCode;

  const LocationAddress({
    this.address1,
    this.address2,
    this.crossStreet,
    this.city,
    this.state,
    this.timezone,
    this.zipCode,
  });

  factory LocationAddress.fromJson(Map<String, dynamic> json) =>
      _$LocationAddressFromJson(json);

  Map<String, dynamic> toJson() => _$LocationAddressToJson(this);
}

/// Geographic coordinates
@JsonSerializable()
class GeoCoordinates {
  final String latitude;
  final String longitude;

  const GeoCoordinates({required this.latitude, required this.longitude});

  factory GeoCoordinates.fromJson(Map<String, dynamic> json) {
    return GeoCoordinates(
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
    );
  }

  Map<String, dynamic> toJson() => _$GeoCoordinatesToJson(this);
}

/// User location structure
@JsonSerializable()
class UserLocation {
  final LocationAddress? address;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'geo_coordinates')
  final GeoCoordinates? geoCoordinates;
  @JsonKey(name: 'geo_service_verified')
  final String? geoServiceVerified; // 'address_only' or other string values
  @JsonKey(name: 'location_id')
  final String? locationId;
  final String? name;
  @JsonKey(name: 'owner_id')
  final int? ownerId;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'user_verified')
  final bool? userVerified;

  const UserLocation({
    this.address,
    this.createdAt,
    this.geoCoordinates,
    this.geoServiceVerified,
    this.locationId,
    this.name,
    this.ownerId,
    this.updatedAt,
    this.userVerified,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) =>
      _$UserLocationFromJson(json);

  Map<String, dynamic> toJson() => _$UserLocationToJson(this);
}

/// Ticket asset structure
@JsonSerializable()
class TicketAsset {
  @JsonKey(name: 'doorbotId')
  final int doorbotId;
  final AssetKind kind;
  @JsonKey(name: 'onBattery')
  final bool onBattery;
  final String status; // 'online' or 'offline'
  final String uuid;

  const TicketAsset({
    required this.doorbotId,
    required this.kind,
    required this.onBattery,
    required this.status,
    required this.uuid,
  });

  factory TicketAsset.fromJson(Map<String, dynamic> json) =>
      _$TicketAssetFromJson(json);

  Map<String, dynamic> toJson() => _$TicketAssetToJson(this);
}

/// Camera alerts structure
@JsonSerializable()
class CameraAlerts {
  final String connection; // 'online', 'offline', or other string
  final String? battery; // 'low' or other string values
  @JsonKey(name: 'ota_status')
  final String? otaStatus; // 'timeout' or other string values

  const CameraAlerts({required this.connection, this.battery, this.otaStatus});

  factory CameraAlerts.fromJson(Map<String, dynamic> json) =>
      _$CameraAlertsFromJson(json);

  Map<String, dynamic> toJson() => _$CameraAlertsToJson(this);
}

/// Camera features structure
@JsonSerializable()
class CameraFeatures {
  @JsonKey(name: 'motions_enabled')
  final bool? motionsEnabled;
  @JsonKey(name: 'show_recordings')
  final bool? showRecordings;
  @JsonKey(name: 'advanced_motion_enabled')
  final bool? advancedMotionEnabled;
  @JsonKey(name: 'people_only_enabled')
  final bool? peopleOnlyEnabled;
  @JsonKey(name: 'shadow_correction_enabled')
  final bool? shadowCorrectionEnabled;
  @JsonKey(name: 'motion_message_enabled')
  final bool? motionMessageEnabled;
  @JsonKey(name: 'night_vision_enabled')
  final bool? nightVisionEnabled;

  const CameraFeatures({
    this.motionsEnabled,
    this.showRecordings,
    this.advancedMotionEnabled,
    this.peopleOnlyEnabled,
    this.shadowCorrectionEnabled,
    this.motionMessageEnabled,
    this.nightVisionEnabled,
  });

  factory CameraFeatures.fromJson(Map<String, dynamic> json) =>
      _$CameraFeaturesFromJson(json);

  Map<String, dynamic> toJson() => _$CameraFeaturesToJson(this);
}

/// Motion snooze structure
@JsonSerializable()
class MotionSnooze {
  final bool scheduled;

  const MotionSnooze({required this.scheduled});

  factory MotionSnooze.fromJson(Map<String, dynamic> json) =>
      _$MotionSnoozeFromJson(json);

  Map<String, dynamic> toJson() => _$MotionSnoozeToJson(this);
}

/// Motion zones structure
@JsonSerializable()
class MotionZones {
  @JsonKey(name: 'enable_audio')
  final bool enableAudio;
  @JsonKey(name: 'active_motion_filter')
  final int? activeMotionFilter;
  final int? sensitivity;
  @JsonKey(name: 'advanced_object_settings')
  final dynamic advancedObjectSettings;
  final dynamic zone1;
  final dynamic zone2;
  final dynamic zone3;

  const MotionZones({
    required this.enableAudio,
    this.activeMotionFilter,
    this.sensitivity,
    required this.advancedObjectSettings,
    required this.zone1,
    required this.zone2,
    required this.zone3,
  });

  factory MotionZones.fromJson(Map<String, dynamic> json) =>
      _$MotionZonesFromJson(json);

  Map<String, dynamic> toJson() => _$MotionZonesToJson(this);
}

/// Chime settings for cameras
@JsonSerializable()
class CameraChimeSettings {
  final int type;
  final bool enable;
  final int duration;

  const CameraChimeSettings({
    required this.type,
    required this.enable,
    required this.duration,
  });

  factory CameraChimeSettings.fromJson(Map<String, dynamic> json) =>
      _$CameraChimeSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$CameraChimeSettingsToJson(this);
}

/// Floodlight settings structure
@JsonSerializable()
class FloodlightSettings {
  final int? priority;
  final int? duration;
  final int? brightness;
  @JsonKey(name: 'always_on')
  final bool? alwaysOn;
  @JsonKey(name: 'always_on_duration')
  final int? alwaysOnDuration;

  const FloodlightSettings({
    this.priority,
    this.duration,
    this.brightness,
    this.alwaysOn,
    this.alwaysOnDuration,
  });

  factory FloodlightSettings.fromJson(Map<String, dynamic> json) =>
      _$FloodlightSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$FloodlightSettingsToJson(this);
}

/// Sheila settings structure
@JsonSerializable()
class SheilaSettings {
  @JsonKey(name: 'cv_processing_enabled')
  final bool? cvProcessingEnabled;
  @JsonKey(name: 'local_storage_enabled')
  final bool? localStorageEnabled; // true for Ring Edge devices

  const SheilaSettings({this.cvProcessingEnabled, this.localStorageEnabled});

  factory SheilaSettings.fromJson(Map<String, dynamic> json) =>
      _$SheilaSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SheilaSettingsToJson(this);
}

/// Server settings structure
@JsonSerializable()
class ServerSettings {
  @JsonKey(name: 'ring_media_server_enabled')
  final bool ringMediaServerEnabled;

  const ServerSettings({required this.ringMediaServerEnabled});

  factory ServerSettings.fromJson(Map<String, dynamic> json) =>
      _$ServerSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$ServerSettingsToJson(this);
}

/// Camera settings structure
@JsonSerializable()
class CameraSettingsData {
  @JsonKey(name: 'enable_vod')
  final dynamic enableVod; // bool or int (1)
  @JsonKey(name: 'motion_zones')
  final dynamic motionZones; // MotionZones object or array
  @JsonKey(name: 'motion_snooze_preset_profile')
  final String? motionSnoozePresetProfile;
  @JsonKey(name: 'live_view_preset_profile')
  final String? liveViewPresetProfile;
  @JsonKey(name: 'live_view_presets')
  final List<String>? liveViewPresets;
  @JsonKey(name: 'motion_snooze_presets')
  final List<String>? motionSnoozePresets;
  @JsonKey(name: 'doorbell_volume')
  final int? doorbellVolume;
  @JsonKey(name: 'chime_settings')
  final CameraChimeSettings? chimeSettings;
  @JsonKey(name: 'video_settings')
  final dynamic videoSettings;
  @JsonKey(name: 'motion_announcement')
  final bool? motionAnnouncement;
  @JsonKey(name: 'stream_setting')
  final int? streamSetting;
  @JsonKey(name: 'advanced_motion_detection_enabled')
  final bool? advancedMotionDetectionEnabled;
  @JsonKey(name: 'advanced_motion_detection_human_only_mode')
  final bool? advancedMotionDetectionHumanOnlyMode;
  @JsonKey(name: 'luma_night_threshold')
  final int? lumaNightThreshold;
  @JsonKey(name: 'enable_audio_recording')
  final bool? enableAudioRecording;
  @JsonKey(name: 'people_detection_eligible')
  final bool? peopleDetectionEligible;
  @JsonKey(name: 'pir_settings')
  final dynamic pirSettings;
  @JsonKey(name: 'pir_motion_zones')
  final List<int>? pirMotionZones;
  @JsonKey(name: 'floodlight_settings')
  final FloodlightSettings? floodlightSettings;
  @JsonKey(name: 'light_schedule_settings')
  final dynamic lightScheduleSettings;
  @JsonKey(name: 'luma_light_threshold')
  final int? lumaLightThreshold;
  @JsonKey(name: 'live_view_disabled')
  final bool? liveViewDisabled; // set by modes
  @JsonKey(name: 'motion_detection_enabled')
  final bool? motionDetectionEnabled; // set by modes or Record Motion toggle
  @JsonKey(name: 'power_mode')
  final String? powerMode; // 'battery' or 'wired'
  @JsonKey(name: 'sheila_settings')
  final SheilaSettings? sheilaSettings;
  @JsonKey(name: 'server_settings')
  final ServerSettings? serverSettings;

  const CameraSettingsData({
    required this.enableVod,
    this.motionZones,
    this.motionSnoozePresetProfile,
    this.liveViewPresetProfile,
    this.liveViewPresets,
    this.motionSnoozePresets,
    this.doorbellVolume,
    this.chimeSettings,
    required this.videoSettings,
    this.motionAnnouncement,
    this.streamSetting,
    this.advancedMotionDetectionEnabled,
    this.advancedMotionDetectionHumanOnlyMode,
    this.lumaNightThreshold,
    this.enableAudioRecording,
    this.peopleDetectionEligible,
    this.pirSettings,
    this.pirMotionZones,
    this.floodlightSettings,
    this.lightScheduleSettings,
    this.lumaLightThreshold,
    this.liveViewDisabled,
    this.motionDetectionEnabled,
    this.powerMode,
    this.sheilaSettings,
    this.serverSettings,
  });

  factory CameraSettingsData.fromJson(Map<String, dynamic> json) =>
      _$CameraSettingsDataFromJson(json);

  Map<String, dynamic> toJson() => _$CameraSettingsDataToJson(this);
}

/// Camera owner information
@JsonSerializable()
class CameraOwner {
  final int? id;
  final String? email;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;

  const CameraOwner({this.id, this.email, this.firstName, this.lastName});

  factory CameraOwner.fromJson(Map<String, dynamic> json) =>
      _$CameraOwnerFromJson(json);

  Map<String, dynamic> toJson() => _$CameraOwnerToJson(this);
}

/// Siren status structure
@JsonSerializable()
class SirenStatus {
  @JsonKey(name: 'started_at')
  final String? startedAt;
  final String? duration;
  @JsonKey(name: 'ends_at')
  final String? endsAt;
  @JsonKey(name: 'seconds_remaining')
  final int? secondsRemaining;

  const SirenStatus({
    this.startedAt,
    this.duration,
    this.endsAt,
    this.secondsRemaining,
  });

  factory SirenStatus.fromJson(Map<String, dynamic> json) =>
      _$SirenStatusFromJson(json);

  Map<String, dynamic> toJson() => _$SirenStatusToJson(this);
}

/// Camera health structure
@JsonSerializable()
class CameraHealthData {
  @JsonKey(name: 'device_type')
  final String? deviceType;
  @JsonKey(name: 'last_update_time')
  final int? lastUpdateTime;
  final bool? connected;
  @JsonKey(name: 'rss_connected')
  final bool? rssConnected;
  @JsonKey(name: 'vod_enabled')
  final bool? vodEnabled;
  @JsonKey(name: 'sidewalk_connection')
  final bool? sidewalkConnection;
  @JsonKey(name: 'floodlight_on')
  final bool? floodlightOn;
  @JsonKey(name: 'siren_on')
  final bool? sirenOn;
  @JsonKey(name: 'white_led_on')
  final bool? whiteLedOn;
  @JsonKey(name: 'night_mode_on')
  final bool? nightModeOn;
  @JsonKey(name: 'hatch_open')
  final bool? hatchOpen;
  @JsonKey(name: 'packet_loss')
  final double? packetLoss;
  @JsonKey(name: 'packet_loss_category')
  final String? packetLossCategory; // 'good' or other string
  final int? rssi;
  @JsonKey(name: 'battery_voltage')
  final double? batteryVoltage;
  @JsonKey(name: 'wifi_is_ring_network')
  final bool? wifiIsRingNetwork;
  @JsonKey(name: 'supported_rpc_commands')
  final List<String>? supportedRpcCommands;
  @JsonKey(name: 'ota_status')
  final String? otaStatus; // 'successful' or other string
  @JsonKey(name: 'ext_power_state')
  final int? extPowerState; // 0 or other number
  @JsonKey(name: 'pref_run_mode')
  final String? prefRunMode; // 'low_power' or other string
  @JsonKey(name: 'run_mode')
  final String? runMode; // 'low_power', 'full_power', or other string
  @JsonKey(name: 'network_connection_value')
  final String? networkConnectionValue; // 'wifi' or other string
  @JsonKey(name: 'ac_power')
  final int? acPower; // 0 if not on ac power, 1 if ac power
  @JsonKey(name: 'battery_present')
  final bool? batteryPresent;
  @JsonKey(name: 'external_connection')
  final bool? externalConnection;
  @JsonKey(name: 'battery_percentage')
  final int? batteryPercentage; // 0 - 100
  @JsonKey(name: 'battery_percentage_category')
  final String? batteryPercentageCategory; // 'very_good', 'unknown', or other
  @JsonKey(name: 'firmware_version')
  final String? firmwareVersion; // e.g., 'cam-1.12.13000'
  @JsonKey(name: 'rssi_category')
  final String? rssiCategory; // 'good' or other string
  @JsonKey(name: 'battery_voltage_category')
  final String? batteryVoltageCategory; // 'very_good' or other string
  @JsonKey(name: 'second_battery_voltage_category')
  final String? secondBatteryVoltageCategory; // 'unknown' or other string
  @JsonKey(name: 'second_battery_percentage')
  final int? secondBatteryPercentage; // 0 - 100
  @JsonKey(name: 'second_battery_percentage_category')
  final String? secondBatteryPercentageCategory; // 'unknown' or other string
  @JsonKey(name: 'battery_save')
  final bool? batterySave;
  @JsonKey(name: 'firmware_version_status')
  final String? firmwareVersionStatus; // 'Up to Date'
  @JsonKey(name: 'tx_rate')
  final int? txRate;
  @JsonKey(name: 'ptz_connected')
  final String? ptzConnected; // 'penguin' or other string

  const CameraHealthData({
    this.deviceType,
    this.lastUpdateTime,
    this.connected,
    this.rssConnected,
    this.vodEnabled,
    this.sidewalkConnection,
    this.floodlightOn,
    this.sirenOn,
    this.whiteLedOn,
    this.nightModeOn,
    this.hatchOpen,
    this.packetLoss,
    this.packetLossCategory,
    this.rssi,
    this.batteryVoltage,
    this.wifiIsRingNetwork,
    this.supportedRpcCommands,
    this.otaStatus,
    this.extPowerState,
    this.prefRunMode,
    this.runMode,
    this.networkConnectionValue,
    this.acPower,
    this.batteryPresent,
    this.externalConnection,
    this.batteryPercentage,
    this.batteryPercentageCategory,
    this.firmwareVersion,
    this.rssiCategory,
    this.batteryVoltageCategory,
    this.secondBatteryVoltageCategory,
    this.secondBatteryPercentage,
    this.secondBatteryPercentageCategory,
    this.batterySave,
    this.firmwareVersionStatus,
    this.txRate,
    this.ptzConnected,
  });

  factory CameraHealthData.fromJson(Map<String, dynamic> json) =>
      _$CameraHealthDataFromJson(json);

  Map<String, dynamic> toJson() => _$CameraHealthDataToJson(this);
}

/// Base camera data structure
@JsonSerializable()
class BaseCameraData {
  final CameraAlerts? alerts;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'deactivated_at')
  final String? deactivatedAt;
  final String? description;
  @JsonKey(name: 'device_id')
  final String? deviceId;
  final CameraFeatures? features;
  final int? id;
  @JsonKey(name: 'is_sidewalk_gateway')
  final bool? isSidewalkGateway;
  @JsonKey(name: 'location_id')
  final String? locationId;
  @JsonKey(name: 'motion_snooze')
  final MotionSnooze? motionSnooze;
  @JsonKey(name: 'night_mode_status')
  final String? nightModeStatus; // 'unknown', 'true', or 'false'
  final bool? owned;
  @JsonKey(name: 'ring_net_id')
  final dynamic ringNetId;
  final CameraSettingsData? settings;
  final bool? subscribed;
  @JsonKey(name: 'subscribed_motions')
  final bool? subscribedMotions;
  @JsonKey(name: 'time_zone')
  final String? timeZone;
  @JsonKey(name: 'motion_detection_enabled')
  final bool? motionDetectionEnabled;
  @JsonKey(name: 'camera_location_indoor')
  final bool? cameraLocationIndoor;
  @JsonKey(name: 'facing_window')
  final bool? facingWindow;
  @JsonKey(name: 'enable_ir_led')
  final bool? enableIrLed;
  final CameraOwner? owner;
  @JsonKey(name: 'led_status')
  final dynamic ledStatus; // 'on', 'off', or object
  @JsonKey(name: 'ring_cam_light_installed')
  final dynamic ringCamLightInstalled; // 'true', 'false', or other types
  @JsonKey(name: 'ring_cam_setup_flow')
  final dynamic ringCamSetupFlow; // 'floodlight' or other types
  @JsonKey(name: 'siren_status')
  final SirenStatus? sirenStatus;
  final CameraHealthData? health;

  const BaseCameraData({
    this.alerts,
    this.createdAt,
    this.deactivatedAt,
    this.description,
    this.deviceId,
    this.features,
    this.id,
    this.isSidewalkGateway,
    this.locationId,
    this.motionSnooze,
    this.nightModeStatus,
    this.owned,
    required this.ringNetId,
    this.settings,
    this.subscribed,
    this.subscribedMotions,
    this.timeZone,
    this.motionDetectionEnabled,
    this.cameraLocationIndoor,
    this.facingWindow,
    this.enableIrLed,
    this.owner,
    this.ledStatus,
    this.ringCamLightInstalled,
    this.ringCamSetupFlow,
    this.sirenStatus,
    this.health,
  });

  factory BaseCameraData.fromJson(Map<String, dynamic> json) =>
      _$BaseCameraDataFromJson(json);

  Map<String, dynamic> toJson() => _$BaseCameraDataToJson(this);
}

/// Regular camera data (non-ONVIF)
@JsonSerializable()
class CameraData extends BaseCameraData {
  final String kind; // RingCameraKind except onvif_camera
  final String address;
  @JsonKey(name: 'battery_life')
  final dynamic batteryLife; // number, string, or null
  @JsonKey(name: 'battery_life_2')
  final dynamic batteryLife2; // number, string, or null
  @JsonKey(name: 'battery_voltage')
  final double? batteryVoltage;
  @JsonKey(name: 'battery_voltage_2')
  final double? batteryVoltage2;
  @JsonKey(name: 'external_connection')
  final bool? externalConnection;
  @JsonKey(name: 'firmware_version')
  final String? firmwareVersion;
  final double? latitude;
  final double? longitude;
  @JsonKey(name: 'ring_id')
  final dynamic ringId;
  final bool stolen;

  const CameraData({
    required this.kind,
    required this.address,
    required this.batteryLife,
    this.batteryLife2,
    this.batteryVoltage,
    this.batteryVoltage2,
    this.externalConnection,
    this.firmwareVersion,
    this.latitude,
    this.longitude,
    required this.ringId,
    required this.stolen,
    super.alerts,
    super.createdAt,
    super.deactivatedAt,
    super.description,
    super.deviceId,
    super.features,
    super.id,
    super.isSidewalkGateway,
    super.locationId,
    super.motionSnooze,
    super.nightModeStatus,
    super.owned,
    required super.ringNetId,
    super.settings,
    super.subscribed,
    super.subscribedMotions,
    super.timeZone,
    super.motionDetectionEnabled,
    super.cameraLocationIndoor,
    super.facingWindow,
    super.enableIrLed,
    super.owner,
    super.ledStatus,
    super.ringCamLightInstalled,
    super.ringCamSetupFlow,
    super.sirenStatus,
    super.health,
  });

  factory CameraData.fromJson(Map<String, dynamic> json) =>
      _$CameraDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CameraDataToJson(this);
}

/// ONVIF camera third party properties
@JsonSerializable()
class OnvifThirdPartyProperties {
  @JsonKey(name: 'amzn_dsn')
  final String amznDsn;
  final String uuid;

  const OnvifThirdPartyProperties({required this.amznDsn, required this.uuid});

  factory OnvifThirdPartyProperties.fromJson(Map<String, dynamic> json) =>
      _$OnvifThirdPartyPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$OnvifThirdPartyPropertiesToJson(this);
}

/// ONVIF camera metadata
@JsonSerializable()
class OnvifCameraMetadata {
  @JsonKey(name: 'legacy_fw_migrated')
  final bool legacyFwMigrated;
  @JsonKey(name: 'imported_from_amazon')
  final bool importedFromAmazon;
  @JsonKey(name: 'is_sidewalk_gateway')
  final bool isSidewalkGateway;
  @JsonKey(name: 'third_party_manufacturer')
  final String thirdPartyManufacturer;
  @JsonKey(name: 'third_party_model')
  final String thirdPartyModel;
  @JsonKey(name: 'third_party_dsn')
  final String thirdPartyDsn;
  @JsonKey(name: 'third_party_properties')
  final OnvifThirdPartyProperties thirdPartyProperties;

  const OnvifCameraMetadata({
    required this.legacyFwMigrated,
    required this.importedFromAmazon,
    required this.isSidewalkGateway,
    required this.thirdPartyManufacturer,
    required this.thirdPartyModel,
    required this.thirdPartyDsn,
    required this.thirdPartyProperties,
  });

  factory OnvifCameraMetadata.fromJson(Map<String, dynamic> json) =>
      _$OnvifCameraMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$OnvifCameraMetadataToJson(this);
}

/// ONVIF camera data
@JsonSerializable()
class OnvifCameraData extends BaseCameraData {
  final String kind; // Should be 'onvif_camera'
  final OnvifCameraMetadata metadata;
  @JsonKey(name: 'owner_id')
  final int ownerId;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const OnvifCameraData({
    required this.kind,
    required this.metadata,
    required this.ownerId,
    required this.updatedAt,
    required super.alerts,
    required super.createdAt,
    super.deactivatedAt,
    required super.description,
    required super.deviceId,
    required super.features,
    required super.id,
    required super.isSidewalkGateway,
    required super.locationId,
    super.motionSnooze,
    required super.nightModeStatus,
    required super.owned,
    required super.ringNetId,
    required super.settings,
    required super.subscribed,
    required super.subscribedMotions,
    required super.timeZone,
    super.motionDetectionEnabled,
    super.cameraLocationIndoor,
    super.facingWindow,
    super.enableIrLed,
    required super.owner,
    super.ledStatus,
    super.ringCamLightInstalled,
    super.ringCamSetupFlow,
    super.sirenStatus,
    required super.health,
  });

  factory OnvifCameraData.fromJson(Map<String, dynamic> json) =>
      _$OnvifCameraDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OnvifCameraDataToJson(this);
}

/// Third party garage door opener properties
@JsonSerializable()
class ThirdPartyGdoProperties {
  @JsonKey(name: 'key_access_point_associated')
  final String keyAccessPointAssociated; // 'true' or 'false'

  const ThirdPartyGdoProperties({required this.keyAccessPointAssociated});

  factory ThirdPartyGdoProperties.fromJson(Map<String, dynamic> json) =>
      _$ThirdPartyGdoPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$ThirdPartyGdoPropertiesToJson(this);
}

/// Third party garage door opener metadata
@JsonSerializable()
class ThirdPartyGdoMetadata {
  @JsonKey(name: 'is_sidewalk_gateway')
  final bool isSidewalkGateway;
  @JsonKey(name: 'third_party_manufacturer')
  final String thirdPartyManufacturer;
  @JsonKey(name: 'third_party_model')
  final String thirdPartyModel;
  @JsonKey(name: 'third_party_properties')
  final ThirdPartyGdoProperties thirdPartyProperties;
  @JsonKey(name: 'integration_type')
  final String integrationType; // 'Key by Amazon' or other string

  const ThirdPartyGdoMetadata({
    required this.isSidewalkGateway,
    required this.thirdPartyManufacturer,
    required this.thirdPartyModel,
    required this.thirdPartyProperties,
    required this.integrationType,
  });

  factory ThirdPartyGdoMetadata.fromJson(Map<String, dynamic> json) =>
      _$ThirdPartyGdoMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$ThirdPartyGdoMetadataToJson(this);
}

/// Third party garage door opener
@JsonSerializable()
class ThirdPartyGarageDoorOpener {
  final int id;
  final String kind; // Should be 'third_party_gdo'
  final String description;
  @JsonKey(name: 'location_id')
  final String locationId;
  @JsonKey(name: 'owner_id')
  final int ownerId;
  @JsonKey(name: 'hardware_id')
  final String hardwareId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  final String role; // 'owner' or other string
  final ThirdPartyGdoMetadata metadata;
  @JsonKey(name: 'ring_net_id')
  final dynamic ringNetId;
  @JsonKey(name: 'is_sidewalk_gateway')
  final bool isSidewalkGateway;

  const ThirdPartyGarageDoorOpener({
    required this.id,
    required this.kind,
    required this.description,
    required this.locationId,
    required this.ownerId,
    required this.hardwareId,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.metadata,
    required this.ringNetId,
    required this.isSidewalkGateway,
  });

  factory ThirdPartyGarageDoorOpener.fromJson(Map<String, dynamic> json) =>
      _$ThirdPartyGarageDoorOpenerFromJson(json);

  Map<String, dynamic> toJson() => _$ThirdPartyGarageDoorOpenerToJson(this);
}

/// Intercom function structure
@JsonSerializable()
class IntercomFunction {
  final dynamic name;

  const IntercomFunction({required this.name});

  factory IntercomFunction.fromJson(Map<String, dynamic> json) =>
      _$IntercomFunctionFromJson(json);

  Map<String, dynamic> toJson() => _$IntercomFunctionToJson(this);
}

/// Intercom chime settings
@JsonSerializable()
class IntercomChimeSettings {
  final int? type;
  final bool enable;
  final int? duration;

  const IntercomChimeSettings({this.type, required this.enable, this.duration});

  factory IntercomChimeSettings.fromJson(Map<String, dynamic> json) =>
      _$IntercomChimeSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$IntercomChimeSettingsToJson(this);
}

/// Intercom settings
@JsonSerializable()
class IntercomSettings {
  final String predecessor;
  final String config;
  @JsonKey(name: 'ring_to_open')
  final bool ringToOpen;
  @JsonKey(name: 'intercom_type')
  final String intercomType; // 'DF' or other string
  @JsonKey(name: 'unlock_mode')
  final int? unlockMode;
  final int? replication;

  const IntercomSettings({
    required this.predecessor,
    required this.config,
    required this.ringToOpen,
    required this.intercomType,
    this.unlockMode,
    this.replication,
  });

  factory IntercomSettings.fromJson(Map<String, dynamic> json) =>
      _$IntercomSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$IntercomSettingsToJson(this);
}

/// Intercom handset audio settings
@JsonSerializable()
class IntercomHandsetSettings {
  @JsonKey(name: 'show_recordings')
  final bool showRecordings;
  @JsonKey(name: 'recording_ttl')
  final int? recordingTtl;
  @JsonKey(name: 'recording_enabled')
  final bool recordingEnabled;
  @JsonKey(name: 'keep_alive')
  final dynamic keepAlive;
  @JsonKey(name: 'chime_settings')
  final IntercomChimeSettings chimeSettings;
  @JsonKey(name: 'intercom_settings')
  final IntercomSettings intercomSettings;
  @JsonKey(name: 'keep_alive_auto')
  final int? keepAliveAuto;
  @JsonKey(name: 'doorbell_volume')
  final int? doorbellVolume;
  @JsonKey(name: 'enable_chime')
  final int? enableChime;
  @JsonKey(name: 'theft_alarm_enable')
  final int? theftAlarmEnable;
  @JsonKey(name: 'use_cached_domain')
  final int? useCachedDomain;
  @JsonKey(name: 'use_server_ip')
  final int? useServerIp;
  @JsonKey(name: 'server_domain')
  final String serverDomain; // 'fw.ring.com' or other string
  @JsonKey(name: 'server_ip')
  final dynamic serverIp;
  @JsonKey(name: 'enable_log')
  final int? enableLog;
  @JsonKey(name: 'forced_keep_alive')
  final dynamic forcedKeepAlive;
  @JsonKey(name: 'mic_volume')
  final int? micVolume;
  @JsonKey(name: 'voice_volume')
  final int? voiceVolume;

  const IntercomHandsetSettings({
    required this.showRecordings,
    this.recordingTtl,
    required this.recordingEnabled,
    required this.keepAlive,
    required this.chimeSettings,
    required this.intercomSettings,
    this.keepAliveAuto,
    this.doorbellVolume,
    this.enableChime,
    this.theftAlarmEnable,
    this.useCachedDomain,
    this.useServerIp,
    required this.serverDomain,
    required this.serverIp,
    this.enableLog,
    required this.forcedKeepAlive,
    this.micVolume,
    this.voiceVolume,
  });

  factory IntercomHandsetSettings.fromJson(Map<String, dynamic> json) =>
      _$IntercomHandsetSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$IntercomHandsetSettingsToJson(this);
}

/// Intercom handset audio features
@JsonSerializable()
class IntercomHandsetFeatures {
  @JsonKey(name: 'motion_zone_recommendation')
  final bool motionZoneRecommendation;
  @JsonKey(name: 'motions_enabled')
  final bool motionsEnabled;
  @JsonKey(name: 'show_recordings')
  final bool showRecordings;
  @JsonKey(name: 'show_vod_settings')
  final bool showVodSettings;
  @JsonKey(name: 'rich_notifications_eligible')
  final bool richNotificationsEligible;
  @JsonKey(name: 'show_24x7_lite')
  final bool show24x7Lite;
  @JsonKey(name: 'show_offline_motion_events')
  final bool showOfflineMotionEvents;
  @JsonKey(name: 'cfes_eligible')
  final bool cfesEligible;
  @JsonKey(name: 'sheila_camera_eligible')
  final bool? sheilaCameraEligible;
  @JsonKey(name: 'sheila_camera_processing_eligible')
  final bool? sheilaCameraProcessingEligible;
  @JsonKey(name: 'chime_auto_detect_capable')
  final bool chimeAutoDetectCapable;

  const IntercomHandsetFeatures({
    required this.motionZoneRecommendation,
    required this.motionsEnabled,
    required this.showRecordings,
    required this.showVodSettings,
    required this.richNotificationsEligible,
    required this.show24x7Lite,
    required this.showOfflineMotionEvents,
    required this.cfesEligible,
    this.sheilaCameraEligible,
    this.sheilaCameraProcessingEligible,
    required this.chimeAutoDetectCapable,
  });

  factory IntercomHandsetFeatures.fromJson(Map<String, dynamic> json) =>
      _$IntercomHandsetFeaturesFromJson(json);

  Map<String, dynamic> toJson() => _$IntercomHandsetFeaturesToJson(this);
}

/// Intercom handset audio alerts
@JsonSerializable()
class IntercomHandsetAlerts {
  final String connection; // 'online', 'offline', or other string
  @JsonKey(name: 'ota_status')
  final String? otaStatus; // 'no_ota' or other string

  const IntercomHandsetAlerts({required this.connection, this.otaStatus});

  factory IntercomHandsetAlerts.fromJson(Map<String, dynamic> json) =>
      _$IntercomHandsetAlertsFromJson(json);

  Map<String, dynamic> toJson() => _$IntercomHandsetAlertsToJson(this);
}

/// Intercom handset audio metadata
@JsonSerializable()
class IntercomHandsetMetadata {
  final bool ethernet;
  @JsonKey(name: 'legacy_fw_migrated')
  final bool legacyFwMigrated;
  @JsonKey(name: 'imported_from_amazon')
  final bool importedFromAmazon;
  @JsonKey(name: 'is_sidewalk_gateway')
  final bool isSidewalkGateway;
  @JsonKey(name: 'key_access_point_associated')
  final bool keyAccessPointAssociated;

  const IntercomHandsetMetadata({
    required this.ethernet,
    required this.legacyFwMigrated,
    required this.importedFromAmazon,
    required this.isSidewalkGateway,
    required this.keyAccessPointAssociated,
  });

  factory IntercomHandsetMetadata.fromJson(Map<String, dynamic> json) =>
      _$IntercomHandsetMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$IntercomHandsetMetadataToJson(this);
}

/// Intercom handset audio data
@JsonSerializable()
class IntercomHandsetAudioData {
  final int? id;
  final String description;
  @JsonKey(name: 'device_id')
  final String deviceId;
  final String kind; // Should be 'intercom_handset_audio'
  final IntercomFunction function;
  final IntercomHandsetSettings settings;
  final IntercomHandsetFeatures features;
  final bool owned;
  final CameraOwner owner;
  final IntercomHandsetAlerts alerts;
  @JsonKey(name: 'firmware_version')
  final String firmwareVersion; // 'Up to Date' or other string
  @JsonKey(name: 'location_id')
  final String locationId;
  @JsonKey(name: 'time_zone')
  final String timeZone;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'ring_net_id')
  final dynamic ringNetId;
  @JsonKey(name: 'is_sidewalk_gateway')
  final bool isSidewalkGateway;
  final bool subscribed;
  @JsonKey(name: 'deactivated_at')
  final String? deactivatedAt;
  @JsonKey(name: 'battery_life')
  final String batteryLife;
  final IntercomHandsetMetadata metadata;

  const IntercomHandsetAudioData({
    this.id,
    required this.description,
    required this.deviceId,
    required this.kind,
    required this.function,
    required this.settings,
    required this.features,
    required this.owned,
    required this.owner,
    required this.alerts,
    required this.firmwareVersion,
    required this.locationId,
    required this.timeZone,
    required this.createdAt,
    required this.ringNetId,
    required this.isSidewalkGateway,
    required this.subscribed,
    this.deactivatedAt,
    required this.batteryLife,
    required this.metadata,
  });

  factory IntercomHandsetAudioData.fromJson(Map<String, dynamic> json) =>
      _$IntercomHandsetAudioDataFromJson(json);

  Map<String, dynamic> toJson() => _$IntercomHandsetAudioDataToJson(this);
}

/// Unknown device structure
@JsonSerializable()
class UnknownDevice {
  final int id;
  final dynamic kind;
  final String description;

  const UnknownDevice({
    required this.id,
    required this.kind,
    required this.description,
  });

  factory UnknownDevice.fromJson(Map<String, dynamic> json) =>
      _$UnknownDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$UnknownDeviceToJson(this);
}

/// CV detection type structure
@JsonSerializable()
class CvDetectionType {
  final bool enabled;
  final String mode;
  final bool notification;

  const CvDetectionType({
    required this.enabled,
    required this.mode,
    required this.notification,
  });

  factory CvDetectionType.fromJson(Map<String, dynamic> json) =>
      _$CvDetectionTypeFromJson(json);

  Map<String, dynamic> toJson() => _$CvDetectionTypeToJson(this);
}

/// Day/Night configuration
@JsonSerializable()
class DayNightConfig {
  final int day;
  final int night;

  const DayNightConfig({required this.day, required this.night});

  factory DayNightConfig.fromJson(Map<String, dynamic> json) =>
      _$DayNightConfigFromJson(json);

  Map<String, dynamic> toJson() => _$DayNightConfigToJson(this);
}

/// Advanced object settings
@JsonSerializable()
class AdvancedObjectSettings {
  @JsonKey(name: 'human_detection_confidence')
  final DayNightConfig humanDetectionConfidence;
  @JsonKey(name: 'motion_zone_overlap')
  final DayNightConfig motionZoneOverlap;
  @JsonKey(name: 'object_size_maximum')
  final DayNightConfig objectSizeMaximum;
  @JsonKey(name: 'object_size_minimum')
  final DayNightConfig objectSizeMinimum;
  @JsonKey(name: 'object_time_overlap')
  final DayNightConfig objectTimeOverlap;

  const AdvancedObjectSettings({
    required this.humanDetectionConfidence,
    required this.motionZoneOverlap,
    required this.objectSizeMaximum,
    required this.objectSizeMinimum,
    required this.objectTimeOverlap,
  });

  factory AdvancedObjectSettings.fromJson(Map<String, dynamic> json) =>
      _$AdvancedObjectSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AdvancedObjectSettingsToJson(this);
}

/// Advanced motion settings
@JsonSerializable()
class AdvancedMotionSettings {
  @JsonKey(name: 'active_motion_filter')
  final int activeMotionFilter;
  @JsonKey(name: 'advanced_object_settings')
  final AdvancedObjectSettings advancedObjectSettings;

  const AdvancedMotionSettings({
    required this.activeMotionFilter,
    required this.advancedObjectSettings,
  });

  factory AdvancedMotionSettings.fromJson(Map<String, dynamic> json) =>
      _$AdvancedMotionSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AdvancedMotionSettingsToJson(this);
}

/// Device chime settings
@JsonSerializable()
class DeviceChimeSettings {
  final int duration;
  final bool enable;
  @JsonKey(name: 'enable_ext')
  final bool enableExt;
  final int type;

  const DeviceChimeSettings({
    required this.duration,
    required this.enable,
    required this.enableExt,
    required this.type,
  });

  factory DeviceChimeSettings.fromJson(Map<String, dynamic> json) =>
      _$DeviceChimeSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceChimeSettingsToJson(this);
}

/// Motion settings
@JsonSerializable()
class MotionSettings {
  @JsonKey(name: 'enable_audio')
  final bool enableAudio;
  @JsonKey(name: 'motion_detection_enabled')
  final bool motionDetectionEnabled;
  @JsonKey(name: 'enable_ir_led')
  final bool enableIrLed;
  @JsonKey(name: 'advanced_motion_detection_enabled')
  final bool advancedMotionDetectionEnabled;
  @JsonKey(name: 'advanced_motion_detection_mode')
  final String advancedMotionDetectionMode;
  @JsonKey(name: 'advanced_motion_detection_human_only_mode')
  final bool advancedMotionDetectionHumanOnlyMode;
  @JsonKey(name: 'advanced_motion_detection_loitering_mode')
  final bool advancedMotionDetectionLoiteringMode;
  @JsonKey(name: 'motion_snooze_privacy_timeout')
  final int motionSnoozePrivacyTimeout;
  @JsonKey(name: 'advanced_motion_zones_enabled')
  final bool advancedMotionZonesEnabled;
  @JsonKey(name: 'advanced_motion_zones_type')
  final String advancedMotionZonesType;
  @JsonKey(name: 'enable_indoor_mode')
  final bool enableIndoorMode;
  @JsonKey(name: 'enable_pir_validation')
  final bool enablePirValidation;
  @JsonKey(name: 'loitering_threshold')
  final int loiteringThreshold;
  @JsonKey(name: 'enable_rlmd')
  final bool enableRlmd;
  @JsonKey(name: 'enable_recording')
  final bool enableRecording;
  @JsonKey(name: 'end_detection')
  final int endDetection;
  @JsonKey(name: 'advanced_motion_recording_human_mode')
  final bool advancedMotionRecordingHumanMode;
  @JsonKey(name: 'advanced_motion_glance_enabled')
  final bool advancedMotionGlanceEnabled;

  const MotionSettings({
    required this.enableAudio,
    required this.motionDetectionEnabled,
    required this.enableIrLed,
    required this.advancedMotionDetectionEnabled,
    required this.advancedMotionDetectionMode,
    required this.advancedMotionDetectionHumanOnlyMode,
    required this.advancedMotionDetectionLoiteringMode,
    required this.motionSnoozePrivacyTimeout,
    required this.advancedMotionZonesEnabled,
    required this.advancedMotionZonesType,
    required this.enableIndoorMode,
    required this.enablePirValidation,
    required this.loiteringThreshold,
    required this.enableRlmd,
    required this.enableRecording,
    required this.endDetection,
    required this.advancedMotionRecordingHumanMode,
    required this.advancedMotionGlanceEnabled,
  });

  factory MotionSettings.fromJson(Map<String, dynamic> json) =>
      _$MotionSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$MotionSettingsToJson(this);
}

/// Video settings
@JsonSerializable()
class VideoSettings {
  @JsonKey(name: 'exposure_control')
  final int exposureControl;
  @JsonKey(name: 'night_color_enable')
  final bool nightColorEnable;
  @JsonKey(name: 'hdr_enable')
  final bool hdrEnable;
  @JsonKey(name: 'clip_length_max')
  final int clipLengthMax;
  @JsonKey(name: 'clip_length_min')
  final int clipLengthMin;
  @JsonKey(name: 'ae_mode')
  final int aeMode;
  @JsonKey(name: 'ae_mask')
  final String aeMask;

  const VideoSettings({
    required this.exposureControl,
    required this.nightColorEnable,
    required this.hdrEnable,
    required this.clipLengthMax,
    required this.clipLengthMin,
    required this.aeMode,
    required this.aeMask,
  });

  factory VideoSettings.fromJson(Map<String, dynamic> json) =>
      _$VideoSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$VideoSettingsToJson(this);
}

/// VOD settings
@JsonSerializable()
class VodSettings {
  final bool enable;
  @JsonKey(name: 'toggled_at')
  final String toggledAt; // date
  @JsonKey(name: 'use_cached_vod_domain')
  final bool useCachedVodDomain;

  const VodSettings({
    required this.enable,
    required this.toggledAt,
    required this.useCachedVodDomain,
  });

  factory VodSettings.fromJson(Map<String, dynamic> json) =>
      _$VodSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$VodSettingsToJson(this);
}

/// Volume settings
@JsonSerializable()
class VolumeSettings {
  @JsonKey(name: 'doorbell_volume')
  final int doorbellVolume;
  @JsonKey(name: 'mic_volume')
  final int micVolume;
  @JsonKey(name: 'voice_volume')
  final int voiceVolume;

  const VolumeSettings({
    required this.doorbellVolume,
    required this.micVolume,
    required this.voiceVolume,
  });

  factory VolumeSettings.fromJson(Map<String, dynamic> json) =>
      _$VolumeSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$VolumeSettingsToJson(this);
}

/// CV detection types
@JsonSerializable()
class CvDetectionTypes {
  final CvDetectionType human;
  final CvDetectionType loitering;
  final CvDetectionType motion;
  @JsonKey(name: 'moving_vehicle')
  final CvDetectionType movingVehicle;
  @JsonKey(name: 'nearby_pom')
  final CvDetectionType nearbyPom;
  @JsonKey(name: 'other_motion')
  final CvDetectionType otherMotion;
  @JsonKey(name: 'package_delivery')
  final CvDetectionType packageDelivery;
  @JsonKey(name: 'package_pickup')
  final CvDetectionType packagePickup;

  const CvDetectionTypes({
    required this.human,
    required this.loitering,
    required this.motion,
    required this.movingVehicle,
    required this.nearbyPom,
    required this.otherMotion,
    required this.packageDelivery,
    required this.packagePickup,
  });

  factory CvDetectionTypes.fromJson(Map<String, dynamic> json) =>
      _$CvDetectionTypesFromJson(json);

  Map<String, dynamic> toJson() => _$CvDetectionTypesToJson(this);
}

/// CV threshold
@JsonSerializable()
class CvThreshold {
  final int loitering;
  @JsonKey(name: 'package_delivery')
  final int packageDelivery;

  const CvThreshold({required this.loitering, required this.packageDelivery});

  factory CvThreshold.fromJson(Map<String, dynamic> json) =>
      _$CvThresholdFromJson(json);

  Map<String, dynamic> toJson() => _$CvThresholdToJson(this);
}

/// CV settings
@JsonSerializable()
class CvSettings {
  @JsonKey(name: 'detection_types')
  final CvDetectionTypes detectionTypes;
  final CvThreshold threshold;

  const CvSettings({required this.detectionTypes, required this.threshold});

  factory CvSettings.fromJson(Map<String, dynamic> json) =>
      _$CvSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$CvSettingsToJson(this);
}

/// General settings
@JsonSerializable()
class GeneralSettings {
  @JsonKey(name: 'enable_audio_recording')
  final bool enableAudioRecording;
  @JsonKey(name: 'lite_24x7_enabled')
  final bool lite24x7Enabled;
  @JsonKey(name: 'offline_motion_event_enabled')
  final bool offlineMotionEventEnabled;
  @JsonKey(name: 'lite_24x7_subscribed')
  final bool lite24x7Subscribed;
  @JsonKey(name: 'offline_motion_event_subscribed')
  final bool offlineMotionEventSubscribed;
  @JsonKey(name: 'firmwares_locked')
  final bool firmwaresLocked;
  @JsonKey(name: 'utc_offset')
  final String utcOffset;
  @JsonKey(name: 'theft_alarm_enable')
  final bool theftAlarmEnable;
  @JsonKey(name: 'use_wrapup_domain')
  final bool useWrapupDomain;
  @JsonKey(name: 'power_mode')
  final String powerMode; // 'battery' or 'wired'
  @JsonKey(name: 'data_collection_enabled')
  final bool dataCollectionEnabled;

  const GeneralSettings({
    required this.enableAudioRecording,
    required this.lite24x7Enabled,
    required this.offlineMotionEventEnabled,
    required this.lite24x7Subscribed,
    required this.offlineMotionEventSubscribed,
    required this.firmwaresLocked,
    required this.utcOffset,
    required this.theftAlarmEnable,
    required this.useWrapupDomain,
    required this.powerMode,
    required this.dataCollectionEnabled,
  });

  factory GeneralSettings.fromJson(Map<String, dynamic> json) =>
      _$GeneralSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$GeneralSettingsToJson(this);
}

/// Keep alive settings
@JsonSerializable()
class KeepAliveSettings {
  @JsonKey(name: 'keep_alive_auto')
  final int keepAliveAuto;

  const KeepAliveSettings({required this.keepAliveAuto});

  factory KeepAliveSettings.fromJson(Map<String, dynamic> json) =>
      _$KeepAliveSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$KeepAliveSettingsToJson(this);
}

/// PIR settings
@JsonSerializable()
class PirSettings {
  @JsonKey(name: 'sensitivity_1')
  final int sensitivity1;
  @JsonKey(name: 'sensitivity_2')
  final int sensitivity2;
  @JsonKey(name: 'sensitivity_3')
  final int sensitivity3;
  @JsonKey(name: 'zone_enable')
  final int zoneEnable;

  const PirSettings({
    required this.sensitivity1,
    required this.sensitivity2,
    required this.sensitivity3,
    required this.zoneEnable,
  });

  factory PirSettings.fromJson(Map<String, dynamic> json) =>
      _$PirSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$PirSettingsToJson(this);
}

/// Snapshot settings
@JsonSerializable()
class SnapshotSettings {
  @JsonKey(name: 'frequency_secs')
  final int frequencySecs;
  @JsonKey(name: 'lite_24x7_resolution_p')
  final int lite24x7ResolutionP;
  @JsonKey(name: 'ome_resolution_p')
  final int omeResolutionP;
  @JsonKey(name: 'max_upload_kb')
  final int maxUploadKb;
  @JsonKey(name: 'frequency_after_secs')
  final int frequencyAfterSecs;
  @JsonKey(name: 'period_after_secs')
  final int periodAfterSecs;
  @JsonKey(name: 'close_container')
  final int closeContainer;

  const SnapshotSettings({
    required this.frequencySecs,
    required this.lite24x7ResolutionP,
    required this.omeResolutionP,
    required this.maxUploadKb,
    required this.frequencyAfterSecs,
    required this.periodAfterSecs,
    required this.closeContainer,
  });

  factory SnapshotSettings.fromJson(Map<String, dynamic> json) =>
      _$SnapshotSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SnapshotSettingsToJson(this);
}

/// Client device settings
@JsonSerializable()
class ClientDeviceSettings {
  @JsonKey(name: 'ringtones_enabled')
  final bool ringtonesEnabled;
  @JsonKey(name: 'people_only_enabled')
  final bool peopleOnlyEnabled;
  @JsonKey(name: 'advanced_motion_enabled')
  final bool advancedMotionEnabled;
  @JsonKey(name: 'motion_message_enabled')
  final bool motionMessageEnabled;
  @JsonKey(name: 'shadow_correction_enabled')
  final bool shadowCorrectionEnabled;
  @JsonKey(name: 'night_vision_enabled')
  final bool nightVisionEnabled;
  @JsonKey(name: 'light_schedule_enabled')
  final bool lightScheduleEnabled;
  @JsonKey(name: 'rich_notifications_eligible')
  final bool richNotificationsEligible;
  @JsonKey(name: 'show_24x7_lite')
  final bool show24x7Lite;
  @JsonKey(name: 'show_offline_motion_events')
  final bool showOfflineMotionEvents;
  @JsonKey(name: 'cfes_eligible')
  final bool cfesEligible;
  @JsonKey(name: 'show_radar_data')
  final bool showRadarData;
  @JsonKey(name: 'motion_zone_recommendation')
  final bool motionZoneRecommendation;

  const ClientDeviceSettings({
    required this.ringtonesEnabled,
    required this.peopleOnlyEnabled,
    required this.advancedMotionEnabled,
    required this.motionMessageEnabled,
    required this.shadowCorrectionEnabled,
    required this.nightVisionEnabled,
    required this.lightScheduleEnabled,
    required this.richNotificationsEligible,
    required this.show24x7Lite,
    required this.showOfflineMotionEvents,
    required this.cfesEligible,
    required this.showRadarData,
    required this.motionZoneRecommendation,
  });

  factory ClientDeviceSettings.fromJson(Map<String, dynamic> json) =>
      _$ClientDeviceSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$ClientDeviceSettingsToJson(this);
}

/// Alexa settings
@JsonSerializable()
class AlexaSettings {
  @JsonKey(name: 'delay_ms')
  final int delayMs;

  const AlexaSettings({required this.delayMs});

  factory AlexaSettings.fromJson(Map<String, dynamic> json) =>
      _$AlexaSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AlexaSettingsToJson(this);
}

/// Autoreply settings
@JsonSerializable()
class AutoreplySettings {
  @JsonKey(name: 'delay_ms')
  final int delayMs;

  const AutoreplySettings({required this.delayMs});

  factory AutoreplySettings.fromJson(Map<String, dynamic> json) =>
      _$AutoreplySettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AutoreplySettingsToJson(this);
}

/// Concierge settings
@JsonSerializable()
class ConciergeSettings {
  @JsonKey(name: 'alexa_settings')
  final AlexaSettings? alexaSettings;
  @JsonKey(name: 'autoreply_settings')
  final AutoreplySettings? autoreplySettings;
  final String? mode;

  const ConciergeSettings({
    this.alexaSettings,
    this.autoreplySettings,
    this.mode,
  });

  factory ConciergeSettings.fromJson(Map<String, dynamic> json) =>
      _$ConciergeSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$ConciergeSettingsToJson(this);
}

/// Camera device settings data (complete structure)
@JsonSerializable()
class CameraDeviceSettingsData {
  @JsonKey(name: 'advanced_motion_settings')
  final AdvancedMotionSettings advancedMotionSettings;
  @JsonKey(name: 'chime_settings')
  final DeviceChimeSettings chimeSettings;
  @JsonKey(name: 'motion_settings')
  final MotionSettings motionSettings;
  @JsonKey(name: 'video_settings')
  final VideoSettings videoSettings;
  @JsonKey(name: 'vod_settings')
  final VodSettings vodSettings;
  @JsonKey(name: 'volume_settings')
  final VolumeSettings volumeSettings;
  @JsonKey(name: 'cv_settings')
  final CvSettings cvSettings;
  @JsonKey(name: 'general_settings')
  final GeneralSettings generalSettings;
  @JsonKey(name: 'keep_alive_settings')
  final KeepAliveSettings keepAliveSettings;
  @JsonKey(name: 'pir_settings')
  final PirSettings pirSettings;
  @JsonKey(name: 'snapshot_settings')
  final SnapshotSettings snapshotSettings;
  @JsonKey(name: 'client_device_settings')
  final ClientDeviceSettings clientDeviceSettings;
  @JsonKey(name: 'concierge_settings')
  final ConciergeSettings? conciergeSettings;

  const CameraDeviceSettingsData({
    required this.advancedMotionSettings,
    required this.chimeSettings,
    required this.motionSettings,
    required this.videoSettings,
    required this.vodSettings,
    required this.volumeSettings,
    required this.cvSettings,
    required this.generalSettings,
    required this.keepAliveSettings,
    required this.pirSettings,
    required this.snapshotSettings,
    required this.clientDeviceSettings,
    this.conciergeSettings,
  });

  factory CameraDeviceSettingsData.fromJson(Map<String, dynamic> json) =>
      _$CameraDeviceSettingsDataFromJson(json);

  Map<String, dynamic> toJson() => _$CameraDeviceSettingsDataToJson(this);
}

/// Health category type
/// Can be 'very_poor', 'poor', 'good', 'very_good', 'unknown', 'NA', or other string
typedef HealthCategory = String?;

/// Chime health information
@JsonSerializable()
class ChimeHealth {
  final int id;
  @JsonKey(name: 'wifi_name')
  final String wifiName;
  @JsonKey(name: 'battery_percentage')
  final HealthCategory batteryPercentage;
  @JsonKey(name: 'battery_percentage_category')
  final HealthCategory batteryPercentageCategory;
  @JsonKey(name: 'battery_voltage')
  final double? batteryVoltage;
  @JsonKey(name: 'battery_voltage_category')
  final HealthCategory batteryVoltageCategory;
  @JsonKey(name: 'latest_signal_strength')
  final int latestSignalStrength;
  @JsonKey(name: 'latest_signal_category')
  final HealthCategory latestSignalCategory;
  @JsonKey(name: 'average_signal_strength')
  final int averageSignalStrength;
  @JsonKey(name: 'average_signal_category')
  final HealthCategory averageSignalCategory;
  final Firmware firmware;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'wifi_is_ring_network')
  final bool wifiIsRingNetwork;
  @JsonKey(name: 'packet_loss_category')
  final HealthCategory packetLossCategory;
  @JsonKey(name: 'packet_loss_strength')
  final int packetLossStrength;

  const ChimeHealth({
    required this.id,
    required this.wifiName,
    required this.batteryPercentage,
    required this.batteryPercentageCategory,
    this.batteryVoltage,
    required this.batteryVoltageCategory,
    required this.latestSignalStrength,
    required this.latestSignalCategory,
    required this.averageSignalStrength,
    required this.averageSignalCategory,
    required this.firmware,
    required this.updatedAt,
    required this.wifiIsRingNetwork,
    required this.packetLossCategory,
    required this.packetLossStrength,
  });

  factory ChimeHealth.fromJson(Map<String, dynamic> json) =>
      _$ChimeHealthFromJson(json);

  Map<String, dynamic> toJson() => _$ChimeHealthToJson(this);
}

/// Camera health information (extends ChimeHealth)
@JsonSerializable()
class CameraHealth extends ChimeHealth {
  @JsonKey(name: 'transformer_voltage')
  final int? transformerVoltage;
  @JsonKey(name: 'transformer_voltage_category')
  final String? transformerVoltageCategory; // 'good' or other
  @JsonKey(name: 'ext_power_state')
  final int? extPowerState;

  const CameraHealth({
    this.transformerVoltage,
    this.transformerVoltageCategory,
    this.extPowerState,
    required super.id,
    required super.wifiName,
    required super.batteryPercentage,
    required super.batteryPercentageCategory,
    super.batteryVoltage,
    required super.batteryVoltageCategory,
    required super.latestSignalStrength,
    required super.latestSignalCategory,
    required super.averageSignalStrength,
    required super.averageSignalCategory,
    required super.firmware,
    required super.updatedAt,
    required super.wifiIsRingNetwork,
    required super.packetLossCategory,
    required super.packetLossStrength,
  });

  factory CameraHealth.fromJson(Map<String, dynamic> json) =>
      _$CameraHealthFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CameraHealthToJson(this);
}

/// Ding kind type
/// Represents various event types for cameras and doorbells
typedef DingKind = String;

/// Common ding kinds
class DingKindConstants {
  static const String motion = 'motion';
  static const String ding = 'ding';
  static const String onDemand = 'on_demand'; // Live View
  static const String alarm = 'alarm'; // Linked Event - Alarm
  static const String onDemandLink = 'on_demand_link'; // Linked Event - Motion
  static const String doorActivity = 'door_activity'; // knock
  static const String keyAccess = 'key_access';
  static const String deletedFootage = 'DELETED_FOOTAGE';
  static const String offlineFootage = 'OFFLINE_FOOTAGE';
  static const String offlineMotion = 'OFFLINE_MOTION';
}

/// Ding state type
typedef DingState = String;

/// Common ding states
class DingStateConstants {
  static const String ringing = 'ringing';
  static const String connected = 'connected';
  static const String timedOut = 'timed_out';
  static const String completed = 'completed';
}

/// CV properties structure
@JsonSerializable()
class CvProperties {
  @JsonKey(name: 'detection_type')
  final dynamic detectionType;
  @JsonKey(name: 'person_detected')
  final dynamic personDetected;
  @JsonKey(name: 'stream_broken')
  final dynamic streamBroken;

  const CvProperties({
    required this.detectionType,
    required this.personDetected,
    required this.streamBroken,
  });

  factory CvProperties.fromJson(Map<String, dynamic> json) =>
      _$CvPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$CvPropertiesToJson(this);
}

/// Camera event structure
@JsonSerializable()
class CameraEvent {
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'cv_properties')
  final CvProperties cvProperties;
  @JsonKey(name: 'ding_id')
  final int dingId;
  @JsonKey(name: 'ding_id_str')
  final String dingIdStr;
  @JsonKey(name: 'doorbot_id')
  final int doorbotId;
  final bool favorite;
  final DingKind kind;
  final bool recorded;
  @JsonKey(name: 'recording_status')
  final String recordingStatus; // 'ready' or 'audio_ready'
  final String state; // 'timed_out' or 'completed'

  const CameraEvent({
    required this.createdAt,
    required this.cvProperties,
    required this.dingId,
    required this.dingIdStr,
    required this.doorbotId,
    required this.favorite,
    required this.kind,
    required this.recorded,
    required this.recordingStatus,
    required this.state,
  });

  factory CameraEvent.fromJson(Map<String, dynamic> json) =>
      _$CameraEventFromJson(json);

  Map<String, dynamic> toJson() => _$CameraEventToJson(this);
}

/// Pagination metadata
@JsonSerializable()
class PaginationMeta {
  @JsonKey(name: 'pagination_key')
  final String paginationKey;

  const PaginationMeta({required this.paginationKey});

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationMetaToJson(this);
}

/// Camera event response
@JsonSerializable()
class CameraEventResponse {
  final List<CameraEvent> events;
  final PaginationMeta meta;

  const CameraEventResponse({required this.events, required this.meta});

  factory CameraEventResponse.fromJson(Map<String, dynamic> json) =>
      _$CameraEventResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CameraEventResponseToJson(this);
}

/// Camera event options for querying
@JsonSerializable()
class CameraEventOptions {
  final int? limit;
  final DingKind? kind;
  final String? state; // 'missed', 'accepted', or 'person_detected'
  final bool? favorites;
  final String? olderThanId; // alias for pagination_key
  final String? paginationKey;

  const CameraEventOptions({
    this.limit,
    this.kind,
    this.state,
    this.favorites,
    this.olderThanId,
    this.paginationKey,
  });

  factory CameraEventOptions.fromJson(Map<String, dynamic> json) =>
      _$CameraEventOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$CameraEventOptionsToJson(this);
}

/// Video search result
@JsonSerializable()
class VideoSearchResult {
  @JsonKey(name: 'ding_id')
  final String dingId;
  @JsonKey(name: 'created_at')
  final int createdAt;
  @JsonKey(name: 'hq_url')
  final String? hqUrl;
  @JsonKey(name: 'lq_url')
  final String lqUrl;
  @JsonKey(name: 'preroll_duration')
  final dynamic prerollDuration;
  @JsonKey(name: 'thumbnail_url')
  final String thumbnailUrl;
  @JsonKey(name: 'untranscoded_url')
  final String untranscodedUrl;
  final DingKind kind;
  final String state; // 'timed_out' or 'completed'
  @JsonKey(name: 'had_subscription')
  final bool hadSubscription;
  final bool favorite;
  final int duration;
  @JsonKey(name: 'cv_properties')
  final CvProperties cvProperties;

  const VideoSearchResult({
    required this.dingId,
    required this.createdAt,
    this.hqUrl,
    required this.lqUrl,
    required this.prerollDuration,
    required this.thumbnailUrl,
    required this.untranscodedUrl,
    required this.kind,
    required this.state,
    required this.hadSubscription,
    required this.favorite,
    required this.duration,
    required this.cvProperties,
  });

  factory VideoSearchResult.fromJson(Map<String, dynamic> json) =>
      _$VideoSearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$VideoSearchResultToJson(this);
}

/// Video search response
@JsonSerializable()
class VideoSearchResponse {
  @JsonKey(name: 'video_search')
  final List<VideoSearchResult> videoSearch;

  const VideoSearchResponse({required this.videoSearch});

  factory VideoSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$VideoSearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VideoSearchResponseToJson(this);
}

/// Periodical footage structure
@JsonSerializable()
class PeriodicalFootage {
  @JsonKey(name: 'start_ms')
  final int startMs;
  @JsonKey(name: 'end_ms')
  final int endMs;
  @JsonKey(name: 'playback_ms')
  final int playbackMs;
  final String kind; // 'online_periodical' or 'offline_periodical'
  final String url;
  final bool deleted;
  final List<int> snapshots;

  const PeriodicalFootage({
    required this.startMs,
    required this.endMs,
    required this.playbackMs,
    required this.kind,
    required this.url,
    required this.deleted,
    required this.snapshots,
  });

  factory PeriodicalFootage.fromJson(Map<String, dynamic> json) =>
      _$PeriodicalFootageFromJson(json);

  Map<String, dynamic> toJson() => _$PeriodicalFootageToJson(this);
}

/// Periodic footage metadata
@JsonSerializable()
class PeriodicFootageMeta {
  @JsonKey(name: 'pagination_key')
  final int paginationKey;
  @JsonKey(name: 'butch_size')
  final int butchSize;

  const PeriodicFootageMeta({
    required this.paginationKey,
    required this.butchSize,
  });

  factory PeriodicFootageMeta.fromJson(Map<String, dynamic> json) =>
      _$PeriodicFootageMetaFromJson(json);

  Map<String, dynamic> toJson() => _$PeriodicFootageMetaToJson(this);
}

/// Periodic footage response
@JsonSerializable()
class PeriodicFootageResponse {
  final PeriodicFootageMeta meta;
  final List<PeriodicalFootage> data;
  @JsonKey(name: 'responseTimestamp')
  final int responseTimestamp;

  const PeriodicFootageResponse({
    required this.meta,
    required this.data,
    required this.responseTimestamp,
  });

  factory PeriodicFootageResponse.fromJson(Map<String, dynamic> json) =>
      _$PeriodicFootageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PeriodicFootageResponseToJson(this);
}

/// History options for querying device history
@JsonSerializable()
class HistoryOptions {
  final int? limit;
  final int? offset;
  final String? category; // 'alarm' or 'beams'
  final int? maxLevel;

  const HistoryOptions({this.limit, this.offset, this.category, this.maxLevel});

  factory HistoryOptions.fromJson(Map<String, dynamic> json) =>
      _$HistoryOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryOptionsToJson(this);
}

/// Ring device history event
@JsonSerializable()
class RingDeviceHistoryEvent {
  final String msg; // 'DataUpdate'
  final MessageDataType datatype;
  final dynamic body; // Skipping detailed structure for now

  const RingDeviceHistoryEvent({
    required this.msg,
    required this.datatype,
    required this.body,
  });

  factory RingDeviceHistoryEvent.fromJson(Map<String, dynamic> json) =>
      _$RingDeviceHistoryEventFromJson(json);

  Map<String, dynamic> toJson() => _$RingDeviceHistoryEventToJson(this);
}

/// Notification detection type constants
class NotificationDetectionType {
  static const String human = 'human';
  static const String loitering = 'loitering';
  static const String motion = 'motion';
  static const String otherMotion = 'other_motion';
  static const String notAvailable = 'null';
  static const String streamBroken = 'stream_broken';
}

/// Push notification action constants
class PushNotificationAction {
  static const String ding = 'com.ring.pn.live-event.ding';
  static const String motion = 'com.ring.pn.live-event.motion';
  static const String intercomDing = 'com.ring.pn.live-event.intercom';
  static const String intercomUnlock = 'com.ring.push.INTERCOM_UNLOCK_FROM_APP';
  static const String alarmModeNone =
      'com.ring.push.HANDLE_NEW_SECURITY_PANEL_MODE_NONE_NOTICE';
  static const String alarmModeSome =
      'com.ring.push.HANDLE_NEW_SECURITY_PANEL_MODE_SOME_NOTICE';
  static const String alarmSoundSiren =
      'com.ring.push.HANDLE_NEW_USER_SOUND_SIREN';
  static const String alarmSilenceSiren =
      'com.ring.push.HANDLE_NEW_NON_ALARM_SIREN_SILENCED';
}

/// Push notification Android config
@JsonSerializable()
class PushNotificationAndroidConfig {
  final String category; // PushNotificationAction or other string
  final String body;

  const PushNotificationAndroidConfig({
    required this.category,
    required this.body,
  });

  factory PushNotificationAndroidConfig.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationAndroidConfigFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationAndroidConfigToJson(this);
}

/// Push notification analytics
@JsonSerializable()
class PushNotificationAnalytics {
  @JsonKey(name: 'server_correlation_id')
  final String serverCorrelationId;
  @JsonKey(name: 'server_id')
  final String serverId; // 'com.ring.pns' or other string
  final String subcategory;
  @JsonKey(name: 'triggered_at')
  final int triggeredAt;
  @JsonKey(name: 'sent_at')
  final int sentAt;
  @JsonKey(name: 'referring_item_type')
  final String referringItemType;
  @JsonKey(name: 'referring_item_id')
  final String referringItemId;

  const PushNotificationAnalytics({
    required this.serverCorrelationId,
    required this.serverId,
    required this.subcategory,
    required this.triggeredAt,
    required this.sentAt,
    required this.referringItemType,
    required this.referringItemId,
  });

  factory PushNotificationAnalytics.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationAnalyticsFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationAnalyticsToJson(this);
}

/// Push notification device
@JsonSerializable()
class PushNotificationDevice {
  @JsonKey(name: 'e2ee_enabled')
  final bool e2eeEnabled;
  final int id;
  final String kind; // RingCameraKind or RingDeviceType
  final String name;

  const PushNotificationDevice({
    required this.e2eeEnabled,
    required this.id,
    required this.kind,
    required this.name,
  });

  factory PushNotificationDevice.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationDeviceToJson(this);
}

/// Push notification ding details
@JsonSerializable()
class PushNotificationDing {
  final String id;
  @JsonKey(name: 'created_at')
  final String createdAt;
  final String subtype; // 'other_motion', 'motion', 'ding', 'human', etc.
  @JsonKey(name: 'detection_type')
  final String? detectionType; // NotificationDetectionType

  const PushNotificationDing({
    required this.id,
    required this.createdAt,
    required this.subtype,
    this.detectionType,
  });

  factory PushNotificationDing.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationDingFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationDingToJson(this);
}

/// Push notification eventito
@JsonSerializable()
class PushNotificationEventito {
  final String type; // NotificationDetectionType
  final int timestamp;

  const PushNotificationEventito({required this.type, required this.timestamp});

  factory PushNotificationEventito.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationEventitoFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationEventitoToJson(this);
}

/// Push notification live session
@JsonSerializable()
class PushNotificationLiveSession {
  @JsonKey(name: 'streaming_data_hash')
  final String streamingDataHash;
  @JsonKey(name: 'active_streaming_profile')
  final String activeStreamingProfile; // 'rms' or other string
  @JsonKey(name: 'default_audio_route')
  final String defaultAudioRoute;
  @JsonKey(name: 'max_duration')
  final int maxDuration;

  const PushNotificationLiveSession({
    required this.streamingDataHash,
    required this.activeStreamingProfile,
    required this.defaultAudioRoute,
    required this.maxDuration,
  });

  factory PushNotificationLiveSession.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationLiveSessionFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationLiveSessionToJson(this);
}

/// Push notification event
@JsonSerializable()
class PushNotificationEvent {
  final PushNotificationDing ding;
  final PushNotificationEventito eventito;
  final String riid;
  @JsonKey(name: 'is_sidewalk')
  final bool isSidewalk;
  @JsonKey(name: 'live_session')
  final PushNotificationLiveSession liveSession;

  const PushNotificationEvent({
    required this.ding,
    required this.eventito,
    required this.riid,
    required this.isSidewalk,
    required this.liveSession,
  });

  factory PushNotificationEvent.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationEventFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationEventToJson(this);
}

/// Push notification location
@JsonSerializable()
class PushNotificationLocation {
  final String id;

  const PushNotificationLocation({required this.id});

  factory PushNotificationLocation.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationLocationFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationLocationToJson(this);
}

/// Push notification data payload
@JsonSerializable()
class PushNotificationDingData {
  final PushNotificationDevice device;
  final PushNotificationEvent event;
  final PushNotificationLocation location;

  const PushNotificationDingData({
    required this.device,
    required this.event,
    required this.location,
  });

  factory PushNotificationDingData.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationDingDataFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationDingDataToJson(this);
}

/// Push notification image
@JsonSerializable()
class PushNotificationImage {
  @JsonKey(name: 'snapshot_uuid')
  final String snapshotUuid;

  const PushNotificationImage({required this.snapshotUuid});

  factory PushNotificationImage.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationImageFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationImageToJson(this);
}

/// Push notification ding v2 (for motion/ding events)
@JsonSerializable()
class PushNotificationDingV2 {
  final String version; // '2.0.0' or other string
  @JsonKey(name: 'android_config')
  final PushNotificationAndroidConfig androidConfig;
  final PushNotificationAnalytics analytics;
  final PushNotificationDingData data;
  final PushNotificationImage? img;

  const PushNotificationDingV2({
    required this.version,
    required this.androidConfig,
    required this.analytics,
    required this.data,
    this.img,
  });

  factory PushNotificationDingV2.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationDingV2FromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationDingV2ToJson(this);
}

/// Push notification APS (Apple Push Service) structure
@JsonSerializable()
class PushNotificationAps {
  final String alert;

  const PushNotificationAps({required this.alert});

  factory PushNotificationAps.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationApsFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationApsToJson(this);
}

/// Push notification alarm meta
@JsonSerializable()
class PushNotificationAlarmMeta {
  @JsonKey(name: 'device_zid')
  final int deviceZid;
  @JsonKey(name: 'location_id')
  final String locationId;

  const PushNotificationAlarmMeta({
    required this.deviceZid,
    required this.locationId,
  });

  factory PushNotificationAlarmMeta.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationAlarmMetaFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationAlarmMetaToJson(this);
}

/// Push notification alarm inner structure
@JsonSerializable()
class PushNotificationAlarm {
  final PushNotificationAps aps;
  final String action; // PushNotificationAction or other string
  final PushNotificationAlarmMeta alarmMeta;

  const PushNotificationAlarm({
    required this.aps,
    required this.action,
    required this.alarmMeta,
  });

  factory PushNotificationAlarm.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationAlarmFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationAlarmToJson(this);
}

/// Push notification alarm v2 wrapper
@JsonSerializable()
class PushNotificationAlarmV2 {
  final PushNotificationAlarmGcmData data;

  const PushNotificationAlarmV2({required this.data});

  factory PushNotificationAlarmV2.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationAlarmV2FromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationAlarmV2ToJson(this);
}

/// Push notification alarm GCM data wrapper
@JsonSerializable()
class PushNotificationAlarmGcmData {
  final PushNotificationAlarm gcmData;

  const PushNotificationAlarmGcmData({required this.gcmData});

  factory PushNotificationAlarmGcmData.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationAlarmGcmDataFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationAlarmGcmDataToJson(this);
}

/// Push notification intercom unlock inner structure
@JsonSerializable()
class PushNotificationIntercomUnlock {
  final PushNotificationAps aps;
  final String action; // Should be PushNotificationAction.IntercomUnlock
  final PushNotificationAlarmMeta alarmMeta;

  const PushNotificationIntercomUnlock({
    required this.aps,
    required this.action,
    required this.alarmMeta,
  });

  factory PushNotificationIntercomUnlock.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationIntercomUnlockFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationIntercomUnlockToJson(this);
}

/// Push notification intercom unlock v2 wrapper
@JsonSerializable()
class PushNotificationIntercomUnlockV2 {
  final PushNotificationIntercomUnlockGcmData data;

  const PushNotificationIntercomUnlockV2({required this.data});

  factory PushNotificationIntercomUnlockV2.fromJson(
    Map<String, dynamic> json,
  ) => _$PushNotificationIntercomUnlockV2FromJson(json);

  Map<String, dynamic> toJson() =>
      _$PushNotificationIntercomUnlockV2ToJson(this);
}

/// Push notification intercom unlock GCM data wrapper
@JsonSerializable()
class PushNotificationIntercomUnlockGcmData {
  final PushNotificationIntercomUnlock gcmData;

  const PushNotificationIntercomUnlockGcmData({required this.gcmData});

  factory PushNotificationIntercomUnlockGcmData.fromJson(
    Map<String, dynamic> json,
  ) => _$PushNotificationIntercomUnlockGcmDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PushNotificationIntercomUnlockGcmDataToJson(this);
}

/// Socket ticket response
@JsonSerializable()
class SocketTicketResponse {
  final String ticket;
  final int?
  responseTimestampe; // Note: typo in original API (nullable because not always present)

  const SocketTicketResponse({required this.ticket, this.responseTimestampe});

  factory SocketTicketResponse.fromJson(Map<String, dynamic> json) =>
      _$SocketTicketResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SocketTicketResponseToJson(this);
}

/// Auth token response
@JsonSerializable()
class AuthTokenResponse {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'expires_in')
  final int expiresIn;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  final String scope; // 'client'
  @JsonKey(name: 'token_type')
  final String tokenType; // 'Bearer'

  const AuthTokenResponse({
    required this.accessToken,
    required this.expiresIn,
    required this.refreshToken,
    required this.scope,
    required this.tokenType,
  });

  factory AuthTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokenResponseToJson(this);
}

/// Two-stage verification state
typedef TwoStageVerificationState = String;

/// Two-stage verification state constants
class TwoStageVerificationStateConstants {
  static const String sms = 'sms';
  static const String email = 'email';
  static const String totp = 'totp'; // time-based OTP
}

/// Auth 2FA error response
@JsonSerializable()
class Auth2faErrorResponse {
  final dynamic error;
  final String? errorDescription;

  const Auth2faErrorResponse({this.error, this.errorDescription});

  factory Auth2faErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$Auth2faErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$Auth2faErrorResponseToJson(this);
}

/// Auth 2FA success response
@JsonSerializable()
class Auth2faSuccessResponse {
  final int nextTimeInSecs;
  final String phone;
  final TwoStageVerificationState tsvState;

  const Auth2faSuccessResponse({
    required this.nextTimeInSecs,
    required this.phone,
    required this.tsvState,
  });

  factory Auth2faSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$Auth2faSuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$Auth2faSuccessResponseToJson(this);
}

/// User preferences
@JsonSerializable()
class UserPreferences {
  final dynamic settings;
  final dynamic preferences;

  const UserPreferences({required this.settings, required this.preferences});

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);
}

/// User profile
@JsonSerializable()
class UserProfile {
  final int id;
  final String email;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  @JsonKey(name: 'authentication_token')
  final String authenticationToken;
  final Map<String, dynamic> features;
  @JsonKey(name: 'user_preferences')
  final UserPreferences userPreferences;
  @JsonKey(name: 'hardware_id')
  final String hardwareId;
  @JsonKey(name: 'explorer_program_terms')
  final dynamic explorerProgramTerms;
  @JsonKey(name: 'user_flow')
  final String userFlow; // 'ring' or other string
  @JsonKey(name: 'app_brand')
  final String appBrand;
  final String country;
  final String status; // 'legacy' or other string
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'tfa_enabled')
  final bool tfaEnabled;
  @JsonKey(name: 'tfa_phone_number')
  final String? tfaPhoneNumber;
  @JsonKey(name: 'account_type')
  final String accountType; // 'ring' or other string

  const UserProfile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.authenticationToken,
    required this.features,
    required this.userPreferences,
    required this.hardwareId,
    required this.explorerProgramTerms,
    required this.userFlow,
    required this.appBrand,
    required this.country,
    required this.status,
    required this.createdAt,
    required this.tfaEnabled,
    this.tfaPhoneNumber,
    required this.accountType,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

/// Profile response
@JsonSerializable()
class ProfileResponse {
  final UserProfile profile;

  const ProfileResponse({required this.profile});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}

/// Session response (alias for ProfileResponse)
typedef SessionResponse = ProfileResponse;

/// Account monitoring status
@JsonSerializable()
class AccountMonitoringStatus {
  final String accountUuid;
  final String externalServiceConfigType; // 'rrms' or other string
  final String accountState; // 'PROFESSIONAL' or other string
  final bool eligibleForDispatch;
  final bool addressComplete;
  final bool contactsComplete;
  final bool codewordComplete;
  final bool alarmSignalSent;
  final bool professionallyMonitored;
  final bool userAcceptDispatch;
  final int installationDate;
  final String externalId;
  final bool vrRequired;
  final bool vrUserOptIn;
  final String cmsMonitoringType; // 'full' or other string
  final bool dispatchSetupComplete;

  const AccountMonitoringStatus({
    required this.accountUuid,
    required this.externalServiceConfigType,
    required this.accountState,
    required this.eligibleForDispatch,
    required this.addressComplete,
    required this.contactsComplete,
    required this.codewordComplete,
    required this.alarmSignalSent,
    required this.professionallyMonitored,
    required this.userAcceptDispatch,
    required this.installationDate,
    required this.externalId,
    required this.vrRequired,
    required this.vrUserOptIn,
    required this.cmsMonitoringType,
    required this.dispatchSetupComplete,
  });

  factory AccountMonitoringStatus.fromJson(Map<String, dynamic> json) =>
      _$AccountMonitoringStatusFromJson(json);

  Map<String, dynamic> toJson() => _$AccountMonitoringStatusToJson(this);
}

/// Dispatch signal type constants
class DispatchSignalType {
  static const String burglar = 'user-verified-burglar-xa';
  static const String fire = 'user-verified-fire-xa';
}

/// Location mode input type
typedef LocationModeInput = String;

/// Location mode input constants
class LocationModeInputConstants {
  static const String home = 'home';
  static const String away = 'away';
  static const String disarmed = 'disarmed';
}

/// Location mode type (includes disabled states)
typedef LocationMode = String;

/// Location mode constants
class LocationModeConstants {
  static const String home = 'home';
  static const String away = 'away';
  static const String disarmed = 'disarmed';
  static const String disabled = 'disabled';
  static const String unset = 'unset';
}

/// Disabled location modes
const List<String> disabledLocationModes = ['disabled', 'unset'];

/// Location mode security status
@JsonSerializable()
class LocationModeSecurityStatus {
  final int? lu;
  final String? md; // 'none' or other string
  final String? returnTopic;

  const LocationModeSecurityStatus({this.lu, this.md, this.returnTopic});

  factory LocationModeSecurityStatus.fromJson(Map<String, dynamic> json) =>
      _$LocationModeSecurityStatusFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModeSecurityStatusToJson(this);
}

/// Not yet participating device
@JsonSerializable()
class NotYetParticipatingDevice {
  final int deviceId;
  final String deviceIdType; // 'doorbot' or other string

  const NotYetParticipatingDevice({
    required this.deviceId,
    required this.deviceIdType,
  });

  factory NotYetParticipatingDevice.fromJson(Map<String, dynamic> json) =>
      _$NotYetParticipatingDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$NotYetParticipatingDeviceToJson(this);
}

/// Location mode response
@JsonSerializable()
class LocationModeResponse {
  final LocationMode mode;
  final int? lastUpdateTimeMs;
  final LocationModeSecurityStatus securityStatus;
  final bool readOnly;
  final List<NotYetParticipatingDevice>? notYetParticipatingInMode;

  const LocationModeResponse({
    required this.mode,
    this.lastUpdateTimeMs,
    required this.securityStatus,
    required this.readOnly,
    this.notYetParticipatingInMode,
  });

  factory LocationModeResponse.fromJson(Map<String, dynamic> json) =>
      _$LocationModeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModeResponseToJson(this);
}

/// Location mode action type
typedef LocationModeAction = String;

/// Location mode action constants
class LocationModeActionConstants {
  static const String disableMotionDetection = 'disableMotionDetection';
  static const String enableMotionDetection = 'enableMotionDetection';
  static const String blockLiveViewLocally = 'blockLiveViewLocally';
  static const String allowLiveViewLocally = 'allowLiveViewLocally';
}

/// Location mode setting for a device
@JsonSerializable()
class LocationModeSetting {
  final String deviceId;
  final String deviceIdType; // 'doorbot' or other string
  final List<LocationModeAction> actions;

  const LocationModeSetting({
    required this.deviceId,
    required this.deviceIdType,
    required this.actions,
  });

  factory LocationModeSetting.fromJson(Map<String, dynamic> json) =>
      _$LocationModeSettingFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModeSettingToJson(this);
}

/// Location mode settings for all modes
@JsonSerializable()
class LocationModeSettings {
  final List<LocationModeSetting> disarmed;
  final List<LocationModeSetting> home;
  final List<LocationModeSetting> away;

  const LocationModeSettings({
    required this.disarmed,
    required this.home,
    required this.away,
  });

  factory LocationModeSettings.fromJson(Map<String, dynamic> json) =>
      _$LocationModeSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModeSettingsToJson(this);
}

/// Location mode settings response
@JsonSerializable()
class LocationModeSettingsResponse extends LocationModeSettings {
  final int lastUpdateTimeMs;

  const LocationModeSettingsResponse({
    required this.lastUpdateTimeMs,
    required super.disarmed,
    required super.home,
    required super.away,
  });

  factory LocationModeSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$LocationModeSettingsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LocationModeSettingsResponseToJson(this);
}

/// Location mode sharing settings
@JsonSerializable()
class LocationModeSharing {
  final bool sharedUsersEnabled;
  final int lastUpdateTimeMs;

  const LocationModeSharing({
    required this.sharedUsersEnabled,
    required this.lastUpdateTimeMs,
  });

  factory LocationModeSharing.fromJson(Map<String, dynamic> json) =>
      _$LocationModeSharingFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModeSharingToJson(this);
}

/// Helper function to check if WebSocket is supported for an asset
bool isWebSocketSupportedAsset({required String kind}) {
  return kind.startsWith('base_station') || kind.startsWith('beams_bridge');
}

// NOTE: Complete port of ring-types.ts
// All types have been ported from the TypeScript original.
