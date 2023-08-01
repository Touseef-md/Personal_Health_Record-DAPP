import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:phr/providers/doctor_provider.dart';
// import 'package:phr/providers/eth_utils_provider.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phr/providers/rsa_provider.dart';
import 'package:phr/screens/approve_doctor_screen.dart';
import 'package:phr/widgets/patient_drawer.dart';
// import '../modals/doctor.dart';

class DoctorHomeScreen extends ConsumerStatefulWidget {
  static const routeName = '/doctor';
  const DoctorHomeScreen({super.key});

  @override
  ConsumerState<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends ConsumerState<DoctorHomeScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? mtoken = "";
  String? patientAddress = '';
  late var documentId;
  final _form = GlobalKey<FormState>();
  bool imageLoadError = false;
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
    documentId = ref.read(doctorNotifierProvider).value?.address;
    // print('Save token id ${documentId}');
    // print('${dotenv.env['ACCOUNT_ADDRESS']}');
    await FirebaseFirestore.instance
        .collection('UserTokens')
        .doc('${documentId}')
        .set({'token': mtoken});
  }

  Future storeNewDoctor(Map data) async {
    print('Store new doctor function');
    final directory = await getExternalStorageDirectories();
    print(directory);
    var address = data['address'];
    print('THis is the address${address}');
    final writeFile = File('${directory![0].path}/${address}.txt');
    // File(
    // '${directory![0].path}/phr/NewDoctorData/file${data['address']}.txt');
    // print('THis is the built file ${writeFile}');
    final writtenFile = await writeFile.writeAsString(data.toString());
    print('Written file is : ${writtenFile}');
    final readFile = await writtenFile.readAsString();
    print('This is the read file: ${readFile}');
  }

  Future storeApproveAppointment(Map data) async {
    final directory = await getExternalStorageDirectories();
    var address = data['address'];
    final writeFile = await File(
            '${directory![0].path}/approveAppointment/${address}/${data['date']}.txt')
        .create(
      exclusive: false,
      recursive: true,
    );
    var encodedData = json.encode(data);
    final writtenFile = await writeFile.writeAsString(encodedData);
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
          print('INside the details');
          if (details != null) {
            // print()
            // print('These are the detailssssss${details.payload.runtimeType}');
            var decodedPayload = json.decode(details.payload as String);
            print('details as json${decodedPayload}');
            print(decodedPayload['request_no']);
            print(decodedPayload['request_no'].runtimeType);
            if (decodedPayload['request_no'] == '2') {
              print('Request 2 is present');
              storeApproveAppointment(decodedPayload);
            }
            // print(
            //     'THis is the details received ${details.id},${details.input},${details.notificationResponseType},${details.payload}');
            // Navigator.pushNamed(
            //   context,
            //   ApproveDoctorScreen.routeName,
            //   arguments: details.payload,
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
    Future storePHR(Map data) async {
      final directory = await getExternalStorageDirectories();
      // decoded
      var patientAddr = data['patient_address'];
      // print('This is the patient addr:${patientAddress}');
      final writeFile =
          await File('${directory![0].path}/phrs/${patientAddress}.txt').create(
        exclusive: false,
        recursive: true,
      );
      // print('Made the written object');
      final writtenFile = await writeFile.writeAsString(data['phr']);
      // final readFile = await writtenFile.readAsString();
      // // print('Before decodding :${readFile}');
      // // List decodedPhr = json.decode(readFile);
      // List<int> decodedPhr = [];
      // // print('Original length:${decodedPhr.length}');
      // // print('INt list length:${(decodedPhr.whereType<int>().toList()).length}');
      // var temp = json.decode(readFile);
      // for (int i = 0; i < temp.length; i++) {
      //   //   if(decodedPhr[i].runtimeType==int)
      //   decodedPhr.add(temp[i]);
      // }
      // print((json.decode(readFile))[0].runtimeType);
      // // print('Json decoded phr is :${decodedPhr}');
      // // print('Decoded phr is :${utf8.decode(decodedPhr)}');
      // var cipher = utf8.decode(decodedPhr);
      // String phr =
      //     ref.read(rsaKeyNotifierProvider.notifier).decryptWithRSA(cipher);
      // print('THis is the phr sent:${phr}');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('.......................on Message.................');
      print('THis is the message:${message.data}');
      print(
          'onMessage: ${message.notification?.title}/${message.notification?.body}');
      // await storeNewDoctor(message.data);
      // print('LIne after store function');
      if (message.data['request_no'] == '4') {
        print('THis is the phr received to the doctor');
        print(message.data['phr']);
        print(message.data['phr'].runtimeType);
        await storePHR(message.data);
        await ref.read(doctorNotifierProvider.notifier).getPHRs();
      }
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

  void pushMessage(
      String token, String body, String title, Map dataPayload) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAr6_IiXQ:APA91bEhqkKelWHfS-3uJfHK85tYnKlN-eMbujt0TiSfi2moYNOwoKOOM_h1OlS22_xftYVIktWcwYTaEBX68YKcXsLTEHTYQdOeUhJJO0sA-aJ2Vt3jsJWfjfdSenUBdPr5IMz80c6P'
        },
        body: json.encode(
          <String, dynamic>{
            'priority': 'high',
            'data': dataPayload,
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
              'android_channel_id': '2'
            },
            'to': token
          },
        ),
      );
    } catch (err) {
      print(err);
    }
  }

  void _onSubmit() async {
    final isValid = _form.currentState == null;
    if (isValid || !_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();
    // print(patientAddress);
    // print('Cross check ${documentId == patientAddress!.toLowerCase()}');
    // print(
    // 'TRUe or false   ${patientAddress!.toLowerCase() == ref.read(doctorNotifierProvider).value!.address}');
    // await FirebaseFirestore.instance
    //     .collection('UserTokens')
    //     .doc('User1')
    //     .set({'token': mtoken});
    final test = patientAddress!.toLowerCase().toString();
    // print('THis is the pateint address ${patientAddress!.toLowerCase()}');
    // final testSnap = await FirebaseFirestore.instance
    // .collection("UserTokens")
    // .doc("User1")
    // .get();
    // print(
    // 'THis is the test Snap${testSnap.exists},${testSnap.id},${testSnap.data()}');
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc(test)
        .get();
    print('Testing firestone');
    String token = (snap.data() as Map)['token'];
    print('TOken is ${token}');
    // final doctor = ref.read(doctorNotifierProvider).value!.address;
    final doctor = ref.read(doctorNotifierProvider).value!;
    final dataPayload = {
      'click_action': 'FLUTTER_NOTIFICATIOIN_CLICK',
      'status': 'done',
      'body': 'This is the data body',
      'title': 'This is the data title',
      'request_no': 1,
      'name': doctor.name,
      'email': doctor.email,
      'address': doctor.address
    };
    pushMessage(token, 'New doctor wants to access your PHR', 'A New Doctor',
        dataPayload);
  }

  @override
  Widget build(BuildContext context) {
    final doctor = ref.watch(doctorNotifierProvider);
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // extendBody: true,
      appBar: AppBar(
        title: Text('Dashboard'),
        // backgroundColor: Colors.transparent,
        // foregroundColor: Colors.white,
      ),
      drawer: PatientDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello,',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        '${doctor.value?.name} 👋',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    foregroundImage: imageLoadError
                        ? AssetImage(
                            'assets/images/LoginImage.jpg',
                          ) as ImageProvider<Object>?
                        : NetworkImage(
                            doctor.value!.imageUrl,
                            scale: 5,
                          ),
                    onForegroundImageError: (exception, stackTrace) {
                      print('Error while loading');
                      imageLoadError = true;
                    },
                    backgroundColor: Colors.grey,
                    minRadius: 10,
                    maxRadius: 35,
                  )
                ],
              ),
              Container(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      25,
                    ),
                  ),
                  // elevation: 5,
                  color: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add new Patient',
                          style:
                              Theme.of(context).textTheme.headlineSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Form(
                          key: _form,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  constraints: BoxConstraints.loose(
                                    Size(
                                      double.infinity,
                                      45,
                                    ),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  // label: Text(
                                  //   'Enter patient Address ->',
                                  // ),
                                  labelText: 'Enter',
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Enter a valid account address';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  setState(() {
                                    patientAddress = newValue;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _onSubmit();
                                },
                                child: Text(
                                  'Add Patient',
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                    label: Text(
                      'Search Patient using Address',
                    ),
                    constraints: BoxConstraints.loose(
                      Size(
                        double.infinity,
                        50,
                      ),
                    )
                    // border: OutlineInputBorder(),
                    ),
                onFieldSubmitted: (value) {},
              ),
              // ListView.builder(itemBuilder: (context, index) {
        
              // },itemCount: ,)
              Text('THis is '),
              // ref.watch(ethUtilsNotifierProvider);
            ],
          ),
        ),
      ),
    );
  }
}
