import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reverb_websocket_flutter/pusher_service.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final pusher = PusherService();
  String data = "No data";
  late StreamSubscription eventSub;

  @override
  void initState() {
    super.initState();
    // pusher.subscribeToChannel("");
    eventSub = pusher
        .subscribeAndBindToEvent("test-channel", 'TestEvent')
        .listen((message) {
      setState(() {
        data = message['message'];
      });
    });
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
            Text(data),
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
