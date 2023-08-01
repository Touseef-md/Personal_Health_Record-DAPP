import 'dart:convert';
import './doctor.dart';

class HealthRecord {
  final String name;
  // DateTime dob;
  final String bloodGroup;
  final String age;
  final String address;
  double weight = 0;
  double height = 0;
  late List<Doctor> doctors;
  // late List<Map<String, dynamic>> bloodPressure;
  late List bloodPressure;
  late List appointments = [];
  late List conditions = [];
  late List prescriptions = [];
  HealthRecord({
    required this.name,
    required this.bloodGroup,
    required this.age,
    required this.weight,
    required this.height,
    required this.address,
    this.bloodPressure = const [],
    this.appointments = const [],
    this.conditions = const [],
    this.prescriptions = const [],
  });

  void addBloodPressure(int sys, int dia, int pul) {
    bloodPressure.add({
      'systolic': sys,
      'diastolic': dia,
      'pulse': pul,
      'timestamp': DateTime.now(),
    });
  }

  Map toJson() {
    var list = jsonEncode(bloodPressure);
    var appointmentList = json.encode(appointments);
    var conditionList = json.encode(conditions);
    var prescriptionList = json.encode(prescriptions);
    print('Encoded blood pressure${list}');
    return {
      'address': address,
      'name': name,
      'bloodGroup': bloodGroup,
      'age': age,
      'weight': weight,
      'height': height,
      'bloodPressure': list,
      'appointments': appointmentList,
      'conditions': conditionList,
      'prescriptions': prescriptionList,
    };
  }
}
