// ignore_for_file: empty_catches, must_be_immutable, unused_local_variable, deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:yumprides_driver/calling_module/receive_call/backend/call_notifications.dart';
import 'package:yumprides_driver/controller/dash_board_controller.dart';

import 'package:yumprides_driver/controller/settings_controller.dart';
import 'package:yumprides_driver/firebase_options.dart';
import 'package:yumprides_driver/on_boarding_screen.dart';
import 'package:yumprides_driver/page/auth_screens/login_screen.dart';
import 'package:yumprides_driver/page/auth_screens/mobile_number_screen.dart';
import 'package:yumprides_driver/page/auth_screens/signup_screen.dart';
import 'package:yumprides_driver/page/dash_board.dart';
import 'package:yumprides_driver/service/api.dart';
import 'package:yumprides_driver/service/network_status_service.dart';
import 'package:yumprides_driver/service/notification_service.dart';
import 'package:yumprides_driver/themes/md_app_theme.dart';
import 'package:yumprides_driver/themes/styles.dart';
import 'package:yumprides_driver/utils/theme_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumprides_driver/widget/permission_dialog.dart';
import 'constant/send_notification.dart';
import 'page/chats_screen/conversation_screen.dart';
import 'page/localization_screens/localization_screen.dart';
import 'service/localization_service.dart';
import 'utils/Preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Preferences.initPref();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.playIntegrity,
    // androidProvider: AndroidProvider.playIntegrity,

    appleProvider: AppleProvider.appAttest,
  );
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  var request = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
/*
  WidgetsBinding.instance.addPostFrameCallback((_) {
    debugPrint(navigatorKey.currentContext != null
        ? "✅ Navigator key attached"
        : "❌ Navigator key missing");
  });*/

  if (!Platform.isIOS) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt > 28) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
  }
  Stripe.publishableKey =
      'pk_live_51QT6NuFCZA829IV4efUVvxXyEBw6Ugx0UpnsA72trVbiHwOT5LS3V9ukp5jgk9GawAXbE1ZHIUHc4cl1cvfk0qF300qEAmMSKT';
  // Stripe.merchantIdentifier = 'Yump';

  // await Stripe.instance.applySettings();

  // await FirebaseAuth.instance.signOut();
  // await clearAppData();
  // print("Here is the user id: ${Preferences.getInt(Preferences.userId)}");
  // await requestTrackingPermission();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // final _networkStatusService = NetworkStatusService();




  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getCurrentAppTheme();
    NotificationService.setupInteractedMessage(context);
    Future.delayed(const Duration(seconds: 3), () {
      if (Preferences.getString(Preferences.languageCodeKey)
          .toString()
          .isNotEmpty) {
        LocalizationService().changeLocale(
            Preferences.getString(Preferences.languageCodeKey).toString());
      }
      API.header['accesstoken'] =
          Preferences.getString(Preferences.accesstoken);
    });
    super.initState();
    // 👇 Start listening to connectivity
   /* WidgetsBinding.instance.addPostFrameCallback((_) {
      _networkStatusService.listenToInternetChanges(context);
    });*/
  }

  @override
  void dispose() {
    // 👇 Dispose listener when app shuts down
    // _networkStatusService.dispose();
    super.dispose();
  }
  ThemeProvider themeChangeProvider = ThemeProvider();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    // themeChangeProvider.darkTheme = await themeChangeProvider.getTheme();
    // // themeChangeProvider.darkTheme =
    //     await themeChangeProvider.darkThemePreference.getTheme();
  }

  Future<void> setupInteractedMessage(BuildContext context) async {
    initialize(context);
    await FirebaseMessaging.instance.subscribeToTopic("yumprides_driver");

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {}

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        display(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.notification != null) {
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
        } else if (message.data['statut'] == "new" &&
            message.data['statut'] == "rejected") {
          await Get.to(DashBoard());
        } else if (message.data['type'] == "payment received") {
          DashBoardController dashBoardController =
              Get.put(DashBoardController());
          dashBoardController.selectedDrawerIndex.value = 4;
          await Get.to(DashBoard());
        }
      }
    });
  }

  Future<void> initialize(BuildContext context) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: iosInitializationSettings);
    await FlutterLocalNotificationsPlugin().initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) async {});

    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void display(RemoteMessage message) async {
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
    } on Exception {}
  }

  // GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
