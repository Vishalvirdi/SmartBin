import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smartbin/view/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // await AwesomeNotifications().initialize(null, [
  //   NotificationChannel(
  //       channelGroupKey: "smart_groupkey",
  //       channelKey: "smartbin",
  //       channelName: "Alert",
  //       channelDescription: "Dustbin filled alert")
  // ], channelGroups: [
  //   NotificationChannelGroup(
  //       channelGroupkey: "smart_groupkey", channelGroupName: "group_name")
  // ]);

  AwesomeNotifications().initialize(
    // set the icon to be used in the notification bar
    null,
    // set the color of the app icon in the notification bar
    [
      NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          defaultColor: Colors.blue,
          importance: NotificationImportance.High,
          channelDescription: "Basic notifications"),
    ],
  );

  bool isAllowedToSendNotifications =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotifications) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const SplashScreen());
  }
}
