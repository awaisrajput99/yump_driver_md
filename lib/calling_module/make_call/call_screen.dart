// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

/*import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart' as agr;*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:yumprides_driver/calling_module/make_call/backend/firestoremethods.dart';
import 'package:yumprides_driver/constant/constant.dart';
import 'package:yumprides_driver/page/dash_board.dart';

class CallScreen extends StatefulWidget {
  final bool isBroadcaster;
  final String channelId;
  final String userId;
  final String driverId;
  final String userName;
  const CallScreen(
      {super.key,
      required this.isBroadcaster,
      required this.channelId,
      required this.userId,
      required this.userName,
      required this.driverId});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> with TickerProviderStateMixin {
  // late final RtcEngine _engine;
  List<int> remoteUid = [];
  bool switchCamera = true;
  bool isMuted = false;
  final bool _isLive = false;
/*  ConnectionStateType _connectionState =
      ConnectionStateType.connectionStateDisconnected;*/
  final String _streamStatus = 'Initializing...';
  Timer? _timeoutTimer;

  final bool _isReconnecting = false;
  Timer? _reconnectionTimer;
  final int _reconnectionAttempts = 0;
  final int _maxReconnectionAttempts = 5;

  @override
  void initState() {
    super.initState();
    // _initEngine();
  }

  void _inviteUser(String selectedUserId) async {
    await firestoreMethods().addUser(widget.channelId, selectedUserId);
  }

/*  Future<void> _initEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: Constant.agoraId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    _addListeners();

    // await _engine.enableVideo();
    await _engine.startPreview();
    await _engine
        .setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    await _engine.setClientRole(
        role: widget.isBroadcaster
            ? ClientRoleType.clientRoleBroadcaster
            : ClientRoleType.clientRoleAudience);

    _joinChannel();
  }*/

  String baseUrl = "https://streaming-app-server-6s95.onrender.com";
  String? token;

  Future<void> getToken() async {
    final res = await http.get(
      Uri.parse(
          '$baseUrl/rtc/${widget.channelId}/publisher/userAccount/${widget.driverId}/'),
    );

    if (res.statusCode == 200) {
      setState(() {
        token = jsonDecode(res.body)['rtcToken'];
      });
    } else {
      debugPrint('Failed to fetch the token');
    }
  }

/*  void _addListeners() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint(
              "Local user joined ${connection.channelId} after $elapsed ms");
          setState(() {
            _isLive = true;
            _streamStatus = 'Live';
            _isReconnecting = false;
            _reconnectionAttempts = 0;
          });
        },
        onConnectionStateChanged: (RtcConnection connection,
            ConnectionStateType state, ConnectionChangedReasonType reason) {
          debugPrint("Connection state changed: $state, reason: $reason");
          setState(() {
            _connectionState = state;
            _streamStatus = _getStatusFromConnectionState(state);
          });
          if (state == ConnectionStateType.connectionStateReconnecting) {
            _handleReconnection();
          } else if (state == ConnectionStateType.connectionStateConnected) {
            _isReconnecting = false;
            _reconnectionAttempts = 0;
            _inviteUser(widget.userId);
          }
        },
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          debugPrint("Remote user joined: $uid $elapsed");
          setState(() {
            remoteUid.add(uid);
          });
          _engine.getUserInfoByUid(uid).then((userInfo) {
            debugPrint(
                "User account: ${userInfo.userAccount}, UID: ${userInfo.uid}");
          }).catchError((err) {
            debugPrint("Failed to get user info: $err");
          });
          debugPrint("$remoteUid");
        },
        onUserInfoUpdated: (int uid, agr.UserInfo userInfo) {
          debugPrint(
              "User info updated: UID: $uid, UserAccount: ${userInfo.userAccount}");
          // Here you can map the numeric UID to the user account if needed
        },
        onUserOffline:
            (RtcConnection connection, int uid, UserOfflineReasonType reason) {
          debugPrint("Remote user offline: $uid $reason");
          setState(() {
            remoteUid.removeWhere((element) => element == uid);
          });
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          debugPrint("Local user left channel: ${connection.channelId}");
          debugPrint("Time in channel: ${stats.duration} seconds");
          setState(() {
            remoteUid.clear();
            _isLive = false;
            _streamStatus = 'Offline';
          });
        },
        onTokenPrivilegeWillExpire: (connection, token) async {
          await getToken();
          await _engine.renewToken(token);
        },
        onError: (ErrorCodeType err, String msg) {
          debugPrint("Error occurred: $err, $msg");
          setState(() {
            _streamStatus = 'Error: $err';
          });
        },
      ),
    );
  }*/

