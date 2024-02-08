import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:live_streaming/src/utils/constants/m_helper.dart';


class NotificationController {

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod( ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
    var valueMap = receivedAction.payload;
    debugPrint("notification data on Foreground -> $valueMap");

  }
}

class LocalNotification {
  static final client = FlutterLocalNotificationsPlugin();
  FlutterLocalNotificationsPlugin getLocalPlugin() => client;
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message");
  debugPrint("${message.data}");
  var valueMap = message.data;
  debugPrint("notification message -> $message/$valueMap");
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound('notification'),
    description: "Channel important"
);

void handleNotification() async {
  await LocalNotification().getLocalPlugin().resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    String bigPic = "";
    BigPictureStyleInformation bigPictureStyleInformation;
    AndroidNotificationDetails androidNotificationDetails;
    IOSNotificationDetails iosNotificationDetails;

    var imageUrl = android?.imageUrl;
    if (imageUrl != null && imageUrl.toString().length > 6) {
      bigPic = await downloadAndSaveFile(imageUrl.toString(), 'big_pic');
      bigPictureStyleInformation = BigPictureStyleInformation(FilePathAndroidBitmap(bigPic), largeIcon: FilePathAndroidBitmap(bigPic));
      androidNotificationDetails = AndroidNotificationDetails(
        channel.id, channel.name,
        channelDescription: channel.description,
        icon: '@mipmap/ic_launcher',
        styleInformation: bigPictureStyleInformation,
        sound: const RawResourceAndroidNotificationSound('notification'),
        priority: Priority.high,
        importance: Importance.max,
      );
    } else {
      androidNotificationDetails = AndroidNotificationDetails(
        channel.id, channel.name,
        channelDescription: channel.description,
        icon: '@mipmap/ic_launcher',
        sound: const RawResourceAndroidNotificationSound('notification'),
        priority: Priority.high,
        importance: Importance.max,
      );
    }

    iosNotificationDetails = const IOSNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);

    var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    LocalNotification().getLocalPlugin().initialize(initializationSettings, onSelectNotification: (st) {
      debugPrint("data ---------------------> $st");
      Map valueMap = jsonDecode(st ?? "");
      debugPrint("value Map -> $valueMap");
    });

    AwesomeNotifications().initialize(null, [
          NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'call_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            importance: NotificationImportance.Max,
          ),
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(channelGroupKey: 'basic_channel_group', channelGroupName: 'Basic group')
        ], debug: true);

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
      Map<String, String> stringQueryParameters =
      message.data.map((key, value) => MapEntry(key, value!.toString()));
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: notification.hashCode,
              channelKey: 'call_channel',
              title: notification.title,
              body: notification.body,
              payload: stringQueryParameters,
              criticalAlert: true,
              notificationLayout: NotificationLayout.Default,
              displayOnBackground: true,
              roundedBigPicture: true,
              roundedLargeIcon: true,
              displayOnForeground: true),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    debugPrint(" ${message.data["data"]}----------------------onMessageOpenedApp ------------------: \n${message.data.toString()}");
  }).onData((data) {
    var valueMap = data.data;
    debugPrint("notification data -> $valueMap");
  });

  FirebaseMessaging.instance.getInitialMessage().then((value) => value != null ? firebaseMessagingBackgroundHandler : false);
}
