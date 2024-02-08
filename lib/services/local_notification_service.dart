// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class LocalNotificationService{
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   static void initialize(){
//     const InitializationSettings initializationSettingsAndroid =  InitializationSettings(android: AndroidInitializationSettings("@drawable/ic_launcher"));
//     _notificationsPlugin.initialize(initializationSettingsAndroid, onDidReceiveBackgroundNotificationResponse: (details){
//       if(details.input  != null){}
//     });
//   }
//
//   static Future<void> display(var arguments)async{
//     if(arguments.isNotEmpty){
//       Map<String, dynamic> data = arguments[0];
//
//       try{
//         final id = DateTime.now().microsecondsSinceEpoch ~/ 1000;
//         NotificationDetails notificationDetails = NotificationDetails(
//           android: AndroidNotificationDetails(
//             "Channel Id",
//             "Main Channel",
//             groupKey: "gfg",
//             color: Colors.pinkAccent,
//             importance: Importance.max,
//             playSound: true,
//             priority: Priority.high)
//         );
//
//         await _notificationsPlugin.show(id, data['receiver_id'], data['message'], notificationDetails);
//       }catch(e){
//         debugPrint(e.toString());
//       }
//     }
//   }
// }