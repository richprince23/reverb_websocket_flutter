import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';

class PusherService {
  static final PusherService _instance = PusherService._internal();
  late final PusherChannelsClient client;
  late final PublicChannel channel;
  late StreamSubscription connectionSubs;

  factory PusherService() {
    return _instance;
  }

  PusherService._internal() {
    _initPusher();
  }

  void _initPusher() {
    final options = PusherChannelsOptions.fromHost(
      scheme: 'ws',
      host: 'localhost',
      key: 'qbobmadn1ajewww7v5yi',
      port: 8080,
      metadata: PusherChannelsOptionsMetadata.byDefault(),
    );

    client = PusherChannelsClient.websocket(
      options: options,
      connectionErrorHandler: (exception, trace, refresh) {
        log('Connection error: $exception');
        refresh();
      },
    );
  }

  Future subscribeToChannel(String channelName) async {
    connectionSubs = client.onConnectionEstablished.listen(
      (_) {
        log('Connection established');
        channel = client.publicChannel(channelName);
        channel.subscribe();
        log('Channel subscribed');
      },
      onError: (e) => log('Connection stream error: $e'),
    );

    client.lifecycleStream.listen(
      (state) => log('Connection state: $state'),
    );

    await client.connect();
  }

  /// Subscribe to a channel and listen for events
  Stream<Map<String, dynamic>> subscribeAndBindToEvent(
      String channelName, String eventName) async*{
    Map<String, dynamic> data;
    // subscribe to the channel
    await subscribeToChannel(channelName);
    await for (var event in channel.bind(eventName)) {
      data = jsonDecode(event.data);
      yield data;
    }
  }

  void dispose() {
    connectionSubs.cancel();
    client.disconnect();
  }
}
