import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:phr/widgets/patient_drawer.dart';

class ApproveAppointmentScreen extends StatefulWidget {
  const ApproveAppointmentScreen({super.key});
  static const routeName = '/approve-appointment';

  @override
  State<ApproveAppointmentScreen> createState() =>
      _ApproveAppointmentScreenState();
}

class _ApproveAppointmentScreenState extends State<ApproveAppointmentScreen> {
  bool _approve = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAppointments();
  }

  List appointments = [];

  Future getFile(String path) async {
    var file = File(path);
    var isValid = await file.exists();
    if (isValid) {
      // print('${await file.exists()}');
      // print('Exists in getFile function in approve_requests');
      var encodedJson = await file.readAsString();
      print('This isthe enocde whiel getting fiile${encodedJson}');
      print('Runtype of decoded file: ${json.decode(encodedJson).runtimeType}');
      return json.decode(encodedJson);
    }
    return null;
  }

  Future getAppointments() async {
    final lists = await getExternalStorageDirectories();
    // if()
    final directory =
        Directory(lists![0].path + '/approveAppointment').listSync(
      recursive: true,
    );
    print('This is teh direcotry:${directory}');
    List<Future<dynamic>> requests = [];
    if (directory.isNotEmpty) {
      print('These are the non zero directories ${directory}');
      requests = directory.map((item) async {
        var fileData = await getFile(item.path);
        print('THis is the file data: ${fileData}');
        return fileData;
        // return file;
      }).toList();
      appointments = [];
      for (int i = 0; i < requests.length; i++) {
        requests[i].then((value) {
          setState(() {
            appointments.add(value);
          });
        });
      }
    }
    print('THese are the requests:${requests}');
    // return requests;

    // final directory = await getExternalStorageDirectories();
    // var address = data['address'];
    // final readFile = await File(
    //     '${directory![0].path}/approveAppointment/${address}/${data['date']}.txt');
    // // var encodedData = json.encode(data);
    // // final writtenFile = await writeFile.writeAsString(encodedData);
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

  void approveOrReject(Map object) async {
    // print('OBject inside the approve func:${object['address'].runtimeType}');
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc((object['address'] as String).toLowerCase())
        .get();
    String token = (snap.data() as Map)['token'];
    var dataPayload;
    if (_approve) {
      dataPayload = {
        'click_action': 'FLUTTER_NOTIFICATIOIN_CLICK',
        'status': 'done',
        'body': 'This is the data body',
        'title': 'This is the data title',
        // 'address': dotenv.env['ACCOUNT_ADDRESS'],
        'request_no': 3,
        'request_approved': true,
        // 'date': selectedDate.toIso8601String(),
        // 'hour': selectedTime.hour,
        // 'minute': selectedTime.minute,
        // {
        //   'hour': selectedTime.hour,
        //   'minute': selectedTime.minute,
        // }.toString(),
      };
    } else {
      dataPayload = {
        'click_action': 'FLUTTER_NOTIFICATIOIN_CLICK',
        'status': 'done',
        'body': 'This is the data body',
        'title': 'This is the data title',
        // 'address': dotenv.env['ACCOUNT_ADDRESS'],
        'request_no': 3,
        'request_approved': false,
        // 'date': selectedDate.toIso8601String(),
        // 'hour': selectedTime.hour,
        // 'minute': selectedTime.minute,
        // {
        //   'hour': selectedTime.hour,
        //   'minute': selectedTime.minute,
        // }.toString(),
      };
    }
    pushMessage(token, 'Check the status of your appointment',
        'Requested appointment', dataPayload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Approve Appointment',
        ),
      ),
      drawer: PatientDrawer(),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Column(
              children: [
                Card(
                  child: Text((appointments[index]).toString()),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _approve = true;
                        approveOrReject(appointments[index]);
                      },
                      child: Text('Approve'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _approve = false;
                        approveOrReject(appointments[index]);
                      },
                      child: Text('Reject'),
                    )
                  ],
                )
              ],
            );
          },
          itemCount: appointments.length,
        ),
      ),
    );
  }
}
