import 'dart:io';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phr/modals/healtrecord.dart';
import 'package:phr/providers/eth_utils_provider.dart';
import 'package:phr/providers/rsa_provider.dart';
import 'package:path_provider/path_provider.dart';
import '../modals/healtrecord.dart';
import '../modals/doctor.dart';

class DoctorProvider extends StateNotifier<AsyncValue<Doctor>> {
  late Doctor doctor;
  late List<HealthRecord> healthRecords = [];
  // var HealthRecord[] healthRecords;
  StateNotifierProviderRef ref;
  DoctorProvider(this.ref) : super(const AsyncValue.loading());

  Future getFile(String path) async {
    print('This is the path sent to the getFile func:${path}');
    var file = File(path);
    var isValid = await file.exists();
    List<int> decodedPhr = [];
    if (isValid) {
      var encodedJson = await file.readAsString();
      var decodedJson = json.decode(encodedJson);
      print('THis is the json decoded phr:${decodedJson}');
      print('Inside of getFile for phr:${decodedJson.runtimeType}');
      for (int i = 0; i < decodedJson.length; i++) {
        decodedPhr.add(decodedJson[i]);
      }
      var cipher = utf8.decode(decodedPhr);
      String phr =
          ref.read(rsaKeyNotifierProvider.notifier).decryptWithRSA(cipher);
      print(
          'This is jsut before returing in getFile in doctor provider: ${phr}');
      try {
        var finalPhr = json.decode(phr);
        return finalPhr;
      } catch (err) {
        print('Error while decrypting:${err}');
        return null;
      }
      // return json.decode(phr);
    }
  }

  Future getPHRs() async {
    state = AsyncValue.loading();
    final parentDir = await getExternalStorageDirectories();
    // var phrsFolder=directory![0].path/phrs
    var isDirectory = Directory(parentDir![0].path + '/phrs');
    if (!(await isDirectory.exists())) {
      return;
    }
    List directory = isDirectory.listSync();
    if (directory.isNotEmpty) {
      print('THese are the non empty directoryies:${directory}');
      // healthRecords =
      var futureHealthRecords = directory.map((phr) async {
        var fileData = await getFile(phr.path);
        return fileData;
      }).toList();
      futureHealthRecords.forEach(
        (element) {
          element.then(
            (value) {
              print('This is the future completion value:${value}');
              if (value != null)
                healthRecords.add(
                  HealthRecord(
                    address: value['address'],
                    name: value['name'],
                    bloodGroup: value['bloodGroup'],
                    age: value['age'],
                    weight: value['weight'],
                    height: value['height'],
                    appointments: json.decode(value['appointments']),
                    bloodPressure: json.decode(value['bloodPressure']),
                    conditions: json.decode(value['conditions']),
                    prescriptions: json.decode(value['prescriptions']),
                  ),
                );
            },
          );
        },
      );
    }
    state = AsyncValue.data(doctor);
  }

  Future getDoctor(String doctorAddr) async {
    state = AsyncValue.loading();
    try {
      final result = await ref
          .read(ethUtilsNotifierProvider.notifier)
          .getDoctor(doctorAddr);
      if (result == null) {
        throw Exception(['Not able to get the doctor']);
        // state = AsyncValue.error(Error., StackTrace.current);
        print('Sorry not able to get the doctor...');
        return false;
      }
      print('THis is the doctor${result}');
      doctor = Doctor(
        email: result[1],
        name: result[0],
        address: result[3].toString(),
        imageUrl: result[2],
        publicKey: result[5],
      );
      print('This is the doctor object${doctor}');
      await getPHRs();
      state = AsyncValue.data(doctor);
      return true;
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error in getDoctor() in doctorProvider: ${err}');
      return false;
    }
  }

  Future createDoctor(
    String name,
    String email,
    String imageUrl,
    String address,
  ) async {
    await ref.read(rsaKeyNotifierProvider.notifier).createKeyPair(1);
    doctor = Doctor(
      name: name,
      email: email,
      imageUrl: imageUrl,
      address: address,
      publicKey: ref.read(rsaKeyNotifierProvider.notifier).getPublicKey,
    );
    try {
      // await ref.read(rsaKeyNotifierProvider.notifier).createKeyPair(1);
      var publicKey =
          await ref.read(rsaKeyNotifierProvider.notifier).getPublicKey;
      final result = await ref
          .read(ethUtilsNotifierProvider.notifier)
          .addNewDoctor(doctor, publicKey);
      if (result == null || result == false) return false;
      return true;
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error in createDoctor() in doctor_provider.dart: ${err}');
      return false;
    }
  }
}

final doctorNotifierProvider =
    StateNotifierProvider<DoctorProvider, AsyncValue<Doctor>>((ref) {
  return DoctorProvider(ref);
});
