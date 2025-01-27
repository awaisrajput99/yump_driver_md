// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:yumprides_driver/calling_module/make_call/backend/firestoremethods.dart';
import 'package:yumprides_driver/calling_module/make_call/call_screen.dart';

class DialCall extends StatefulWidget {
  String userId;
  String userName;
  String driverId;

  DialCall({
    super.key,
    required this.userId,
    required this.userName,
    required this.driverId,
  });

  @override
  State<DialCall> createState() => _DialCallState();
}

class _DialCallState extends State<DialCall> {
  callUser(String userId, String userName) async {
    String channelId =
        await firestoreMethods().callStream(context, widget.driverId);

    if (channelId.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CallScreen(
            isBroadcaster: true,
            channelId: channelId,
            userId: userId,
            userName: userName,
            driverId: widget.driverId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              callUser(widget.userId, widget.userName);
            },
            child: const Text(
              "Call",
              style: TextStyle(color: Colors.black),
            )),
      ),
    );
  }
}
