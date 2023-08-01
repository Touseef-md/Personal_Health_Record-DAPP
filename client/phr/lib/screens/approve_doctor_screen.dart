import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../modals/doctor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phr/providers/doctor_approve_requests_provider.dart';
import 'package:phr/providers/eth_utils_provider.dart';
import 'package:phr/providers/health_record_provider.dart';
import 'package:phr/providers/rsa_provider.dart';
import 'package:phr/widgets/patient_drawer.dart';

class ApproveDoctorScreen extends ConsumerStatefulWidget {
  static const routeName = '/approve_doctor';
  ApproveDoctorScreen({super.key});

  @override
  ConsumerState<ApproveDoctorScreen> createState() =>
      _ApproveDoctorScreenState();
}

class _ApproveDoctorScreenState extends ConsumerState<ApproveDoctorScreen> {
  List requests = [];
  @override
  void initState() {
    super.initState();
    getRequest();
    // return;
    // ref.read(provider)
  }

  Future getRequest() async {
    print('GEt request called for approve doctor screen...');
    setState(() {
      requests = [];
    });
    final result = (await ref
        .read(doctorApproveNotifierProvider.notifier)
        .getRequests()) as List<Future<dynamic>>;
    // setState(() {
    //   requests = result;
    // });
    // requests.forEach(
    //   (element) {
    //     element.
    //   },
    // );
    // print('Req3us type is :${requests}');
    // (requests[0] as Future<dynamic>);
    for (var i = 0; i < result.length; i++) {
      result[i].then((value) {
        setState(() {
          requests.add(value);
        });
      });
    }
  }

  // requests =
  Future pushMessage(
      String token, String body, String title, Map dataPayload) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAr6_IiXQ:APA91bEhqkKelWHfS-3uJfHK85tYnKlN-eMbujt0TiSfi2moYNOwoKOOM_h1OlS22_xftYVIktWcwYTaEBX68YKcXsLTEHTYQdOeUhJJO0sA-aJ2Vt3jsJWfjfdSenUBdPr5IMz80c6P'
        },
        body: json.encode(
          {
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
      print('Response is ${response}');
    } catch (err) {
      print(err);
    }
  }

  Doctor findDoctor(String address) {
    var doctorList =
        ref.read(healthRecordNotifierProvider.notifier).healthRecord.doctors;
    return doctorList.firstWhere((element) => element.address == address);

    // .takeWhile((value) => value.address == address)
    // .toList()[0];
    // return doctorList.singleWhere((element) => element.address == address);
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments;

    // print('THese are the args: ${args}');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Approve Requests',
        ),
      ),
      drawer: PatientDrawer(),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) {
            // final buildresult = (requests[index] as Future<dynamic>)
            //     .then((value) => Text(value));
            // print('THis is the build result${buildresult}');
            return Card(
              child: Column(
                children: [
                  Text(requests[index].toString()),
                  ElevatedButton(
                    onPressed: () {
                      // requests[index]
                      print(requests[index].toString());
                      // print(
                      // 'Address from the approve screen${requests[index]['address']}');
                      // var encode = jsonEncode(requests[index]);
                      // print('Encdoed is ${encode}');
                      // print(jsonDecode(encode));
                      // print('DEcoded is ${jsonDecode(encode).runtimeType}');
                      // print('Decoded is ${jsonDecode(requests[index])}');
                      var currentDoc = requests[index];
                      ref
                          .read(ethUtilsNotifierProvider.notifier)
                          .approveDoctor(requests[index]['address'],
                              dotenv.env['ACCOUNT_ADDRESS']!)
                          .then((value) async {
                        print('Approve called...');
                        await ref
                            .read(doctorApproveNotifierProvider.notifier)
                            .removeRequest(requests[index]['address']);
                      }).then((value) async {
                        print('Remove request called...');
                        await getRequest();
                        await ref
                            .read(healthRecordNotifierProvider.notifier)
                            .getDoctorsForPatient();
                        print('Doctor address is :${currentDoc['address']}');
                        var addedDoctor = findDoctor(currentDoc['address']);
                        DocumentSnapshot snap = await FirebaseFirestore.instance
                            .collection("UserTokens")
                            .doc(currentDoc['address'] as String)
                            .get();
                        String token = snap['token'];
                        var phr = ref
                            .read(healthRecordNotifierProvider.notifier)
                            .healthRecord;
                        var jsonPhr = json.encode(phr);
                        var cipher = ref
                            .read(rsaKeyNotifierProvider.notifier)
                            .encryptWithRSAWithKey(
                                jsonPhr, addedDoctor.publicKey);
                        var cipherEncode = utf8.encode(cipher);
                        var dataPayload = {
                          'click_action': 'FLUTTER_NOTIFICATIOIN_CLICK',
                          'status': 'done',
                          'body': 'This is the data body',
                          'title': 'This is the data title',
                          // 'address': dotenv.env['ACCOUNT_ADDRESS'],
                          'request_no': 4,
                          'patient_addr': dotenv.env['ACCOUNT_ADDRESS'],
                          'phr': json.encode(cipherEncode),
                          // 'request_approved': true,
                        };
                        var userName = ref
                            .read(healthRecordNotifierProvider.notifier)
                            .healthRecord
                            .name;
                        pushMessage(token, 'PHR of ${userName} received ',
                            'PHR received', dataPayload);
                      });
                    },
                    child: Text(
                      'Approve',
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: requests.length,
          //  FutureBuilder(builder: (context, snapshot) {
          //     return;
          // },future: ),
        ),
      ),
    );
  }
}
