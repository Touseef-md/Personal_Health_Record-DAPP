import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phr/modals/doctor.dart';
import 'package:phr/providers/health_record_provider.dart';
import 'package:phr/widgets/patient_drawer.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AppointmentsScreen extends ConsumerStatefulWidget {
  static const routeName = 'appointment';

  AppointmentsScreen({super.key});

  @override
  ConsumerState<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends ConsumerState<AppointmentsScreen> {
  var dummyDoctor;
  var dropDownValue;
  List addedDoctor = [];
  @override
  void initState() {
    // TODO: implement initState
    print('INIT called');

    super.initState();
  }
  // List addedDoctor = ['Dr. Touseef', 'Dr. Ashafq', 'Select'];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      initialDatePickerMode: DatePickerMode.day,
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1990, 1, 1, 0, 0, 0, 0, 0),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
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
        body: json.encode({
          'priority': 'high',
          'data': dataPayload,
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
            'android_channel_id': '2'
          },
          'to': token
        }),

        // jsonEncode(
        // <String, dynamic>{
        //   'priority': 'high',
        //   'data': dataPayload,
        //   'notification': <String, dynamic>{
        //     'title': title,
        //     'body': body,
        //     'android_channel_id': '2'
        //   },
        //   'to': token
        // },
        // ),
      );
      print('Response is ${response}');
    } catch (err) {
      print(err);
    }
  }

  void _book() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc((dropDownValue as Doctor).address.toLowerCase())
        .get();
    String token = (snap.data() as Map)['token'];
    print('Token is ${token}');
    final dataPayload = {
      'click_action': 'FLUTTER_NOTIFICATIOIN_CLICK',
      'status': 'done',
      'body': 'This is the data body',
      'title': 'This is the data title',
      'address': dotenv.env['ACCOUNT_ADDRESS'],
      'request_no': 2,
      'date': selectedDate.toIso8601String(),
      'hour': selectedTime.hour,
      'minute': selectedTime.minute,
      // {
      //   'hour': selectedTime.hour,
      //   'minute': selectedTime.minute,
      // }.toString(),
    };
    final userName =
        ref.read(healthRecordNotifierProvider.notifier).healthRecord.name;
    // var jsonData = json.encode(dataPayload);
    // var jsonDecode = json.decode(jsonData);
    // print('This is the decoded json${jsonDecode}');
    pushMessage(token, '${userName} wants to book a appointment',
        'New Appointment', dataPayload);
  }

  @override
  Widget build(BuildContext context) {
    addedDoctor = [];
    addedDoctor = [
      ...ref.read(healthRecordNotifierProvider.notifier).healthRecord.doctors
    ];
    print('THese are the doctors ${addedDoctor}');
    dummyDoctor = Doctor(
        name: 'Select', email: '', imageUrl: '', address: '', publicKey: '');
    dropDownValue = dummyDoctor;
    addedDoctor.add(dummyDoctor);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appointment',
        ),
      ),
      drawer: PatientDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      value: dummyDoctor,
                      decoration: InputDecoration(
                        label: Text(
                          'Choose Doctor',
                        ),
                      ),
                      items: addedDoctor
                          .map(
                            (doctor) => DropdownMenuItem(
                              value: doctor,
                              child: Text(doctor.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        dropDownValue = value as Doctor;
                      },
                      validator: (value) {
                        if (value == null || value == 'Select') {
                          return 'Choose a valid doctor';
                        }
                        return null;
                      },
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    DateFormat.yMd().format(selectedDate),
                  ),
                  TextButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Text(
                      'Choose Date',
                    ),
                  ),
                  Text(selectedTime.format(context)),
                  TextButton(
                    onPressed: () {
                      _selectTime(context);
                    },
                    child: Text(
                      'Choose Time',
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _book();
                },
                child: Text(
                  'Book',
                ),
              ),
              Text(
                'Previous Appointments',
              ),
              // ref.watch(healthRecordNotifierProvider.notifier).healthRecord.appointments.
              // final _appointments=ref.read()
              ref.watch(healthRecordNotifierProvider).when(
                data: (data) {
                  final _appointments = ref
                      .read(healthRecordNotifierProvider.notifier)
                      .healthRecord
                      .appointments;
                  return Container(
                    alignment: Alignment.centerLeft,
                    height: double.minPositive,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Card(
                          child: Text(_appointments[index].toString()),
                        );
                      },
                      itemCount: _appointments.length,
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return Text(' There is an error:${error}');
                },
                loading: () {
                  return CircularProgressIndicator();
                },
              ),
              // ListView.builder(
              //   itemBuilder: (context, index) {},
              //   itemCount: ref
              //       .read(healthRecordNotifierProvider.notifier)
              //       .healthRecord
              //       .appointments
              //       .length,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
