import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:phr/modals/healtrecord.dart';
import 'package:phr/providers/doctor_provider.dart';
import 'package:phr/widgets/patient_drawer.dart';

class SubmitPrescriptionScreen extends ConsumerStatefulWidget {
  static const routeName = '/submit_prescription';

  SubmitPrescriptionScreen({super.key});

  @override
  ConsumerState<SubmitPrescriptionScreen> createState() =>
      _SubmitPrescriptionScreenState();
}

class _SubmitPrescriptionScreenState
    extends ConsumerState<SubmitPrescriptionScreen> {
  // @override
  // initState(){
  //   super:initState();
  // }

  String prescription = '';

  Future _submit(String patientAddress) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc(patientAddress.toLowerCase())
        .get();
    print('Patient address is :${patientAddress}');
    // print('THis is the snap:${snap.data()}');
    String token = snap['token'];
    var payload = {
      'click_action': 'FLUTTER_NOTIFICATIOIN_CLICK',
      'status': 'done',
      'body': 'This is the data body',
      'title': 'This is the data title',
      // 'address': dotenv.env['ACCOUNT_ADDRESS'],
      'request_no': 5,
      // 'patient_addr': dotenv.env['ACCOUNT_ADDRESS'],
      'patient_address': patientAddress,
      'added_prescription': json.encode(prescription),
      // 'request_approved': true,
    };
    var docName = ref.read(doctorNotifierProvider).value!.name;
    pushMessage(token, 'Prescription added by Dr.${docName}',
        'Prescription Added', payload);
  }

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

  @override
  Widget build(BuildContext context) {
    final HealthRecord healthRecod =
        ModalRoute.of(context)!.settings.arguments as HealthRecord;
    return Scaffold(
      appBar: AppBar(title: Text('Prescription')),
      drawer: PatientDrawer(),
      body: Column(
        children: [
          Text(healthRecod.name),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter the prescription',
            ),
            onChanged: (value) {
              setState(() {
                prescription = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: (prescription.isEmpty || prescription == '')
                ? null
                : () async {
                    await _submit(healthRecod.address);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Prescription submitted to the patient',
                        ),
                      ),
                    );
                    setState(() {
                      prescription = '';
                    });
                  },
            child: Text('Submit Prescription'),
          )
        ],
      ),
    );
  }
}
