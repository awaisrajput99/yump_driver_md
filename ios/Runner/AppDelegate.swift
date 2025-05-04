import UIKit
import Flutter
import Firebase
import GoogleMaps
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyC8JtIMqTQ8KByebN3hnijwXPZnt3wzrRs")

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    GeneratedPluginRegistrant.register(with: self)

    // Cold start notification handling
    if let launchOptions = launchOptions,
       let userInfo = launchOptions[.remoteNotification] as? [AnyHashable: Any] {
      DispatchQueue.main.async {
        NotificationCenter.default.post(
          name: Notification.Name("FLUTTER_NOTIFICATION_CLICK"),
          object: nil,
          userInfo: userInfo
        )
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ application: UIApplication,
                           didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  // Critical addition for iOS notification handling
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                      didReceive response: UNNotificationResponse,
                                      withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    // Forward to FlutterFire
    if FlutterAppDelegate.responds(to: #selector(FlutterAppDelegate.userNotificationCenter(_:didReceive:withCompletionHandler:))) {
      super.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
    }

    // Post to Flutter side
    NotificationCenter.default.post(
      name: Notification.Name("FLUTTER_NOTIFICATION_CLICK"),
      object: nil,
      userInfo: userInfo
    )

    completionHandler()
  }
}