/*  @override
  Widget build(BuildContext context) {
    // print(
    //     "Here is the user id: ${FirebaseAuth.instance.currentUser?.uid ?? ""}");
    return ChangeNotifierProvider(create: (_) {
      return themeChangeProvider;
    }, child: Consumer<DarkThemeProvider>(builder: (context, value, child) {
      return GetMaterialApp(
        title: 'Yump Rides Driver'.tr,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: ThemeData.light(),
        locale: LocalizationService.locale,
        fallbackLocale: LocalizationService.locale,
        translations: LocalizationService(),
        builder: EasyLoading.init(),
        navigatorKey: callNavigatorKey,
        home: GetBuilder(
          init: SettingsController(),
          builder: (controller) {
            return Preferences.getString(Preferences.languageCodeKey)
                    .toString()
                    .isEmpty
                ? const LocalizationScreens(intentType: "main")
                : Preferences.getBoolean(Preferences.isFinishOnBoardingKey)
                    ? Preferences.getBoolean(Preferences.isLogin)
                        ? DashBoard()
                        : LoginScreen()
                    // MobileNumberScreen(
                    //     isLogin: true,
                    //   )
                    : const OnBoardingScreen();
          },
        ),
      );

      // GetMaterialApp(
      //   title: 'Yump Rides Driver'.tr,
      //   debugShowCheckedModeBanner: false,

      //   //         theme: lightTheme, // Define your light theme here
      //   // darkTheme: darkTheme, // Define your dark theme here
      //   // theme: ThemeData(
      //   //   fontFamily: 'roboto', // Set the app-wide font to Roboto
      //   // ), // Define your light theme here
      //   // Remove the dark theme or ignore it
      //   themeMode: ThemeMode.light, // Force the app to use light them
      //   theme: Styles.themeData(
      //       // themeChangeProvider.darkTheme == 0
      //       //     ? true
      //       //     : themeChangeProvider.darkTheme == 1
      //       //         ? false
      //       //         : themeChangeProvider.getSystemThem(),
      //       false,
      //       context),
      //   // themeMode: ThemeMode.light,
      //   locale: LocalizationService.locale,
      //   fallbackLocale: LocalizationService.locale,
      //   translations: LocalizationService(),
      //   builder: EasyLoading.init(),
      //   home: GetBuilder(
      //       init: SettingsController(),
      //       builder: (controller) {
      //         return Preferences.getString(Preferences.languageCodeKey)
      //                 .toString()
      //                 .isEmpty
      //             ? const LocalizationScreens(intentType: "main")
      //             : Preferences.getBoolean(Preferences.isFinishOnBoardingKey)
      //                 ? Preferences.getBoolean(Preferences.isLogin)
      //                     ? DashBoard()
      //                     : const LoginScreen()
      //                 : const OnBoardingScreen();
      //       }),
      // );
    }));
  }*/

// by numan ch
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (_) {
        final themeProvider = ThemeProvider();
        themeProvider.loadTheme(); // Load saved theme preference
        // themeProvider.darkTheme = 1; // Set to Light Theme

        return themeProvider;
      },
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return GetMaterialApp(
          navigatorKey: navigatorKey,
          title: 'Yump Rides Driver'.tr,
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.darkTheme == 2
              ? ThemeMode.system
              : themeProvider.darkTheme == 0
                  ? ThemeMode.dark
                  : ThemeMode.light,
          theme: MdAppTheme.lightTheme,
          darkTheme: MdAppTheme.darkTheme,
          locale: LocalizationService.locale,
          fallbackLocale: LocalizationService.locale,
          translations: LocalizationService(),
          builder: EasyLoading.init(),
          // navigatorKey: callNavigatorKey,

          home: GetBuilder(
            init: SettingsController(),
            builder: (controller) {
              return Preferences.getString(Preferences.languageCodeKey)
                      .toString()
                      .isEmpty
                  ? const LocalizationScreens(intentType: "main")
                  : Preferences.getBoolean(Preferences.isFinishOnBoardingKey)
                      ? Preferences.getBoolean(Preferences.isLogin)
                          ? DashBoard()
                          : LoginScreen()
                      : const OnBoardingScreen();
            },
          ),
        );
      }),
    );
  }
}

Future<void> clearAppData() async {
  // Clear Shared Preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  // Clear Cache
  final directory = await getTemporaryDirectory();
  await directory.delete(recursive: true);

  // Clear Application Storage
  final appDirectory = await getApplicationDocumentsDirectory();
  await appDirectory.delete(recursive: true);

  print('Cache and storage cleared successfully.');
}
// team id: 859DC4BPTW
// apn key id: K642C69S95
