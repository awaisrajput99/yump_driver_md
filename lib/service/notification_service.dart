import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:yumprides_driver/constant/constant.dart';
import 'package:yumprides_driver/page/new_ride_screens/new_ride_screen.dart';

import '../controller/dash_board_controller.dart';
import '../model/ride_request_notification_modal.dart';
import '../page/chats_screen/conversation_screen.dart';
import '../page/dash_board.dart';
import '../page/my_profile/my_profile_screen.dart';

class NotificationService {
  static bool _initialized = false;
  static Future<void> setupInteractedMessage(BuildContext context) async {
    initialize(context);
    await FirebaseMessaging.instance.subscribeToTopic("yumprides_driver");

    // when application is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      if (initialMessage.notification != null) {
        await handleMessage(initialMessage, context);
      }
    }

    // when application is running and active
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        display(message);
      }
    });

    // when application is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.notification != null) {
        await handleMessage(message, context);
      }
    });
  }

  //message handler
  static Future<void> handleMessage(RemoteMessage message, BuildContext context) async {
    if (message.notification != null) {
/*
      Get.to(NewRideScreen());
      Constant.showShimmerBottomSheet(context: context, title: "Numan ch", itemCount: 10);
*/

      if (message.data['status'] == "done") {
        await Get.to(ConversationScreen(), arguments: {
          'receiverId': int.parse(
              json.decode(message.data['message'])['senderId'].toString()),
          'orderId': int.parse(
              json.decode(message.data['message'])['orderId'].toString()),
          'receiverName':
              json.decode(message.data['message'])['senderName'].toString(),
          'receiverPhoto':
              json.decode(message.data['message'])['senderPhoto'].toString(),
        });
      } else if (message.data['statut'] == "new" ||
          message.data['statut'] == "rejected") {
        await Get.to(DashBoard());
      } else if (message.data['type'] == "payment received") {
        DashBoardController dashBoardController =
            Get.put(DashBoardController());
        dashBoardController.selectedDrawerIndex.value = 4;
        await Get.to(DashBoard());
      }/* else if (message.data['type'] == "driver_availability") {
        final rideRequest = RideRequestNotificationModel.fromMap(message.data);
        await Get.to(() => NewRideScreen(), arguments: rideRequest);
      }*/
    }
  }

// initialize the local notification
  static Future<void> initialize(BuildContext context) async {
    if (_initialized) return;
    _initialized = true;
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
      enableVibration: true
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: iosInitializationSettings);
    await FlutterLocalNotificationsPlugin().initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
          if (response.payload != null) {
            try {
              final messageData = jsonDecode(response.payload!);
              await NotificationService.handleMessage(RemoteMessage.fromMap({
                'data': messageData,
                'notification': {
                  'title': 'Notification',
                  'body': '',
                },
              }), context);
            } catch (e) {
              debugPrint('Payload parsing error: $e');
            }
          }
        }
    );

    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

// display the notification
  static Future<void> display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "01",
        "yumprides-driver",
        importance: Importance.max,
        priority: Priority.high,
      ));

      await FlutterLocalNotificationsPlugin().show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    } on Exception catch(e){
      debugPrint("Notification display error: $e");
    }
  }


  static Future<void> displayMd(RemoteMessage message) async {
    try {
      if (message.notification == null) return;

      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel', // Match this with initialize()
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await FlutterLocalNotificationsPlugin().show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      debugPrint("Notification display error: $e");
    }
  }
}
