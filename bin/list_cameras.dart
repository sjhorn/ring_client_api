import 'package:ring_client_api/ring_client_api.dart';

void main(List<String> args) async {
  if (args.isEmpty) {
    print('Usage: dart list_cameras.dart <refresh_token>');
    return;
  }
  final ringClientApi = RingApi(RefreshTokenAuth(refreshToken: args.first));
  final cameras = await ringClientApi.getCameras();
  for (var camera in cameras) {
    print('Camera: ${camera.name}, ID: ${camera.id}');
  }
}
