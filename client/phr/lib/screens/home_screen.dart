import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phr/providers/health_record_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phr/screens/update_health_record_screen.dart';
import 'package:phr/widgets/patient_drawer.dart';
import 'dart:io';
import './approve_doctor_screen.dart';
import 'dart:convert';

class HomeScreen extends ConsumerStatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? mtoken;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
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
      // print('My taken is ${mtoken}');
      saveToken();
    });
  }

  void saveToken() async {
    var documentId = ref
        .read(healthRecordNotifierProvider.notifier)
        .patientAddress
        .toLowerCase();
    // print('Save token id ${documentId}');
    // print('${dotenv.env['ACCOUNT_ADDRESS']}');
    await FirebaseFirestore.instance
        .collection('UserTokens')
        .doc('${documentId}')
        .set({'token': mtoken});
  }

  // void updateAppointment() {}
  Future updatePrescription(Map data) async {
    final directory = await getExternalStorageDirectories();
    var address = data['patient_address'];
    final writeFile =
        await File('${directory![0].path}/updatePrescription/${address}.txt')
            .create(
      exclusive: false,
      recursive: true,
    );
    var encodedJson = json.encode(data);
    final written = await writeFile.writeAsString(encodedJson);
  }

  Future storeNewDoctor(Map data) async {
    // print('Store new doctor function');
    final directory = await getExternalStorageDirectories();
    print(directory);
    var address = data['address'];
    // print('THis is the address${address}');
    // if(directory![0].)
    final writeFile =
        await File('${directory![0].path}/approve/${address}.txt').create(
      exclusive: false,
      recursive: true,
    );
    // File(
    // '${directory![0].path}/phr/NewDoctorData/file${data['address']}.txt');
    // print('THis is the built file ${writeFile}');
    // print('Thi is the data ${data}');
    var encodedJson = json.encode(data);
    // print('encdoed is ${en}');
    // print('Decoded is ${json.decode(en)}');
    // print('utf encode ${utf8.encode(en)}');
    // print('urf-8 decode ${utf8.decode(utf8.encode(en))}');
    final writtenFile = await writeFile.writeAsString(encodedJson);
    // print('Written file is : ${writtenFile}');
    final readFile = await writtenFile.readAsString();
    // print(json.decode(readFile).runtimeType);
    // print('This is the read file: ${readFile}');
  }

  void initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialize = const DarwinInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);
    // FlutterLocalNotificationsPlugin.
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        try {
          // print('INside the details');
          if (details != null) {
            print('These are the detailsss ${details.payload}');
            var decodedPayload = json.decode(details.payload as String);
            if (decodedPayload['request_no'] == '3') {
              print('Decoded request is 3');
              // updateAppointment();
            }
            // print(json.decode(details.payload as String));
            // print(
            //     'THis is the details receivedddd ${details.id},${details.input},${details.notificationResponseType},${details.payload}');
            // Navigator.pushNamed(
            //   context,
            //   ApproveDoctorScreen.routeName,
            // );
          } else {
            print('Details are null');
          }
        } catch (err) {
          print('Error is ${err}');
        }
        return;
      },
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('.......................on Message.................');
      print('THis is the message:${message.data}');
      print('THis is the message type${message.runtimeType}');
      print(
          'onMessage: ${message.notification?.title}/${message.notification?.body}');
      // print('THis is teh message data ${message.data['request_no'].runtimeType}');
      if (message.data['request_no'] == '1') {
        await storeNewDoctor(message.data);
      } else if (message.data['request_no'] == '3') {
        // print(message.data['request_approved']);
        if (message.data['request_approved'] == 'true') {
          // message.data
          ref
              .read(healthRecordNotifierProvider.notifier)
              .recordAppointment(message.data);
        } else {}
        print('YEah the message data is 3');
      } else if (message.data['request_no'] == '5') {
        await updatePrescription(message.data);
      }
      print('LIne after store function');
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        '2',
        '2',
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
          payload: json.encode(message.data));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // floatingActionButton: ButtonWidget(
        //   text: 'H',
        //   onPress: () {},
        // ),
        appBar: AppBar(
          title: Text(
            'PHR',
          ),
          // backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        drawer: PatientDrawer(),
        // backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  // surfaceTintColor: Colors.deepPurpleAccent,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      35,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(
                    // horizontal: 15,
                    vertical: 15,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/images/LoginImage.jpg',
                          ),
                          radius: 40,
                        ),
                        Column(
                          children: [
                            Text(
                              'Mohd Touseef',
                              style: Theme.of(context).textTheme.headline3,
                              // maxLines: 5,
                              // softWrap: true,
                              // overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Age: 22',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            Text(
                              'Weight: 62',
                            ),
                            Text(
                              'Height: 5.9ft',
                            ),
                          ],
                        )
                        // Image.asset(
                        //   'assets/images/LoginImage.jpg',
                        //   height: 500,
                        //   width: 200,
                        //   fit: BoxFit.cover,
                        // ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                          shape: Theme.of(context).cardTheme.shape,
                          margin: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 5,
                          ),
                          elevation: 1,
                          surfaceTintColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 18,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Blood Group',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                      ),
                                ),
                                Icon(
                                  Icons.bloodtype,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                Text(
                                  'A+',
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                )
                              ],
                            ),
                          )),
                    ),
                    Expanded(
                      child: Card(
                        surfaceTintColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 18,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Weight',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                    ),
                              ),
                              Icon(
                                Icons.monitor_weight,
                                color: Colors.white,
                                size: 40,
                              ),
                              Text(
                                '80 Kg',
                                style: Theme.of(context).textTheme.displaySmall,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'My Health',
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  // textAlign: TextAlign.left,
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(healthRecordNotifierProvider.notifier)
                            .retriveRecord(dotenv.env['ACCOUNT_ADDRESS']!);
                      },
                      child: Text('Retrive Data'),
                    );
                  },
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(healthRecordNotifierProvider.notifier)
                            .getDoctorsForPatient();
                      },
                      child: Text(
                        'GEt Doctors',
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }
}
