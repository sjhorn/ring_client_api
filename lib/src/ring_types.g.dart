// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ring_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketIoMessage _$SocketIoMessageFromJson(Map<String, dynamic> json) =>
    SocketIoMessage(
      msg: $enumDecode(_$MessageTypeEnumMap, json['msg']),
      datatype: $enumDecode(_$MessageDataTypeEnumMap, json['datatype']),
      src: json['src'] as String,
      body: json['body'] as List<dynamic>,
    );

Map<String, dynamic> _$SocketIoMessageToJson(SocketIoMessage instance) =>
    <String, dynamic>{
      'msg': _$MessageTypeEnumMap[instance.msg]!,
      'datatype': _$MessageDataTypeEnumMap[instance.datatype]!,
      'src': instance.src,
      'body': instance.body,
    };

const _$MessageTypeEnumMap = {
  MessageType.roomGetList: 'RoomGetList',
  MessageType.sessionInfo: 'SessionInfo',
  MessageType.deviceInfoDocGetList: 'DeviceInfoDocGetList',
  MessageType.deviceInfoSet: 'DeviceInfoSet',
};

const _$MessageDataTypeEnumMap = {
  MessageDataType.roomListV2Type: 'RoomListV2Type',
  MessageDataType.sessionInfoType: 'SessionInfoType',
  MessageDataType.deviceInfoDocType: 'DeviceInfoDocType',
  MessageDataType.deviceInfoSetType: 'DeviceInfoSetType',
  MessageDataType.hubDisconnectionEventType: 'HubDisconnectionEventType',
};

AssetSession _$AssetSessionFromJson(Map<String, dynamic> json) => AssetSession(
  assetUuid: json['assetUuid'] as String,
  connectionStatus: json['connectionStatus'] as String,
  doorbotId: (json['doorbotId'] as num?)?.toInt(),
  kind: json['kind'] as String,
  sessionId: (json['sessionId'] as num?)?.toInt(),
);

Map<String, dynamic> _$AssetSessionToJson(AssetSession instance) =>
    <String, dynamic>{
      'assetUuid': instance.assetUuid,
      'connectionStatus': instance.connectionStatus,
      'doorbotId': instance.doorbotId,
      'kind': instance.kind,
      'sessionId': instance.sessionId,
    };

