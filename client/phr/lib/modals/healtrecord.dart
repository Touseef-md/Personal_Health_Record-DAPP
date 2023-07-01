class HealthRecord {
  final String name;
  // DateTime dob;
  final String bloodGroup;
  final String age;
  double weight = 0;
  double height = 0;
  late List<Map<String, dynamic>> bloodPressure;
  HealthRecord({
    required this.name,
    required this.bloodGroup,
    required this.age,
    required this.weight,
    required this.height,
  });

  void addBloodPressure(int sys, int dia, int pul) {
    bloodPressure.add({
      'systolic': sys,
      'diastolic': dia,
      'pulse': pul,
      'timestamp': DateTime.now(),
    });
  }

  Map toJson() => {
        'name': name,
        'bloodGroup': bloodGroup,
        'age': age,
        'weight': weight,
        'height': height,
      };
}
