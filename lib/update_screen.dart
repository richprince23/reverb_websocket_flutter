import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pusher_client_socket/pusher_client_socket.dart';
import 'package:reverb_websocket_flutter/pusher_service.dart';
import 'package:reverb_websocket_flutter/reverb_service.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final pusher = PusherService();
  String sdata = "No data";
  late StreamSubscription eventSub;

  final reverb = ReverbService();
  late Channel channel;

  @override
  void initState() {
    super.initState();
    // pusher.subscribeToChannel("");
    // eventSub = pusher
    //     .subscribeAndBindToEvent("test-channel", 'TestEvent')
    //     .listen((message) {
    //   setState(() {
    //     data = message['message'];
    //   });
    // });
    reverb.initChannel();
    // reverb.pusherClient.subscribe("test-channel").bind("TestEvent", (data) {
    //   print(data);
    // });
    // reverb.pusherClient.connect();
    reverb.pusherClient.onConnectionEstablished((data) {
      // print("Connection established - socket-id: ${pusherClient.socketId}");
      print("Connection established - data: $data");
      channel = reverb.pusherClient.channel("test-channel");
      channel.subscribe();
      channel.bind("TestEvent", (Map<String, dynamic> e) {
        log(e.toString());
        // var jsonData = jsonDecode(e);
        setState(() {
          sdata = e['message'];
        });
      });
    });

    reverb.connect();
  }

  @override
  void dispose() {
    eventSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(sdata),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