AlarmInfo _$AlarmInfoFromJson(Map<String, dynamic> json) => AlarmInfo(
  state: $enumDecode(_$AlarmStateEnumMap, json['state']),
  faultedDevices: (json['faultedDevices'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  timestamp: (json['timestamp'] as num?)?.toInt(),
  uuid: json['uuid'] as String?,
);

Map<String, dynamic> _$AlarmInfoToJson(AlarmInfo instance) => <String, dynamic>{
  'state': _$AlarmStateEnumMap[instance.state]!,
  'faultedDevices': instance.faultedDevices,
  'timestamp': instance.timestamp,
  'uuid': instance.uuid,
};

const _$AlarmStateEnumMap = {
  AlarmState.burglarAlarm: 'burglar-alarm',
  AlarmState.entryDelay: 'entry-delay',
  AlarmState.fireAlarm: 'fire-alarm',
  AlarmState.coAlarm: 'co-alarm',
  AlarmState.panic: 'panic',
  AlarmState.userVerifiedBurglarAlarm: 'user-verified-burglar-alarm',
  AlarmState.userVerifiedCoOrFireAlarm: 'user-verified-co-or-fire-alarm',
  AlarmState.burglarAcceleratedAlarm: 'burglar-accelerated-alarm',
  AlarmState.fireAcceleratedAlarm: 'fire-accelerated-alarm',
};

SirenInfo _$SirenInfoFromJson(Map<String, dynamic> json) =>
    SirenInfo(state: $enumDecode(_$SirenStateEnumMap, json['state']));

Map<String, dynamic> _$SirenInfoToJson(SirenInfo instance) => <String, dynamic>{
  'state': _$SirenStateEnumMap[instance.state]!,
};

const _$SirenStateEnumMap = {SirenState.on: 'on', SirenState.off: 'off'};

HueSaturation _$HueSaturationFromJson(Map<String, dynamic> json) =>
    HueSaturation(
      hue: (json['hue'] as num?)?.toDouble(),
      sat: (json['sat'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$HueSaturationToJson(HueSaturation instance) =>
    <String, dynamic>{'hue': instance.hue, 'sat': instance.sat};

ComponentDevice _$ComponentDeviceFromJson(Map<String, dynamic> json) =>
    ComponentDevice(rel: json['rel'] as String, zid: json['zid'] as String);

Map<String, dynamic> _$ComponentDeviceToJson(ComponentDevice instance) =>
    <String, dynamic>{'rel': instance.rel, 'zid': instance.zid};

RingDeviceData _$RingDeviceDataFromJson(Map<String, dynamic> json) =>
    RingDeviceData(
      zid: json['zid'] as String,
      name: json['name'] as String,
      deviceType: json['deviceType'] as String,
      categoryId: (json['categoryId'] as num?)?.toInt(),
      batteryLevel: (json['batteryLevel'] as num?)?.toInt(),
      batteryStatus: $enumDecode(_$BatteryStatusEnumMap, json['batteryStatus']),
      batteryBackup: $enumDecodeNullable(
        _$BatteryBackupEnumMap,
        json['batteryBackup'],
      ),
      acStatus: $enumDecodeNullable(_$AcStatusEnumMap, json['acStatus']),
      manufacturerName: json['manufacturerName'] as String?,
      serialNumber: json['serialNumber'] as String?,
      tamperStatus: $enumDecode(_$TamperStatusEnumMap, json['tamperStatus']),
      faulted: json['faulted'] as bool?,
      locked: $enumDecodeNullable(_$LockStatusEnumMap, json['locked']),
      roomId: (json['roomId'] as num?)?.toInt(),
      volume: (json['volume'] as num?)?.toDouble(),
      mode: json['mode'] as String?,
      transitionDelayEndTimestamp: (json['transitionDelayEndTimestamp'] as num?)
          ?.toInt(),
      alarmInfo: json['alarmInfo'] == null
          ? null
          : AlarmInfo.fromJson(json['alarmInfo'] as Map<String, dynamic>),
      siren: json['siren'] == null
          ? null
          : SirenInfo.fromJson(json['siren'] as Map<String, dynamic>),
      alarmStatus: json['alarmStatus'] as String?,
      co: json['co'] as Map<String, dynamic>?,
      smoke: json['smoke'] as Map<String, dynamic>?,
      flood: json['flood'] as Map<String, dynamic>?,
      freeze: json['freeze'] as Map<String, dynamic>?,
      motionStatus: $enumDecodeNullable(
        _$MotionStatusEnumMap,
        json['motionStatus'],
      ),
      groupId: json['groupId'] as String?,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      on: json['on'] as bool?,
      level: (json['level'] as num?)?.toDouble(),
      hs: json['hs'] == null
          ? null
          : HueSaturation.fromJson(json['hs'] as Map<String, dynamic>),
      ct: (json['ct'] as num?)?.toDouble(),
      status: json['status'] as String?,
      parentZid: json['parentZid'] as String?,
      rootDevice: json['rootDevice'] as String?,
      relToParentZid: json['relToParentZid'] as String?,
      celsius: (json['celsius'] as num?)?.toDouble(),
      faultHigh: (json['faultHigh'] as num?)?.toDouble(),
      faultLow: (json['faultLow'] as num?)?.toDouble(),
      setPoint: (json['setPoint'] as num?)?.toDouble(),
      setPointMax: (json['setPointMax'] as num?)?.toDouble(),
      setPointMin: (json['setPointMin'] as num?)?.toDouble(),
      basicValue: (json['basicValue'] as num?)?.toInt(),
      componentDevices: (json['componentDevices'] as List<dynamic>?)
          ?.map((e) => ComponentDevice.fromJson(e as Map<String, dynamic>))
          .toList(),
      motionSensorEnabled: json['motionSensorEnabled'] as bool?,
      brightness: (json['brightness'] as num?)?.toDouble(),
      valveState: json['valveState'] as String?,
    );

Map<String, dynamic> _$RingDeviceDataToJson(RingDeviceData instance) =>
    <String, dynamic>{
      'zid': instance.zid,
      'name': instance.name,
      'deviceType': instance.deviceType,
      'categoryId': instance.categoryId,
      'batteryLevel': instance.batteryLevel,
      'batteryStatus': _$BatteryStatusEnumMap[instance.batteryStatus]!,
      'batteryBackup': _$BatteryBackupEnumMap[instance.batteryBackup],
      'acStatus': _$AcStatusEnumMap[instance.acStatus],
      'manufacturerName': instance.manufacturerName,
      'serialNumber': instance.serialNumber,
      'tamperStatus': _$TamperStatusEnumMap[instance.tamperStatus]!,
      'faulted': instance.faulted,
      'locked': _$LockStatusEnumMap[instance.locked],
      'roomId': instance.roomId,
      'volume': instance.volume,
      'mode': instance.mode,
      'transitionDelayEndTimestamp': instance.transitionDelayEndTimestamp,
      'alarmInfo': instance.alarmInfo,
      'siren': instance.siren,
      'alarmStatus': instance.alarmStatus,
      'co': instance.co,
      'smoke': instance.smoke,
      'flood': instance.flood,
      'freeze': instance.freeze,
      'motionStatus': _$MotionStatusEnumMap[instance.motionStatus],
      'groupId': instance.groupId,
      'tags': instance.tags,
      'on': instance.on,
      'level': instance.level,
      'hs': instance.hs,
      'ct': instance.ct,
      'status': instance.status,
      'parentZid': instance.parentZid,
      'rootDevice': instance.rootDevice,
      'relToParentZid': instance.relToParentZid,
      'celsius': instance.celsius,
      'faultHigh': instance.faultHigh,
      'faultLow': instance.faultLow,
      'setPoint': instance.setPoint,
      'setPointMax': instance.setPointMax,
      'setPointMin': instance.setPointMin,
      'basicValue': instance.basicValue,
      'componentDevices': instance.componentDevices,
      'motionSensorEnabled': instance.motionSensorEnabled,
      'brightness': instance.brightness,
      'valveState': instance.valveState,
    };

const _$BatteryStatusEnumMap = {
  BatteryStatus.full: 'full',
  BatteryStatus.charged: 'charged',
  BatteryStatus.ok: 'ok',
  BatteryStatus.low: 'low',
  BatteryStatus.none: 'none',
  BatteryStatus.charging: 'charging',
};

const _$BatteryBackupEnumMap = {
  BatteryBackup.charged: 'charged',
  BatteryBackup.charging: 'charging',
  BatteryBackup.inUse: 'inUse',
};

const _$AcStatusEnumMap = {AcStatus.error: 'error', AcStatus.ok: 'ok'};

const _$TamperStatusEnumMap = {
  TamperStatus.ok: 'ok',
  TamperStatus.tamper: 'tamper',
};

const _$LockStatusEnumMap = {
  LockStatus.jammed: 'jammed',
  LockStatus.locked: 'locked',
  LockStatus.unlocked: 'unlocked',
  LockStatus.unknown: 'unknown',
};

const _$MotionStatusEnumMap = {
  MotionStatus.clear: 'clear',
  MotionStatus.faulted: 'faulted',
};

BaseStation _$BaseStationFromJson(Map<String, dynamic> json) => BaseStation(
  address: json['address'] as String?,
  alerts: json['alerts'] as List<dynamic>?,
  description: json['description'] as String?,
  deviceId: json['deviceId'] as String?,
  features: json['features'],
  firmwareVersion: json['firmwareVersion'] as String?,
  id: (json['id'] as num?)?.toInt(),
  kind: json['kind'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  locationId: json['location_id'] as String?,
  longitude: (json['longitude'] as num?)?.toDouble(),
  owned: json['owned'] as bool?,
  owner: json['owner'] == null
      ? null
      : BaseStationOwner.fromJson(json['owner'] as Map<String, dynamic>),
  ringId: json['ringId'],
  settings: json['settings'],
  stolen: json['stolen'] as bool?,
  timeZone: json['timeZone'] as String?,
);

Map<String, dynamic> _$BaseStationToJson(BaseStation instance) =>
    <String, dynamic>{
      'address': instance.address,
      'alerts': instance.alerts,
      'description': instance.description,
      'deviceId': instance.deviceId,
      'features': instance.features,
      'firmwareVersion': instance.firmwareVersion,
      'id': instance.id,
      'kind': instance.kind,
      'latitude': instance.latitude,
      'location_id': instance.locationId,
      'longitude': instance.longitude,
      'owned': instance.owned,
      'owner': instance.owner,
      'ringId': instance.ringId,
      'settings': instance.settings,
      'stolen': instance.stolen,
      'timeZone': instance.timeZone,
    };

BaseStationOwner _$BaseStationOwnerFromJson(Map<String, dynamic> json) =>
    BaseStationOwner(
      id: (json['id'] as num?)?.toInt(),
      email: json['email'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
    );

Map<String, dynamic> _$BaseStationOwnerToJson(BaseStationOwner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

BeamBridge _$BeamBridgeFromJson(Map<String, dynamic> json) => BeamBridge(
  createdAt: json['createdAt'] as String,
  description: json['description'] as String,
  hardwareId: json['hardwareId'] as String,
  id: (json['id'] as num).toInt(),
  kind: json['kind'] as String,
  locationId: json['location_id'] as String,
  metadata: BeamBridgeMetadata.fromJson(
    json['metadata'] as Map<String, dynamic>,
  ),
  ownerId: (json['ownerId'] as num).toInt(),
  role: json['role'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$BeamBridgeToJson(BeamBridge instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'description': instance.description,
      'hardwareId': instance.hardwareId,
      'id': instance.id,
      'kind': instance.kind,
      'location_id': instance.locationId,
      'metadata': instance.metadata,
      'ownerId': instance.ownerId,
      'role': instance.role,
      'updatedAt': instance.updatedAt,
    };

BeamBridgeMetadata _$BeamBridgeMetadataFromJson(Map<String, dynamic> json) =>
    BeamBridgeMetadata(
      ethernet: json['ethernet'] as bool,
      legacyFwMigrated: json['legacyFwMigrated'] as bool,
    );

Map<String, dynamic> _$BeamBridgeMetadataToJson(BeamBridgeMetadata instance) =>
    <String, dynamic>{
      'ethernet': instance.ethernet,
      'legacyFwMigrated': instance.legacyFwMigrated,
    };

ChimeSettings _$ChimeSettingsFromJson(Map<String, dynamic> json) =>
    ChimeSettings(
      volume: (json['volume'] as num?)?.toInt(),
      dingAudioUserId: json['dingAudioUserId'] as String?,
      dingAudioId: json['dingAudioId'] as String?,
      motionAudioUserId: json['motionAudioUserId'] as String?,
      motionAudioId: json['motionAudioId'] as String?,
    );

Map<String, dynamic> _$ChimeSettingsToJson(ChimeSettings instance) =>
    <String, dynamic>{
      'volume': instance.volume,
      'dingAudioUserId': instance.dingAudioUserId,
      'dingAudioId': instance.dingAudioId,
      'motionAudioUserId': instance.motionAudioUserId,
      'motionAudioId': instance.motionAudioId,
    };

ChimeFeatures _$ChimeFeaturesFromJson(Map<String, dynamic> json) =>
    ChimeFeatures(ringtonesEnabled: json['ringtonesEnabled'] as bool?);

Map<String, dynamic> _$ChimeFeaturesToJson(ChimeFeatures instance) =>
    <String, dynamic>{'ringtonesEnabled': instance.ringtonesEnabled};

ChimeAlerts _$ChimeAlertsFromJson(Map<String, dynamic> json) => ChimeAlerts(
  connection: json['connection'] as String?,
  rssi: json['rssi'] as String?,
);

Map<String, dynamic> _$ChimeAlertsToJson(ChimeAlerts instance) =>
    <String, dynamic>{'connection': instance.connection, 'rssi': instance.rssi};

ChimeDoNotDisturb _$ChimeDoNotDisturbFromJson(Map<String, dynamic> json) =>
    ChimeDoNotDisturb(secondsLeft: (json['secondsLeft'] as num?)?.toInt());

Map<String, dynamic> _$ChimeDoNotDisturbToJson(ChimeDoNotDisturb instance) =>
    <String, dynamic>{'secondsLeft': instance.secondsLeft};

ChimeOwner _$ChimeOwnerFromJson(Map<String, dynamic> json) => ChimeOwner(
  id: (json['id'] as num?)?.toInt(),
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  email: json['email'] as String?,
);

Map<String, dynamic> _$ChimeOwnerToJson(ChimeOwner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
    };

ChimeData _$ChimeDataFromJson(Map<String, dynamic> json) => ChimeData(
  id: (json['id'] as num?)?.toInt(),
  description: json['description'] as String?,
  deviceId: json['deviceId'] as String?,
  timeZone: json['timeZone'] as String?,
  firmwareVersion: json['firmwareVersion'] as String?,
  kind: json['kind'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  address: json['address'] as String?,
  settings: json['settings'] == null
      ? null
      : ChimeSettings.fromJson(json['settings'] as Map<String, dynamic>),
  features: json['features'] == null
      ? null
      : ChimeFeatures.fromJson(json['features'] as Map<String, dynamic>),
  owned: json['owned'] as bool?,
  alerts: json['alerts'] == null
      ? null
      : ChimeAlerts.fromJson(json['alerts'] as Map<String, dynamic>),
  doNotDisturb: json['doNotDisturb'] == null
      ? null
      : ChimeDoNotDisturb.fromJson(
          json['doNotDisturb'] as Map<String, dynamic>,
        ),
  stolen: json['stolen'] as bool?,
  locationId: json['locationId'] as String?,
  ringId: json['ringId'],
  owner: json['owner'] == null
      ? null
      : ChimeOwner.fromJson(json['owner'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChimeDataToJson(ChimeData instance) => <String, dynamic>{
  'id': instance.id,
  'description': instance.description,
  'deviceId': instance.deviceId,
  'timeZone': instance.timeZone,
  'firmwareVersion': instance.firmwareVersion,
  'kind': instance.kind,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'address': instance.address,
  'settings': instance.settings,
  'features': instance.features,
  'owned': instance.owned,
  'alerts': instance.alerts,
  'doNotDisturb': instance.doNotDisturb,
  'stolen': instance.stolen,
  'locationId': instance.locationId,
  'ringId': instance.ringId,
  'owner': instance.owner,
};

ChimeUpdate _$ChimeUpdateFromJson(Map<String, dynamic> json) => ChimeUpdate(
  description: json['description'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  address: json['address'] as String?,
  settings: json['settings'] == null
      ? null
      : ChimeUpdateSettings.fromJson(json['settings'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChimeUpdateToJson(ChimeUpdate instance) =>
    <String, dynamic>{
      'description': instance.description,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'settings': instance.settings,
    };

ChimeUpdateSettings _$ChimeUpdateSettingsFromJson(Map<String, dynamic> json) =>
    ChimeUpdateSettings(
      volume: (json['volume'] as num?)?.toInt(),
      dingAudioUserId: json['dingAudioUserId'] as String?,
      dingAudioId: json['dingAudioId'] as String?,
      motionAudioUserId: json['motionAudioUserId'] as String?,
      motionAudioId: json['motionAudioId'] as String?,
    );

Map<String, dynamic> _$ChimeUpdateSettingsToJson(
  ChimeUpdateSettings instance,
) => <String, dynamic>{
  'volume': instance.volume,
  'dingAudioUserId': instance.dingAudioUserId,
  'dingAudioId': instance.dingAudioId,
  'motionAudioUserId': instance.motionAudioUserId,
  'motionAudioId': instance.motionAudioId,
};

RingtoneAudio _$RingtoneAudioFromJson(Map<String, dynamic> json) =>
    RingtoneAudio(
      userId: json['userId'] as String,
      id: json['id'] as String,
      description: json['description'] as String,
      kind: json['kind'] as String,
      url: json['url'] as String,
      checksum: json['checksum'] as String,
      available: json['available'] as String,
    );

Map<String, dynamic> _$RingtoneAudioToJson(RingtoneAudio instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'id': instance.id,
      'description': instance.description,
      'kind': instance.kind,
      'url': instance.url,
      'checksum': instance.checksum,
      'available': instance.available,
    };

RingtoneOptions _$RingtoneOptionsFromJson(Map<String, dynamic> json) =>
    RingtoneOptions(
      defaultDingUserId: json['defaultDingUserId'] as String,
      defaultDingId: json['defaultDingId'] as String,
      defaultMotionUserId: json['defaultMotionUserId'] as String,
      defaultMotionId: json['defaultMotionId'] as String,
      audios: (json['audios'] as List<dynamic>)
          .map((e) => RingtoneAudio.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RingtoneOptionsToJson(RingtoneOptions instance) =>
    <String, dynamic>{
      'defaultDingUserId': instance.defaultDingUserId,
      'defaultDingId': instance.defaultDingId,
      'defaultMotionUserId': instance.defaultMotionUserId,
      'defaultMotionId': instance.defaultMotionId,
      'audios': instance.audios,
    };

LocationAddress _$LocationAddressFromJson(Map<String, dynamic> json) =>
    LocationAddress(
      address1: json['address1'] as String?,
      address2: json['address2'] as String?,
      crossStreet: json['cross_street'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      timezone: json['timezone'] as String?,
      zipCode: json['zip_code'] as String?,
    );

Map<String, dynamic> _$LocationAddressToJson(LocationAddress instance) =>
    <String, dynamic>{
      'address1': instance.address1,
      'address2': instance.address2,
      'cross_street': instance.crossStreet,
      'city': instance.city,
      'state': instance.state,
      'timezone': instance.timezone,
      'zip_code': instance.zipCode,
    };

GeoCoordinates _$GeoCoordinatesFromJson(Map<String, dynamic> json) =>
    GeoCoordinates(
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
    );

Map<String, dynamic> _$GeoCoordinatesToJson(GeoCoordinates instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

UserLocation _$UserLocationFromJson(Map<String, dynamic> json) => UserLocation(
  address: json['address'] == null
      ? null
      : LocationAddress.fromJson(json['address'] as Map<String, dynamic>),
  createdAt: json['created_at'] as String?,
  geoCoordinates: json['geo_coordinates'] == null
      ? null
      : GeoCoordinates.fromJson(
          json['geo_coordinates'] as Map<String, dynamic>,
        ),
  geoServiceVerified: json['geo_service_verified'] as String?,
  locationId: json['location_id'] as String?,
  name: json['name'] as String?,
  ownerId: (json['owner_id'] as num?)?.toInt(),
  updatedAt: json['updated_at'] as String?,
  userVerified: json['user_verified'] as bool?,
);

Map<String, dynamic> _$UserLocationToJson(UserLocation instance) =>
    <String, dynamic>{
      'address': instance.address,
      'created_at': instance.createdAt,
      'geo_coordinates': instance.geoCoordinates,
      'geo_service_verified': instance.geoServiceVerified,
      'location_id': instance.locationId,
      'name': instance.name,
      'owner_id': instance.ownerId,
      'updated_at': instance.updatedAt,
      'user_verified': instance.userVerified,
    };

TicketAsset _$TicketAssetFromJson(Map<String, dynamic> json) => TicketAsset(
  doorbotId: (json['doorbotId'] as num).toInt(),
  kind: json['kind'] as String,
  onBattery: json['onBattery'] as bool,
  status: json['status'] as String,
  uuid: json['uuid'] as String,
);

Map<String, dynamic> _$TicketAssetToJson(TicketAsset instance) =>
    <String, dynamic>{
      'doorbotId': instance.doorbotId,
      'kind': instance.kind,
      'onBattery': instance.onBattery,
      'status': instance.status,
      'uuid': instance.uuid,
    };

CameraAlerts _$CameraAlertsFromJson(Map<String, dynamic> json) => CameraAlerts(
  connection: json['connection'] as String,
  battery: json['battery'] as String?,
  otaStatus: json['otaStatus'] as String?,
);

Map<String, dynamic> _$CameraAlertsToJson(CameraAlerts instance) =>
    <String, dynamic>{
      'connection': instance.connection,
      'battery': instance.battery,
      'otaStatus': instance.otaStatus,
    };

CameraFeatures _$CameraFeaturesFromJson(Map<String, dynamic> json) =>
    CameraFeatures(
      motionsEnabled: json['motionsEnabled'] as bool?,
      showRecordings: json['showRecordings'] as bool?,
      advancedMotionEnabled: json['advancedMotionEnabled'] as bool?,
      peopleOnlyEnabled: json['peopleOnlyEnabled'] as bool?,
      shadowCorrectionEnabled: json['shadowCorrectionEnabled'] as bool?,
      motionMessageEnabled: json['motionMessageEnabled'] as bool?,
      nightVisionEnabled: json['nightVisionEnabled'] as bool?,
    );

Map<String, dynamic> _$CameraFeaturesToJson(CameraFeatures instance) =>
    <String, dynamic>{
      'motionsEnabled': instance.motionsEnabled,
      'showRecordings': instance.showRecordings,
      'advancedMotionEnabled': instance.advancedMotionEnabled,
      'peopleOnlyEnabled': instance.peopleOnlyEnabled,
      'shadowCorrectionEnabled': instance.shadowCorrectionEnabled,
      'motionMessageEnabled': instance.motionMessageEnabled,
      'nightVisionEnabled': instance.nightVisionEnabled,
    };

MotionSnooze _$MotionSnoozeFromJson(Map<String, dynamic> json) =>
    MotionSnooze(scheduled: json['scheduled'] as bool);

Map<String, dynamic> _$MotionSnoozeToJson(MotionSnooze instance) =>
    <String, dynamic>{'scheduled': instance.scheduled};

MotionZones _$MotionZonesFromJson(Map<String, dynamic> json) => MotionZones(
  enableAudio: json['enableAudio'] as bool,
  activeMotionFilter: (json['activeMotionFilter'] as num?)?.toInt(),
  sensitivity: (json['sensitivity'] as num?)?.toInt(),
  advancedObjectSettings: json['advancedObjectSettings'],
  zone1: json['zone1'],
  zone2: json['zone2'],
  zone3: json['zone3'],
);

Map<String, dynamic> _$MotionZonesToJson(MotionZones instance) =>
    <String, dynamic>{
      'enableAudio': instance.enableAudio,
      'activeMotionFilter': instance.activeMotionFilter,
      'sensitivity': instance.sensitivity,
      'advancedObjectSettings': instance.advancedObjectSettings,
      'zone1': instance.zone1,
      'zone2': instance.zone2,
      'zone3': instance.zone3,
    };

CameraChimeSettings _$CameraChimeSettingsFromJson(Map<String, dynamic> json) =>
    CameraChimeSettings(
      type: (json['type'] as num).toInt(),
      enable: json['enable'] as bool,
      duration: (json['duration'] as num).toInt(),
    );

Map<String, dynamic> _$CameraChimeSettingsToJson(
  CameraChimeSettings instance,
) => <String, dynamic>{
  'type': instance.type,
  'enable': instance.enable,
  'duration': instance.duration,
};

FloodlightSettings _$FloodlightSettingsFromJson(Map<String, dynamic> json) =>
    FloodlightSettings(
      priority: (json['priority'] as num).toInt(),
      duration: (json['duration'] as num).toInt(),
      brightness: (json['brightness'] as num?)?.toInt(),
      alwaysOn: json['alwaysOn'] as bool,
      alwaysOnDuration: (json['alwaysOnDuration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FloodlightSettingsToJson(FloodlightSettings instance) =>
    <String, dynamic>{
      'priority': instance.priority,
      'duration': instance.duration,
      'brightness': instance.brightness,
      'alwaysOn': instance.alwaysOn,
      'alwaysOnDuration': instance.alwaysOnDuration,
    };

SheilaSettings _$SheilaSettingsFromJson(Map<String, dynamic> json) =>
    SheilaSettings(
      cvProcessingEnabled: json['cvProcessingEnabled'] as bool?,
      localStorageEnabled: json['localStorageEnabled'] as bool?,
    );

Map<String, dynamic> _$SheilaSettingsToJson(SheilaSettings instance) =>
    <String, dynamic>{
      'cvProcessingEnabled': instance.cvProcessingEnabled,
      'localStorageEnabled': instance.localStorageEnabled,
    };

ServerSettings _$ServerSettingsFromJson(Map<String, dynamic> json) =>
    ServerSettings(
      ringMediaServerEnabled: json['ringMediaServerEnabled'] as bool,
    );

Map<String, dynamic> _$ServerSettingsToJson(ServerSettings instance) =>
    <String, dynamic>{
      'ringMediaServerEnabled': instance.ringMediaServerEnabled,
    };

CameraSettingsData _$CameraSettingsDataFromJson(
  Map<String, dynamic> json,
) => CameraSettingsData(
  enableVod: json['enableVod'],
  motionZones: json['motionZones'] == null
      ? null
      : MotionZones.fromJson(json['motionZones'] as Map<String, dynamic>),
  motionSnoozePresetProfile: json['motionSnoozePresetProfile'] as String?,
  liveViewPresetProfile: json['liveViewPresetProfile'] as String?,
  liveViewPresets: (json['liveViewPresets'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  motionSnoozePresets: (json['motionSnoozePresets'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  doorbellVolume: (json['doorbellVolume'] as num?)?.toInt(),
  chimeSettings: json['chimeSettings'] == null
      ? null
      : CameraChimeSettings.fromJson(
          json['chimeSettings'] as Map<String, dynamic>,
        ),
  videoSettings: json['videoSettings'],
  motionAnnouncement: json['motionAnnouncement'] as bool?,
  streamSetting: (json['streamSetting'] as num?)?.toInt(),
  advancedMotionDetectionEnabled:
      json['advancedMotionDetectionEnabled'] as bool?,
  advancedMotionDetectionHumanOnlyMode:
      json['advancedMotionDetectionHumanOnlyMode'] as bool?,
  lumaNightThreshold: (json['lumaNightThreshold'] as num?)?.toInt(),
  enableAudioRecording: json['enableAudioRecording'] as bool?,
  peopleDetectionEligible: json['peopleDetectionEligible'] as bool?,
  pirSettings: json['pirSettings'],
  pirMotionZones: (json['pirMotionZones'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  floodlightSettings: json['floodlightSettings'] == null
      ? null
      : FloodlightSettings.fromJson(
          json['floodlightSettings'] as Map<String, dynamic>,
        ),
  lightScheduleSettings: json['lightScheduleSettings'],
  lumaLightThreshold: (json['lumaLightThreshold'] as num?)?.toInt(),
  liveViewDisabled: json['liveViewDisabled'] as bool?,
  motionDetectionEnabled: json['motionDetectionEnabled'] as bool?,
  powerMode: json['powerMode'] as String?,
  sheilaSettings: json['sheilaSettings'] == null
      ? null
      : SheilaSettings.fromJson(json['sheilaSettings'] as Map<String, dynamic>),
  serverSettings: json['serverSettings'] == null
      ? null
      : ServerSettings.fromJson(json['serverSettings'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CameraSettingsDataToJson(CameraSettingsData instance) =>
    <String, dynamic>{
      'enableVod': instance.enableVod,
      'motionZones': instance.motionZones,
      'motionSnoozePresetProfile': instance.motionSnoozePresetProfile,
      'liveViewPresetProfile': instance.liveViewPresetProfile,
      'liveViewPresets': instance.liveViewPresets,
      'motionSnoozePresets': instance.motionSnoozePresets,
      'doorbellVolume': instance.doorbellVolume,
      'chimeSettings': instance.chimeSettings,
      'videoSettings': instance.videoSettings,
      'motionAnnouncement': instance.motionAnnouncement,
      'streamSetting': instance.streamSetting,
      'advancedMotionDetectionEnabled': instance.advancedMotionDetectionEnabled,
      'advancedMotionDetectionHumanOnlyMode':
          instance.advancedMotionDetectionHumanOnlyMode,
      'lumaNightThreshold': instance.lumaNightThreshold,
      'enableAudioRecording': instance.enableAudioRecording,
      'peopleDetectionEligible': instance.peopleDetectionEligible,
      'pirSettings': instance.pirSettings,
      'pirMotionZones': instance.pirMotionZones,
      'floodlightSettings': instance.floodlightSettings,
      'lightScheduleSettings': instance.lightScheduleSettings,
      'lumaLightThreshold': instance.lumaLightThreshold,
      'liveViewDisabled': instance.liveViewDisabled,
      'motionDetectionEnabled': instance.motionDetectionEnabled,
      'powerMode': instance.powerMode,
      'sheilaSettings': instance.sheilaSettings,
      'serverSettings': instance.serverSettings,
    };

CameraOwner _$CameraOwnerFromJson(Map<String, dynamic> json) => CameraOwner(
  id: (json['id'] as num?)?.toInt(),
  email: json['email'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
);

Map<String, dynamic> _$CameraOwnerToJson(CameraOwner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

SirenStatus _$SirenStatusFromJson(Map<String, dynamic> json) => SirenStatus(
  startedAt: json['startedAt'] as String?,
  duration: json['duration'] as String?,
  endsAt: json['endsAt'] as String?,
  secondsRemaining: (json['secondsRemaining'] as num?)?.toInt(),
);

Map<String, dynamic> _$SirenStatusToJson(SirenStatus instance) =>
    <String, dynamic>{
      'startedAt': instance.startedAt,
      'duration': instance.duration,
      'endsAt': instance.endsAt,
      'secondsRemaining': instance.secondsRemaining,
    };

CameraHealthData _$CameraHealthDataFromJson(
  Map<String, dynamic> json,
) => CameraHealthData(
  deviceType: json['deviceType'] as String?,
  lastUpdateTime: (json['lastUpdateTime'] as num?)?.toInt(),
  connected: json['connected'] as bool?,
  rssConnected: json['rssConnected'] as bool?,
  vodEnabled: json['vodEnabled'] as bool?,
  sidewalkConnection: json['sidewalkConnection'] as bool?,
  floodlightOn: json['floodlightOn'] as bool?,
  sirenOn: json['sirenOn'] as bool?,
  whiteLedOn: json['whiteLedOn'] as bool?,
  nightModeOn: json['nightModeOn'] as bool?,
  hatchOpen: json['hatchOpen'] as bool?,
  packetLoss: (json['packetLoss'] as num?)?.toDouble(),
  packetLossCategory: json['packetLossCategory'] as String?,
  rssi: (json['rssi'] as num?)?.toInt(),
  batteryVoltage: (json['batteryVoltage'] as num?)?.toDouble(),
  wifiIsRingNetwork: json['wifiIsRingNetwork'] as bool?,
  supportedRpcCommands: (json['supportedRpcCommands'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  otaStatus: json['otaStatus'] as String?,
  extPowerState: (json['extPowerState'] as num?)?.toInt(),
  prefRunMode: json['prefRunMode'] as String?,
  runMode: json['runMode'] as String?,
  networkConnectionValue: json['networkConnectionValue'] as String?,
  acPower: (json['acPower'] as num?)?.toInt(),
  batteryPresent: json['batteryPresent'] as bool?,
  externalConnection: json['externalConnection'] as bool?,
  batteryPercentage: (json['batteryPercentage'] as num?)?.toInt(),
  batteryPercentageCategory: json['batteryPercentageCategory'] as String?,
  firmwareVersion: json['firmwareVersion'] as String?,
  rssiCategory: json['rssiCategory'] as String?,
  batteryVoltageCategory: json['batteryVoltageCategory'] as String?,
  secondBatteryVoltageCategory: json['secondBatteryVoltageCategory'] as String?,
  secondBatteryPercentage: (json['secondBatteryPercentage'] as num?)?.toInt(),
  secondBatteryPercentageCategory:
      json['secondBatteryPercentageCategory'] as String?,
  batterySave: json['batterySave'] as bool?,
  firmwareVersionStatus: json['firmwareVersionStatus'] as String?,
  txRate: (json['txRate'] as num?)?.toInt(),
  ptzConnected: json['ptzConnected'] as String?,
);

Map<String, dynamic> _$CameraHealthDataToJson(
  CameraHealthData instance,
) => <String, dynamic>{
  'deviceType': instance.deviceType,
  'lastUpdateTime': instance.lastUpdateTime,
  'connected': instance.connected,
  'rssConnected': instance.rssConnected,
  'vodEnabled': instance.vodEnabled,
  'sidewalkConnection': instance.sidewalkConnection,
  'floodlightOn': instance.floodlightOn,
  'sirenOn': instance.sirenOn,
  'whiteLedOn': instance.whiteLedOn,
  'nightModeOn': instance.nightModeOn,
  'hatchOpen': instance.hatchOpen,
  'packetLoss': instance.packetLoss,
  'packetLossCategory': instance.packetLossCategory,
  'rssi': instance.rssi,
  'batteryVoltage': instance.batteryVoltage,
  'wifiIsRingNetwork': instance.wifiIsRingNetwork,
  'supportedRpcCommands': instance.supportedRpcCommands,
  'otaStatus': instance.otaStatus,
  'extPowerState': instance.extPowerState,
  'prefRunMode': instance.prefRunMode,
  'runMode': instance.runMode,
  'networkConnectionValue': instance.networkConnectionValue,
  'acPower': instance.acPower,
  'batteryPresent': instance.batteryPresent,
  'externalConnection': instance.externalConnection,
  'batteryPercentage': instance.batteryPercentage,
  'batteryPercentageCategory': instance.batteryPercentageCategory,
  'firmwareVersion': instance.firmwareVersion,
  'rssiCategory': instance.rssiCategory,
  'batteryVoltageCategory': instance.batteryVoltageCategory,
  'secondBatteryVoltageCategory': instance.secondBatteryVoltageCategory,
  'secondBatteryPercentage': instance.secondBatteryPercentage,
  'secondBatteryPercentageCategory': instance.secondBatteryPercentageCategory,
  'batterySave': instance.batterySave,
  'firmwareVersionStatus': instance.firmwareVersionStatus,
  'txRate': instance.txRate,
  'ptzConnected': instance.ptzConnected,
};

BaseCameraData _$BaseCameraDataFromJson(Map<String, dynamic> json) =>
    BaseCameraData(
      alerts: json['alerts'] == null
          ? null
          : CameraAlerts.fromJson(json['alerts'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
      deactivatedAt: json['deactivatedAt'] as String?,
      description: json['description'] as String?,
      deviceId: json['deviceId'] as String?,
      features: json['features'] == null
          ? null
          : CameraFeatures.fromJson(json['features'] as Map<String, dynamic>),
      id: (json['id'] as num?)?.toInt(),
      isSidewalkGateway: json['isSidewalkGateway'] as bool?,
      locationId: json['locationId'] as String?,
      motionSnooze: json['motionSnooze'] == null
          ? null
          : MotionSnooze.fromJson(json['motionSnooze'] as Map<String, dynamic>),
      nightModeStatus: json['nightModeStatus'] as String?,
      owned: json['owned'] as bool?,
      ringNetId: json['ringNetId'],
      settings: json['settings'] == null
          ? null
          : CameraSettingsData.fromJson(
              json['settings'] as Map<String, dynamic>,
            ),
      subscribed: json['subscribed'] as bool?,
      subscribedMotions: json['subscribedMotions'] as bool?,
      timeZone: json['timeZone'] as String?,
      motionDetectionEnabled: json['motionDetectionEnabled'] as bool?,
      cameraLocationIndoor: json['cameraLocationIndoor'] as bool?,
      facingWindow: json['facingWindow'] as bool?,
      enableIrLed: json['enableIrLed'] as bool?,
      owner: json['owner'] == null
          ? null
          : CameraOwner.fromJson(json['owner'] as Map<String, dynamic>),
      ledStatus: json['ledStatus'] as String?,
      ringCamLightInstalled: json['ringCamLightInstalled'] as String?,
      ringCamSetupFlow: json['ringCamSetupFlow'] as String?,
      sirenStatus: json['sirenStatus'] == null
          ? null
          : SirenStatus.fromJson(json['sirenStatus'] as Map<String, dynamic>),
      health: json['health'] == null
          ? null
          : CameraHealthData.fromJson(json['health'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BaseCameraDataToJson(BaseCameraData instance) =>
    <String, dynamic>{
      'alerts': instance.alerts,
      'createdAt': instance.createdAt,
      'deactivatedAt': instance.deactivatedAt,
      'description': instance.description,
      'deviceId': instance.deviceId,
      'features': instance.features,
      'id': instance.id,
      'isSidewalkGateway': instance.isSidewalkGateway,
      'locationId': instance.locationId,
      'motionSnooze': instance.motionSnooze,
      'nightModeStatus': instance.nightModeStatus,
      'owned': instance.owned,
      'ringNetId': instance.ringNetId,
      'settings': instance.settings,
      'subscribed': instance.subscribed,
      'subscribedMotions': instance.subscribedMotions,
      'timeZone': instance.timeZone,
      'motionDetectionEnabled': instance.motionDetectionEnabled,
      'cameraLocationIndoor': instance.cameraLocationIndoor,
      'facingWindow': instance.facingWindow,
      'enableIrLed': instance.enableIrLed,
      'owner': instance.owner,
      'ledStatus': instance.ledStatus,
      'ringCamLightInstalled': instance.ringCamLightInstalled,
      'ringCamSetupFlow': instance.ringCamSetupFlow,
      'sirenStatus': instance.sirenStatus,
      'health': instance.health,
    };

CameraData _$CameraDataFromJson(Map<String, dynamic> json) => CameraData(
  kind: json['kind'] as String,
  address: json['address'] as String,
  batteryLife: json['batteryLife'],
  batteryLife2: json['batteryLife2'],
  batteryVoltage: (json['batteryVoltage'] as num?)?.toDouble(),
  batteryVoltage2: (json['batteryVoltage2'] as num?)?.toDouble(),
  externalConnection: json['externalConnection'] as bool?,
  firmwareVersion: json['firmwareVersion'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  ringId: json['ringId'],
  stolen: json['stolen'] as bool,
  alerts: json['alerts'] == null
      ? null
      : CameraAlerts.fromJson(json['alerts'] as Map<String, dynamic>),
  createdAt: json['createdAt'] as String?,
  deactivatedAt: json['deactivatedAt'] as String?,
  description: json['description'] as String?,
  deviceId: json['deviceId'] as String?,
  features: json['features'] == null
      ? null
      : CameraFeatures.fromJson(json['features'] as Map<String, dynamic>),
  id: (json['id'] as num?)?.toInt(),
  isSidewalkGateway: json['isSidewalkGateway'] as bool?,
  locationId: json['locationId'] as String?,
  motionSnooze: json['motionSnooze'] == null
      ? null
      : MotionSnooze.fromJson(json['motionSnooze'] as Map<String, dynamic>),
  nightModeStatus: json['nightModeStatus'] as String?,
  owned: json['owned'] as bool?,
  ringNetId: json['ringNetId'],
  settings: json['settings'] == null
      ? null
      : CameraSettingsData.fromJson(json['settings'] as Map<String, dynamic>),
  subscribed: json['subscribed'] as bool?,
  subscribedMotions: json['subscribedMotions'] as bool?,
  timeZone: json['timeZone'] as String?,
  motionDetectionEnabled: json['motionDetectionEnabled'] as bool?,
  cameraLocationIndoor: json['cameraLocationIndoor'] as bool?,
  facingWindow: json['facingWindow'] as bool?,
  enableIrLed: json['enableIrLed'] as bool?,
  owner: json['owner'] == null
      ? null
      : CameraOwner.fromJson(json['owner'] as Map<String, dynamic>),
  ledStatus: json['ledStatus'] as String?,
  ringCamLightInstalled: json['ringCamLightInstalled'] as String?,
  ringCamSetupFlow: json['ringCamSetupFlow'] as String?,
  sirenStatus: json['sirenStatus'] == null
      ? null
      : SirenStatus.fromJson(json['sirenStatus'] as Map<String, dynamic>),
  health: json['health'] == null
      ? null
      : CameraHealthData.fromJson(json['health'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CameraDataToJson(CameraData instance) =>
    <String, dynamic>{
      'alerts': instance.alerts,
      'createdAt': instance.createdAt,
      'deactivatedAt': instance.deactivatedAt,
      'description': instance.description,
      'deviceId': instance.deviceId,
      'features': instance.features,
      'id': instance.id,
      'isSidewalkGateway': instance.isSidewalkGateway,
      'locationId': instance.locationId,
      'motionSnooze': instance.motionSnooze,
      'nightModeStatus': instance.nightModeStatus,
      'owned': instance.owned,
      'ringNetId': instance.ringNetId,
      'settings': instance.settings,
      'subscribed': instance.subscribed,
      'subscribedMotions': instance.subscribedMotions,
      'timeZone': instance.timeZone,
      'motionDetectionEnabled': instance.motionDetectionEnabled,
      'cameraLocationIndoor': instance.cameraLocationIndoor,
      'facingWindow': instance.facingWindow,
      'enableIrLed': instance.enableIrLed,
      'owner': instance.owner,
      'ledStatus': instance.ledStatus,
      'ringCamLightInstalled': instance.ringCamLightInstalled,
      'ringCamSetupFlow': instance.ringCamSetupFlow,
      'sirenStatus': instance.sirenStatus,
      'health': instance.health,
      'kind': instance.kind,
      'address': instance.address,
      'batteryLife': instance.batteryLife,
      'batteryLife2': instance.batteryLife2,
      'batteryVoltage': instance.batteryVoltage,
      'batteryVoltage2': instance.batteryVoltage2,
      'externalConnection': instance.externalConnection,
      'firmwareVersion': instance.firmwareVersion,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'ringId': instance.ringId,
      'stolen': instance.stolen,
    };

OnvifThirdPartyProperties _$OnvifThirdPartyPropertiesFromJson(
  Map<String, dynamic> json,
) => OnvifThirdPartyProperties(
  amznDsn: json['amznDsn'] as String,
  uuid: json['uuid'] as String,
);

Map<String, dynamic> _$OnvifThirdPartyPropertiesToJson(
  OnvifThirdPartyProperties instance,
) => <String, dynamic>{'amznDsn': instance.amznDsn, 'uuid': instance.uuid};

OnvifCameraMetadata _$OnvifCameraMetadataFromJson(Map<String, dynamic> json) =>
    OnvifCameraMetadata(
      legacyFwMigrated: json['legacyFwMigrated'] as bool,
      importedFromAmazon: json['importedFromAmazon'] as bool,
      isSidewalkGateway: json['isSidewalkGateway'] as bool,
      thirdPartyManufacturer: json['thirdPartyManufacturer'] as String,
      thirdPartyModel: json['thirdPartyModel'] as String,
      thirdPartyDsn: json['thirdPartyDsn'] as String,
      thirdPartyProperties: OnvifThirdPartyProperties.fromJson(
        json['thirdPartyProperties'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$OnvifCameraMetadataToJson(
  OnvifCameraMetadata instance,
) => <String, dynamic>{
  'legacyFwMigrated': instance.legacyFwMigrated,
  'importedFromAmazon': instance.importedFromAmazon,
  'isSidewalkGateway': instance.isSidewalkGateway,
  'thirdPartyManufacturer': instance.thirdPartyManufacturer,
  'thirdPartyModel': instance.thirdPartyModel,
  'thirdPartyDsn': instance.thirdPartyDsn,
  'thirdPartyProperties': instance.thirdPartyProperties,
};

OnvifCameraData _$OnvifCameraDataFromJson(Map<String, dynamic> json) =>
    OnvifCameraData(
      kind: json['kind'] as String,
      metadata: OnvifCameraMetadata.fromJson(
        json['metadata'] as Map<String, dynamic>,
      ),
      ownerId: (json['ownerId'] as num).toInt(),
      updatedAt: json['updatedAt'] as String,
      alerts: json['alerts'] == null
          ? null
          : CameraAlerts.fromJson(json['alerts'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
      deactivatedAt: json['deactivatedAt'] as String?,
      description: json['description'] as String?,
      deviceId: json['deviceId'] as String?,
      features: json['features'] == null
          ? null
          : CameraFeatures.fromJson(json['features'] as Map<String, dynamic>),
      id: (json['id'] as num?)?.toInt(),
      isSidewalkGateway: json['isSidewalkGateway'] as bool?,
      locationId: json['locationId'] as String?,
      motionSnooze: json['motionSnooze'] == null
          ? null
          : MotionSnooze.fromJson(json['motionSnooze'] as Map<String, dynamic>),
      nightModeStatus: json['nightModeStatus'] as String?,
      owned: json['owned'] as bool?,
      ringNetId: json['ringNetId'],
      settings: json['settings'] == null
          ? null
          : CameraSettingsData.fromJson(
              json['settings'] as Map<String, dynamic>,
            ),
      subscribed: json['subscribed'] as bool?,
      subscribedMotions: json['subscribedMotions'] as bool?,
      timeZone: json['timeZone'] as String?,
      motionDetectionEnabled: json['motionDetectionEnabled'] as bool?,
      cameraLocationIndoor: json['cameraLocationIndoor'] as bool?,
      facingWindow: json['facingWindow'] as bool?,
      enableIrLed: json['enableIrLed'] as bool?,
      owner: json['owner'] == null
          ? null
          : CameraOwner.fromJson(json['owner'] as Map<String, dynamic>),
      ledStatus: json['ledStatus'] as String?,
      ringCamLightInstalled: json['ringCamLightInstalled'] as String?,
      ringCamSetupFlow: json['ringCamSetupFlow'] as String?,
      sirenStatus: json['sirenStatus'] == null
          ? null
          : SirenStatus.fromJson(json['sirenStatus'] as Map<String, dynamic>),
      health: json['health'] == null
          ? null
          : CameraHealthData.fromJson(json['health'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OnvifCameraDataToJson(OnvifCameraData instance) =>
    <String, dynamic>{
      'alerts': instance.alerts,
      'createdAt': instance.createdAt,
      'deactivatedAt': instance.deactivatedAt,
      'description': instance.description,
      'deviceId': instance.deviceId,
      'features': instance.features,
      'id': instance.id,
      'isSidewalkGateway': instance.isSidewalkGateway,
      'locationId': instance.locationId,
      'motionSnooze': instance.motionSnooze,
      'nightModeStatus': instance.nightModeStatus,
      'owned': instance.owned,
      'ringNetId': instance.ringNetId,
      'settings': instance.settings,
      'subscribed': instance.subscribed,
      'subscribedMotions': instance.subscribedMotions,
      'timeZone': instance.timeZone,
      'motionDetectionEnabled': instance.motionDetectionEnabled,
      'cameraLocationIndoor': instance.cameraLocationIndoor,
      'facingWindow': instance.facingWindow,
      'enableIrLed': instance.enableIrLed,
      'owner': instance.owner,
      'ledStatus': instance.ledStatus,
      'ringCamLightInstalled': instance.ringCamLightInstalled,
      'ringCamSetupFlow': instance.ringCamSetupFlow,
      'sirenStatus': instance.sirenStatus,
      'health': instance.health,
      'kind': instance.kind,
      'metadata': instance.metadata,
      'ownerId': instance.ownerId,
      'updatedAt': instance.updatedAt,
    };

ThirdPartyGdoProperties _$ThirdPartyGdoPropertiesFromJson(
  Map<String, dynamic> json,
) => ThirdPartyGdoProperties(
  keyAccessPointAssociated: json['keyAccessPointAssociated'] as String,
);

Map<String, dynamic> _$ThirdPartyGdoPropertiesToJson(
  ThirdPartyGdoProperties instance,
) => <String, dynamic>{
  'keyAccessPointAssociated': instance.keyAccessPointAssociated,
};

ThirdPartyGdoMetadata _$ThirdPartyGdoMetadataFromJson(
  Map<String, dynamic> json,
) => ThirdPartyGdoMetadata(
  isSidewalkGateway: json['isSidewalkGateway'] as bool,
  thirdPartyManufacturer: json['thirdPartyManufacturer'] as String,
  thirdPartyModel: json['thirdPartyModel'] as String,
  thirdPartyProperties: ThirdPartyGdoProperties.fromJson(
    json['thirdPartyProperties'] as Map<String, dynamic>,
  ),
  integrationType: json['integrationType'] as String,
);

Map<String, dynamic> _$ThirdPartyGdoMetadataToJson(
  ThirdPartyGdoMetadata instance,
) => <String, dynamic>{
  'isSidewalkGateway': instance.isSidewalkGateway,
  'thirdPartyManufacturer': instance.thirdPartyManufacturer,
  'thirdPartyModel': instance.thirdPartyModel,
  'thirdPartyProperties': instance.thirdPartyProperties,
  'integrationType': instance.integrationType,
};

ThirdPartyGarageDoorOpener _$ThirdPartyGarageDoorOpenerFromJson(
  Map<String, dynamic> json,
) => ThirdPartyGarageDoorOpener(
  id: (json['id'] as num).toInt(),
  kind: json['kind'] as String,
  description: json['description'] as String,
  locationId: json['locationId'] as String,
  ownerId: (json['ownerId'] as num).toInt(),
  hardwareId: json['hardwareId'] as String,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
  role: json['role'] as String,
  metadata: ThirdPartyGdoMetadata.fromJson(
    json['metadata'] as Map<String, dynamic>,
  ),
  ringNetId: json['ringNetId'],
  isSidewalkGateway: json['isSidewalkGateway'] as bool,
);

Map<String, dynamic> _$ThirdPartyGarageDoorOpenerToJson(
  ThirdPartyGarageDoorOpener instance,
) => <String, dynamic>{
  'id': instance.id,
  'kind': instance.kind,
  'description': instance.description,
  'locationId': instance.locationId,
  'ownerId': instance.ownerId,
  'hardwareId': instance.hardwareId,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'role': instance.role,
  'metadata': instance.metadata,
  'ringNetId': instance.ringNetId,
  'isSidewalkGateway': instance.isSidewalkGateway,
};

IntercomFunction _$IntercomFunctionFromJson(Map<String, dynamic> json) =>
    IntercomFunction(name: json['name']);

Map<String, dynamic> _$IntercomFunctionToJson(IntercomFunction instance) =>
    <String, dynamic>{'name': instance.name};

IntercomChimeSettings _$IntercomChimeSettingsFromJson(
  Map<String, dynamic> json,
) => IntercomChimeSettings(
  type: (json['type'] as num?)?.toInt(),
  enable: json['enable'] as bool,
  duration: (json['duration'] as num?)?.toInt(),
);

Map<String, dynamic> _$IntercomChimeSettingsToJson(
  IntercomChimeSettings instance,
) => <String, dynamic>{
  'type': instance.type,
  'enable': instance.enable,
  'duration': instance.duration,
};

IntercomSettings _$IntercomSettingsFromJson(Map<String, dynamic> json) =>
    IntercomSettings(
      predecessor: json['predecessor'] as String,
      config: json['config'] as String,
      ringToOpen: json['ringToOpen'] as bool,
      intercomType: json['intercomType'] as String,
      unlockMode: (json['unlockMode'] as num?)?.toInt(),
      replication: (json['replication'] as num?)?.toInt(),
    );

Map<String, dynamic> _$IntercomSettingsToJson(IntercomSettings instance) =>
    <String, dynamic>{
      'predecessor': instance.predecessor,
      'config': instance.config,
      'ringToOpen': instance.ringToOpen,
      'intercomType': instance.intercomType,
      'unlockMode': instance.unlockMode,
      'replication': instance.replication,
    };

IntercomHandsetSettings _$IntercomHandsetSettingsFromJson(
  Map<String, dynamic> json,
) => IntercomHandsetSettings(
  showRecordings: json['showRecordings'] as bool,
  recordingTtl: (json['recordingTtl'] as num?)?.toInt(),
  recordingEnabled: json['recordingEnabled'] as bool,
  keepAlive: json['keepAlive'],
  chimeSettings: IntercomChimeSettings.fromJson(
    json['chimeSettings'] as Map<String, dynamic>,
  ),
  intercomSettings: IntercomSettings.fromJson(
    json['intercomSettings'] as Map<String, dynamic>,
  ),
  keepAliveAuto: (json['keepAliveAuto'] as num?)?.toInt(),
  doorbellVolume: (json['doorbellVolume'] as num?)?.toInt(),
  enableChime: (json['enableChime'] as num?)?.toInt(),
  theftAlarmEnable: (json['theftAlarmEnable'] as num?)?.toInt(),
  useCachedDomain: (json['useCachedDomain'] as num?)?.toInt(),
  useServerIp: (json['useServerIp'] as num?)?.toInt(),
  serverDomain: json['serverDomain'] as String,
  serverIp: json['serverIp'],
  enableLog: (json['enableLog'] as num?)?.toInt(),
  forcedKeepAlive: json['forcedKeepAlive'],
  micVolume: (json['micVolume'] as num?)?.toInt(),
  voiceVolume: (json['voiceVolume'] as num?)?.toInt(),
);

Map<String, dynamic> _$IntercomHandsetSettingsToJson(
  IntercomHandsetSettings instance,
) => <String, dynamic>{
  'showRecordings': instance.showRecordings,
  'recordingTtl': instance.recordingTtl,
  'recordingEnabled': instance.recordingEnabled,
  'keepAlive': instance.keepAlive,
  'chimeSettings': instance.chimeSettings,
  'intercomSettings': instance.intercomSettings,
  'keepAliveAuto': instance.keepAliveAuto,
  'doorbellVolume': instance.doorbellVolume,
  'enableChime': instance.enableChime,
  'theftAlarmEnable': instance.theftAlarmEnable,
  'useCachedDomain': instance.useCachedDomain,
  'useServerIp': instance.useServerIp,
  'serverDomain': instance.serverDomain,
  'serverIp': instance.serverIp,
  'enableLog': instance.enableLog,
  'forcedKeepAlive': instance.forcedKeepAlive,
  'micVolume': instance.micVolume,
  'voiceVolume': instance.voiceVolume,
};

IntercomHandsetFeatures _$IntercomHandsetFeaturesFromJson(
  Map<String, dynamic> json,
) => IntercomHandsetFeatures(
  motionZoneRecommendation: json['motionZoneRecommendation'] as bool,
  motionsEnabled: json['motionsEnabled'] as bool,
  showRecordings: json['showRecordings'] as bool,
  showVodSettings: json['showVodSettings'] as bool,
  richNotificationsEligible: json['richNotificationsEligible'] as bool,
  show24x7Lite: json['show24x7Lite'] as bool,
  showOfflineMotionEvents: json['showOfflineMotionEvents'] as bool,
  cfesEligible: json['cfesEligible'] as bool,
  sheilaCameraEligible: json['sheilaCameraEligible'] as bool?,
  sheilaCameraProcessingEligible:
      json['sheilaCameraProcessingEligible'] as bool?,
  chimeAutoDetectCapable: json['chimeAutoDetectCapable'] as bool,
);

Map<String, dynamic> _$IntercomHandsetFeaturesToJson(
  IntercomHandsetFeatures instance,
) => <String, dynamic>{
  'motionZoneRecommendation': instance.motionZoneRecommendation,
  'motionsEnabled': instance.motionsEnabled,
  'showRecordings': instance.showRecordings,
  'showVodSettings': instance.showVodSettings,
  'richNotificationsEligible': instance.richNotificationsEligible,
  'show24x7Lite': instance.show24x7Lite,
  'showOfflineMotionEvents': instance.showOfflineMotionEvents,
  'cfesEligible': instance.cfesEligible,
  'sheilaCameraEligible': instance.sheilaCameraEligible,
  'sheilaCameraProcessingEligible': instance.sheilaCameraProcessingEligible,
  'chimeAutoDetectCapable': instance.chimeAutoDetectCapable,
};

IntercomHandsetAlerts _$IntercomHandsetAlertsFromJson(
  Map<String, dynamic> json,
) => IntercomHandsetAlerts(
  connection: json['connection'] as String,
  otaStatus: json['otaStatus'] as String?,
);

Map<String, dynamic> _$IntercomHandsetAlertsToJson(
  IntercomHandsetAlerts instance,
) => <String, dynamic>{
  'connection': instance.connection,
  'otaStatus': instance.otaStatus,
};

IntercomHandsetMetadata _$IntercomHandsetMetadataFromJson(
  Map<String, dynamic> json,
) => IntercomHandsetMetadata(
  ethernet: json['ethernet'] as bool,
  legacyFwMigrated: json['legacyFwMigrated'] as bool,
  importedFromAmazon: json['importedFromAmazon'] as bool,
  isSidewalkGateway: json['isSidewalkGateway'] as bool,
  keyAccessPointAssociated: json['keyAccessPointAssociated'] as bool,
);

Map<String, dynamic> _$IntercomHandsetMetadataToJson(
  IntercomHandsetMetadata instance,
) => <String, dynamic>{
  'ethernet': instance.ethernet,
  'legacyFwMigrated': instance.legacyFwMigrated,
  'importedFromAmazon': instance.importedFromAmazon,
  'isSidewalkGateway': instance.isSidewalkGateway,
  'keyAccessPointAssociated': instance.keyAccessPointAssociated,
};

IntercomHandsetAudioData _$IntercomHandsetAudioDataFromJson(
  Map<String, dynamic> json,
) => IntercomHandsetAudioData(
  id: (json['id'] as num?)?.toInt(),
  description: json['description'] as String,
  deviceId: json['deviceId'] as String,
  kind: json['kind'] as String,
  function: IntercomFunction.fromJson(json['function'] as Map<String, dynamic>),
  settings: IntercomHandsetSettings.fromJson(
    json['settings'] as Map<String, dynamic>,
  ),
  features: IntercomHandsetFeatures.fromJson(
    json['features'] as Map<String, dynamic>,
  ),
  owned: json['owned'] as bool,
  owner: CameraOwner.fromJson(json['owner'] as Map<String, dynamic>),
  alerts: IntercomHandsetAlerts.fromJson(
    json['alerts'] as Map<String, dynamic>,
  ),
  firmwareVersion: json['firmwareVersion'] as String,
  locationId: json['locationId'] as String,
  timeZone: json['timeZone'] as String,
  createdAt: json['createdAt'] as String,
  ringNetId: json['ringNetId'],
  isSidewalkGateway: json['isSidewalkGateway'] as bool,
  subscribed: json['subscribed'] as bool,
  deactivatedAt: json['deactivatedAt'] as String?,
  batteryLife: json['batteryLife'] as String,
  metadata: IntercomHandsetMetadata.fromJson(
    json['metadata'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$IntercomHandsetAudioDataToJson(
  IntercomHandsetAudioData instance,
) => <String, dynamic>{
  'id': instance.id,
  'description': instance.description,
  'deviceId': instance.deviceId,
  'kind': instance.kind,
  'function': instance.function,
  'settings': instance.settings,
  'features': instance.features,
  'owned': instance.owned,
  'owner': instance.owner,
  'alerts': instance.alerts,
  'firmwareVersion': instance.firmwareVersion,
  'locationId': instance.locationId,
  'timeZone': instance.timeZone,
  'createdAt': instance.createdAt,
  'ringNetId': instance.ringNetId,
  'isSidewalkGateway': instance.isSidewalkGateway,
  'subscribed': instance.subscribed,
  'deactivatedAt': instance.deactivatedAt,
  'batteryLife': instance.batteryLife,
  'metadata': instance.metadata,
};

UnknownDevice _$UnknownDeviceFromJson(Map<String, dynamic> json) =>
    UnknownDevice(
      id: (json['id'] as num).toInt(),
      kind: json['kind'],
      description: json['description'] as String,
    );

Map<String, dynamic> _$UnknownDeviceToJson(UnknownDevice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': instance.kind,
      'description': instance.description,
    };

CvDetectionType _$CvDetectionTypeFromJson(Map<String, dynamic> json) =>
    CvDetectionType(
      enabled: json['enabled'] as bool,
      mode: json['mode'] as String,
      notification: json['notification'] as bool,
    );

Map<String, dynamic> _$CvDetectionTypeToJson(CvDetectionType instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'mode': instance.mode,
      'notification': instance.notification,
    };

DayNightConfig _$DayNightConfigFromJson(Map<String, dynamic> json) =>
    DayNightConfig(
      day: (json['day'] as num).toInt(),
      night: (json['night'] as num).toInt(),
    );

Map<String, dynamic> _$DayNightConfigToJson(DayNightConfig instance) =>
    <String, dynamic>{'day': instance.day, 'night': instance.night};

AdvancedObjectSettings _$AdvancedObjectSettingsFromJson(
  Map<String, dynamic> json,
) => AdvancedObjectSettings(
  humanDetectionConfidence: DayNightConfig.fromJson(
    json['humanDetectionConfidence'] as Map<String, dynamic>,
  ),
  motionZoneOverlap: DayNightConfig.fromJson(
    json['motionZoneOverlap'] as Map<String, dynamic>,
  ),
  objectSizeMaximum: DayNightConfig.fromJson(
    json['objectSizeMaximum'] as Map<String, dynamic>,
  ),
  objectSizeMinimum: DayNightConfig.fromJson(
    json['objectSizeMinimum'] as Map<String, dynamic>,
  ),
  objectTimeOverlap: DayNightConfig.fromJson(
    json['objectTimeOverlap'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AdvancedObjectSettingsToJson(
  AdvancedObjectSettings instance,
) => <String, dynamic>{
  'humanDetectionConfidence': instance.humanDetectionConfidence,
  'motionZoneOverlap': instance.motionZoneOverlap,
  'objectSizeMaximum': instance.objectSizeMaximum,
  'objectSizeMinimum': instance.objectSizeMinimum,
  'objectTimeOverlap': instance.objectTimeOverlap,
};

AdvancedMotionSettings _$AdvancedMotionSettingsFromJson(
  Map<String, dynamic> json,
) => AdvancedMotionSettings(
  activeMotionFilter: (json['activeMotionFilter'] as num).toInt(),
  advancedObjectSettings: AdvancedObjectSettings.fromJson(
    json['advancedObjectSettings'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AdvancedMotionSettingsToJson(
  AdvancedMotionSettings instance,
) => <String, dynamic>{
  'activeMotionFilter': instance.activeMotionFilter,
  'advancedObjectSettings': instance.advancedObjectSettings,
};

DeviceChimeSettings _$DeviceChimeSettingsFromJson(Map<String, dynamic> json) =>
    DeviceChimeSettings(
      duration: (json['duration'] as num).toInt(),
      enable: json['enable'] as bool,
      enableExt: json['enableExt'] as bool,
      type: (json['type'] as num).toInt(),
    );

Map<String, dynamic> _$DeviceChimeSettingsToJson(
  DeviceChimeSettings instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'enable': instance.enable,
  'enableExt': instance.enableExt,
  'type': instance.type,
};

MotionSettings _$MotionSettingsFromJson(Map<String, dynamic> json) =>
    MotionSettings(
      enableAudio: json['enableAudio'] as bool,
      motionDetectionEnabled: json['motionDetectionEnabled'] as bool,
      enableIrLed: json['enableIrLed'] as bool,
      advancedMotionDetectionEnabled:
          json['advancedMotionDetectionEnabled'] as bool,
      advancedMotionDetectionMode:
          json['advancedMotionDetectionMode'] as String,
      advancedMotionDetectionHumanOnlyMode:
          json['advancedMotionDetectionHumanOnlyMode'] as bool,
      advancedMotionDetectionLoiteringMode:
          json['advancedMotionDetectionLoiteringMode'] as bool,
      motionSnoozePrivacyTimeout: (json['motionSnoozePrivacyTimeout'] as num)
          .toInt(),
      advancedMotionZonesEnabled: json['advancedMotionZonesEnabled'] as bool,
      advancedMotionZonesType: json['advancedMotionZonesType'] as String,
      enableIndoorMode: json['enableIndoorMode'] as bool,
      enablePirValidation: json['enablePirValidation'] as bool,
      loiteringThreshold: (json['loiteringThreshold'] as num).toInt(),
      enableRlmd: json['enableRlmd'] as bool,
      enableRecording: json['enableRecording'] as bool,
      endDetection: (json['endDetection'] as num).toInt(),
      advancedMotionRecordingHumanMode:
          json['advancedMotionRecordingHumanMode'] as bool,
      advancedMotionGlanceEnabled: json['advancedMotionGlanceEnabled'] as bool,
    );

Map<String, dynamic> _$MotionSettingsToJson(
  MotionSettings instance,
) => <String, dynamic>{
  'enableAudio': instance.enableAudio,
  'motionDetectionEnabled': instance.motionDetectionEnabled,
  'enableIrLed': instance.enableIrLed,
  'advancedMotionDetectionEnabled': instance.advancedMotionDetectionEnabled,
  'advancedMotionDetectionMode': instance.advancedMotionDetectionMode,
  'advancedMotionDetectionHumanOnlyMode':
      instance.advancedMotionDetectionHumanOnlyMode,
  'advancedMotionDetectionLoiteringMode':
      instance.advancedMotionDetectionLoiteringMode,
  'motionSnoozePrivacyTimeout': instance.motionSnoozePrivacyTimeout,
  'advancedMotionZonesEnabled': instance.advancedMotionZonesEnabled,
  'advancedMotionZonesType': instance.advancedMotionZonesType,
  'enableIndoorMode': instance.enableIndoorMode,
  'enablePirValidation': instance.enablePirValidation,
  'loiteringThreshold': instance.loiteringThreshold,
  'enableRlmd': instance.enableRlmd,
  'enableRecording': instance.enableRecording,
  'endDetection': instance.endDetection,
  'advancedMotionRecordingHumanMode': instance.advancedMotionRecordingHumanMode,
  'advancedMotionGlanceEnabled': instance.advancedMotionGlanceEnabled,
};

VideoSettings _$VideoSettingsFromJson(Map<String, dynamic> json) =>
    VideoSettings(
      exposureControl: (json['exposureControl'] as num).toInt(),
      nightColorEnable: json['nightColorEnable'] as bool,
      hdrEnable: json['hdrEnable'] as bool,
      clipLengthMax: (json['clipLengthMax'] as num).toInt(),
      clipLengthMin: (json['clipLengthMin'] as num).toInt(),
      aeMode: (json['aeMode'] as num).toInt(),
      aeMask: json['aeMask'] as String,
    );

Map<String, dynamic> _$VideoSettingsToJson(VideoSettings instance) =>
    <String, dynamic>{
      'exposureControl': instance.exposureControl,
      'nightColorEnable': instance.nightColorEnable,
      'hdrEnable': instance.hdrEnable,
      'clipLengthMax': instance.clipLengthMax,
      'clipLengthMin': instance.clipLengthMin,
      'aeMode': instance.aeMode,
      'aeMask': instance.aeMask,
    };

VodSettings _$VodSettingsFromJson(Map<String, dynamic> json) => VodSettings(
  enable: json['enable'] as bool,
  toggledAt: json['toggledAt'] as String,
  useCachedVodDomain: json['useCachedVodDomain'] as bool,
);

Map<String, dynamic> _$VodSettingsToJson(VodSettings instance) =>
    <String, dynamic>{
      'enable': instance.enable,
      'toggledAt': instance.toggledAt,
      'useCachedVodDomain': instance.useCachedVodDomain,
    };

VolumeSettings _$VolumeSettingsFromJson(Map<String, dynamic> json) =>
    VolumeSettings(
      doorbellVolume: (json['doorbellVolume'] as num).toInt(),
      micVolume: (json['micVolume'] as num).toInt(),
      voiceVolume: (json['voiceVolume'] as num).toInt(),
    );

Map<String, dynamic> _$VolumeSettingsToJson(VolumeSettings instance) =>
    <String, dynamic>{
      'doorbellVolume': instance.doorbellVolume,
      'micVolume': instance.micVolume,
      'voiceVolume': instance.voiceVolume,
    };

CvDetectionTypes _$CvDetectionTypesFromJson(Map<String, dynamic> json) =>
    CvDetectionTypes(
      human: CvDetectionType.fromJson(json['human'] as Map<String, dynamic>),
      loitering: CvDetectionType.fromJson(
        json['loitering'] as Map<String, dynamic>,
      ),
      motion: CvDetectionType.fromJson(json['motion'] as Map<String, dynamic>),
      movingVehicle: CvDetectionType.fromJson(
        json['movingVehicle'] as Map<String, dynamic>,
      ),
      nearbyPom: CvDetectionType.fromJson(
        json['nearbyPom'] as Map<String, dynamic>,
      ),
      otherMotion: CvDetectionType.fromJson(
        json['otherMotion'] as Map<String, dynamic>,
      ),
      packageDelivery: CvDetectionType.fromJson(
        json['packageDelivery'] as Map<String, dynamic>,
      ),
      packagePickup: CvDetectionType.fromJson(
        json['packagePickup'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CvDetectionTypesToJson(CvDetectionTypes instance) =>
    <String, dynamic>{
      'human': instance.human,
      'loitering': instance.loitering,
      'motion': instance.motion,
      'movingVehicle': instance.movingVehicle,
      'nearbyPom': instance.nearbyPom,
      'otherMotion': instance.otherMotion,
      'packageDelivery': instance.packageDelivery,
      'packagePickup': instance.packagePickup,
    };

CvThreshold _$CvThresholdFromJson(Map<String, dynamic> json) => CvThreshold(
  loitering: (json['loitering'] as num).toInt(),
  packageDelivery: (json['packageDelivery'] as num).toInt(),
);

Map<String, dynamic> _$CvThresholdToJson(CvThreshold instance) =>
    <String, dynamic>{
      'loitering': instance.loitering,
      'packageDelivery': instance.packageDelivery,
    };

CvSettings _$CvSettingsFromJson(Map<String, dynamic> json) => CvSettings(
  detectionTypes: CvDetectionTypes.fromJson(
    json['detectionTypes'] as Map<String, dynamic>,
  ),
  threshold: CvThreshold.fromJson(json['threshold'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CvSettingsToJson(CvSettings instance) =>
    <String, dynamic>{
      'detectionTypes': instance.detectionTypes,
      'threshold': instance.threshold,
    };

GeneralSettings _$GeneralSettingsFromJson(Map<String, dynamic> json) =>
    GeneralSettings(
      enableAudioRecording: json['enableAudioRecording'] as bool,
      lite24x7Enabled: json['lite24x7Enabled'] as bool,
      offlineMotionEventEnabled: json['offlineMotionEventEnabled'] as bool,
      lite24x7Subscribed: json['lite24x7Subscribed'] as bool,
      offlineMotionEventSubscribed:
          json['offlineMotionEventSubscribed'] as bool,
      firmwaresLocked: json['firmwaresLocked'] as bool,
      utcOffset: json['utcOffset'] as String,
      theftAlarmEnable: json['theftAlarmEnable'] as bool,
      useWrapupDomain: json['useWrapupDomain'] as bool,
      powerMode: json['powerMode'] as String,
      dataCollectionEnabled: json['dataCollectionEnabled'] as bool,
    );

Map<String, dynamic> _$GeneralSettingsToJson(GeneralSettings instance) =>
    <String, dynamic>{
      'enableAudioRecording': instance.enableAudioRecording,
      'lite24x7Enabled': instance.lite24x7Enabled,
      'offlineMotionEventEnabled': instance.offlineMotionEventEnabled,
      'lite24x7Subscribed': instance.lite24x7Subscribed,
      'offlineMotionEventSubscribed': instance.offlineMotionEventSubscribed,
      'firmwaresLocked': instance.firmwaresLocked,
      'utcOffset': instance.utcOffset,
      'theftAlarmEnable': instance.theftAlarmEnable,
      'useWrapupDomain': instance.useWrapupDomain,
      'powerMode': instance.powerMode,
      'dataCollectionEnabled': instance.dataCollectionEnabled,
    };

KeepAliveSettings _$KeepAliveSettingsFromJson(Map<String, dynamic> json) =>
    KeepAliveSettings(keepAliveAuto: (json['keepAliveAuto'] as num).toInt());

Map<String, dynamic> _$KeepAliveSettingsToJson(KeepAliveSettings instance) =>
    <String, dynamic>{'keepAliveAuto': instance.keepAliveAuto};

PirSettings _$PirSettingsFromJson(Map<String, dynamic> json) => PirSettings(
  sensitivity1: (json['sensitivity1'] as num).toInt(),
  sensitivity2: (json['sensitivity2'] as num).toInt(),
  sensitivity3: (json['sensitivity3'] as num).toInt(),
  zoneEnable: (json['zoneEnable'] as num).toInt(),
);

Map<String, dynamic> _$PirSettingsToJson(PirSettings instance) =>
    <String, dynamic>{
      'sensitivity1': instance.sensitivity1,
      'sensitivity2': instance.sensitivity2,
      'sensitivity3': instance.sensitivity3,
      'zoneEnable': instance.zoneEnable,
    };

SnapshotSettings _$SnapshotSettingsFromJson(Map<String, dynamic> json) =>
    SnapshotSettings(
      frequencySecs: (json['frequencySecs'] as num).toInt(),
      lite24x7ResolutionP: (json['lite24x7ResolutionP'] as num).toInt(),
      omeResolutionP: (json['omeResolutionP'] as num).toInt(),
      maxUploadKb: (json['maxUploadKb'] as num).toInt(),
      frequencyAfterSecs: (json['frequencyAfterSecs'] as num).toInt(),
      periodAfterSecs: (json['periodAfterSecs'] as num).toInt(),
      closeContainer: (json['closeContainer'] as num).toInt(),
    );

Map<String, dynamic> _$SnapshotSettingsToJson(SnapshotSettings instance) =>
    <String, dynamic>{
      'frequencySecs': instance.frequencySecs,
      'lite24x7ResolutionP': instance.lite24x7ResolutionP,
      'omeResolutionP': instance.omeResolutionP,
      'maxUploadKb': instance.maxUploadKb,
      'frequencyAfterSecs': instance.frequencyAfterSecs,
      'periodAfterSecs': instance.periodAfterSecs,
      'closeContainer': instance.closeContainer,
    };

ClientDeviceSettings _$ClientDeviceSettingsFromJson(
  Map<String, dynamic> json,
) => ClientDeviceSettings(
  ringtonesEnabled: json['ringtonesEnabled'] as bool,
  peopleOnlyEnabled: json['peopleOnlyEnabled'] as bool,
  advancedMotionEnabled: json['advancedMotionEnabled'] as bool,
  motionMessageEnabled: json['motionMessageEnabled'] as bool,
  shadowCorrectionEnabled: json['shadowCorrectionEnabled'] as bool,
  nightVisionEnabled: json['nightVisionEnabled'] as bool,
  lightScheduleEnabled: json['lightScheduleEnabled'] as bool,
  richNotificationsEligible: json['richNotificationsEligible'] as bool,
  show24x7Lite: json['show24x7Lite'] as bool,
  showOfflineMotionEvents: json['showOfflineMotionEvents'] as bool,
  cfesEligible: json['cfesEligible'] as bool,
  showRadarData: json['showRadarData'] as bool,
  motionZoneRecommendation: json['motionZoneRecommendation'] as bool,
);

Map<String, dynamic> _$ClientDeviceSettingsToJson(
  ClientDeviceSettings instance,
) => <String, dynamic>{
  'ringtonesEnabled': instance.ringtonesEnabled,
  'peopleOnlyEnabled': instance.peopleOnlyEnabled,
  'advancedMotionEnabled': instance.advancedMotionEnabled,
  'motionMessageEnabled': instance.motionMessageEnabled,
  'shadowCorrectionEnabled': instance.shadowCorrectionEnabled,
  'nightVisionEnabled': instance.nightVisionEnabled,
  'lightScheduleEnabled': instance.lightScheduleEnabled,
  'richNotificationsEligible': instance.richNotificationsEligible,
  'show24x7Lite': instance.show24x7Lite,
  'showOfflineMotionEvents': instance.showOfflineMotionEvents,
  'cfesEligible': instance.cfesEligible,
  'showRadarData': instance.showRadarData,
  'motionZoneRecommendation': instance.motionZoneRecommendation,
};

AlexaSettings _$AlexaSettingsFromJson(Map<String, dynamic> json) =>
    AlexaSettings(delayMs: (json['delayMs'] as num).toInt());

Map<String, dynamic> _$AlexaSettingsToJson(AlexaSettings instance) =>
    <String, dynamic>{'delayMs': instance.delayMs};

AutoreplySettings _$AutoreplySettingsFromJson(Map<String, dynamic> json) =>
    AutoreplySettings(delayMs: (json['delayMs'] as num).toInt());

Map<String, dynamic> _$AutoreplySettingsToJson(AutoreplySettings instance) =>
    <String, dynamic>{'delayMs': instance.delayMs};

ConciergeSettings _$ConciergeSettingsFromJson(Map<String, dynamic> json) =>
    ConciergeSettings(
      alexaSettings: json['alexaSettings'] == null
          ? null
          : AlexaSettings.fromJson(
              json['alexaSettings'] as Map<String, dynamic>,
            ),
      autoreplySettings: json['autoreplySettings'] == null
          ? null
          : AutoreplySettings.fromJson(
              json['autoreplySettings'] as Map<String, dynamic>,
            ),
      mode: json['mode'] as String?,
    );

Map<String, dynamic> _$ConciergeSettingsToJson(ConciergeSettings instance) =>
    <String, dynamic>{
      'alexaSettings': instance.alexaSettings,
      'autoreplySettings': instance.autoreplySettings,
      'mode': instance.mode,
    };

CameraDeviceSettingsData _$CameraDeviceSettingsDataFromJson(
  Map<String, dynamic> json,
) => CameraDeviceSettingsData(
  advancedMotionSettings: AdvancedMotionSettings.fromJson(
    json['advancedMotionSettings'] as Map<String, dynamic>,
  ),
  chimeSettings: DeviceChimeSettings.fromJson(
    json['chimeSettings'] as Map<String, dynamic>,
  ),
  motionSettings: MotionSettings.fromJson(
    json['motionSettings'] as Map<String, dynamic>,
  ),
  videoSettings: VideoSettings.fromJson(
    json['videoSettings'] as Map<String, dynamic>,
  ),
  vodSettings: VodSettings.fromJson(
    json['vodSettings'] as Map<String, dynamic>,
  ),
  volumeSettings: VolumeSettings.fromJson(
    json['volumeSettings'] as Map<String, dynamic>,
  ),
  cvSettings: CvSettings.fromJson(json['cvSettings'] as Map<String, dynamic>),
  generalSettings: GeneralSettings.fromJson(
    json['generalSettings'] as Map<String, dynamic>,
  ),
  keepAliveSettings: KeepAliveSettings.fromJson(
    json['keepAliveSettings'] as Map<String, dynamic>,
  ),
  pirSettings: PirSettings.fromJson(
    json['pirSettings'] as Map<String, dynamic>,
  ),
  snapshotSettings: SnapshotSettings.fromJson(
    json['snapshotSettings'] as Map<String, dynamic>,
  ),
  clientDeviceSettings: ClientDeviceSettings.fromJson(
    json['clientDeviceSettings'] as Map<String, dynamic>,
  ),
  conciergeSettings: json['conciergeSettings'] == null
      ? null
      : ConciergeSettings.fromJson(
          json['conciergeSettings'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$CameraDeviceSettingsDataToJson(
  CameraDeviceSettingsData instance,
) => <String, dynamic>{
  'advancedMotionSettings': instance.advancedMotionSettings,
  'chimeSettings': instance.chimeSettings,
  'motionSettings': instance.motionSettings,
  'videoSettings': instance.videoSettings,
  'vodSettings': instance.vodSettings,
  'volumeSettings': instance.volumeSettings,
  'cvSettings': instance.cvSettings,
  'generalSettings': instance.generalSettings,
  'keepAliveSettings': instance.keepAliveSettings,
  'pirSettings': instance.pirSettings,
  'snapshotSettings': instance.snapshotSettings,
  'clientDeviceSettings': instance.clientDeviceSettings,
  'conciergeSettings': instance.conciergeSettings,
};

ChimeHealth _$ChimeHealthFromJson(Map<String, dynamic> json) => ChimeHealth(
  id: (json['id'] as num).toInt(),
  wifiName: json['wifiName'] as String,
  batteryPercentage: json['batteryPercentage'] as String?,
  batteryPercentageCategory: json['batteryPercentageCategory'] as String?,
  batteryVoltage: (json['batteryVoltage'] as num?)?.toDouble(),
  batteryVoltageCategory: json['batteryVoltageCategory'] as String?,
  latestSignalStrength: (json['latestSignalStrength'] as num).toInt(),
  latestSignalCategory: json['latestSignalCategory'] as String?,
  averageSignalStrength: (json['averageSignalStrength'] as num).toInt(),
  averageSignalCategory: json['averageSignalCategory'] as String?,
  firmware: json['firmware'] as String,
  updatedAt: json['updatedAt'] as String,
  wifiIsRingNetwork: json['wifiIsRingNetwork'] as bool,
  packetLossCategory: json['packetLossCategory'] as String?,
  packetLossStrength: (json['packetLossStrength'] as num).toInt(),
);

Map<String, dynamic> _$ChimeHealthToJson(ChimeHealth instance) =>
    <String, dynamic>{
      'id': instance.id,
      'wifiName': instance.wifiName,
      'batteryPercentage': instance.batteryPercentage,
      'batteryPercentageCategory': instance.batteryPercentageCategory,
      'batteryVoltage': instance.batteryVoltage,
      'batteryVoltageCategory': instance.batteryVoltageCategory,
      'latestSignalStrength': instance.latestSignalStrength,
      'latestSignalCategory': instance.latestSignalCategory,
      'averageSignalStrength': instance.averageSignalStrength,
      'averageSignalCategory': instance.averageSignalCategory,
      'firmware': instance.firmware,
      'updatedAt': instance.updatedAt,
      'wifiIsRingNetwork': instance.wifiIsRingNetwork,
      'packetLossCategory': instance.packetLossCategory,
      'packetLossStrength': instance.packetLossStrength,
    };

CameraHealth _$CameraHealthFromJson(Map<String, dynamic> json) => CameraHealth(
  transformerVoltage: (json['transformerVoltage'] as num?)?.toInt(),
  transformerVoltageCategory: json['transformerVoltageCategory'] as String?,
  extPowerState: (json['extPowerState'] as num?)?.toInt(),
  id: (json['id'] as num).toInt(),
  wifiName: json['wifiName'] as String,
  batteryPercentage: json['batteryPercentage'] as String?,
  batteryPercentageCategory: json['batteryPercentageCategory'] as String?,
  batteryVoltage: (json['batteryVoltage'] as num?)?.toDouble(),
  batteryVoltageCategory: json['batteryVoltageCategory'] as String?,
  latestSignalStrength: (json['latestSignalStrength'] as num).toInt(),
  latestSignalCategory: json['latestSignalCategory'] as String?,
  averageSignalStrength: (json['averageSignalStrength'] as num).toInt(),
  averageSignalCategory: json['averageSignalCategory'] as String?,
  firmware: json['firmware'] as String,
  updatedAt: json['updatedAt'] as String,
  wifiIsRingNetwork: json['wifiIsRingNetwork'] as bool,
  packetLossCategory: json['packetLossCategory'] as String?,
  packetLossStrength: (json['packetLossStrength'] as num).toInt(),
);

Map<String, dynamic> _$CameraHealthToJson(CameraHealth instance) =>
    <String, dynamic>{
      'id': instance.id,
      'wifiName': instance.wifiName,
      'batteryPercentage': instance.batteryPercentage,
      'batteryPercentageCategory': instance.batteryPercentageCategory,
      'batteryVoltage': instance.batteryVoltage,
      'batteryVoltageCategory': instance.batteryVoltageCategory,
      'latestSignalStrength': instance.latestSignalStrength,
      'latestSignalCategory': instance.latestSignalCategory,
      'averageSignalStrength': instance.averageSignalStrength,
      'averageSignalCategory': instance.averageSignalCategory,
      'firmware': instance.firmware,
      'updatedAt': instance.updatedAt,
      'wifiIsRingNetwork': instance.wifiIsRingNetwork,
      'packetLossCategory': instance.packetLossCategory,
      'packetLossStrength': instance.packetLossStrength,
      'transformerVoltage': instance.transformerVoltage,
      'transformerVoltageCategory': instance.transformerVoltageCategory,
      'extPowerState': instance.extPowerState,
    };

CvProperties _$CvPropertiesFromJson(Map<String, dynamic> json) => CvProperties(
  detectionType: json['detectionType'],
  personDetected: json['personDetected'],
  streamBroken: json['streamBroken'],
);

Map<String, dynamic> _$CvPropertiesToJson(CvProperties instance) =>
    <String, dynamic>{
      'detectionType': instance.detectionType,
      'personDetected': instance.personDetected,
      'streamBroken': instance.streamBroken,
    };

CameraEvent _$CameraEventFromJson(Map<String, dynamic> json) => CameraEvent(
  createdAt: json['createdAt'] as String,
  cvProperties: CvProperties.fromJson(
    json['cvProperties'] as Map<String, dynamic>,
  ),
  dingId: (json['dingId'] as num).toInt(),
  dingIdStr: json['dingIdStr'] as String,
  doorbotId: (json['doorbotId'] as num).toInt(),
  favorite: json['favorite'] as bool,
  kind: json['kind'] as String,
  recorded: json['recorded'] as bool,
  recordingStatus: json['recordingStatus'] as String,
  state: json['state'] as String,
);

Map<String, dynamic> _$CameraEventToJson(CameraEvent instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'cvProperties': instance.cvProperties,
      'dingId': instance.dingId,
      'dingIdStr': instance.dingIdStr,
      'doorbotId': instance.doorbotId,
      'favorite': instance.favorite,
      'kind': instance.kind,
      'recorded': instance.recorded,
      'recordingStatus': instance.recordingStatus,
      'state': instance.state,
    };

PaginationMeta _$PaginationMetaFromJson(Map<String, dynamic> json) =>
    PaginationMeta(paginationKey: json['paginationKey'] as String);

Map<String, dynamic> _$PaginationMetaToJson(PaginationMeta instance) =>
    <String, dynamic>{'paginationKey': instance.paginationKey};

CameraEventResponse _$CameraEventResponseFromJson(Map<String, dynamic> json) =>
    CameraEventResponse(
      events: (json['events'] as List<dynamic>)
          .map((e) => CameraEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CameraEventResponseToJson(
  CameraEventResponse instance,
) => <String, dynamic>{'events': instance.events, 'meta': instance.meta};

CameraEventOptions _$CameraEventOptionsFromJson(Map<String, dynamic> json) =>
    CameraEventOptions(
      limit: (json['limit'] as num?)?.toInt(),
      kind: json['kind'] as String?,
      state: json['state'] as String?,
      favorites: json['favorites'] as bool?,
      olderThanId: json['olderThanId'] as String?,
      paginationKey: json['paginationKey'] as String?,
    );

Map<String, dynamic> _$CameraEventOptionsToJson(CameraEventOptions instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'kind': instance.kind,
      'state': instance.state,
      'favorites': instance.favorites,
      'olderThanId': instance.olderThanId,
      'paginationKey': instance.paginationKey,
    };

VideoSearchResult _$VideoSearchResultFromJson(Map<String, dynamic> json) =>
    VideoSearchResult(
      dingId: json['dingId'] as String,
      createdAt: (json['createdAt'] as num).toInt(),
      hqUrl: json['hqUrl'] as String?,
      lqUrl: json['lqUrl'] as String,
      prerollDuration: json['prerollDuration'],
      thumbnailUrl: json['thumbnailUrl'] as String,
      untranscodedUrl: json['untranscodedUrl'] as String,
      kind: json['kind'] as String,
      state: json['state'] as String,
      hadSubscription: json['hadSubscription'] as bool,
      favorite: json['favorite'] as bool,
      duration: (json['duration'] as num).toInt(),
      cvProperties: CvProperties.fromJson(
        json['cvProperties'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$VideoSearchResultToJson(VideoSearchResult instance) =>
    <String, dynamic>{
      'dingId': instance.dingId,
      'createdAt': instance.createdAt,
      'hqUrl': instance.hqUrl,
      'lqUrl': instance.lqUrl,
      'prerollDuration': instance.prerollDuration,
      'thumbnailUrl': instance.thumbnailUrl,
      'untranscodedUrl': instance.untranscodedUrl,
      'kind': instance.kind,
      'state': instance.state,
      'hadSubscription': instance.hadSubscription,
      'favorite': instance.favorite,
      'duration': instance.duration,
      'cvProperties': instance.cvProperties,
    };

VideoSearchResponse _$VideoSearchResponseFromJson(Map<String, dynamic> json) =>
    VideoSearchResponse(
      videoSearch: (json['videoSearch'] as List<dynamic>)
          .map((e) => VideoSearchResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VideoSearchResponseToJson(
  VideoSearchResponse instance,
) => <String, dynamic>{'videoSearch': instance.videoSearch};

PeriodicalFootage _$PeriodicalFootageFromJson(Map<String, dynamic> json) =>
    PeriodicalFootage(
      startMs: (json['startMs'] as num).toInt(),
      endMs: (json['endMs'] as num).toInt(),
      playbackMs: (json['playbackMs'] as num).toInt(),
      kind: json['kind'] as String,
      url: json['url'] as String,
      deleted: json['deleted'] as bool,
      snapshots: (json['snapshots'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$PeriodicalFootageToJson(PeriodicalFootage instance) =>
    <String, dynamic>{
      'startMs': instance.startMs,
      'endMs': instance.endMs,
      'playbackMs': instance.playbackMs,
      'kind': instance.kind,
      'url': instance.url,
      'deleted': instance.deleted,
      'snapshots': instance.snapshots,
    };

PeriodicFootageMeta _$PeriodicFootageMetaFromJson(Map<String, dynamic> json) =>
    PeriodicFootageMeta(
      paginationKey: (json['paginationKey'] as num).toInt(),
      butchSize: (json['butchSize'] as num).toInt(),
    );

Map<String, dynamic> _$PeriodicFootageMetaToJson(
  PeriodicFootageMeta instance,
) => <String, dynamic>{
  'paginationKey': instance.paginationKey,
  'butchSize': instance.butchSize,
};

PeriodicFootageResponse _$PeriodicFootageResponseFromJson(
  Map<String, dynamic> json,
) => PeriodicFootageResponse(
  meta: PeriodicFootageMeta.fromJson(json['meta'] as Map<String, dynamic>),
  data: (json['data'] as List<dynamic>)
      .map((e) => PeriodicalFootage.fromJson(e as Map<String, dynamic>))
      .toList(),
  responseTimestamp: (json['responseTimestamp'] as num).toInt(),
);

Map<String, dynamic> _$PeriodicFootageResponseToJson(
  PeriodicFootageResponse instance,
) => <String, dynamic>{
  'meta': instance.meta,
  'data': instance.data,
  'responseTimestamp': instance.responseTimestamp,
};

HistoryOptions _$HistoryOptionsFromJson(Map<String, dynamic> json) =>
    HistoryOptions(
      limit: (json['limit'] as num?)?.toInt(),
      offset: (json['offset'] as num?)?.toInt(),
      category: json['category'] as String?,
      maxLevel: (json['maxLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HistoryOptionsToJson(HistoryOptions instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'offset': instance.offset,
      'category': instance.category,
      'maxLevel': instance.maxLevel,
    };

RingDeviceHistoryEvent _$RingDeviceHistoryEventFromJson(
  Map<String, dynamic> json,
) => RingDeviceHistoryEvent(
  msg: json['msg'] as String,
  datatype: $enumDecode(_$MessageDataTypeEnumMap, json['datatype']),
  body: json['body'],
);

Map<String, dynamic> _$RingDeviceHistoryEventToJson(
  RingDeviceHistoryEvent instance,
) => <String, dynamic>{
  'msg': instance.msg,
  'datatype': _$MessageDataTypeEnumMap[instance.datatype]!,
  'body': instance.body,
};

PushNotificationAndroidConfig _$PushNotificationAndroidConfigFromJson(
  Map<String, dynamic> json,
) => PushNotificationAndroidConfig(
  category: json['category'] as String,
  body: json['body'] as String,
);

Map<String, dynamic> _$PushNotificationAndroidConfigToJson(
  PushNotificationAndroidConfig instance,
) => <String, dynamic>{'category': instance.category, 'body': instance.body};

PushNotificationAnalytics _$PushNotificationAnalyticsFromJson(
  Map<String, dynamic> json,
) => PushNotificationAnalytics(
  serverCorrelationId: json['serverCorrelationId'] as String,
  serverId: json['serverId'] as String,
  subcategory: json['subcategory'] as String,
  triggeredAt: (json['triggeredAt'] as num).toInt(),
  sentAt: (json['sentAt'] as num).toInt(),
  referringItemType: json['referringItemType'] as String,
  referringItemId: json['referringItemId'] as String,
);

Map<String, dynamic> _$PushNotificationAnalyticsToJson(
  PushNotificationAnalytics instance,
) => <String, dynamic>{
  'serverCorrelationId': instance.serverCorrelationId,
  'serverId': instance.serverId,
  'subcategory': instance.subcategory,
  'triggeredAt': instance.triggeredAt,
  'sentAt': instance.sentAt,
  'referringItemType': instance.referringItemType,
  'referringItemId': instance.referringItemId,
};

PushNotificationDevice _$PushNotificationDeviceFromJson(
  Map<String, dynamic> json,
) => PushNotificationDevice(
  e2eeEnabled: json['e2eeEnabled'] as bool,
  id: (json['id'] as num).toInt(),
  kind: json['kind'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$PushNotificationDeviceToJson(
  PushNotificationDevice instance,
) => <String, dynamic>{
  'e2eeEnabled': instance.e2eeEnabled,
  'id': instance.id,
  'kind': instance.kind,
  'name': instance.name,
};

PushNotificationDing _$PushNotificationDingFromJson(
  Map<String, dynamic> json,
) => PushNotificationDing(
  id: json['id'] as String,
  createdAt: json['createdAt'] as String,
  subtype: json['subtype'] as String,
  detectionType: json['detectionType'] as String?,
);

Map<String, dynamic> _$PushNotificationDingToJson(
  PushNotificationDing instance,
) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt,
  'subtype': instance.subtype,
  'detectionType': instance.detectionType,
};

PushNotificationEventito _$PushNotificationEventitoFromJson(
  Map<String, dynamic> json,
) => PushNotificationEventito(
  type: json['type'] as String,
  timestamp: (json['timestamp'] as num).toInt(),
);

Map<String, dynamic> _$PushNotificationEventitoToJson(
  PushNotificationEventito instance,
) => <String, dynamic>{'type': instance.type, 'timestamp': instance.timestamp};

PushNotificationLiveSession _$PushNotificationLiveSessionFromJson(
  Map<String, dynamic> json,
) => PushNotificationLiveSession(
  streamingDataHash: json['streamingDataHash'] as String,
  activeStreamingProfile: json['activeStreamingProfile'] as String,
  defaultAudioRoute: json['defaultAudioRoute'] as String,
  maxDuration: (json['maxDuration'] as num).toInt(),
);

Map<String, dynamic> _$PushNotificationLiveSessionToJson(
  PushNotificationLiveSession instance,
) => <String, dynamic>{
  'streamingDataHash': instance.streamingDataHash,
  'activeStreamingProfile': instance.activeStreamingProfile,
  'defaultAudioRoute': instance.defaultAudioRoute,
  'maxDuration': instance.maxDuration,
};

PushNotificationEvent _$PushNotificationEventFromJson(
  Map<String, dynamic> json,
) => PushNotificationEvent(
  ding: PushNotificationDing.fromJson(json['ding'] as Map<String, dynamic>),
  eventito: PushNotificationEventito.fromJson(
    json['eventito'] as Map<String, dynamic>,
  ),
  riid: json['riid'] as String,
  isSidewalk: json['isSidewalk'] as bool,
  liveSession: PushNotificationLiveSession.fromJson(
    json['liveSession'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$PushNotificationEventToJson(
  PushNotificationEvent instance,
) => <String, dynamic>{
  'ding': instance.ding,
  'eventito': instance.eventito,
  'riid': instance.riid,
  'isSidewalk': instance.isSidewalk,
  'liveSession': instance.liveSession,
};

PushNotificationLocation _$PushNotificationLocationFromJson(
  Map<String, dynamic> json,
) => PushNotificationLocation(id: json['id'] as String);

Map<String, dynamic> _$PushNotificationLocationToJson(
  PushNotificationLocation instance,
) => <String, dynamic>{'id': instance.id};

PushNotificationDingData _$PushNotificationDingDataFromJson(
  Map<String, dynamic> json,
) => PushNotificationDingData(
  device: PushNotificationDevice.fromJson(
    json['device'] as Map<String, dynamic>,
  ),
  event: PushNotificationEvent.fromJson(json['event'] as Map<String, dynamic>),
  location: PushNotificationLocation.fromJson(
    json['location'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$PushNotificationDingDataToJson(
  PushNotificationDingData instance,
) => <String, dynamic>{
  'device': instance.device,
  'event': instance.event,
  'location': instance.location,
};

PushNotificationImage _$PushNotificationImageFromJson(
  Map<String, dynamic> json,
) => PushNotificationImage(snapshotUuid: json['snapshotUuid'] as String);

Map<String, dynamic> _$PushNotificationImageToJson(
  PushNotificationImage instance,
) => <String, dynamic>{'snapshotUuid': instance.snapshotUuid};

PushNotificationDingV2 _$PushNotificationDingV2FromJson(
  Map<String, dynamic> json,
) => PushNotificationDingV2(
  version: json['version'] as String,
  androidConfig: PushNotificationAndroidConfig.fromJson(
    json['androidConfig'] as Map<String, dynamic>,
  ),
  analytics: PushNotificationAnalytics.fromJson(
    json['analytics'] as Map<String, dynamic>,
  ),
  data: PushNotificationDingData.fromJson(json['data'] as Map<String, dynamic>),
  img: json['img'] == null
      ? null
      : PushNotificationImage.fromJson(json['img'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PushNotificationDingV2ToJson(
  PushNotificationDingV2 instance,
) => <String, dynamic>{
  'version': instance.version,
  'androidConfig': instance.androidConfig,
  'analytics': instance.analytics,
  'data': instance.data,
  'img': instance.img,
};

PushNotificationAps _$PushNotificationApsFromJson(Map<String, dynamic> json) =>
    PushNotificationAps(alert: json['alert'] as String);

Map<String, dynamic> _$PushNotificationApsToJson(
  PushNotificationAps instance,
) => <String, dynamic>{'alert': instance.alert};

PushNotificationAlarmMeta _$PushNotificationAlarmMetaFromJson(
  Map<String, dynamic> json,
) => PushNotificationAlarmMeta(
  deviceZid: (json['deviceZid'] as num).toInt(),
  locationId: json['locationId'] as String,
);

Map<String, dynamic> _$PushNotificationAlarmMetaToJson(
  PushNotificationAlarmMeta instance,
) => <String, dynamic>{
  'deviceZid': instance.deviceZid,
  'locationId': instance.locationId,
};

PushNotificationAlarm _$PushNotificationAlarmFromJson(
  Map<String, dynamic> json,
) => PushNotificationAlarm(
  aps: PushNotificationAps.fromJson(json['aps'] as Map<String, dynamic>),
  action: json['action'] as String,
  alarmMeta: PushNotificationAlarmMeta.fromJson(
    json['alarmMeta'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$PushNotificationAlarmToJson(
  PushNotificationAlarm instance,
) => <String, dynamic>{
  'aps': instance.aps,
  'action': instance.action,
  'alarmMeta': instance.alarmMeta,
};

PushNotificationAlarmV2 _$PushNotificationAlarmV2FromJson(
  Map<String, dynamic> json,
) => PushNotificationAlarmV2(
  data: PushNotificationAlarmGcmData.fromJson(
    json['data'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$PushNotificationAlarmV2ToJson(
  PushNotificationAlarmV2 instance,
) => <String, dynamic>{'data': instance.data};

PushNotificationAlarmGcmData _$PushNotificationAlarmGcmDataFromJson(
  Map<String, dynamic> json,
) => PushNotificationAlarmGcmData(
  gcmData: PushNotificationAlarm.fromJson(
    json['gcmData'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$PushNotificationAlarmGcmDataToJson(
  PushNotificationAlarmGcmData instance,
) => <String, dynamic>{'gcmData': instance.gcmData};

PushNotificationIntercomUnlock _$PushNotificationIntercomUnlockFromJson(
  Map<String, dynamic> json,
) => PushNotificationIntercomUnlock(
  aps: PushNotificationAps.fromJson(json['aps'] as Map<String, dynamic>),
  action: json['action'] as String,
  alarmMeta: PushNotificationAlarmMeta.fromJson(
    json['alarmMeta'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$PushNotificationIntercomUnlockToJson(
  PushNotificationIntercomUnlock instance,
) => <String, dynamic>{
  'aps': instance.aps,
  'action': instance.action,
  'alarmMeta': instance.alarmMeta,
};

PushNotificationIntercomUnlockV2 _$PushNotificationIntercomUnlockV2FromJson(
  Map<String, dynamic> json,
) => PushNotificationIntercomUnlockV2(
  data: PushNotificationIntercomUnlockGcmData.fromJson(
    json['data'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$PushNotificationIntercomUnlockV2ToJson(
  PushNotificationIntercomUnlockV2 instance,
) => <String, dynamic>{'data': instance.data};

PushNotificationIntercomUnlockGcmData
_$PushNotificationIntercomUnlockGcmDataFromJson(Map<String, dynamic> json) =>
    PushNotificationIntercomUnlockGcmData(
      gcmData: PushNotificationIntercomUnlock.fromJson(
        json['gcmData'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$PushNotificationIntercomUnlockGcmDataToJson(
  PushNotificationIntercomUnlockGcmData instance,
) => <String, dynamic>{'gcmData': instance.gcmData};

SocketTicketResponse _$SocketTicketResponseFromJson(
  Map<String, dynamic> json,
) => SocketTicketResponse(
  ticket: json['ticket'] as String,
  responseTimestampe: (json['responseTimestampe'] as num).toInt(),
);

Map<String, dynamic> _$SocketTicketResponseToJson(
  SocketTicketResponse instance,
) => <String, dynamic>{
  'ticket': instance.ticket,
  'responseTimestampe': instance.responseTimestampe,
};

AuthTokenResponse _$AuthTokenResponseFromJson(Map<String, dynamic> json) =>
    AuthTokenResponse(
      accessToken: json['access_token'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
      refreshToken: json['refresh_token'] as String,
      scope: json['scope'] as String,
      tokenType: json['token_type'] as String,
    );

Map<String, dynamic> _$AuthTokenResponseToJson(AuthTokenResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'expires_in': instance.expiresIn,
      'refresh_token': instance.refreshToken,
      'scope': instance.scope,
      'token_type': instance.tokenType,
    };

Auth2faErrorResponse _$Auth2faErrorResponseFromJson(
  Map<String, dynamic> json,
) => Auth2faErrorResponse(
  error: json['error'],
  errorDescription: json['errorDescription'] as String?,
);

Map<String, dynamic> _$Auth2faErrorResponseToJson(
  Auth2faErrorResponse instance,
) => <String, dynamic>{
  'error': instance.error,
  'errorDescription': instance.errorDescription,
};

Auth2faSuccessResponse _$Auth2faSuccessResponseFromJson(
  Map<String, dynamic> json,
) => Auth2faSuccessResponse(
  nextTimeInSecs: (json['nextTimeInSecs'] as num).toInt(),
  phone: json['phone'] as String,
  tsvState: json['tsvState'] as String,
);

Map<String, dynamic> _$Auth2faSuccessResponseToJson(
  Auth2faSuccessResponse instance,
) => <String, dynamic>{
  'nextTimeInSecs': instance.nextTimeInSecs,
  'phone': instance.phone,
  'tsvState': instance.tsvState,
};

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      settings: json['settings'],
      preferences: json['preferences'],
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'settings': instance.settings,
      'preferences': instance.preferences,
    };

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  phoneNumber: json['phoneNumber'] as String,
  authenticationToken: json['authenticationToken'] as String,
  features: json['features'] as Map<String, dynamic>,
  userPreferences: UserPreferences.fromJson(
    json['userPreferences'] as Map<String, dynamic>,
  ),
  hardwareId: json['hardwareId'] as String,
  explorerProgramTerms: json['explorerProgramTerms'],
  userFlow: json['userFlow'] as String,
  appBrand: json['appBrand'] as String,
  country: json['country'] as String,
  status: json['status'] as String,
  createdAt: json['createdAt'] as String,
  tfaEnabled: json['tfaEnabled'] as bool,
  tfaPhoneNumber: json['tfaPhoneNumber'] as String?,
  accountType: json['accountType'] as String,
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'authenticationToken': instance.authenticationToken,
      'features': instance.features,
      'userPreferences': instance.userPreferences,
      'hardwareId': instance.hardwareId,
      'explorerProgramTerms': instance.explorerProgramTerms,
      'userFlow': instance.userFlow,
      'appBrand': instance.appBrand,
      'country': instance.country,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'tfaEnabled': instance.tfaEnabled,
      'tfaPhoneNumber': instance.tfaPhoneNumber,
      'accountType': instance.accountType,
    };

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    ProfileResponse(
      profile: UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{'profile': instance.profile};

AccountMonitoringStatus _$AccountMonitoringStatusFromJson(
  Map<String, dynamic> json,
) => AccountMonitoringStatus(
  accountUuid: json['accountUuid'] as String,
  externalServiceConfigType: json['externalServiceConfigType'] as String,
  accountState: json['accountState'] as String,
  eligibleForDispatch: json['eligibleForDispatch'] as bool,
  addressComplete: json['addressComplete'] as bool,
  contactsComplete: json['contactsComplete'] as bool,
  codewordComplete: json['codewordComplete'] as bool,
  alarmSignalSent: json['alarmSignalSent'] as bool,
  professionallyMonitored: json['professionallyMonitored'] as bool,
  userAcceptDispatch: json['userAcceptDispatch'] as bool,
  installationDate: (json['installationDate'] as num).toInt(),
  externalId: json['externalId'] as String,
  vrRequired: json['vrRequired'] as bool,
  vrUserOptIn: json['vrUserOptIn'] as bool,
  cmsMonitoringType: json['cmsMonitoringType'] as String,
  dispatchSetupComplete: json['dispatchSetupComplete'] as bool,
);

Map<String, dynamic> _$AccountMonitoringStatusToJson(
  AccountMonitoringStatus instance,
) => <String, dynamic>{
  'accountUuid': instance.accountUuid,
  'externalServiceConfigType': instance.externalServiceConfigType,
  'accountState': instance.accountState,
  'eligibleForDispatch': instance.eligibleForDispatch,
  'addressComplete': instance.addressComplete,
  'contactsComplete': instance.contactsComplete,
  'codewordComplete': instance.codewordComplete,
  'alarmSignalSent': instance.alarmSignalSent,
  'professionallyMonitored': instance.professionallyMonitored,
  'userAcceptDispatch': instance.userAcceptDispatch,
  'installationDate': instance.installationDate,
  'externalId': instance.externalId,
  'vrRequired': instance.vrRequired,
  'vrUserOptIn': instance.vrUserOptIn,
  'cmsMonitoringType': instance.cmsMonitoringType,
  'dispatchSetupComplete': instance.dispatchSetupComplete,
};

LocationModeSecurityStatus _$LocationModeSecurityStatusFromJson(
  Map<String, dynamic> json,
) => LocationModeSecurityStatus(
  lu: (json['lu'] as num?)?.toInt(),
  md: json['md'] as String?,
  returnTopic: json['returnTopic'] as String?,
);

Map<String, dynamic> _$LocationModeSecurityStatusToJson(
  LocationModeSecurityStatus instance,
) => <String, dynamic>{
  'lu': instance.lu,
  'md': instance.md,
  'returnTopic': instance.returnTopic,
};

NotYetParticipatingDevice _$NotYetParticipatingDeviceFromJson(
  Map<String, dynamic> json,
) => NotYetParticipatingDevice(
  deviceId: (json['deviceId'] as num).toInt(),
  deviceIdType: json['deviceIdType'] as String,
);

Map<String, dynamic> _$NotYetParticipatingDeviceToJson(
  NotYetParticipatingDevice instance,
) => <String, dynamic>{
  'deviceId': instance.deviceId,
  'deviceIdType': instance.deviceIdType,
};

LocationModeResponse _$LocationModeResponseFromJson(
  Map<String, dynamic> json,
) => LocationModeResponse(
  mode: json['mode'] as String,
  lastUpdateTimeMs: (json['lastUpdateTimeMs'] as num?)?.toInt(),
  securityStatus: LocationModeSecurityStatus.fromJson(
    json['securityStatus'] as Map<String, dynamic>,
  ),
  readOnly: json['readOnly'] as bool,
  notYetParticipatingInMode:
      (json['notYetParticipatingInMode'] as List<dynamic>?)
          ?.map(
            (e) =>
                NotYetParticipatingDevice.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$LocationModeResponseToJson(
  LocationModeResponse instance,
) => <String, dynamic>{
  'mode': instance.mode,
  'lastUpdateTimeMs': instance.lastUpdateTimeMs,
  'securityStatus': instance.securityStatus,
  'readOnly': instance.readOnly,
  'notYetParticipatingInMode': instance.notYetParticipatingInMode,
};

LocationModeSetting _$LocationModeSettingFromJson(Map<String, dynamic> json) =>
    LocationModeSetting(
      deviceId: json['deviceId'] as String,
      deviceIdType: json['deviceIdType'] as String,
      actions: (json['actions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$LocationModeSettingToJson(
  LocationModeSetting instance,
) => <String, dynamic>{
  'deviceId': instance.deviceId,
  'deviceIdType': instance.deviceIdType,
  'actions': instance.actions,
};

LocationModeSettings _$LocationModeSettingsFromJson(
  Map<String, dynamic> json,
) => LocationModeSettings(
  disarmed: (json['disarmed'] as List<dynamic>)
      .map((e) => LocationModeSetting.fromJson(e as Map<String, dynamic>))
      .toList(),
  home: (json['home'] as List<dynamic>)
      .map((e) => LocationModeSetting.fromJson(e as Map<String, dynamic>))
      .toList(),
  away: (json['away'] as List<dynamic>)
      .map((e) => LocationModeSetting.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LocationModeSettingsToJson(
  LocationModeSettings instance,
) => <String, dynamic>{
  'disarmed': instance.disarmed,
  'home': instance.home,
  'away': instance.away,
};

LocationModeSettingsResponse _$LocationModeSettingsResponseFromJson(
  Map<String, dynamic> json,
) => LocationModeSettingsResponse(
  lastUpdateTimeMs: (json['lastUpdateTimeMs'] as num).toInt(),
  disarmed: (json['disarmed'] as List<dynamic>)
      .map((e) => LocationModeSetting.fromJson(e as Map<String, dynamic>))
      .toList(),
  home: (json['home'] as List<dynamic>)
      .map((e) => LocationModeSetting.fromJson(e as Map<String, dynamic>))
      .toList(),
  away: (json['away'] as List<dynamic>)
      .map((e) => LocationModeSetting.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LocationModeSettingsResponseToJson(
  LocationModeSettingsResponse instance,
) => <String, dynamic>{
  'disarmed': instance.disarmed,
  'home': instance.home,
  'away': instance.away,
  'lastUpdateTimeMs': instance.lastUpdateTimeMs,
};

LocationModeSharing _$LocationModeSharingFromJson(Map<String, dynamic> json) =>
    LocationModeSharing(
      sharedUsersEnabled: json['sharedUsersEnabled'] as bool,
      lastUpdateTimeMs: (json['lastUpdateTimeMs'] as num).toInt(),
    );

Map<String, dynamic> _$LocationModeSharingToJson(
  LocationModeSharing instance,
) => <String, dynamic>{
  'sharedUsersEnabled': instance.sharedUsersEnabled,
  'lastUpdateTimeMs': instance.lastUpdateTimeMs,
};
