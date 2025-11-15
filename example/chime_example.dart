import 'dart:io';
import 'package:ring_client_api/ring_client_api.dart';

/// Example demonstrating Ring Chime device control
///
/// This example shows how to:
/// - Access a Ring Chime device from a location
/// - Get and set ringtones
/// - Play sounds (ding and motion alerts)
/// - Update chime settings
void main() async {
  try {
    // Load refresh token from .env file
    final envFile = File('.env');
    final envContent = await envFile.readAsString();
    final refreshToken = envContent
        .split('\n')
        .firstWhere((line) => line.startsWith('refreshToken='))
        .split('=')[1]
        .trim();

    // Create API instance with debug enabled
    final ringApi = RingApi(
      RefreshTokenAuth(refreshToken: refreshToken),
      options: RingApiOptions(debug: true),
    );

    print('Getting locations...');
    final locations = await ringApi.getLocations();

    if (locations.isEmpty) {
      print('No locations found');
      await ringApi.disconnect();
      return;
    }

    final location = locations.first;
    print('Using location: ${location.name}');

    // Get the first chime from the location
    if (location.chimes.isEmpty) {
      print('No chimes found at this location');
      await ringApi.disconnect();
      return;
    }

    final chime = location.chimes.first;
    print('Found chime: ${chime.name}');
    print('  Model: ${chime.model}');
    print('  Current volume: ${chime.volume}');

    // Get available ringtones and find "Triangle" for ding sounds
    print('\nGetting available ringtones...');
    final newRingtone = await chime.getRingtoneByDescription(
      'Triangle',
      ChimeSoundKind.ding,
    );
    print('Found ringtone: ${newRingtone.description}');

    // Update the chime with the new ringtone
    print('\nUpdating chime ringtone...');
    final requiresReboot = await chime.updateChime(
      ChimeUpdate(
        settings: ChimeUpdateSettings(
          dingAudioId: newRingtone.id,
          dingAudioUserId: newRingtone.userId,
        ),
      ),
    );

    if (requiresReboot) {
      print('⚠ Chime may need to reboot for changes to take effect');
    } else {
      print('✓ Chime settings updated');
    }

    // Play the ding sound
    print('\nPlaying ding sound...');
    await chime.playSound(ChimeSoundKind.ding);
    print('✓ Ding sound played');

    // Wait a moment before playing the next sound
    await Future.delayed(Duration(seconds: 2));

    // Play the motion sound
    print('\nPlaying motion sound...');
    await chime.playSound(ChimeSoundKind.motion);
    print('✓ Motion sound played');

    // Clean up
    print('\nDisconnecting...');
    await ringApi.disconnect();
    print('Done!');
  } catch (e, stack) {
    print('Error: $e');
    print('Stack trace: $stack');
    exit(1);
  }
}
