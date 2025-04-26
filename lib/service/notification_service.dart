import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:yumprides_driver/constant/constant.dart';
import 'package:yumprides_driver/constant/custom_toast.dart';
import 'package:yumprides_driver/page/home_screen/driver_availability_screen.dart';
import 'package:yumprides_driver/page/new_ride_screens/new_ride_screen.dart';

import '../controller/dash_board_controller.dart';
import '../main.dart';
import '../model/ride_request_notification_modal.dart';
import '../page/chats_screen/conversation_screen.dart';
import '../page/dash_board.dart';
import '../page/my_profile/my_profile_screen.dart';

class NotificationService {
  static bool _initialized = false;
  static Future<void> setupInteractedMessage(BuildContext context) async {
    initialize(context);

    final NotificationAppLaunchDetails? details =
    await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();

    if (details?.didNotificationLaunchApp ?? false) {
      if (details!.notificationResponse?.payload != null) {
        try {
          final messageData = jsonDecode(details.notificationResponse!.payload!);

          RemoteMessage fakeMessage = RemoteMessage(
            data: Map<String, dynamic>.from(messageData),
            notification: RemoteNotification(
              title: messageData['title']?.toString(),
              body: messageData['body']?.toString(),
            ),
          );

          await handleMessage(fakeMessage, context);
        } catch (e) {
          debugPrint('❌ Error handling launch notification payload: $e');
        }
      }
    }

    await FirebaseMessaging.instance.subscribeToTopic("yumprides_driver");

    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      await handleMessage(initialMessage, navigatorKey.currentContext!);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await displayMd(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await handleMessage(message, context);
    });
  }

  static Future<void> handleMessage(RemoteMessage message, BuildContext context) async {
    if (message.notification != null) {
      debugPrint("🔔 handleMessage: ${message.data}");

      try {
        debugPrint("Handling message data: ${message.data}");


        // ✅ Handle message with 'status' == 'done'
        if (message.data['status'] == "done") {
          final msgData = json.decode(message.data['message']);
          await Get.to(ConversationScreen(), arguments: {
            'receiverId': int.parse(msgData['senderId'].toString()),
            'orderId': int.parse(msgData['orderId'].toString()),
            'receiverName': msgData['senderName'].toString(),
            'receiverPhoto': msgData['senderPhoto'].toString(),
          });
        }

        // ✅ Handle dashboard routing for 'statut'
        else if (message.data['statut'] == "new" ||
            message.data['statut'] == "rejected") {
          await Get.to(DashBoard());
        }

        // ✅ Handle payment type
        else if (message.data['type'] == "payment received") {
          DashBoardController dashBoardController = Get.put(
              DashBoardController());
          dashBoardController.selectedDrawerIndex.value = 4;
          await Get.to(DashBoard());
        }

        // Enhanced click_action handling
        if (message.data.containsKey('click_action')) {
          final clickActionStr = message.data['click_action'];
          try {
            final decoded = json.decode(clickActionStr);
            debugPrint("Decoded click_action: $decoded");

            if (decoded['type'] == 'driver_availability') {
              final rideRequest = RideRequestNotificationModel.fromMap(decoded);
              await Get.offAll(() => DriverAvailabilityScreen(), arguments: rideRequest);
              return;
            } else if(decoded['type'] == 'new_request'){
              Get.offAll(()=>NewRideScreen());
            }
          } catch (e) {
            debugPrint("JSON decode error: $e");
          }
        }

      }  catch (e) {
        debugPrint("❌ Error parsing click_action JSON: $e");
      }
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
        /* onDidReceiveNotificationResponse: (NotificationResponse response) async {
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
              debugPrint("📩 Payload data after decoding: $messageData");
            } catch (e) {
              debugPrint('Payload parsing error: $e');
            }
          }
        }*/
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
          if (response.payload != null) {
            try {
              final messageData = jsonDecode(response.payload!);

              // Enhanced message simulation
              RemoteMessage fakeMessage = RemoteMessage(
                data: Map<String, dynamic>.from(messageData),
                notification: RemoteNotification(
                  title: messageData['title']?.toString(),
                  body: messageData['body']?.toString(),
                ),
              );

              await handleMessage(fakeMessage, context);
            } catch (e) {
              debugPrint('❌ Payload parsing error: $e');
            }
          }
        }

      /*    onDidReceiveNotificationResponse: (NotificationResponse response) async {
          if (response.payload != null) {
            final Map<String, dynamic> payloadData = jsonDecode(response.payload!);
            await handleMessage(RemoteMessage(data: payloadData), navigatorKey.currentContext!);
          }
        }*/


    );

    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }



  static Future<void> displayMd(RemoteMessage message) async {
    try {
      if (message.notification == null) return;

      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final isDriverAvailability =
          message.data['click_action'] != null &&
              jsonDecode(message.data['click_action'])['type'] == 'driver_availability';

      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        // icon: '@drawable/ic_notification', // 👈 Critical line
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        sound: isDriverAvailability
            ? RawResourceAndroidNotificationSound('driver_availability')
            : null,
      );

      final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        categoryIdentifier: 'driver.category', // Add category for actionable notifications
        threadIdentifier: 'yumprides_driver',
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
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