/*  void _handleReconnection() {
    if (!_isReconnecting) {
      _isReconnecting = true;
      _reconnectionTimer = Timer.periodic(Duration(seconds: 10), (timer) {
        if (_reconnectionAttempts < _maxReconnectionAttempts) {
          _reconnectionAttempts++;
          _joinChannel();
        } else {
          timer.cancel();
          _showReconnectionFailedDialog();
        }
      });
    }
  }

  void _showReconnectionFailedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Connection Lost'),
          content: const Text(
              'Failed to reconnect after multiple attempts. Please check your internet connection and try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _leaveChannel();
              },
            ),
          ],
        );
      },
    );
  }*/

/*  String _getStatusFromConnectionState(ConnectionStateType state) {
    switch (state) {
      case ConnectionStateType.connectionStateConnecting:
        return 'Connecting...';
      case ConnectionStateType.connectionStateConnected:
        return 'Connected';
      case ConnectionStateType.connectionStateReconnecting:
        return 'Reconnecting...';
      case ConnectionStateType.connectionStateFailed:
        return 'Connection Failed';
      default:
        return 'Disconnected';
    }
  }*/

/*  Future<void> _joinChannel() async {
    setState(() {
      _streamStatus = 'Joining channel...';
    });

    await getToken();
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }

    try {
      await _engine.joinChannelWithUserAccount(
        token: token!,
        channelId: widget.channelId,
        userAccount: widget.driverId,
        options: const ChannelMediaOptions(),
      );

      _timeoutTimer = Timer(const Duration(seconds: 30), () {
        if (!_isLive) {
          setState(() {
            _streamStatus = 'Failed to join channel after 30 seconds';
          });
        }
      });
    } catch (e) {
      debugPrint("Error joining channel: $e");
      setState(() {
        _streamStatus = 'Error joining channel';
      });
    }
  }*/

/*  void onToggleMute() async {
    setState(() {
      isMuted = !isMuted;
    });
    await _engine.muteLocalAudioStream(isMuted);
  }*/

/*  Future<void> _leaveChannel() async {
    _timeoutTimer?.cancel();
    await _engine.leaveChannel();
    await firestoreMethods().endCall(widget.channelId);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => DashBoard(),
      ),
      (route) => false,
    );
  }

  Widget _buildConnectionStateIndicator() {
    Color color;
    switch (_connectionState) {
      case ConnectionStateType.connectionStateConnected:
        color = Colors.green;
        break;
      case ConnectionStateType.connectionStateConnecting:
        color = Colors.yellow;
        break;
      default:
        color = Colors.red;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: 8,
        backgroundColor: color,
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // await _leaveChannel();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            "Call App 1",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          actions: [
            // _buildConnectionStateIndicator(),
            const CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(
                Icons.person,
                color: Colors.red,
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              top: 50,
              left: 10,
              right: 10,
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.userName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
              /*    Text(
                    _connectionState ==
                            ConnectionStateType.connectionStateDisconnected
                        ? "Calling..."
                        : _connectionState ==
                                ConnectionStateType.connectionStateConnecting
                            ? "Connecting..."
                            : "Connected",
                    style: const TextStyle(color: Colors.white),
                  ),*/
                ],
              ),
            ),
            Positioned(
                bottom: 100,
                right: 10,
                left: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      // onTap: onToggleMute,
                      child: Icon(
                        isMuted ? Icons.mic_off_sharp : Icons.mic,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        // _leaveChannel();
                        await firestoreMethods().endCall(widget.channelId);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashBoard(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.volume_up,
                      color: Colors.white,
                      size: 35,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _reconnectionTimer?.cancel();
    // _engine.leaveChannel();
    // _engine.release();
    super.dispose();
  }
}
