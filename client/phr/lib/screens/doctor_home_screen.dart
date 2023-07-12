// import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DoctorHomeScreen extends StatefulWidget {
  static const routeName = '/doctor';
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? mtoken = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
    getToken();
    initInfo();
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void getToken() async {
    var result = await FirebaseMessaging.instance.getToken();
    setState(() {
      mtoken = result;
      print('My taken is ${mtoken}');
      saveToken();
    });
  }

  void saveToken() async {
    await FirebaseFirestore.instance
        .collection('UserTokens')
        .doc('User1')
        .set({'token': mtoken});
  }

  void initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialize = const DarwinInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        try {
          if (details != null) {
          } else {}
        } catch (err) {}
        return;
      },
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('.......................on Message.................');
      print('THis is the message:${message.data}');
      print(
          'onMessage: ${message.notification?.title}/${message.notification?.body}');

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
      );
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails(),
      );

      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['title']);
    });

    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // extendBody: true,
      appBar: AppBar(
        title: Text('Dashboard'),
        // backgroundColor: Colors.transparent,
        // foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Text('Hello, \n '),
          Text('THis is ')
        ],
      ),
    );
  }
}
