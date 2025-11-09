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
  doorbotId: (json['doorbotId'] as num).toInt(),
  kind: json['kind'] as String,
  sessionId: (json['sessionId'] as num).toInt(),
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
      categoryId: (json['categoryId'] as num).toInt(),
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
