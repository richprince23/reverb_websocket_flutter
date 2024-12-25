import 'dart:developer';

import 'package:pusher_client_socket/pusher_client_socket.dart';

class ReverbService {
  late final PusherClient pusherClient;
  // late final Channel channelName;

  final options = const PusherOptions(
    key: 'qbobmadn1ajewww7v5yi',
    host: 'localhost', // REVERB_HOST
    wsPort: 8080, // REVERB_PORT
    encrypted: false, // (Note: enable it if you'r using wss connection)
    authOptions:
        PusherAuthOptions('http://localhost/broadcasting/auth', headers: {
      'Accept': 'application/json',
      // 'Authorization': 'Bearer AUTH-TOKEN'
    }),
    autoConnect: false,
  );

  Future<void> initChannel() async {
    pusherClient = PusherClient(options: options);
    // pusherClient.onConnectionEstablished((data) {
    //   print("Connection established - socket-id: ${pusherClient.socketId}");
    //   print("Connection established - data: $data");
    //   // channelName = pusherClient.channel("test-channel");
    //   // channelName.subscribe();
    // });
    pusherClient.onConnectionError((error) {
      print("Connection error - $error");
    });
    pusherClient.onError((error) {
      print("Error - $error");
    });
    pusherClient.onDisconnected((data) {
      print("Disconnected - $data");
    });
  }

  void connect() async {
    pusherClient.connect();
  }
}
