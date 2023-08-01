import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phr/providers/eth_utils_provider.dart';
import 'package:phr/providers/filecoin_provider.dart';
import 'package:phr/providers/filemanagement_provider.dart';
import 'package:phr/providers/health_record_provider.dart';
import 'package:phr/providers/rsa_provider.dart';
import 'package:phr/widgets/patient_drawer.dart';

class ApprovePrescription extends ConsumerStatefulWidget {
  const ApprovePrescription({super.key});
  static const routeName = '/approve_prescription';

  @override
  ConsumerState<ApprovePrescription> createState() =>
      _ApprovePrescriptionState();
}

class _ApprovePrescriptionState extends ConsumerState<ApprovePrescription> {
  @override
  void initState() {
    super.initState();
    getPrescriptions();
  }

  List requests = [];

  Future getFile(String path) async {
    var file = File(path);
    var isValid = await file.exists();
    if (isValid) {
      // print('${await file.exists()}');
      // print('Exists in getFile function in approve_requests');
      var encodedJson = await file.readAsString();
      // print('This isthe enocde whiel getting fiile${encodedJson}');
      return json.decode(encodedJson);
    }
    return null;
  }

  void getPrescriptions() async {
    var lists = await getExternalStorageDirectories();
    var directory =
        Directory(lists![0].path + '/updatePrescription').listSync();
    List<Future<dynamic>> futureRequests = [];
    if (directory.isNotEmpty) {
      futureRequests = directory.map((item) async {
        var fileData = await getFile(item.path);
        return fileData;
      }).toList();
      print('Lenght of the approve requests are:${futureRequests.length}');
      futureRequests.forEach((element) async {
        // var fileData=await getFile(element.path);
        element.then(
          (value) {
            setState(() {
              requests.add(value);
            });
          },
        );
        // fileData
        // setState(() {
        //   requests.add('value');
        // });
      });
    }
  }

  void _submit(Map data) async {
    var healthRecordNotifier = ref.read(healthRecordNotifierProvider.notifier);
    var healthRecord = healthRecordNotifier.healthRecord;
    healthRecord.prescriptions.add(data['added_prescription']);
    String jsonHealthRecord = json.encode(healthRecord);
    print('Just before encrypting');
    print(jsonHealthRecord.runtimeType);
    print(jsonHealthRecord.length);
    print(jsonHealthRecord);
    var cipher = ref
        .read(rsaKeyNotifierProvider.notifier)
        .encryptWithRSA(jsonHealthRecord);
    var cipherEncode = utf8.encode(cipher);
    var cid = await ref
        .read(filecoinNotifierProvider.notifier)
        .postData(cipherEncode);
    await ref
        .read(ethUtilsNotifierProvider.notifier)
        .updateHealthRecord(dotenv.env['ACCOUNT_ADDRESS']!, cid);
    ref
        .read(filemanagementNotifierProvider.notifier)
        .deleteFileExternalStorageDirectories(
            '/updatePrescription/${dotenv.env['ACCOUNT_ADDRESS']}.txt');
    print('Deletion of prescription is complete');
    getPrescriptions();
    print('Fetching of prescriptions is comoplete');

    // healthRecordNotifier.updateRecord(healthRecord.name, blood, height, weight, age, bloodPressure)
  }

  @override
  Widget build(BuildContext context) {
    // getPrescriptions();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Approve Prescription',
          ),
        ),
        drawer: PatientDrawer(),
        body: SingleChildScrollView(
          // physics: ,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: double.maxFinite,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Text(
                              requests[index].toString(),
                              // overflow: TextOverflow.,
                              softWrap: true,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _submit(requests[index]);
                          },
                          child: Text(
                            'Approve',
                          ),
                        )
                      ],
                    );
                  },
                  itemCount: requests.length,
                ),
              )
            ],
          ),
        ));
  }
}
