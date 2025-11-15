// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ring_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketIoMessage _$SocketIoMessageFromJson(Map<String, dynamic> json) =>
    SocketIoMessage(
      msg: $enumDecodeNullable(_$MessageTypeEnumMap, json['msg']),
      datatype: $enumDecodeNullable(_$MessageDataTypeEnumMap, json['datatype']),
      src: json['src'] as String?,
      body: json['body'] as List<dynamic>?,
      seq: (json['seq'] as num?)?.toInt(),
      sessionId: (json['sessionId'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      context: json['context'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$SocketIoMessageToJson(SocketIoMessage instance) =>
    <String, dynamic>{
      'msg': _$MessageTypeEnumMap[instance.msg],
      'datatype': _$MessageDataTypeEnumMap[instance.datatype],
      'src': instance.src,
      'body': instance.body,
      'seq': instance.seq,
      'sessionId': instance.sessionId,
      'status': instance.status,
      'context': instance.context,
    };

const _$MessageTypeEnumMap = {
  MessageType.roomGetList: 'RoomGetList',
  MessageType.sessionInfo: 'SessionInfo',
  MessageType.deviceInfoDocGetList: 'DeviceInfoDocGetList',
  MessageType.deviceInfoSet: 'DeviceInfoSet',
  MessageType.subscriptionTopicsInfo: 'SubscriptionTopicsInfo',
  MessageType.dataUpdate: 'DataUpdate',
  MessageType.passthru: 'Passthru',
  MessageType.empty: '',
};

const _$MessageDataTypeEnumMap = {
  MessageDataType.roomListV2Type: 'RoomListV2Type',
  MessageDataType.sessionInfoType: 'SessionInfoType',
  MessageDataType.deviceInfoDocType: 'DeviceInfoDocType',
  MessageDataType.deviceInfoSetType: 'DeviceInfoSetType',
  MessageDataType.hubDisconnectionEventType: 'HubDisconnectionEventType',
  MessageDataType.subscriptionTopicType: 'SubscriptionTopicType',
  MessageDataType.passthruType: 'PassthruType',
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
  deviceId: json['device_id'] as String?,
  features: json['features'],
  firmwareVersion: json['firmware_version'] as String?,
  id: (json['id'] as num?)?.toInt(),
  kind: json['kind'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  locationId: json['location_id'] as String?,
  longitude: (json['longitude'] as num?)?.toDouble(),
  owned: json['owned'] as bool?,
  owner: json['owner'] == null
      ? null
      : BaseStationOwner.fromJson(json['owner'] as Map<String, dynamic>),
  ringId: json['ring_id'],
  settings: json['settings'],
  stolen: json['stolen'] as bool?,
  timeZone: json['time_zone'] as String?,
);

Map<String, dynamic> _$BaseStationToJson(BaseStation instance) =>
    <String, dynamic>{
      'address': instance.address,
      'alerts': instance.alerts,
      'description': instance.description,
      'device_id': instance.deviceId,
      'features': instance.features,
      'firmware_version': instance.firmwareVersion,
      'id': instance.id,
      'kind': instance.kind,
      'latitude': instance.latitude,
      'location_id': instance.locationId,
      'longitude': instance.longitude,
      'owned': instance.owned,
      'owner': instance.owner,
      'ring_id': instance.ringId,
      'settings': instance.settings,
      'stolen': instance.stolen,
      'time_zone': instance.timeZone,
    };

BaseStationOwner _$BaseStationOwnerFromJson(Map<String, dynamic> json) =>
    BaseStationOwner(
      id: (json['id'] as num?)?.toInt(),
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
    );

Map<String, dynamic> _$BaseStationOwnerToJson(BaseStationOwner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
    };

BeamBridge _$BeamBridgeFromJson(Map<String, dynamic> json) => BeamBridge(
  createdAt: json['created_at'] as String,
  description: json['description'] as String,
  hardwareId: json['hardware_id'] as String,
  id: (json['id'] as num).toInt(),
  kind: json['kind'] as String,
  locationId: json['location_id'] as String,
  metadata: BeamBridgeMetadata.fromJson(
    json['metadata'] as Map<String, dynamic>,
  ),
  ownerId: (json['owner_id'] as num).toInt(),
  role: json['role'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$BeamBridgeToJson(BeamBridge instance) =>
    <String, dynamic>{
      'created_at': instance.createdAt,
      'description': instance.description,
      'hardware_id': instance.hardwareId,
      'id': instance.id,
      'kind': instance.kind,
      'location_id': instance.locationId,
      'metadata': instance.metadata,
      'owner_id': instance.ownerId,
      'role': instance.role,
      'updated_at': instance.updatedAt,
    };

BeamBridgeMetadata _$BeamBridgeMetadataFromJson(Map<String, dynamic> json) =>
    BeamBridgeMetadata(
      ethernet: json['ethernet'] as bool,
      legacyFwMigrated: json['legacy_fw_migrated'] as bool,
    );

Map<String, dynamic> _$BeamBridgeMetadataToJson(BeamBridgeMetadata instance) =>
    <String, dynamic>{
      'ethernet': instance.ethernet,
      'legacy_fw_migrated': instance.legacyFwMigrated,
    };

ChimeSettings _$ChimeSettingsFromJson(Map<String, dynamic> json) =>
    ChimeSettings(
      volume: (json['volume'] as num?)?.toInt(),
      dingAudioUserId: json['ding_audio_user_id'] as String?,
      dingAudioId: json['ding_audio_id'] as String?,
      motionAudioUserId: json['motion_audio_user_id'] as String?,
      motionAudioId: json['motion_audio_id'] as String?,
    );

Map<String, dynamic> _$ChimeSettingsToJson(ChimeSettings instance) =>
    <String, dynamic>{
      'volume': instance.volume,
      'ding_audio_user_id': instance.dingAudioUserId,
      'ding_audio_id': instance.dingAudioId,
      'motion_audio_user_id': instance.motionAudioUserId,
      'motion_audio_id': instance.motionAudioId,
    };

ChimeFeatures _$ChimeFeaturesFromJson(Map<String, dynamic> json) =>
    ChimeFeatures(ringtonesEnabled: json['ringtones_enabled'] as bool?);

Map<String, dynamic> _$ChimeFeaturesToJson(ChimeFeatures instance) =>
    <String, dynamic>{'ringtones_enabled': instance.ringtonesEnabled};

ChimeAlerts _$ChimeAlertsFromJson(Map<String, dynamic> json) => ChimeAlerts(
  connection: json['connection'] as String?,
  rssi: json['rssi'] as String?,
);

Map<String, dynamic> _$ChimeAlertsToJson(ChimeAlerts instance) =>
    <String, dynamic>{'connection': instance.connection, 'rssi': instance.rssi};

ChimeDoNotDisturb _$ChimeDoNotDisturbFromJson(Map<String, dynamic> json) =>
    ChimeDoNotDisturb(secondsLeft: (json['seconds_left'] as num?)?.toInt());

Map<String, dynamic> _$ChimeDoNotDisturbToJson(ChimeDoNotDisturb instance) =>
    <String, dynamic>{'seconds_left': instance.secondsLeft};

ChimeOwner _$ChimeOwnerFromJson(Map<String, dynamic> json) => ChimeOwner(
  id: (json['id'] as num?)?.toInt(),
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  email: json['email'] as String?,
);

Map<String, dynamic> _$ChimeOwnerToJson(ChimeOwner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
    };

ChimeData _$ChimeDataFromJson(Map<String, dynamic> json) => ChimeData(
  id: (json['id'] as num?)?.toInt(),
  description: json['description'] as String?,
  deviceId: json['device_id'] as String?,
  timeZone: json['time_zone'] as String?,
  firmwareVersion: json['firmware_version'] as String?,
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
  doNotDisturb: json['do_not_disturb'] == null
      ? null
      : ChimeDoNotDisturb.fromJson(
          json['do_not_disturb'] as Map<String, dynamic>,
        ),
  stolen: json['stolen'] as bool?,
  locationId: json['location_id'] as String?,
  ringId: json['ring_id'],
  owner: json['owner'] == null
      ? null
      : ChimeOwner.fromJson(json['owner'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChimeDataToJson(ChimeData instance) => <String, dynamic>{
  'id': instance.id,
  'description': instance.description,
  'device_id': instance.deviceId,
  'time_zone': instance.timeZone,
  'firmware_version': instance.firmwareVersion,
  'kind': instance.kind,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'address': instance.address,
  'settings': instance.settings,
  'features': instance.features,
  'owned': instance.owned,
  'alerts': instance.alerts,
  'do_not_disturb': instance.doNotDisturb,
  'stolen': instance.stolen,
  'location_id': instance.locationId,
  'ring_id': instance.ringId,
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
      userId: json['user_id'] as String,
      id: json['id'] as String,
      description: json['description'] as String,
      kind: json['kind'] as String,
      url: json['url'] as String,
      checksum: json['checksum'] as String,
      available: json['available'] as String,
    );

Map<String, dynamic> _$RingtoneAudioToJson(RingtoneAudio instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'id': instance.id,
      'description': instance.description,
      'kind': instance.kind,
      'url': instance.url,
      'checksum': instance.checksum,
      'available': instance.available,
    };

RingtoneOptions _$RingtoneOptionsFromJson(Map<String, dynamic> json) =>
    RingtoneOptions(
      defaultDingUserId: json['default_ding_user_id'] as String,
      defaultDingId: json['default_ding_id'] as String,
      defaultMotionUserId: json['default_motion_user_id'] as String,
      defaultMotionId: json['default_motion_id'] as String,
      audios: (json['audios'] as List<dynamic>)
          .map((e) => RingtoneAudio.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RingtoneOptionsToJson(RingtoneOptions instance) =>
    <String, dynamic>{
      'default_ding_user_id': instance.defaultDingUserId,
      'default_ding_id': instance.defaultDingId,
      'default_motion_user_id': instance.defaultMotionUserId,
      'default_motion_id': instance.defaultMotionId,
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
  otaStatus: json['ota_status'] as String?,
);

Map<String, dynamic> _$CameraAlertsToJson(CameraAlerts instance) =>
    <String, dynamic>{
      'connection': instance.connection,
      'battery': instance.battery,
      'ota_status': instance.otaStatus,
    };

CameraFeatures _$CameraFeaturesFromJson(Map<String, dynamic> json) =>
    CameraFeatures(
      motionsEnabled: json['motions_enabled'] as bool?,
      showRecordings: json['show_recordings'] as bool?,
      advancedMotionEnabled: json['advanced_motion_enabled'] as bool?,
      peopleOnlyEnabled: json['people_only_enabled'] as bool?,
      shadowCorrectionEnabled: json['shadow_correction_enabled'] as bool?,
      motionMessageEnabled: json['motion_message_enabled'] as bool?,
      nightVisionEnabled: json['night_vision_enabled'] as bool?,
    );

Map<String, dynamic> _$CameraFeaturesToJson(CameraFeatures instance) =>
    <String, dynamic>{
      'motions_enabled': instance.motionsEnabled,
      'show_recordings': instance.showRecordings,
      'advanced_motion_enabled': instance.advancedMotionEnabled,
      'people_only_enabled': instance.peopleOnlyEnabled,
      'shadow_correction_enabled': instance.shadowCorrectionEnabled,
      'motion_message_enabled': instance.motionMessageEnabled,
      'night_vision_enabled': instance.nightVisionEnabled,
    };

MotionSnooze _$MotionSnoozeFromJson(Map<String, dynamic> json) =>
    MotionSnooze(scheduled: json['scheduled'] as bool);

Map<String, dynamic> _$MotionSnoozeToJson(MotionSnooze instance) =>
    <String, dynamic>{'scheduled': instance.scheduled};

MotionZones _$MotionZonesFromJson(Map<String, dynamic> json) => MotionZones(
  enableAudio: json['enable_audio'] as bool,
  activeMotionFilter: (json['active_motion_filter'] as num?)?.toInt(),
  sensitivity: (json['sensitivity'] as num?)?.toInt(),
  advancedObjectSettings: json['advanced_object_settings'],
  zone1: json['zone1'],
  zone2: json['zone2'],
  zone3: json['zone3'],
);

Map<String, dynamic> _$MotionZonesToJson(MotionZones instance) =>
    <String, dynamic>{
      'enable_audio': instance.enableAudio,
      'active_motion_filter': instance.activeMotionFilter,
      'sensitivity': instance.sensitivity,
      'advanced_object_settings': instance.advancedObjectSettings,
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
      priority: (json['priority'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      brightness: (json['brightness'] as num?)?.toInt(),
      alwaysOn: json['always_on'] as bool?,
      alwaysOnDuration: (json['always_on_duration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FloodlightSettingsToJson(FloodlightSettings instance) =>
    <String, dynamic>{
      'priority': instance.priority,
      'duration': instance.duration,
      'brightness': instance.brightness,
      'always_on': instance.alwaysOn,
      'always_on_duration': instance.alwaysOnDuration,
    };

SheilaSettings _$SheilaSettingsFromJson(Map<String, dynamic> json) =>
    SheilaSettings(
      cvProcessingEnabled: json['cv_processing_enabled'] as bool?,
      localStorageEnabled: json['local_storage_enabled'] as bool?,
    );

Map<String, dynamic> _$SheilaSettingsToJson(SheilaSettings instance) =>
    <String, dynamic>{
      'cv_processing_enabled': instance.cvProcessingEnabled,
      'local_storage_enabled': instance.localStorageEnabled,
    };

ServerSettings _$ServerSettingsFromJson(Map<String, dynamic> json) =>
    ServerSettings(
      ringMediaServerEnabled: json['ring_media_server_enabled'] as bool,
    );

Map<String, dynamic> _$ServerSettingsToJson(ServerSettings instance) =>
    <String, dynamic>{
      'ring_media_server_enabled': instance.ringMediaServerEnabled,
    };

CameraSettingsData _$CameraSettingsDataFromJson(Map<String, dynamic> json) =>
    CameraSettingsData(
      enableVod: json['enable_vod'],
      motionZones: json['motion_zones'],
      motionSnoozePresetProfile:
          json['motion_snooze_preset_profile'] as String?,
      liveViewPresetProfile: json['live_view_preset_profile'] as String?,
      liveViewPresets: (json['live_view_presets'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      motionSnoozePresets: (json['motion_snooze_presets'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      doorbellVolume: (json['doorbell_volume'] as num?)?.toInt(),
      chimeSettings: json['chime_settings'] == null
          ? null
          : CameraChimeSettings.fromJson(
              json['chime_settings'] as Map<String, dynamic>,
            ),
      videoSettings: json['video_settings'],
      motionAnnouncement: json['motion_announcement'] as bool?,
      streamSetting: (json['stream_setting'] as num?)?.toInt(),
      advancedMotionDetectionEnabled:
          json['advanced_motion_detection_enabled'] as bool?,
      advancedMotionDetectionHumanOnlyMode:
          json['advanced_motion_detection_human_only_mode'] as bool?,
      lumaNightThreshold: (json['luma_night_threshold'] as num?)?.toInt(),
      enableAudioRecording: json['enable_audio_recording'] as bool?,
      peopleDetectionEligible: json['people_detection_eligible'] as bool?,
      pirSettings: json['pir_settings'],
      pirMotionZones: (json['pir_motion_zones'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      floodlightSettings: json['floodlight_settings'] == null
          ? null
          : FloodlightSettings.fromJson(
              json['floodlight_settings'] as Map<String, dynamic>,
            ),
      lightScheduleSettings: json['light_schedule_settings'],
      lumaLightThreshold: (json['luma_light_threshold'] as num?)?.toInt(),
      liveViewDisabled: json['live_view_disabled'] as bool?,
      motionDetectionEnabled: json['motion_detection_enabled'] as bool?,
      powerMode: json['power_mode'] as String?,
      sheilaSettings: json['sheila_settings'] == null
          ? null
          : SheilaSettings.fromJson(
              json['sheila_settings'] as Map<String, dynamic>,
            ),
      serverSettings: json['server_settings'] == null
          ? null
          : ServerSettings.fromJson(
              json['server_settings'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$CameraSettingsDataToJson(
  CameraSettingsData instance,
) => <String, dynamic>{
  'enable_vod': instance.enableVod,
  'motion_zones': instance.motionZones,
  'motion_snooze_preset_profile': instance.motionSnoozePresetProfile,
  'live_view_preset_profile': instance.liveViewPresetProfile,
  'live_view_presets': instance.liveViewPresets,
  'motion_snooze_presets': instance.motionSnoozePresets,
  'doorbell_volume': instance.doorbellVolume,
  'chime_settings': instance.chimeSettings,
  'video_settings': instance.videoSettings,
  'motion_announcement': instance.motionAnnouncement,
  'stream_setting': instance.streamSetting,
  'advanced_motion_detection_enabled': instance.advancedMotionDetectionEnabled,
  'advanced_motion_detection_human_only_mode':
      instance.advancedMotionDetectionHumanOnlyMode,
  'luma_night_threshold': instance.lumaNightThreshold,
  'enable_audio_recording': instance.enableAudioRecording,
  'people_detection_eligible': instance.peopleDetectionEligible,
  'pir_settings': instance.pirSettings,
  'pir_motion_zones': instance.pirMotionZones,
  'floodlight_settings': instance.floodlightSettings,
  'light_schedule_settings': instance.lightScheduleSettings,
  'luma_light_threshold': instance.lumaLightThreshold,
  'live_view_disabled': instance.liveViewDisabled,
  'motion_detection_enabled': instance.motionDetectionEnabled,
  'power_mode': instance.powerMode,
  'sheila_settings': instance.sheilaSettings,
  'server_settings': instance.serverSettings,
};

CameraOwner _$CameraOwnerFromJson(Map<String, dynamic> json) => CameraOwner(
  id: (json['id'] as num?)?.toInt(),
  email: json['email'] as String?,
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
);

Map<String, dynamic> _$CameraOwnerToJson(CameraOwner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
    };

SirenStatus _$SirenStatusFromJson(Map<String, dynamic> json) => SirenStatus(
  startedAt: json['started_at'] as String?,
  duration: json['duration'] as String?,
  endsAt: json['ends_at'] as String?,
  secondsRemaining: (json['seconds_remaining'] as num?)?.toInt(),
);

Map<String, dynamic> _$SirenStatusToJson(SirenStatus instance) =>
    <String, dynamic>{
      'started_at': instance.startedAt,
      'duration': instance.duration,
      'ends_at': instance.endsAt,
      'seconds_remaining': instance.secondsRemaining,
    };

CameraHealthData _$CameraHealthDataFromJson(Map<String, dynamic> json) =>
    CameraHealthData(
      deviceType: json['device_type'] as String?,
      lastUpdateTime: (json['last_update_time'] as num?)?.toInt(),
      connected: json['connected'] as bool?,
      rssConnected: json['rss_connected'] as bool?,
      vodEnabled: json['vod_enabled'] as bool?,
      sidewalkConnection: json['sidewalk_connection'] as bool?,
      floodlightOn: json['floodlight_on'] as bool?,
      sirenOn: json['siren_on'] as bool?,
      whiteLedOn: json['white_led_on'] as bool?,
      nightModeOn: json['night_mode_on'] as bool?,
      hatchOpen: json['hatch_open'] as bool?,
      packetLoss: (json['packet_loss'] as num?)?.toDouble(),
      packetLossCategory: json['packet_loss_category'] as String?,
      rssi: (json['rssi'] as num?)?.toInt(),
      batteryVoltage: (json['battery_voltage'] as num?)?.toDouble(),
      wifiIsRingNetwork: json['wifi_is_ring_network'] as bool?,
      supportedRpcCommands: (json['supported_rpc_commands'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      otaStatus: json['ota_status'] as String?,
      extPowerState: (json['ext_power_state'] as num?)?.toInt(),
      prefRunMode: json['pref_run_mode'] as String?,
      runMode: json['run_mode'] as String?,
      networkConnectionValue: json['network_connection_value'] as String?,
      acPower: (json['ac_power'] as num?)?.toInt(),
      batteryPresent: json['battery_present'] as bool?,
      externalConnection: json['external_connection'] as bool?,
      batteryPercentage: (json['battery_percentage'] as num?)?.toInt(),
      batteryPercentageCategory: json['battery_percentage_category'] as String?,
      firmwareVersion: json['firmware_version'] as String?,
      rssiCategory: json['rssi_category'] as String?,
      batteryVoltageCategory: json['battery_voltage_category'] as String?,
      secondBatteryVoltageCategory:
          json['second_battery_voltage_category'] as String?,
      secondBatteryPercentage: (json['second_battery_percentage'] as num?)
          ?.toInt(),
      secondBatteryPercentageCategory:
          json['second_battery_percentage_category'] as String?,
      batterySave: json['battery_save'] as bool?,
      firmwareVersionStatus: json['firmware_version_status'] as String?,
      txRate: (json['tx_rate'] as num?)?.toInt(),
      ptzConnected: json['ptz_connected'] as String?,
    );

Map<String, dynamic> _$CameraHealthDataToJson(CameraHealthData instance) =>
    <String, dynamic>{
      'device_type': instance.deviceType,
      'last_update_time': instance.lastUpdateTime,
      'connected': instance.connected,
      'rss_connected': instance.rssConnected,
      'vod_enabled': instance.vodEnabled,
      'sidewalk_connection': instance.sidewalkConnection,
      'floodlight_on': instance.floodlightOn,
      'siren_on': instance.sirenOn,
      'white_led_on': instance.whiteLedOn,
      'night_mode_on': instance.nightModeOn,
      'hatch_open': instance.hatchOpen,
      'packet_loss': instance.packetLoss,
      'packet_loss_category': instance.packetLossCategory,
      'rssi': instance.rssi,
      'battery_voltage': instance.batteryVoltage,
      'wifi_is_ring_network': instance.wifiIsRingNetwork,
      'supported_rpc_commands': instance.supportedRpcCommands,
      'ota_status': instance.otaStatus,
      'ext_power_state': instance.extPowerState,
      'pref_run_mode': instance.prefRunMode,
      'run_mode': instance.runMode,
      'network_connection_value': instance.networkConnectionValue,
      'ac_power': instance.acPower,
      'battery_present': instance.batteryPresent,
      'external_connection': instance.externalConnection,
      'battery_percentage': instance.batteryPercentage,
      'battery_percentage_category': instance.batteryPercentageCategory,
      'firmware_version': instance.firmwareVersion,
      'rssi_category': instance.rssiCategory,
      'battery_voltage_category': instance.batteryVoltageCategory,
      'second_battery_voltage_category': instance.secondBatteryVoltageCategory,
      'second_battery_percentage': instance.secondBatteryPercentage,
      'second_battery_percentage_category':
          instance.secondBatteryPercentageCategory,
      'battery_save': instance.batterySave,
      'firmware_version_status': instance.firmwareVersionStatus,
      'tx_rate': instance.txRate,
      'ptz_connected': instance.ptzConnected,
    };

BaseCameraData _$BaseCameraDataFromJson(
  Map<String, dynamic> json,
) => BaseCameraData(
  alerts: json['alerts'] == null
      ? null
      : CameraAlerts.fromJson(json['alerts'] as Map<String, dynamic>),
  createdAt: json['created_at'] as String?,
  deactivatedAt: json['deactivated_at'] as String?,
  description: json['description'] as String?,
  deviceId: json['device_id'] as String?,
  features: json['features'] == null
      ? null
      : CameraFeatures.fromJson(json['features'] as Map<String, dynamic>),
  id: (json['id'] as num?)?.toInt(),
  isSidewalkGateway: json['is_sidewalk_gateway'] as bool?,
  locationId: json['location_id'] as String?,
  motionSnooze: json['motion_snooze'] == null
      ? null
      : MotionSnooze.fromJson(json['motion_snooze'] as Map<String, dynamic>),
  nightModeStatus: json['night_mode_status'] as String?,
  owned: json['owned'] as bool?,
  ringNetId: json['ring_net_id'],
  settings: json['settings'] == null
      ? null
      : CameraSettingsData.fromJson(json['settings'] as Map<String, dynamic>),
  subscribed: json['subscribed'] as bool?,
  subscribedMotions: json['subscribed_motions'] as bool?,
  timeZone: json['time_zone'] as String?,
  motionDetectionEnabled: json['motion_detection_enabled'] as bool?,
  cameraLocationIndoor: json['camera_location_indoor'] as bool?,
  facingWindow: json['facing_window'] as bool?,
  enableIrLed: json['enable_ir_led'] as bool?,
  owner: json['owner'] == null
      ? null
      : CameraOwner.fromJson(json['owner'] as Map<String, dynamic>),
  ledStatus: json['led_status'],
  ringCamLightInstalled: json['ring_cam_light_installed'],
  ringCamSetupFlow: json['ring_cam_setup_flow'],
  sirenStatus: json['siren_status'] == null
      ? null
      : SirenStatus.fromJson(json['siren_status'] as Map<String, dynamic>),
  health: json['health'] == null
      ? null
      : CameraHealthData.fromJson(json['health'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BaseCameraDataToJson(BaseCameraData instance) =>
    <String, dynamic>{
      'alerts': instance.alerts,
      'created_at': instance.createdAt,
      'deactivated_at': instance.deactivatedAt,
      'description': instance.description,
      'device_id': instance.deviceId,
      'features': instance.features,
      'id': instance.id,
      'is_sidewalk_gateway': instance.isSidewalkGateway,
      'location_id': instance.locationId,
      'motion_snooze': instance.motionSnooze,
      'night_mode_status': instance.nightModeStatus,
      'owned': instance.owned,
      'ring_net_id': instance.ringNetId,
      'settings': instance.settings,
      'subscribed': instance.subscribed,
      'subscribed_motions': instance.subscribedMotions,
      'time_zone': instance.timeZone,
      'motion_detection_enabled': instance.motionDetectionEnabled,
      'camera_location_indoor': instance.cameraLocationIndoor,
      'facing_window': instance.facingWindow,
      'enable_ir_led': instance.enableIrLed,
      'owner': instance.owner,
      'led_status': instance.ledStatus,
      'ring_cam_light_installed': instance.ringCamLightInstalled,
      'ring_cam_setup_flow': instance.ringCamSetupFlow,
      'siren_status': instance.sirenStatus,
      'health': instance.health,
    };

CameraData _$CameraDataFromJson(Map<String, dynamic> json) => CameraData(
  kind: json['kind'] as String,
  address: json['address'] as String,
  batteryLife: json['battery_life'],
  batteryLife2: json['battery_life_2'],
  batteryVoltage: (json['battery_voltage'] as num?)?.toDouble(),
  batteryVoltage2: (json['battery_voltage_2'] as num?)?.toDouble(),
  externalConnection: json['external_connection'] as bool?,
  firmwareVersion: json['firmware_version'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  ringId: json['ring_id'],
  stolen: json['stolen'] as bool,
  alerts: json['alerts'] == null
      ? null
      : CameraAlerts.fromJson(json['alerts'] as Map<String, dynamic>),
  createdAt: json['created_at'] as String?,
  deactivatedAt: json['deactivated_at'] as String?,
  description: json['description'] as String?,
  deviceId: json['device_id'] as String?,
  features: json['features'] == null
      ? null
      : CameraFeatures.fromJson(json['features'] as Map<String, dynamic>),
  id: (json['id'] as num?)?.toInt(),
  isSidewalkGateway: json['is_sidewalk_gateway'] as bool?,
  locationId: json['location_id'] as String?,
  motionSnooze: json['motion_snooze'] == null
      ? null
      : MotionSnooze.fromJson(json['motion_snooze'] as Map<String, dynamic>),
  nightModeStatus: json['night_mode_status'] as String?,
  owned: json['owned'] as bool?,
  ringNetId: json['ring_net_id'],
  settings: json['settings'] == null
      ? null
      : CameraSettingsData.fromJson(json['settings'] as Map<String, dynamic>),
  subscribed: json['subscribed'] as bool?,
  subscribedMotions: json['subscribed_motions'] as bool?,
  timeZone: json['time_zone'] as String?,
  motionDetectionEnabled: json['motion_detection_enabled'] as bool?,
  cameraLocationIndoor: json['camera_location_indoor'] as bool?,
  facingWindow: json['facing_window'] as bool?,
  enableIrLed: json['enable_ir_led'] as bool?,
  owner: json['owner'] == null
      ? null
      : CameraOwner.fromJson(json['owner'] as Map<String, dynamic>),
  ledStatus: json['led_status'],
  ringCamLightInstalled: json['ring_cam_light_installed'],
  ringCamSetupFlow: json['ring_cam_setup_flow'],
  sirenStatus: json['siren_status'] == null
      ? null
      : SirenStatus.fromJson(json['siren_status'] as Map<String, dynamic>),
  health: json['health'] == null
      ? null
      : CameraHealthData.fromJson(json['health'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CameraDataToJson(CameraData instance) =>
    <String, dynamic>{
      'alerts': instance.alerts,
      'created_at': instance.createdAt,
      'deactivated_at': instance.deactivatedAt,
      'description': instance.description,
      'device_id': instance.deviceId,
      'features': instance.features,
      'id': instance.id,
      'is_sidewalk_gateway': instance.isSidewalkGateway,
      'location_id': instance.locationId,
      'motion_snooze': instance.motionSnooze,
      'night_mode_status': instance.nightModeStatus,
      'owned': instance.owned,
      'ring_net_id': instance.ringNetId,
      'settings': instance.settings,
      'subscribed': instance.subscribed,
      'subscribed_motions': instance.subscribedMotions,
      'time_zone': instance.timeZone,
      'motion_detection_enabled': instance.motionDetectionEnabled,
      'camera_location_indoor': instance.cameraLocationIndoor,
      'facing_window': instance.facingWindow,
      'enable_ir_led': instance.enableIrLed,
      'owner': instance.owner,
      'led_status': instance.ledStatus,
      'ring_cam_light_installed': instance.ringCamLightInstalled,
      'ring_cam_setup_flow': instance.ringCamSetupFlow,
      'siren_status': instance.sirenStatus,
      'health': instance.health,
      'kind': instance.kind,
      'address': instance.address,
      'battery_life': instance.batteryLife,
      'battery_life_2': instance.batteryLife2,
      'battery_voltage': instance.batteryVoltage,
      'battery_voltage_2': instance.batteryVoltage2,
      'external_connection': instance.externalConnection,
      'firmware_version': instance.firmwareVersion,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'ring_id': instance.ringId,
      'stolen': instance.stolen,
    };

OnvifThirdPartyProperties _$OnvifThirdPartyPropertiesFromJson(
  Map<String, dynamic> json,
) => OnvifThirdPartyProperties(
  amznDsn: json['amzn_dsn'] as String,
  uuid: json['uuid'] as String,
);

Map<String, dynamic> _$OnvifThirdPartyPropertiesToJson(
  OnvifThirdPartyProperties instance,
) => <String, dynamic>{'amzn_dsn': instance.amznDsn, 'uuid': instance.uuid};

OnvifCameraMetadata _$OnvifCameraMetadataFromJson(Map<String, dynamic> json) =>
    OnvifCameraMetadata(
      legacyFwMigrated: json['legacy_fw_migrated'] as bool,
      importedFromAmazon: json['imported_from_amazon'] as bool,
      isSidewalkGateway: json['is_sidewalk_gateway'] as bool,
      thirdPartyManufacturer: json['third_party_manufacturer'] as String,
      thirdPartyModel: json['third_party_model'] as String,
      thirdPartyDsn: json['third_party_dsn'] as String,
      thirdPartyProperties: OnvifThirdPartyProperties.fromJson(
        json['third_party_properties'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$OnvifCameraMetadataToJson(
  OnvifCameraMetadata instance,
) => <String, dynamic>{
  'legacy_fw_migrated': instance.legacyFwMigrated,
  'imported_from_amazon': instance.importedFromAmazon,
  'is_sidewalk_gateway': instance.isSidewalkGateway,
  'third_party_manufacturer': instance.thirdPartyManufacturer,
  'third_party_model': instance.thirdPartyModel,
  'third_party_dsn': instance.thirdPartyDsn,
  'third_party_properties': instance.thirdPartyProperties,
};

OnvifCameraData _$OnvifCameraDataFromJson(
  Map<String, dynamic> json,
) => OnvifCameraData(
  kind: json['kind'] as String,
  metadata: OnvifCameraMetadata.fromJson(
    json['metadata'] as Map<String, dynamic>,
  ),
  ownerId: (json['owner_id'] as num).toInt(),
  updatedAt: json['updated_at'] as String,
  alerts: json['alerts'] == null
      ? null
      : CameraAlerts.fromJson(json['alerts'] as Map<String, dynamic>),
  createdAt: json['created_at'] as String?,
  deactivatedAt: json['deactivated_at'] as String?,
  description: json['description'] as String?,
  deviceId: json['device_id'] as String?,
  features: json['features'] == null
      ? null
      : CameraFeatures.fromJson(json['features'] as Map<String, dynamic>),
  id: (json['id'] as num?)?.toInt(),
  isSidewalkGateway: json['is_sidewalk_gateway'] as bool?,
  locationId: json['location_id'] as String?,
  motionSnooze: json['motion_snooze'] == null
      ? null
      : MotionSnooze.fromJson(json['motion_snooze'] as Map<String, dynamic>),
  nightModeStatus: json['night_mode_status'] as String?,
  owned: json['owned'] as bool?,
  ringNetId: json['ring_net_id'],
  settings: json['settings'] == null
      ? null
      : CameraSettingsData.fromJson(json['settings'] as Map<String, dynamic>),
  subscribed: json['subscribed'] as bool?,
  subscribedMotions: json['subscribed_motions'] as bool?,
  timeZone: json['time_zone'] as String?,
  motionDetectionEnabled: json['motion_detection_enabled'] as bool?,
  cameraLocationIndoor: json['camera_location_indoor'] as bool?,
  facingWindow: json['facing_window'] as bool?,
  enableIrLed: json['enable_ir_led'] as bool?,
  owner: json['owner'] == null
      ? null
      : CameraOwner.fromJson(json['owner'] as Map<String, dynamic>),
  ledStatus: json['led_status'],
  ringCamLightInstalled: json['ring_cam_light_installed'],
  ringCamSetupFlow: json['ring_cam_setup_flow'],
  sirenStatus: json['siren_status'] == null
      ? null
      : SirenStatus.fromJson(json['siren_status'] as Map<String, dynamic>),
  health: json['health'] == null
      ? null
      : CameraHealthData.fromJson(json['health'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OnvifCameraDataToJson(OnvifCameraData instance) =>
    <String, dynamic>{
      'alerts': instance.alerts,
      'created_at': instance.createdAt,
      'deactivated_at': instance.deactivatedAt,
      'description': instance.description,
      'device_id': instance.deviceId,
      'features': instance.features,
      'id': instance.id,
      'is_sidewalk_gateway': instance.isSidewalkGateway,
      'location_id': instance.locationId,
      'motion_snooze': instance.motionSnooze,
      'night_mode_status': instance.nightModeStatus,
      'owned': instance.owned,
      'ring_net_id': instance.ringNetId,
      'settings': instance.settings,
      'subscribed': instance.subscribed,
      'subscribed_motions': instance.subscribedMotions,
      'time_zone': instance.timeZone,
      'motion_detection_enabled': instance.motionDetectionEnabled,
      'camera_location_indoor': instance.cameraLocationIndoor,
      'facing_window': instance.facingWindow,
      'enable_ir_led': instance.enableIrLed,
      'owner': instance.owner,
      'led_status': instance.ledStatus,
      'ring_cam_light_installed': instance.ringCamLightInstalled,
      'ring_cam_setup_flow': instance.ringCamSetupFlow,
      'siren_status': instance.sirenStatus,
      'health': instance.health,
      'kind': instance.kind,
      'metadata': instance.metadata,
      'owner_id': instance.ownerId,
      'updated_at': instance.updatedAt,
    };

ThirdPartyGdoProperties _$ThirdPartyGdoPropertiesFromJson(
  Map<String, dynamic> json,
) => ThirdPartyGdoProperties(
  keyAccessPointAssociated: json['key_access_point_associated'] as String,
);

Map<String, dynamic> _$ThirdPartyGdoPropertiesToJson(
  ThirdPartyGdoProperties instance,
) => <String, dynamic>{
  'key_access_point_associated': instance.keyAccessPointAssociated,
};

ThirdPartyGdoMetadata _$ThirdPartyGdoMetadataFromJson(
  Map<String, dynamic> json,
) => ThirdPartyGdoMetadata(
  isSidewalkGateway: json['is_sidewalk_gateway'] as bool,
  thirdPartyManufacturer: json['third_party_manufacturer'] as String,
  thirdPartyModel: json['third_party_model'] as String,
  thirdPartyProperties: ThirdPartyGdoProperties.fromJson(
    json['third_party_properties'] as Map<String, dynamic>,
  ),
  integrationType: json['integration_type'] as String,
);

Map<String, dynamic> _$ThirdPartyGdoMetadataToJson(
  ThirdPartyGdoMetadata instance,
) => <String, dynamic>{
  'is_sidewalk_gateway': instance.isSidewalkGateway,
  'third_party_manufacturer': instance.thirdPartyManufacturer,
  'third_party_model': instance.thirdPartyModel,
  'third_party_properties': instance.thirdPartyProperties,
  'integration_type': instance.integrationType,
};

ThirdPartyGarageDoorOpener _$ThirdPartyGarageDoorOpenerFromJson(
  Map<String, dynamic> json,
) => ThirdPartyGarageDoorOpener(
  id: (json['id'] as num).toInt(),
  kind: json['kind'] as String,
  description: json['description'] as String,
  locationId: json['location_id'] as String,
  ownerId: (json['owner_id'] as num).toInt(),
  hardwareId: json['hardware_id'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  role: json['role'] as String,
  metadata: ThirdPartyGdoMetadata.fromJson(
    json['metadata'] as Map<String, dynamic>,
  ),
  ringNetId: json['ring_net_id'],
  isSidewalkGateway: json['is_sidewalk_gateway'] as bool,
);

Map<String, dynamic> _$ThirdPartyGarageDoorOpenerToJson(
  ThirdPartyGarageDoorOpener instance,
) => <String, dynamic>{
  'id': instance.id,
  'kind': instance.kind,
  'description': instance.description,
  'location_id': instance.locationId,
  'owner_id': instance.ownerId,
  'hardware_id': instance.hardwareId,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'role': instance.role,
  'metadata': instance.metadata,
  'ring_net_id': instance.ringNetId,
  'is_sidewalk_gateway': instance.isSidewalkGateway,
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
      ringToOpen: json['ring_to_open'] as bool,
      intercomType: json['intercom_type'] as String,
      unlockMode: (json['unlock_mode'] as num?)?.toInt(),
      replication: (json['replication'] as num?)?.toInt(),
    );

Map<String, dynamic> _$IntercomSettingsToJson(IntercomSettings instance) =>
    <String, dynamic>{
      'predecessor': instance.predecessor,
      'config': instance.config,
      'ring_to_open': instance.ringToOpen,
      'intercom_type': instance.intercomType,
      'unlock_mode': instance.unlockMode,
      'replication': instance.replication,
    };

IntercomHandsetSettings _$IntercomHandsetSettingsFromJson(
  Map<String, dynamic> json,
) => IntercomHandsetSettings(
  showRecordings: json['show_recordings'] as bool,
  recordingTtl: (json['recording_ttl'] as num?)?.toInt(),
  recordingEnabled: json['recording_enabled'] as bool,
  keepAlive: json['keep_alive'],
  chimeSettings: IntercomChimeSettings.fromJson(
    json['chime_settings'] as Map<String, dynamic>,
  ),
  intercomSettings: IntercomSettings.fromJson(
    json['intercom_settings'] as Map<String, dynamic>,
  ),
  keepAliveAuto: (json['keep_alive_auto'] as num?)?.toInt(),
  doorbellVolume: (json['doorbell_volume'] as num?)?.toInt(),
  enableChime: (json['enable_chime'] as num?)?.toInt(),
  theftAlarmEnable: (json['theft_alarm_enable'] as num?)?.toInt(),
  useCachedDomain: (json['use_cached_domain'] as num?)?.toInt(),
  useServerIp: (json['use_server_ip'] as num?)?.toInt(),
  serverDomain: json['server_domain'] as String,
  serverIp: json['server_ip'],
  enableLog: (json['enable_log'] as num?)?.toInt(),
  forcedKeepAlive: json['forced_keep_alive'],
  micVolume: (json['mic_volume'] as num?)?.toInt(),
  voiceVolume: (json['voice_volume'] as num?)?.toInt(),
);

Map<String, dynamic> _$IntercomHandsetSettingsToJson(
  IntercomHandsetSettings instance,
) => <String, dynamic>{
  'show_recordings': instance.showRecordings,
  'recording_ttl': instance.recordingTtl,
  'recording_enabled': instance.recordingEnabled,
  'keep_alive': instance.keepAlive,
  'chime_settings': instance.chimeSettings,
  'intercom_settings': instance.intercomSettings,
  'keep_alive_auto': instance.keepAliveAuto,
  'doorbell_volume': instance.doorbellVolume,
  'enable_chime': instance.enableChime,
  'theft_alarm_enable': instance.theftAlarmEnable,
  'use_cached_domain': instance.useCachedDomain,
  'use_server_ip': instance.useServerIp,
  'server_domain': instance.serverDomain,
  'server_ip': instance.serverIp,
  'enable_log': instance.enableLog,
  'forced_keep_alive': instance.forcedKeepAlive,
  'mic_volume': instance.micVolume,
  'voice_volume': instance.voiceVolume,
};

IntercomHandsetFeatures _$IntercomHandsetFeaturesFromJson(
  Map<String, dynamic> json,
) => IntercomHandsetFeatures(
  motionZoneRecommendation: json['motion_zone_recommendation'] as bool,
  motionsEnabled: json['motions_enabled'] as bool,
  showRecordings: json['show_recordings'] as bool,
  showVodSettings: json['show_vod_settings'] as bool,
  richNotificationsEligible: json['rich_notifications_eligible'] as bool,
  show24x7Lite: json['show_24x7_lite'] as bool,
  showOfflineMotionEvents: json['show_offline_motion_events'] as bool,
  cfesEligible: json['cfes_eligible'] as bool,
  sheilaCameraEligible: json['sheila_camera_eligible'] as bool?,
  sheilaCameraProcessingEligible:
      json['sheila_camera_processing_eligible'] as bool?,
  chimeAutoDetectCapable: json['chime_auto_detect_capable'] as bool,
);

Map<String, dynamic> _$IntercomHandsetFeaturesToJson(
  IntercomHandsetFeatures instance,
) => <String, dynamic>{
  'motion_zone_recommendation': instance.motionZoneRecommendation,
  'motions_enabled': instance.motionsEnabled,
  'show_recordings': instance.showRecordings,
  'show_vod_settings': instance.showVodSettings,
  'rich_notifications_eligible': instance.richNotificationsEligible,
  'show_24x7_lite': instance.show24x7Lite,
  'show_offline_motion_events': instance.showOfflineMotionEvents,
  'cfes_eligible': instance.cfesEligible,
  'sheila_camera_eligible': instance.sheilaCameraEligible,
  'sheila_camera_processing_eligible': instance.sheilaCameraProcessingEligible,
  'chime_auto_detect_capable': instance.chimeAutoDetectCapable,
};

IntercomHandsetAlerts _$IntercomHandsetAlertsFromJson(
  Map<String, dynamic> json,
) => IntercomHandsetAlerts(
  connection: json['connection'] as String,
  otaStatus: json['ota_status'] as String?,
);

Map<String, dynamic> _$IntercomHandsetAlertsToJson(
  IntercomHandsetAlerts instance,
) => <String, dynamic>{
  'connection': instance.connection,
  'ota_status': instance.otaStatus,
};

IntercomHandsetMetadata _$IntercomHandsetMetadataFromJson(
  Map<String, dynamic> json,
) => IntercomHandsetMetadata(
  ethernet: json['ethernet'] as bool,
  legacyFwMigrated: json['legacy_fw_migrated'] as bool,
  importedFromAmazon: json['imported_from_amazon'] as bool,
  isSidewalkGateway: json['is_sidewalk_gateway'] as bool,
  keyAccessPointAssociated: json['key_access_point_associated'] as bool,
);

Map<String, dynamic> _$IntercomHandsetMetadataToJson(
  IntercomHandsetMetadata instance,
) => <String, dynamic>{
  'ethernet': instance.ethernet,
  'legacy_fw_migrated': instance.legacyFwMigrated,
  'imported_from_amazon': instance.importedFromAmazon,
  'is_sidewalk_gateway': instance.isSidewalkGateway,
  'key_access_point_associated': instance.keyAccessPointAssociated,
};

IntercomHandsetAudioData _$IntercomHandsetAudioDataFromJson(
  Map<String, dynamic> json,
) => IntercomHandsetAudioData(
  id: (json['id'] as num?)?.toInt(),
  description: json['description'] as String,
  deviceId: json['device_id'] as String,
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
  firmwareVersion: json['firmware_version'] as String,
  locationId: json['location_id'] as String,
  timeZone: json['time_zone'] as String,
  createdAt: json['created_at'] as String,
  ringNetId: json['ring_net_id'],
  isSidewalkGateway: json['is_sidewalk_gateway'] as bool,
  subscribed: json['subscribed'] as bool,
  deactivatedAt: json['deactivated_at'] as String?,
  batteryLife: json['battery_life'] as String,
  metadata: IntercomHandsetMetadata.fromJson(
    json['metadata'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$IntercomHandsetAudioDataToJson(
  IntercomHandsetAudioData instance,
) => <String, dynamic>{
  'id': instance.id,
  'description': instance.description,
  'device_id': instance.deviceId,
  'kind': instance.kind,
  'function': instance.function,
  'settings': instance.settings,
  'features': instance.features,
  'owned': instance.owned,
  'owner': instance.owner,
  'alerts': instance.alerts,
  'firmware_version': instance.firmwareVersion,
  'location_id': instance.locationId,
  'time_zone': instance.timeZone,
  'created_at': instance.createdAt,
  'ring_net_id': instance.ringNetId,
  'is_sidewalk_gateway': instance.isSidewalkGateway,
  'subscribed': instance.subscribed,
  'deactivated_at': instance.deactivatedAt,
  'battery_life': instance.batteryLife,
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
    json['human_detection_confidence'] as Map<String, dynamic>,
  ),
  motionZoneOverlap: DayNightConfig.fromJson(
    json['motion_zone_overlap'] as Map<String, dynamic>,
  ),
  objectSizeMaximum: DayNightConfig.fromJson(
    json['object_size_maximum'] as Map<String, dynamic>,
  ),
  objectSizeMinimum: DayNightConfig.fromJson(
    json['object_size_minimum'] as Map<String, dynamic>,
  ),
  objectTimeOverlap: DayNightConfig.fromJson(
    json['object_time_overlap'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AdvancedObjectSettingsToJson(
  AdvancedObjectSettings instance,
) => <String, dynamic>{
  'human_detection_confidence': instance.humanDetectionConfidence,
  'motion_zone_overlap': instance.motionZoneOverlap,
  'object_size_maximum': instance.objectSizeMaximum,
  'object_size_minimum': instance.objectSizeMinimum,
  'object_time_overlap': instance.objectTimeOverlap,
};

AdvancedMotionSettings _$AdvancedMotionSettingsFromJson(
  Map<String, dynamic> json,
) => AdvancedMotionSettings(
  activeMotionFilter: (json['active_motion_filter'] as num).toInt(),
  advancedObjectSettings: AdvancedObjectSettings.fromJson(
    json['advanced_object_settings'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AdvancedMotionSettingsToJson(
  AdvancedMotionSettings instance,
) => <String, dynamic>{
  'active_motion_filter': instance.activeMotionFilter,
  'advanced_object_settings': instance.advancedObjectSettings,
};

DeviceChimeSettings _$DeviceChimeSettingsFromJson(Map<String, dynamic> json) =>
    DeviceChimeSettings(
      duration: (json['duration'] as num).toInt(),
      enable: json['enable'] as bool,
      enableExt: json['enable_ext'] as bool,
      type: (json['type'] as num).toInt(),
    );

Map<String, dynamic> _$DeviceChimeSettingsToJson(
  DeviceChimeSettings instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'enable': instance.enable,
  'enable_ext': instance.enableExt,
  'type': instance.type,
};

MotionSettings _$MotionSettingsFromJson(
  Map<String, dynamic> json,
) => MotionSettings(
  enableAudio: json['enable_audio'] as bool,
  motionDetectionEnabled: json['motion_detection_enabled'] as bool,
  enableIrLed: json['enable_ir_led'] as bool,
  advancedMotionDetectionEnabled:
      json['advanced_motion_detection_enabled'] as bool,
  advancedMotionDetectionMode: json['advanced_motion_detection_mode'] as String,
  advancedMotionDetectionHumanOnlyMode:
      json['advanced_motion_detection_human_only_mode'] as bool,
  advancedMotionDetectionLoiteringMode:
      json['advanced_motion_detection_loitering_mode'] as bool,
  motionSnoozePrivacyTimeout: (json['motion_snooze_privacy_timeout'] as num)
      .toInt(),
  advancedMotionZonesEnabled: json['advanced_motion_zones_enabled'] as bool,
  advancedMotionZonesType: json['advanced_motion_zones_type'] as String,
  enableIndoorMode: json['enable_indoor_mode'] as bool,
  enablePirValidation: json['enable_pir_validation'] as bool,
  loiteringThreshold: (json['loitering_threshold'] as num).toInt(),
  enableRlmd: json['enable_rlmd'] as bool,
  enableRecording: json['enable_recording'] as bool,
  endDetection: (json['end_detection'] as num).toInt(),
  advancedMotionRecordingHumanMode:
      json['advanced_motion_recording_human_mode'] as bool,
  advancedMotionGlanceEnabled: json['advanced_motion_glance_enabled'] as bool,
);

Map<String, dynamic> _$MotionSettingsToJson(
  MotionSettings instance,
) => <String, dynamic>{
  'enable_audio': instance.enableAudio,
  'motion_detection_enabled': instance.motionDetectionEnabled,
  'enable_ir_led': instance.enableIrLed,
  'advanced_motion_detection_enabled': instance.advancedMotionDetectionEnabled,
  'advanced_motion_detection_mode': instance.advancedMotionDetectionMode,
  'advanced_motion_detection_human_only_mode':
      instance.advancedMotionDetectionHumanOnlyMode,
  'advanced_motion_detection_loitering_mode':
      instance.advancedMotionDetectionLoiteringMode,
  'motion_snooze_privacy_timeout': instance.motionSnoozePrivacyTimeout,
  'advanced_motion_zones_enabled': instance.advancedMotionZonesEnabled,
  'advanced_motion_zones_type': instance.advancedMotionZonesType,
  'enable_indoor_mode': instance.enableIndoorMode,
  'enable_pir_validation': instance.enablePirValidation,
  'loitering_threshold': instance.loiteringThreshold,
  'enable_rlmd': instance.enableRlmd,
  'enable_recording': instance.enableRecording,
  'end_detection': instance.endDetection,
  'advanced_motion_recording_human_mode':
      instance.advancedMotionRecordingHumanMode,
  'advanced_motion_glance_enabled': instance.advancedMotionGlanceEnabled,
};

VideoSettings _$VideoSettingsFromJson(Map<String, dynamic> json) =>
    VideoSettings(
      exposureControl: (json['exposure_control'] as num).toInt(),
      nightColorEnable: json['night_color_enable'] as bool,
      hdrEnable: json['hdr_enable'] as bool,
      clipLengthMax: (json['clip_length_max'] as num).toInt(),
      clipLengthMin: (json['clip_length_min'] as num).toInt(),
      aeMode: (json['ae_mode'] as num).toInt(),
      aeMask: json['ae_mask'] as String,
    );

Map<String, dynamic> _$VideoSettingsToJson(VideoSettings instance) =>
    <String, dynamic>{
      'exposure_control': instance.exposureControl,
      'night_color_enable': instance.nightColorEnable,
      'hdr_enable': instance.hdrEnable,
      'clip_length_max': instance.clipLengthMax,
      'clip_length_min': instance.clipLengthMin,
      'ae_mode': instance.aeMode,
      'ae_mask': instance.aeMask,
    };

VodSettings _$VodSettingsFromJson(Map<String, dynamic> json) => VodSettings(
  enable: json['enable'] as bool,
  toggledAt: json['toggled_at'] as String,
  useCachedVodDomain: json['use_cached_vod_domain'] as bool,
);

Map<String, dynamic> _$VodSettingsToJson(VodSettings instance) =>
    <String, dynamic>{
      'enable': instance.enable,
      'toggled_at': instance.toggledAt,
      'use_cached_vod_domain': instance.useCachedVodDomain,
    };

VolumeSettings _$VolumeSettingsFromJson(Map<String, dynamic> json) =>
    VolumeSettings(
      doorbellVolume: (json['doorbell_volume'] as num).toInt(),
      micVolume: (json['mic_volume'] as num).toInt(),
      voiceVolume: (json['voice_volume'] as num).toInt(),
    );

Map<String, dynamic> _$VolumeSettingsToJson(VolumeSettings instance) =>
    <String, dynamic>{
      'doorbell_volume': instance.doorbellVolume,
      'mic_volume': instance.micVolume,
      'voice_volume': instance.voiceVolume,
    };

CvDetectionTypes _$CvDetectionTypesFromJson(Map<String, dynamic> json) =>
    CvDetectionTypes(
      human: CvDetectionType.fromJson(json['human'] as Map<String, dynamic>),
      loitering: CvDetectionType.fromJson(
        json['loitering'] as Map<String, dynamic>,
      ),
      motion: CvDetectionType.fromJson(json['motion'] as Map<String, dynamic>),
      movingVehicle: CvDetectionType.fromJson(
        json['moving_vehicle'] as Map<String, dynamic>,
      ),
      nearbyPom: CvDetectionType.fromJson(
        json['nearby_pom'] as Map<String, dynamic>,
      ),
      otherMotion: CvDetectionType.fromJson(
        json['other_motion'] as Map<String, dynamic>,
      ),
      packageDelivery: CvDetectionType.fromJson(
        json['package_delivery'] as Map<String, dynamic>,
      ),
      packagePickup: CvDetectionType.fromJson(
        json['package_pickup'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CvDetectionTypesToJson(CvDetectionTypes instance) =>
    <String, dynamic>{
      'human': instance.human,
      'loitering': instance.loitering,
      'motion': instance.motion,
      'moving_vehicle': instance.movingVehicle,
      'nearby_pom': instance.nearbyPom,
      'other_motion': instance.otherMotion,
      'package_delivery': instance.packageDelivery,
      'package_pickup': instance.packagePickup,
    };

CvThreshold _$CvThresholdFromJson(Map<String, dynamic> json) => CvThreshold(
  loitering: (json['loitering'] as num).toInt(),
  packageDelivery: (json['package_delivery'] as num).toInt(),
);

Map<String, dynamic> _$CvThresholdToJson(CvThreshold instance) =>
    <String, dynamic>{
      'loitering': instance.loitering,
      'package_delivery': instance.packageDelivery,
    };

CvSettings _$CvSettingsFromJson(Map<String, dynamic> json) => CvSettings(
  detectionTypes: CvDetectionTypes.fromJson(
    json['detection_types'] as Map<String, dynamic>,
  ),
  threshold: CvThreshold.fromJson(json['threshold'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CvSettingsToJson(CvSettings instance) =>
    <String, dynamic>{
      'detection_types': instance.detectionTypes,
      'threshold': instance.threshold,
    };

GeneralSettings _$GeneralSettingsFromJson(Map<String, dynamic> json) =>
    GeneralSettings(
      enableAudioRecording: json['enable_audio_recording'] as bool,
      lite24x7Enabled: json['lite_24x7_enabled'] as bool,
      offlineMotionEventEnabled: json['offline_motion_event_enabled'] as bool,
      lite24x7Subscribed: json['lite_24x7_subscribed'] as bool,
      offlineMotionEventSubscribed:
          json['offline_motion_event_subscribed'] as bool,
      firmwaresLocked: json['firmwares_locked'] as bool,
      utcOffset: json['utc_offset'] as String,
      theftAlarmEnable: json['theft_alarm_enable'] as bool,
      useWrapupDomain: json['use_wrapup_domain'] as bool,
      powerMode: json['power_mode'] as String,
      dataCollectionEnabled: json['data_collection_enabled'] as bool,
    );

Map<String, dynamic> _$GeneralSettingsToJson(GeneralSettings instance) =>
    <String, dynamic>{
      'enable_audio_recording': instance.enableAudioRecording,
      'lite_24x7_enabled': instance.lite24x7Enabled,
      'offline_motion_event_enabled': instance.offlineMotionEventEnabled,
      'lite_24x7_subscribed': instance.lite24x7Subscribed,
      'offline_motion_event_subscribed': instance.offlineMotionEventSubscribed,
      'firmwares_locked': instance.firmwaresLocked,
      'utc_offset': instance.utcOffset,
      'theft_alarm_enable': instance.theftAlarmEnable,
      'use_wrapup_domain': instance.useWrapupDomain,
      'power_mode': instance.powerMode,
      'data_collection_enabled': instance.dataCollectionEnabled,
    };

KeepAliveSettings _$KeepAliveSettingsFromJson(Map<String, dynamic> json) =>
    KeepAliveSettings(keepAliveAuto: (json['keep_alive_auto'] as num).toInt());

Map<String, dynamic> _$KeepAliveSettingsToJson(KeepAliveSettings instance) =>
    <String, dynamic>{'keep_alive_auto': instance.keepAliveAuto};

PirSettings _$PirSettingsFromJson(Map<String, dynamic> json) => PirSettings(
  sensitivity1: (json['sensitivity_1'] as num).toInt(),
  sensitivity2: (json['sensitivity_2'] as num).toInt(),
  sensitivity3: (json['sensitivity_3'] as num).toInt(),
  zoneEnable: (json['zone_enable'] as num).toInt(),
);

Map<String, dynamic> _$PirSettingsToJson(PirSettings instance) =>
    <String, dynamic>{
      'sensitivity_1': instance.sensitivity1,
      'sensitivity_2': instance.sensitivity2,
      'sensitivity_3': instance.sensitivity3,
      'zone_enable': instance.zoneEnable,
    };

SnapshotSettings _$SnapshotSettingsFromJson(Map<String, dynamic> json) =>
    SnapshotSettings(
      frequencySecs: (json['frequency_secs'] as num).toInt(),
      lite24x7ResolutionP: (json['lite_24x7_resolution_p'] as num).toInt(),
      omeResolutionP: (json['ome_resolution_p'] as num).toInt(),
      maxUploadKb: (json['max_upload_kb'] as num).toInt(),
      frequencyAfterSecs: (json['frequency_after_secs'] as num).toInt(),
      periodAfterSecs: (json['period_after_secs'] as num).toInt(),
      closeContainer: (json['close_container'] as num).toInt(),
    );

Map<String, dynamic> _$SnapshotSettingsToJson(SnapshotSettings instance) =>
    <String, dynamic>{
      'frequency_secs': instance.frequencySecs,
      'lite_24x7_resolution_p': instance.lite24x7ResolutionP,
      'ome_resolution_p': instance.omeResolutionP,
      'max_upload_kb': instance.maxUploadKb,
      'frequency_after_secs': instance.frequencyAfterSecs,
      'period_after_secs': instance.periodAfterSecs,
      'close_container': instance.closeContainer,
    };

ClientDeviceSettings _$ClientDeviceSettingsFromJson(
  Map<String, dynamic> json,
) => ClientDeviceSettings(
  ringtonesEnabled: json['ringtones_enabled'] as bool,
  peopleOnlyEnabled: json['people_only_enabled'] as bool,
  advancedMotionEnabled: json['advanced_motion_enabled'] as bool,
  motionMessageEnabled: json['motion_message_enabled'] as bool,
  shadowCorrectionEnabled: json['shadow_correction_enabled'] as bool,
  nightVisionEnabled: json['night_vision_enabled'] as bool,
  lightScheduleEnabled: json['light_schedule_enabled'] as bool,
  richNotificationsEligible: json['rich_notifications_eligible'] as bool,
  show24x7Lite: json['show_24x7_lite'] as bool,
  showOfflineMotionEvents: json['show_offline_motion_events'] as bool,
  cfesEligible: json['cfes_eligible'] as bool,
  showRadarData: json['show_radar_data'] as bool,
  motionZoneRecommendation: json['motion_zone_recommendation'] as bool,
);

Map<String, dynamic> _$ClientDeviceSettingsToJson(
  ClientDeviceSettings instance,
) => <String, dynamic>{
  'ringtones_enabled': instance.ringtonesEnabled,
  'people_only_enabled': instance.peopleOnlyEnabled,
  'advanced_motion_enabled': instance.advancedMotionEnabled,
  'motion_message_enabled': instance.motionMessageEnabled,
  'shadow_correction_enabled': instance.shadowCorrectionEnabled,
  'night_vision_enabled': instance.nightVisionEnabled,
  'light_schedule_enabled': instance.lightScheduleEnabled,
  'rich_notifications_eligible': instance.richNotificationsEligible,
  'show_24x7_lite': instance.show24x7Lite,
  'show_offline_motion_events': instance.showOfflineMotionEvents,
  'cfes_eligible': instance.cfesEligible,
  'show_radar_data': instance.showRadarData,
  'motion_zone_recommendation': instance.motionZoneRecommendation,
};

AlexaSettings _$AlexaSettingsFromJson(Map<String, dynamic> json) =>
    AlexaSettings(delayMs: (json['delay_ms'] as num).toInt());

Map<String, dynamic> _$AlexaSettingsToJson(AlexaSettings instance) =>
    <String, dynamic>{'delay_ms': instance.delayMs};

AutoreplySettings _$AutoreplySettingsFromJson(Map<String, dynamic> json) =>
    AutoreplySettings(delayMs: (json['delay_ms'] as num).toInt());

Map<String, dynamic> _$AutoreplySettingsToJson(AutoreplySettings instance) =>
    <String, dynamic>{'delay_ms': instance.delayMs};

ConciergeSettings _$ConciergeSettingsFromJson(Map<String, dynamic> json) =>
    ConciergeSettings(
      alexaSettings: json['alexa_settings'] == null
          ? null
          : AlexaSettings.fromJson(
              json['alexa_settings'] as Map<String, dynamic>,
            ),
      autoreplySettings: json['autoreply_settings'] == null
          ? null
          : AutoreplySettings.fromJson(
              json['autoreply_settings'] as Map<String, dynamic>,
            ),
      mode: json['mode'] as String?,
    );

Map<String, dynamic> _$ConciergeSettingsToJson(ConciergeSettings instance) =>
    <String, dynamic>{
      'alexa_settings': instance.alexaSettings,
      'autoreply_settings': instance.autoreplySettings,
      'mode': instance.mode,
    };

CameraDeviceSettingsData _$CameraDeviceSettingsDataFromJson(
  Map<String, dynamic> json,
) => CameraDeviceSettingsData(
  advancedMotionSettings: AdvancedMotionSettings.fromJson(
    json['advanced_motion_settings'] as Map<String, dynamic>,
  ),
  chimeSettings: DeviceChimeSettings.fromJson(
    json['chime_settings'] as Map<String, dynamic>,
  ),
  motionSettings: MotionSettings.fromJson(
    json['motion_settings'] as Map<String, dynamic>,
  ),
  videoSettings: VideoSettings.fromJson(
    json['video_settings'] as Map<String, dynamic>,
  ),
  vodSettings: VodSettings.fromJson(
    json['vod_settings'] as Map<String, dynamic>,
  ),
  volumeSettings: VolumeSettings.fromJson(
    json['volume_settings'] as Map<String, dynamic>,
  ),
  cvSettings: CvSettings.fromJson(json['cv_settings'] as Map<String, dynamic>),
  generalSettings: GeneralSettings.fromJson(
    json['general_settings'] as Map<String, dynamic>,
  ),
  keepAliveSettings: KeepAliveSettings.fromJson(
    json['keep_alive_settings'] as Map<String, dynamic>,
  ),
  pirSettings: PirSettings.fromJson(
    json['pir_settings'] as Map<String, dynamic>,
  ),
  snapshotSettings: SnapshotSettings.fromJson(
    json['snapshot_settings'] as Map<String, dynamic>,
  ),
  clientDeviceSettings: ClientDeviceSettings.fromJson(
    json['client_device_settings'] as Map<String, dynamic>,
  ),
  conciergeSettings: json['concierge_settings'] == null
      ? null
      : ConciergeSettings.fromJson(
          json['concierge_settings'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$CameraDeviceSettingsDataToJson(
  CameraDeviceSettingsData instance,
) => <String, dynamic>{
  'advanced_motion_settings': instance.advancedMotionSettings,
  'chime_settings': instance.chimeSettings,
  'motion_settings': instance.motionSettings,
  'video_settings': instance.videoSettings,
  'vod_settings': instance.vodSettings,
  'volume_settings': instance.volumeSettings,
  'cv_settings': instance.cvSettings,
  'general_settings': instance.generalSettings,
  'keep_alive_settings': instance.keepAliveSettings,
  'pir_settings': instance.pirSettings,
  'snapshot_settings': instance.snapshotSettings,
  'client_device_settings': instance.clientDeviceSettings,
  'concierge_settings': instance.conciergeSettings,
};

ChimeHealth _$ChimeHealthFromJson(Map<String, dynamic> json) => ChimeHealth(
  id: (json['id'] as num).toInt(),
  wifiName: json['wifi_name'] as String,
  batteryPercentage: json['battery_percentage'] as String?,
  batteryPercentageCategory: json['battery_percentage_category'] as String?,
  batteryVoltage: (json['battery_voltage'] as num?)?.toDouble(),
  batteryVoltageCategory: json['battery_voltage_category'] as String?,
  latestSignalStrength: (json['latest_signal_strength'] as num).toInt(),
  latestSignalCategory: json['latest_signal_category'] as String?,
  averageSignalStrength: (json['average_signal_strength'] as num).toInt(),
  averageSignalCategory: json['average_signal_category'] as String?,
  firmware: json['firmware'] as String,
  updatedAt: json['updated_at'] as String,
  wifiIsRingNetwork: json['wifi_is_ring_network'] as bool,
  packetLossCategory: json['packet_loss_category'] as String?,
  packetLossStrength: (json['packet_loss_strength'] as num).toInt(),
);

Map<String, dynamic> _$ChimeHealthToJson(ChimeHealth instance) =>
    <String, dynamic>{
      'id': instance.id,
      'wifi_name': instance.wifiName,
      'battery_percentage': instance.batteryPercentage,
      'battery_percentage_category': instance.batteryPercentageCategory,
      'battery_voltage': instance.batteryVoltage,
      'battery_voltage_category': instance.batteryVoltageCategory,
      'latest_signal_strength': instance.latestSignalStrength,
      'latest_signal_category': instance.latestSignalCategory,
      'average_signal_strength': instance.averageSignalStrength,
      'average_signal_category': instance.averageSignalCategory,
      'firmware': instance.firmware,
      'updated_at': instance.updatedAt,
      'wifi_is_ring_network': instance.wifiIsRingNetwork,
      'packet_loss_category': instance.packetLossCategory,
      'packet_loss_strength': instance.packetLossStrength,
    };

CameraHealth _$CameraHealthFromJson(Map<String, dynamic> json) => CameraHealth(
  transformerVoltage: (json['transformer_voltage'] as num?)?.toInt(),
  transformerVoltageCategory: json['transformer_voltage_category'] as String?,
  extPowerState: (json['ext_power_state'] as num?)?.toInt(),
  id: (json['id'] as num).toInt(),
  wifiName: json['wifi_name'] as String,
  batteryPercentage: json['battery_percentage'] as String?,
  batteryPercentageCategory: json['battery_percentage_category'] as String?,
  batteryVoltage: (json['battery_voltage'] as num?)?.toDouble(),
  batteryVoltageCategory: json['battery_voltage_category'] as String?,
  latestSignalStrength: (json['latest_signal_strength'] as num).toInt(),
  latestSignalCategory: json['latest_signal_category'] as String?,
  averageSignalStrength: (json['average_signal_strength'] as num).toInt(),
  averageSignalCategory: json['average_signal_category'] as String?,
  firmware: json['firmware'] as String,
  updatedAt: json['updated_at'] as String,
  wifiIsRingNetwork: json['wifi_is_ring_network'] as bool,
  packetLossCategory: json['packet_loss_category'] as String?,
  packetLossStrength: (json['packet_loss_strength'] as num).toInt(),
);

Map<String, dynamic> _$CameraHealthToJson(CameraHealth instance) =>
    <String, dynamic>{
      'id': instance.id,
      'wifi_name': instance.wifiName,
      'battery_percentage': instance.batteryPercentage,
      'battery_percentage_category': instance.batteryPercentageCategory,
      'battery_voltage': instance.batteryVoltage,
      'battery_voltage_category': instance.batteryVoltageCategory,
      'latest_signal_strength': instance.latestSignalStrength,
      'latest_signal_category': instance.latestSignalCategory,
      'average_signal_strength': instance.averageSignalStrength,
      'average_signal_category': instance.averageSignalCategory,
      'firmware': instance.firmware,
      'updated_at': instance.updatedAt,
      'wifi_is_ring_network': instance.wifiIsRingNetwork,
      'packet_loss_category': instance.packetLossCategory,
      'packet_loss_strength': instance.packetLossStrength,
      'transformer_voltage': instance.transformerVoltage,
      'transformer_voltage_category': instance.transformerVoltageCategory,
      'ext_power_state': instance.extPowerState,
    };

CvProperties _$CvPropertiesFromJson(Map<String, dynamic> json) => CvProperties(
  detectionType: json['detection_type'],
  personDetected: json['person_detected'],
  streamBroken: json['stream_broken'],
);

Map<String, dynamic> _$CvPropertiesToJson(CvProperties instance) =>
    <String, dynamic>{
      'detection_type': instance.detectionType,
      'person_detected': instance.personDetected,
      'stream_broken': instance.streamBroken,
    };

CameraEvent _$CameraEventFromJson(Map<String, dynamic> json) => CameraEvent(
  createdAt: json['created_at'] as String,
  cvProperties: CvProperties.fromJson(
    json['cv_properties'] as Map<String, dynamic>,
  ),
  dingId: (json['ding_id'] as num).toInt(),
  dingIdStr: json['ding_id_str'] as String,
  doorbotId: (json['doorbot_id'] as num).toInt(),
  favorite: json['favorite'] as bool,
  kind: json['kind'] as String,
  recorded: json['recorded'] as bool,
  recordingStatus: json['recording_status'] as String,
  state: json['state'] as String,
);

Map<String, dynamic> _$CameraEventToJson(CameraEvent instance) =>
    <String, dynamic>{
      'created_at': instance.createdAt,
      'cv_properties': instance.cvProperties,
      'ding_id': instance.dingId,
      'ding_id_str': instance.dingIdStr,
      'doorbot_id': instance.doorbotId,
      'favorite': instance.favorite,
      'kind': instance.kind,
      'recorded': instance.recorded,
      'recording_status': instance.recordingStatus,
      'state': instance.state,
    };

PaginationMeta _$PaginationMetaFromJson(Map<String, dynamic> json) =>
    PaginationMeta(paginationKey: json['pagination_key'] as String);

Map<String, dynamic> _$PaginationMetaToJson(PaginationMeta instance) =>
    <String, dynamic>{'pagination_key': instance.paginationKey};

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
      dingId: json['ding_id'] as String,
      createdAt: (json['created_at'] as num).toInt(),
      hqUrl: json['hq_url'] as String?,
      lqUrl: json['lq_url'] as String,
      prerollDuration: json['preroll_duration'],
      thumbnailUrl: json['thumbnail_url'] as String,
      untranscodedUrl: json['untranscoded_url'] as String,
      kind: json['kind'] as String,
      state: json['state'] as String,
      hadSubscription: json['had_subscription'] as bool,
      favorite: json['favorite'] as bool,
      duration: (json['duration'] as num).toInt(),
      cvProperties: CvProperties.fromJson(
        json['cv_properties'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$VideoSearchResultToJson(VideoSearchResult instance) =>
    <String, dynamic>{
      'ding_id': instance.dingId,
      'created_at': instance.createdAt,
      'hq_url': instance.hqUrl,
      'lq_url': instance.lqUrl,
      'preroll_duration': instance.prerollDuration,
      'thumbnail_url': instance.thumbnailUrl,
      'untranscoded_url': instance.untranscodedUrl,
      'kind': instance.kind,
      'state': instance.state,
      'had_subscription': instance.hadSubscription,
      'favorite': instance.favorite,
      'duration': instance.duration,
      'cv_properties': instance.cvProperties,
    };

VideoSearchResponse _$VideoSearchResponseFromJson(Map<String, dynamic> json) =>
    VideoSearchResponse(
      videoSearch: (json['video_search'] as List<dynamic>)
          .map((e) => VideoSearchResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VideoSearchResponseToJson(
  VideoSearchResponse instance,
) => <String, dynamic>{'video_search': instance.videoSearch};

PeriodicalFootage _$PeriodicalFootageFromJson(Map<String, dynamic> json) =>
    PeriodicalFootage(
      startMs: (json['start_ms'] as num).toInt(),
      endMs: (json['end_ms'] as num).toInt(),
      playbackMs: (json['playback_ms'] as num).toInt(),
      kind: json['kind'] as String,
      url: json['url'] as String,
      deleted: json['deleted'] as bool,
      snapshots: (json['snapshots'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$PeriodicalFootageToJson(PeriodicalFootage instance) =>
    <String, dynamic>{
      'start_ms': instance.startMs,
      'end_ms': instance.endMs,
      'playback_ms': instance.playbackMs,
      'kind': instance.kind,
      'url': instance.url,
      'deleted': instance.deleted,
      'snapshots': instance.snapshots,
    };

PeriodicFootageMeta _$PeriodicFootageMetaFromJson(Map<String, dynamic> json) =>
    PeriodicFootageMeta(
      paginationKey: (json['pagination_key'] as num).toInt(),
      butchSize: (json['butch_size'] as num).toInt(),
    );

Map<String, dynamic> _$PeriodicFootageMetaToJson(
  PeriodicFootageMeta instance,
) => <String, dynamic>{
  'pagination_key': instance.paginationKey,
  'butch_size': instance.butchSize,
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
  serverCorrelationId: json['server_correlation_id'] as String,
  serverId: json['server_id'] as String,
  subcategory: json['subcategory'] as String,
  triggeredAt: (json['triggered_at'] as num).toInt(),
  sentAt: (json['sent_at'] as num).toInt(),
  referringItemType: json['referring_item_type'] as String,
  referringItemId: json['referring_item_id'] as String,
);

Map<String, dynamic> _$PushNotificationAnalyticsToJson(
  PushNotificationAnalytics instance,
) => <String, dynamic>{
  'server_correlation_id': instance.serverCorrelationId,
  'server_id': instance.serverId,
  'subcategory': instance.subcategory,
  'triggered_at': instance.triggeredAt,
  'sent_at': instance.sentAt,
  'referring_item_type': instance.referringItemType,
  'referring_item_id': instance.referringItemId,
};

PushNotificationDevice _$PushNotificationDeviceFromJson(
  Map<String, dynamic> json,
) => PushNotificationDevice(
  e2eeEnabled: json['e2ee_enabled'] as bool,
  id: (json['id'] as num).toInt(),
  kind: json['kind'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$PushNotificationDeviceToJson(
  PushNotificationDevice instance,
) => <String, dynamic>{
  'e2ee_enabled': instance.e2eeEnabled,
  'id': instance.id,
  'kind': instance.kind,
  'name': instance.name,
};

PushNotificationDing _$PushNotificationDingFromJson(
  Map<String, dynamic> json,
) => PushNotificationDing(
  id: json['id'] as String,
  createdAt: json['created_at'] as String,
  subtype: json['subtype'] as String,
  detectionType: json['detection_type'] as String?,
);

Map<String, dynamic> _$PushNotificationDingToJson(
  PushNotificationDing instance,
) => <String, dynamic>{
  'id': instance.id,
  'created_at': instance.createdAt,
  'subtype': instance.subtype,
  'detection_type': instance.detectionType,
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
  streamingDataHash: json['streaming_data_hash'] as String,
  activeStreamingProfile: json['active_streaming_profile'] as String,
  defaultAudioRoute: json['default_audio_route'] as String,
  maxDuration: (json['max_duration'] as num).toInt(),
);

Map<String, dynamic> _$PushNotificationLiveSessionToJson(
  PushNotificationLiveSession instance,
) => <String, dynamic>{
  'streaming_data_hash': instance.streamingDataHash,
  'active_streaming_profile': instance.activeStreamingProfile,
  'default_audio_route': instance.defaultAudioRoute,
  'max_duration': instance.maxDuration,
};

PushNotificationEvent _$PushNotificationEventFromJson(
  Map<String, dynamic> json,
) => PushNotificationEvent(
  ding: PushNotificationDing.fromJson(json['ding'] as Map<String, dynamic>),
  eventito: PushNotificationEventito.fromJson(
    json['eventito'] as Map<String, dynamic>,
  ),
  riid: json['riid'] as String,
  isSidewalk: json['is_sidewalk'] as bool,
  liveSession: PushNotificationLiveSession.fromJson(
    json['live_session'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$PushNotificationEventToJson(
  PushNotificationEvent instance,
) => <String, dynamic>{
  'ding': instance.ding,
  'eventito': instance.eventito,
  'riid': instance.riid,
  'is_sidewalk': instance.isSidewalk,
  'live_session': instance.liveSession,
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
) => PushNotificationImage(snapshotUuid: json['snapshot_uuid'] as String);

Map<String, dynamic> _$PushNotificationImageToJson(
  PushNotificationImage instance,
) => <String, dynamic>{'snapshot_uuid': instance.snapshotUuid};

PushNotificationDingV2 _$PushNotificationDingV2FromJson(
  Map<String, dynamic> json,
) => PushNotificationDingV2(
  version: json['version'] as String,
  androidConfig: PushNotificationAndroidConfig.fromJson(
    json['android_config'] as Map<String, dynamic>,
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
  'android_config': instance.androidConfig,
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
  deviceZid: (json['device_zid'] as num).toInt(),
  locationId: json['location_id'] as String,
);

Map<String, dynamic> _$PushNotificationAlarmMetaToJson(
  PushNotificationAlarmMeta instance,
) => <String, dynamic>{
  'device_zid': instance.deviceZid,
  'location_id': instance.locationId,
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
  responseTimestampe: (json['responseTimestampe'] as num?)?.toInt(),
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
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  phoneNumber: json['phone_number'] as String,
  authenticationToken: json['authentication_token'] as String,
  features: json['features'] as Map<String, dynamic>,
  userPreferences: UserPreferences.fromJson(
    json['user_preferences'] as Map<String, dynamic>,
  ),
  hardwareId: json['hardware_id'] as String,
  explorerProgramTerms: json['explorer_program_terms'],
  userFlow: json['user_flow'] as String,
  appBrand: json['app_brand'] as String,
  country: json['country'] as String,
  status: json['status'] as String,
  createdAt: json['created_at'] as String,
  tfaEnabled: json['tfa_enabled'] as bool,
  tfaPhoneNumber: json['tfa_phone_number'] as String?,
  accountType: json['account_type'] as String,
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone_number': instance.phoneNumber,
      'authentication_token': instance.authenticationToken,
      'features': instance.features,
      'user_preferences': instance.userPreferences,
      'hardware_id': instance.hardwareId,
      'explorer_program_terms': instance.explorerProgramTerms,
      'user_flow': instance.userFlow,
      'app_brand': instance.appBrand,
      'country': instance.country,
      'status': instance.status,
      'created_at': instance.createdAt,
      'tfa_enabled': instance.tfaEnabled,
      'tfa_phone_number': instance.tfaPhoneNumber,
      'account_type': instance.accountType,
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
