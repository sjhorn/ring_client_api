/// Ring Chime device class
///
/// Provides functionality for managing Ring Chime and Chime Pro devices.
/// These devices play sounds when doorbell rings and can act as WiFi extenders.
library;

import 'package:rxdart/rxdart.dart';
import 'ring_types.dart';
import 'rest_client.dart';

/// Settings that require a chime reboot when changed
const List<String> settingsWhichRequireReboot = [
  'ding_audio_id',
  'ding_audio_user_id',
  'motion_audio_id',
  'motion_audio_user_id',
];

/// Represents a Ring Chime or Chime Pro device
///
/// Ring Chimes are devices that play sounds when a doorbell rings or motion is detected.
/// Chime Pro models also act as WiFi extenders to boost signal strength.
class RingChime {
  /// Device ID
  final int id;

  /// Device type (kind)
  final String deviceType;

  /// Model name (e.g., 'Chime', 'Chime Pro', 'Chime v2')
  final String model;

  /// Stream of chime data updates
  final BehaviorSubject<ChimeData> onData;

  /// Stream for requesting data updates
  final PublishSubject<void> onRequestUpdate = PublishSubject<void>();

  /// Initial chime data
  final ChimeData initialData;

  /// REST client for API requests
  final RingRestClient restClient;

  /// Create a new RingChime
  ///
  /// [initialData] - Initial chime data from the API
  /// [restClient] - REST client for making API requests
  RingChime({required this.initialData, required this.restClient})
    : id = initialData.id ?? 0,
      deviceType = initialData.kind ?? 'chime',
      model = ChimeModel.models[initialData.kind] ?? 'Chime',
      onData = BehaviorSubject<ChimeData>.seeded(initialData);

  /// Update chime data
  void updateData(ChimeData update) {
    onData.add(update);
  }

  /// Request a data update from the API
  void requestUpdate() {
    onRequestUpdate.add(null);
  }

  /// Get current chime data
  ChimeData get data => onData.value;

  /// Get chime name (same as description)
  String get name => data.description ?? '';

  /// Get chime description
  String get description => data.description ?? '';

  /// Get current volume level
  int get volume => data.settings?.volume ?? 0;

  /// Build a chime API URL
  ///
  /// [path] - Optional path to append to the base URL
  String chimeUrl([String path = '']) {
    return clientApi('chimes/$id/${path.isEmpty ? '' : path}');
  }

  /// Get available ringtones for this chime
  ///
  /// Returns a [RingtoneOptions] object containing all available ringtones
  Future<RingtoneOptions> getRingtones() {
    return restClient
        .request<Map<String, dynamic>>(
          RequestOptions(url: clientApi('ringtones')),
        )
        .then((response) => RingtoneOptions.fromJson(response.data));
  }

  /// Find a ringtone by description and kind
  ///
  /// [description] - The description of the ringtone to find
  /// [kind] - The kind of sound (ding or motion)
  /// Returns the matching [RingtoneAudio] object
  /// Throws [Exception] if the requested ringtone is not found
  Future<RingtoneAudio> getRingtoneByDescription(
    String description,
    ChimeSoundKind kind,
  ) async {
    final ringtones = await getRingtones();
    final kindStr = kind.name;
    final requestedRingtone = ringtones.audios.where((audio) {
      return audio.available == 'true' &&
          audio.description == description &&
          audio.kind == kindStr;
    }).firstOrNull;

    if (requestedRingtone == null) {
      throw Exception('Requested ringtone not found');
    }

    return requestedRingtone;
  }

  /// Play a sound on the chime
  ///
  /// [kind] - The kind of sound to play (ding or motion)
  Future<void> playSound(ChimeSoundKind kind) async {
    await restClient.request(
      RequestOptions(
        url: chimeUrl('play_sound'),
        method: 'POST',
        json: {'kind': kind.name},
      ),
    );
  }

  /// Snooze the chime for a specified time
  ///
  /// [time] - Time in minutes (max 24 * 60 = 1440 minutes = 24 hours)
  Future<void> snooze(int time) async {
    await restClient.request(
      RequestOptions(
        url: chimeUrl('do_not_disturb'),
        method: 'POST',
        json: {'time': time},
      ),
    );

    requestUpdate();
  }

  /// Clear the snooze and resume normal operation
  Future<void> clearSnooze() async {
    await restClient.request(
      RequestOptions(url: chimeUrl('do_not_disturb'), method: 'POST'),
    );

    requestUpdate();
  }

  /// Update chime settings
  ///
  /// [update] - The settings to update
  /// Returns true if the change requires a reboot, false otherwise
  Future<bool> updateChime(ChimeUpdate update) async {
    await restClient.request(
      RequestOptions(
        url: chimeUrl(),
        method: 'PUT',
        json: {'chime': update.toJson()},
      ),
    );

    requestUpdate();

    // Check if any of the changed settings require a reboot
    final settings = update.settings;
    if (settings != null) {
      final settingsJson = settings.toJson();
      return settingsJson.keys.any(
        (key) => settingsWhichRequireReboot.contains(key),
      );
    }

    return false;
  }

  /// Set the volume level
  ///
  /// [volume] - Volume level between 0 and 11
  /// Throws [ArgumentError] if volume is out of range
  /// Returns true if the change requires a reboot, false otherwise
  Future<bool> setVolume(int volume) {
    if (volume < 0 || volume > 11) {
      throw ArgumentError(
        'Volume for $name must be between 0 and 11, got $volume',
      );
    }

    return updateChime(
      ChimeUpdate(settings: ChimeUpdateSettings(volume: volume)),
    );
  }

  /// Get health information for this chime
  ///
  /// Returns [ChimeHealth] object with detailed health metrics
  Future<ChimeHealth> getHealth() async {
    final response = await restClient.request<Map<String, dynamic>>(
      RequestOptions(url: clientApi('chimes/$id/health')),
    );

    return ChimeHealth.fromJson(
      response.data['device_health'] as Map<String, dynamic>,
    );
  }

  /// Dispose of resources
  void dispose() {
    onData.close();
    onRequestUpdate.close();
  }
}
