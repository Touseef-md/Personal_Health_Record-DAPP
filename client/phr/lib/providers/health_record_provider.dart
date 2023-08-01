import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:phr/providers/doctor_approve_requests_provider.dart';
import 'package:phr/providers/doctor_provider.dart';
import 'package:phr/providers/eth_utils_provider.dart';
import 'package:phr/providers/rsa_provider.dart';
// import 'package:rsa_encrypt/rsa_encrypt.dart';
// import 'package:pointycastle/asymmetric/api.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './filecoin_provider.dart';

import '../modals/doctor.dart';
import '../modals/healtrecord.dart';

class HealthRecordProvider extends StateNotifier<AsyncValue<int>> {
  String _name = '', _blood = '', _address = '';
  double _height = 0, _weight = 0;
  int _age = 0;
  List<Map<String, dynamic>> _bloodPressure = [];
  String patientAddress = dotenv.env['ACCOUNT_ADDRESS']!;
  late HealthRecord healthRecord;
  late String cid;
  // var _keyPair;
  late final _publicKey;
  // ref.read(rsaKeyNotifierProvider.notifier).getPublicKey;
  late final _privateKey;
  // ref.read(rsaKeyNotifierProvider.notifier).getPrivateKey;
  int counter = 0;
  // String _publicK
  StateNotifierProviderRef<HealthRecordProvider, AsyncValue<int>> ref;
  HealthRecordProvider(this.ref) : super(AsyncValue.loading()) {}

  HealthRecord toRecord(Map data) {
    print(data['appointments']);
    print(data['appointments'].runtimeType);
    // print(json.decode(data['appointments'])[0]);
    // print(json.decode(data['appointments'])[0].runtimeType);
    HealthRecord newRecord = HealthRecord(
      address: data['address'],
      name: data['name'],
      bloodGroup: data['bloodGroup'],
      age: data['age'],
      weight: data['weight'],
      height: data['height'],
      bloodPressure: json.decode(data['bloodPressure']),
      // bloodPressure:
      // (json.decode(data['bloodPressure'])) as List<Map<String, dynamic>>,
      appointments: json.decode(data['appointments']),
      conditions: json.decode(data['conditions']),
      prescriptions: json.decode(data['prescriptions']),
    );
    // data.forEach(
    //   (key, value) {},
    // );
    // print(test.runtimeType);
    return newRecord;
  }

  Future getDoctorsForPatient() async {
    print('GetDoctorForPatient called...');
    state = AsyncValue.loading();
    List doctorsList = (await ref
        .read(ethUtilsNotifierProvider.notifier)
        .getDoctorForPatient(patientAddress)) as List;
    print('THis is the returned Doctors list${doctorsList}');
    healthRecord.doctors = [];
    for (int i = 0; i < doctorsList.length; i++) {
      // if (i == 0) {
      // healthRecord.doctors = [];
      // }
      // ref.read(doctorNotifierProvider.notifier).getfDoctor(doctorsList[i]);
      var result = await ref
          .read(ethUtilsNotifierProvider.notifier)
          .getDoctor((doctorsList[i]).toString());
      var doctor = Doctor(
        email: result[1],
        name: result[0],
        address: result[3].toString(),
        imageUrl: result[2],
        publicKey: result[5],
      );
      healthRecord.doctors.add(doctor);
    }
    state = AsyncValue.data(1);
    // print(
    //     'THis is teh doctor lsit in the health record provider: ${healthRecord.doctors[0]}');
  }

  Future retriveRecord(String patientAddr) async {
    state = AsyncValue.loading();
    await ref.read(rsaKeyNotifierProvider.notifier).readKeys(0);
    cid = await ref
        .read(ethUtilsNotifierProvider.notifier)
        .getPatient(patientAddr);
    //Getting doctors for the patient
    var message =
        await ref.read(filecoinNotifierProvider.notifier).retriveData(cid);
    // print('THis is the message: ${message}');
    if (message.isEmpty) return;
    var messageDecode = utf8.decode(message);
    // var message = cipher;
    // await getKeys();
    // var helper = RsaKeyHelper();
    var messageRetived =
        ref.read(rsaKeyNotifierProvider.notifier).decryptWithRSA(messageDecode);
    // _decryptWithRSA(messageDecode, helper.parsePrivateKeyFromPem(_privateKey));
    print('THIs is after decryption : ${messageRetived}');
    // print(jsonDecode(messageRetived));
    var test = jsonDecode(messageRetived);
    print('This is teh decoded retrieved record:${test}');
    healthRecord = toRecord(test);

    print('This is teh retrieved record : ${healthRecord}');
    print(healthRecord.appointments);
    getDoctorsForPatient();
    state = AsyncValue.data(1);
    // print(newRecord.bloodPressure);
    // toRecord(test);
  }

