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

          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final context = navigatorKey.currentContext;
            if (context != null) {
              await handleMessage(fakeMessage, context);
            } else {
              debugPrint("❌ navigatorKey.currentContext still null after frame.");
            }
          });
        } catch (e) {
          debugPrint('❌ Error handling launch notification payload: $e');
        }
      }
    }

    await FirebaseMessaging.instance.subscribeToTopic("yumprides_driver");

 /*   RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      await handleMessage(initialMessage, navigatorKey.currentContext!);
    }*/
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await handleNotificationWithContextCheck(initialMessage!);
        });
      });
    }


    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("🚨 onMessage: ${message.data}");
      await displayMd(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await handleNotificationWithContextCheck(message);
    });
  }

  // In NotificationService class
  static Future<void> handleNotificationWithContextCheck(RemoteMessage message) async {
    const maxRetries = 5;
    const retryDelay = Duration(milliseconds: 200);

    for (var i = 0; i < maxRetries; i++) {
      final context = navigatorKey.currentContext;
      if (context != null) {
        await handleMessage(message, context);
        return;
      }
      await Future.delayed(retryDelay);
    }
    debugPrint("❌ Failed to get context after $maxRetries attempts");
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
        if (message.data.containsKey('driver_availability')) {
          dynamic clickActionData = message.data['click_action'];

          // If it's a string, decode it. If it's already a map, use it directly.
          if (clickActionData is String) {
            try {
              clickActionData = json.decode(clickActionData);
            } catch (e) {
              debugPrint("❌ Failed to decode click_action string: $e");
              return;
            }
          }

          if (clickActionData is Map && clickActionData['type'] == 'driver_availability') {
            try {
              final rideRequest = RideRequestNotificationModel.fromMap(
                Map<String, dynamic>.from(clickActionData),
              );
              await Get.offAll(() => DriverAvailabilityScreen(), arguments: rideRequest);
              return;
            } catch (e) {
              debugPrint('❌ Error parsing RideRequestNotificationModel: $e');
              return;
            }
          } else if (clickActionData['type'] == 'new_request') {
            await Get.offAll(() => NewRideScreen());
            return;
          }
        }
   /*     if (message.data['type'] == 'driver_availability') {
          final rideRequest = RideRequestNotificationModel.fromMap(message.data);
          await Get.offAll(() => DriverAvailabilityScreen(), arguments: rideRequest);
        } else if (message.data['type'] == 'new_request') {
          Get.offAll(() => NewRideScreen());
        }*/

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
        sound: RawResourceAndroidNotificationSound('driver_availability'), // ✅ set sound
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

              RemoteMessage fakeMessage = RemoteMessage(
                data: Map<String, dynamic>.from(messageData),
                notification: RemoteNotification(
                  title: messageData['title']?.toString(),
                  body: messageData['body']?.toString(),
                ),
              );

              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await handleNotificationWithContextCheck(fakeMessage);
              });
            } catch (e) {
              debugPrint('❌ Payload parsing error: $e');
            }
          }
        }
/*        onDidReceiveNotificationResponse: (NotificationResponse response) async {
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

              await handleMessage(fakeMessage, navigatorKey.currentContext!);
            } catch (e) {
              debugPrint('❌ Payload parsing error: $e');
            }
          }
        }*/

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
       /* sound: isDriverAvailability
            ? RawResourceAndroidNotificationSound('driver_availability')
            : null,*/
      );

      final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        categoryIdentifier: 'driver_availability', // Add category for actionable notifications
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