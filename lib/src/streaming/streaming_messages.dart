/// WebRTC streaming message types for Ring camera connections
library;

import 'package:json_annotation/json_annotation.dart';

part 'streaming_messages.g.dart';

/// Session body common to all messages
@JsonSerializable()
class SessionBody {
  @JsonKey(name: 'doorbot_id')
  final int doorbotId;
  @JsonKey(name: 'session_id')
  final String sessionId;

  SessionBody({
    required this.doorbotId,
    required this.sessionId,
  });

  factory SessionBody.fromJson(Map<String, dynamic> json) =>
      _$SessionBodyFromJson(json);
  Map<String, dynamic> toJson() => _$SessionBodyToJson(this);
}

/// SDP answer message
@JsonSerializable()
class AnswerMessage {
  final String method; // 'sdp'
  final AnswerBody body;

  AnswerMessage({
    required this.method,
    required this.body,
  });

  factory AnswerMessage.fromJson(Map<String, dynamic> json) =>
      _$AnswerMessageFromJson(json);
  Map<String, dynamic> toJson() => _$AnswerMessageToJson(this);
}

@JsonSerializable()
class AnswerBody extends SessionBody {
  final String sdp;
  final String type; // 'answer'

  AnswerBody({
    required this.sdp,
    required this.type,
    required super.doorbotId,
    required super.sessionId,
  });

  factory AnswerBody.fromJson(Map<String, dynamic> json) =>
      _$AnswerBodyFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$AnswerBodyToJson(this);
}

/// ICE candidate message
@JsonSerializable()
class IceCandidateMessage {
  final String method; // 'ice'
  final IceCandidateBody body;

  IceCandidateMessage({
    required this.method,
    required this.body,
  });

  factory IceCandidateMessage.fromJson(Map<String, dynamic> json) =>
      _$IceCandidateMessageFromJson(json);
  Map<String, dynamic> toJson() => _$IceCandidateMessageToJson(this);
}

@JsonSerializable()
class IceCandidateBody extends SessionBody {
  final String ice;
  final int mlineindex;

  IceCandidateBody({
    required this.ice,
    required this.mlineindex,
    required super.doorbotId,
    required super.sessionId,
  });

  factory IceCandidateBody.fromJson(Map<String, dynamic> json) =>
      _$IceCandidateBodyFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$IceCandidateBodyToJson(this);
}

/// Session created message
@JsonSerializable()
class SessionCreatedMessage {
  final String method; // 'session_created'
  final SessionBody body;

  SessionCreatedMessage({
    required this.method,
    required this.body,
  });

  factory SessionCreatedMessage.fromJson(Map<String, dynamic> json) =>
      _$SessionCreatedMessageFromJson(json);
  Map<String, dynamic> toJson() => _$SessionCreatedMessageToJson(this);
}

/// Session started message
@JsonSerializable()
class SessionStartedMessage {
  final String method; // 'session_started'
  final SessionBody body;

  SessionStartedMessage({
    required this.method,
    required this.body,
  });

  factory SessionStartedMessage.fromJson(Map<String, dynamic> json) =>
      _$SessionStartedMessageFromJson(json);
  Map<String, dynamic> toJson() => _$SessionStartedMessageToJson(this);
}

/// Pong message
@JsonSerializable()
class PongMessage {
  final String method; // 'pong'
  final SessionBody body;

  PongMessage({
    required this.method,
    required this.body,
  });

  factory PongMessage.fromJson(Map<String, dynamic> json) =>
      _$PongMessageFromJson(json);
  Map<String, dynamic> toJson() => _$PongMessageToJson(this);
}

/// Notification message
@JsonSerializable()
class NotificationMessage {
  final String method; // 'notification'
  final NotificationBody body;

  NotificationMessage({
    required this.method,
    required this.body,
  });

  factory NotificationMessage.fromJson(Map<String, dynamic> json) =>
      _$NotificationMessageFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationMessageToJson(this);
}

@JsonSerializable()
class NotificationBody extends SessionBody {
  @JsonKey(name: 'is_ok')
  final bool isOk;
  final String text;

  NotificationBody({
    required this.isOk,
    required this.text,
    required super.doorbotId,
    required super.sessionId,
  });

  factory NotificationBody.fromJson(Map<String, dynamic> json) =>
      _$NotificationBodyFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$NotificationBodyToJson(this);
}

/// Camera started message
@JsonSerializable()
class CameraStartedMessage {
  final String method; // 'camera_started'
  final SessionBody body;