  // Future updateRecord(String name, String blood, double height, double weight,
  //     int age, List<Map<String, dynamic>> bloodPressure) async {
  //   state = AsyncValue.loading();
  //   _name = name;
  //   _blood = blood;
  //   _height = height;
  //   _weight = weight;
  //   _age = age;
  //   _bloodPressure = bloodPressure;
  //   healthRecord = HealthRecord(
  //       address: _address,
  //       name: _name,
  //       bloodGroup: _blood,
  //       age: _age.toString(),
  //       weight: _weight,
  //       height: _height,
  //       bloodPressure: _bloodPressure);

  //   String jsonHealthRecord = jsonEncode(healthRecord);
  //   print('THis is teh json health record${jsonHealthRecord}');
  //   state = AsyncValue.data(1);
  // }

  Future recordAppointment(Map data) async {
    state = AsyncValue.loading();
    print('Entered recordAppointment');
    healthRecord.appointments.add({
      'date': data['date'],
      'hour': data['hour'],
      'minute': data['minute'],
      'name': data['name'],
      'email': data['email'],
    });
    String jsonHealthRecord = json.encode(healthRecord);
    print('THis is the json encoded health Record:${jsonHealthRecord}');
    // print('THis is the decoded form:${json.decode(jsonHealthRecord)}');
    var cipher = ref
        .read(rsaKeyNotifierProvider.notifier)
        .encryptWithRSA(jsonHealthRecord);
    var cipherEncode = utf8.encode(cipher);
    cid = await ref
        .read(filecoinNotifierProvider.notifier)
        .postData(cipherEncode);
    await ref
        .read(ethUtilsNotifierProvider.notifier)
        .updateHealthRecord(dotenv.env['ACCOUNT_ADDRESS']!, cid);
    print('RecordAppointment() is done...');
    state = AsyncValue.data(1);
  }

  Future addCondition(Map data) async {
    state = AsyncValue.loading();
    // var conditionsList = healthRecord.conditions;
    // try {
    // healthRecord.conditions = List.from(healthRecord.conditions);
    healthRecord.conditions.add(data);
    print(healthRecord.conditions);
    // state = AsyncValue.data(1);
    // } catch (err) {
    // print('THis is teherror while adding: ${err}');
    // return;
    // }
    // healthRecord.conditions.add({
    //   'dateTime': data['dateTime'],
    //   'description': data['description'],
    //   // 'imageUrls': data['imageUrls'],
    // });
    String jsonHealthRecord = json.encode(healthRecord);
    var cipher = ref
        .read(rsaKeyNotifierProvider.notifier)
        .encryptWithRSA(jsonHealthRecord);
    var cipherEncode = utf8.encode(cipher);
    cid = await ref
        .read(filecoinNotifierProvider.notifier)
        .postData(cipherEncode);
    await ref
        .read(ethUtilsNotifierProvider.notifier)
        .updateHealthRecord(dotenv.env['ACCOUNT_ADDRESS']!, cid);
    state = AsyncValue.data(1);
  }

  Future addNewRecord(name, String blood, double height, double weight, int age,
      String address) async {
    state = AsyncValue.loading();
    _name = name;
    _blood = blood;
    _height = height;
    _weight = weight;
    _age = age;
    _address = address;

    healthRecord = HealthRecord(
      address: _address,
      name: _name,
      bloodGroup: _blood,
      age: _age.toString(),
      weight: _weight,
      height: _height,
    );

    String jsonHealthRecord = jsonEncode(healthRecord);
    print('THis is the josn record: $jsonHealthRecord');

    await ref.read(rsaKeyNotifierProvider.notifier).createKeyPair(
        0); //0 is given to create patient public/private Key pair
    var cipher = ref
        .read(rsaKeyNotifierProvider.notifier)
        .encryptWithRSA(jsonHealthRecord);
    // _encryptWithRSA(jsonHealthRecord, helper.parsePublicKeyFromPem(_publicKey));
    // print('THis is the original ciphper: ${cipher}');
    // var encod = utf8.encode(cipher);
    var cipherEncode = utf8.encode(cipher);
    // print('THis is the cipher : ${utf8.encode(cipher)}');
    // print('DEcodeed : ${utf8.decode(encod)}');
    cid = await ref
        .read(filecoinNotifierProvider.notifier)
        .postData(cipherEncode);

    await ref
        .read(ethUtilsNotifierProvider.notifier)
        .addNewRecord(dotenv.env['ACCOUNT_ADDRESS']!, cid);
    state = AsyncValue.data(1);
  }
}

final healthRecordNotifierProvider =
    StateNotifierProvider<HealthRecordProvider, AsyncValue<int>>(
  (ref) {
    return HealthRecordProvider(ref);
  },
);
