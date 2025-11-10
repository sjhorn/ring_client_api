// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streaming_messages.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionBody _$SessionBodyFromJson(Map<String, dynamic> json) => SessionBody(
  doorbotId: (json['doorbot_id'] as num).toInt(),
  sessionId: json['session_id'] as String,
);

Map<String, dynamic> _$SessionBodyToJson(SessionBody instance) =>
    <String, dynamic>{
      'doorbot_id': instance.doorbotId,
      'session_id': instance.sessionId,
    };

AnswerMessage _$AnswerMessageFromJson(Map<String, dynamic> json) =>
    AnswerMessage(
      method: json['method'] as String,
      body: AnswerBody.fromJson(json['body'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnswerMessageToJson(AnswerMessage instance) =>
    <String, dynamic>{'method': instance.method, 'body': instance.body};

AnswerBody _$AnswerBodyFromJson(Map<String, dynamic> json) => AnswerBody(
  sdp: json['sdp'] as String,
  type: json['type'] as String,
  doorbotId: (json['doorbot_id'] as num).toInt(),
  sessionId: json['session_id'] as String,
);

Map<String, dynamic> _$AnswerBodyToJson(AnswerBody instance) =>
    <String, dynamic>{
      'doorbot_id': instance.doorbotId,
      'session_id': instance.sessionId,
      'sdp': instance.sdp,
      'type': instance.type,
    };

IceCandidateMessage _$IceCandidateMessageFromJson(Map<String, dynamic> json) =>
    IceCandidateMessage(
      method: json['method'] as String,
      body: IceCandidateBody.fromJson(json['body'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IceCandidateMessageToJson(
  IceCandidateMessage instance,
) => <String, dynamic>{'method': instance.method, 'body': instance.body};

IceCandidateBody _$IceCandidateBodyFromJson(Map<String, dynamic> json) =>
    IceCandidateBody(
      ice: json['ice'] as String,
      mlineindex: (json['mlineindex'] as num).toInt(),
      doorbotId: (json['doorbot_id'] as num).toInt(),
      sessionId: json['session_id'] as String,
    );

Map<String, dynamic> _$IceCandidateBodyToJson(IceCandidateBody instance) =>
    <String, dynamic>{
      'doorbot_id': instance.doorbotId,
      'session_id': instance.sessionId,
      'ice': instance.ice,
      'mlineindex': instance.mlineindex,
    };

SessionCreatedMessage _$SessionCreatedMessageFromJson(
  Map<String, dynamic> json,
) => SessionCreatedMessage(
  method: json['method'] as String,
  body: SessionBody.fromJson(json['body'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SessionCreatedMessageToJson(
  SessionCreatedMessage instance,
) => <String, dynamic>{'method': instance.method, 'body': instance.body};

SessionStartedMessage _$SessionStartedMessageFromJson(
  Map<String, dynamic> json,
) => SessionStartedMessage(
  method: json['method'] as String,
  body: SessionBody.fromJson(json['body'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SessionStartedMessageToJson(
  SessionStartedMessage instance,
) => <String, dynamic>{'method': instance.method, 'body': instance.body};

PongMessage _$PongMessageFromJson(Map<String, dynamic> json) => PongMessage(
  method: json['method'] as String,
  body: SessionBody.fromJson(json['body'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PongMessageToJson(PongMessage instance) =>
    <String, dynamic>{'method': instance.method, 'body': instance.body};

NotificationMessage _$NotificationMessageFromJson(Map<String, dynamic> json) =>
    NotificationMessage(
      method: json['method'] as String,
      body: NotificationBody.fromJson(json['body'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationMessageToJson(
  NotificationMessage instance,
) => <String, dynamic>{'method': instance.method, 'body': instance.body};

NotificationBody _$NotificationBodyFromJson(Map<String, dynamic> json) =>
    NotificationBody(
      isOk: json['is_ok'] as bool,
      text: json['text'] as String,
      doorbotId: (json['doorbot_id'] as num).toInt(),
      sessionId: json['session_id'] as String,
    );

Map<String, dynamic> _$NotificationBodyToJson(NotificationBody instance) =>
    <String, dynamic>{
      'doorbot_id': instance.doorbotId,
      'session_id': instance.sessionId,
      'is_ok': instance.isOk,
      'text': instance.text,
    };

CameraStartedMessage _$CameraStartedMessageFromJson(
  Map<String, dynamic> json,
) => CameraStartedMessage(
  method: json['method'] as String,
  body: SessionBody.fromJson(json['body'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CameraStartedMessageToJson(
  CameraStartedMessage instance,
) => <String, dynamic>{'method': instance.method, 'body': instance.body};

StreamInfoMessage _$StreamInfoMessageFromJson(Map<String, dynamic> json) =>
    StreamInfoMessage(
      method: json['method'] as String,
      body: StreamInfoBody.fromJson(json['body'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StreamInfoMessageToJson(StreamInfoMessage instance) =>
    <String, dynamic>{'method': instance.method, 'body': instance.body};

StreamInfoBody _$StreamInfoBodyFromJson(Map<String, dynamic> json) =>
    StreamInfoBody(
      transcoding: json['transcoding'] as bool,
      transcodingReason: json['transcoding_reason'] as String,
      doorbotId: (json['doorbot_id'] as num).toInt(),
      sessionId: json['session_id'] as String,
    );

Map<String, dynamic> _$StreamInfoBodyToJson(StreamInfoBody instance) =>
    <String, dynamic>{
      'doorbot_id': instance.doorbotId,
      'session_id': instance.sessionId,
      'transcoding': instance.transcoding,
      'transcoding_reason': instance.transcodingReason,
    };

CloseMessage _$CloseMessageFromJson(Map<String, dynamic> json) => CloseMessage(
  method: json['method'] as String,
  body: CloseBody.fromJson(json['body'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CloseMessageToJson(CloseMessage instance) =>
    <String, dynamic>{'method': instance.method, 'body': instance.body};

CloseBody _$CloseBodyFromJson(Map<String, dynamic> json) => CloseBody(
  reason: CloseReason.fromJson(json['reason'] as Map<String, dynamic>),
  doorbotId: (json['doorbot_id'] as num).toInt(),
  sessionId: json['session_id'] as String,
);

Map<String, dynamic> _$CloseBodyToJson(CloseBody instance) => <String, dynamic>{
  'doorbot_id': instance.doorbotId,
  'session_id': instance.sessionId,
  'reason': instance.reason,
};

CloseReason _$CloseReasonFromJson(Map<String, dynamic> json) => CloseReason(
  code: (json['code'] as num).toInt(),
  text: json['text'] as String,
);

Map<String, dynamic> _$CloseReasonToJson(CloseReason instance) =>
    <String, dynamic>{'code': instance.code, 'text': instance.text};