  CameraStartedMessage({
    required this.method,
    required this.body,
  });

  factory CameraStartedMessage.fromJson(Map<String, dynamic> json) =>
      _$CameraStartedMessageFromJson(json);
  Map<String, dynamic> toJson() => _$CameraStartedMessageToJson(this);
}

/// Stream info message
@JsonSerializable()
class StreamInfoMessage {
  final String method; // 'stream_info'
  final StreamInfoBody body;

  StreamInfoMessage({
    required this.method,
    required this.body,
  });

  factory StreamInfoMessage.fromJson(Map<String, dynamic> json) =>
      _$StreamInfoMessageFromJson(json);
  Map<String, dynamic> toJson() => _$StreamInfoMessageToJson(this);
}

@JsonSerializable()
class StreamInfoBody extends SessionBody {
  final bool transcoding;
  @JsonKey(name: 'transcoding_reason')
  final String transcodingReason;

  StreamInfoBody({
    required this.transcoding,
    required this.transcodingReason,
    required super.doorbotId,
    required super.sessionId,
  });

  factory StreamInfoBody.fromJson(Map<String, dynamic> json) =>
      _$StreamInfoBodyFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$StreamInfoBodyToJson(this);
}

/// Close reason codes
enum CloseReasonCode {
  /// Normal close (code 0)
  normalClose(0),

  /// Authentication failed (code 5)
  /// Examples:
  /// - '[rsl-apps/webrtc-liveview-server/Session.cpp:429] [Auth] [0xd540]: [rsl-apps/session-manager/Manager.cpp:227] [AppAuth] Unauthorized: invalid or expired token'
  /// - 'Authentication failed: -1'
  /// - 'Sessions with the provided ID not found'
  authenticationFailed(5),

  /// Timeout waiting for ping (code 6)
  timeout(6);

  final int code;
  const CloseReasonCode(this.code);

  static CloseReasonCode fromCode(int code) {
    return CloseReasonCode.values.firstWhere(
      (e) => e.code == code,
      orElse: () => CloseReasonCode.normalClose,
    );
  }
}

/// Close message
@JsonSerializable()
class CloseMessage {
  final String method; // 'close'
  final CloseBody body;

  CloseMessage({
    required this.method,
    required this.body,
  });

  factory CloseMessage.fromJson(Map<String, dynamic> json) =>
      _$CloseMessageFromJson(json);
  Map<String, dynamic> toJson() => _$CloseMessageToJson(this);
}

@JsonSerializable()
class CloseBody extends SessionBody {
  final CloseReason reason;

  CloseBody({
    required this.reason,
    required super.doorbotId,
    required super.sessionId,
  });

  factory CloseBody.fromJson(Map<String, dynamic> json) =>
      _$CloseBodyFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$CloseBodyToJson(this);
}

@JsonSerializable()
class CloseReason {
  final int code;
  final String text;

  CloseReason({
    required this.code,
    required this.text,
  });

  factory CloseReason.fromJson(Map<String, dynamic> json) =>
      _$CloseReasonFromJson(json);
  Map<String, dynamic> toJson() => _$CloseReasonToJson(this);
}

/// Union type for all incoming messages
class IncomingMessage {
  final Map<String, dynamic> raw;
  final String method;

  IncomingMessage(this.raw) : method = raw['method'] as String;

  AnswerMessage? get asAnswer =>
      method == 'sdp' ? AnswerMessage.fromJson(raw) : null;

  IceCandidateMessage? get asIceCandidate =>
      method == 'ice' ? IceCandidateMessage.fromJson(raw) : null;

  SessionCreatedMessage? get asSessionCreated =>
      method == 'session_created' ? SessionCreatedMessage.fromJson(raw) : null;

  SessionStartedMessage? get asSessionStarted =>
      method == 'session_started' ? SessionStartedMessage.fromJson(raw) : null;

  PongMessage? get asPong =>
      method == 'pong' ? PongMessage.fromJson(raw) : null;

  CloseMessage? get asClose =>
      method == 'close' ? CloseMessage.fromJson(raw) : null;

  NotificationMessage? get asNotification =>
      method == 'notification' ? NotificationMessage.fromJson(raw) : null;

  CameraStartedMessage? get asCameraStarted =>
      method == 'camera_started' ? CameraStartedMessage.fromJson(raw) : null;

  StreamInfoMessage? get asStreamInfo =>
      method == 'stream_info' ? StreamInfoMessage.fromJson(raw) : null;
}
