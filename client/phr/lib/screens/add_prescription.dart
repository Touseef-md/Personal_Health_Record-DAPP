import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phr/providers/doctor_approve_requests_provider.dart';
import 'package:phr/providers/doctor_provider.dart';
import 'package:phr/screens/submit_prescription.dart';
import 'package:phr/widgets/patient_drawer.dart';

class AddPrescriptionScreen extends StatelessWidget {
  static const routeName = '/add_prescription';
  const AddPrescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Add Prescription',
          ),
        ),
        drawer: PatientDrawer(),
        body: Container(
          height: double.maxFinite,
          child: Consumer(
            builder: (context, ref, child) {
              return ref.watch(doctorNotifierProvider).when(
                data: (data) {
                  final records =
                      ref.read(doctorNotifierProvider.notifier).healthRecords;
                  print('THese are the count:${records.length}');
                  print('These are the records in the tree:${records}');
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, SubmitPrescriptionScreen.routeName,
                              arguments: records[index]);
                        },
                        child: Card(
                          child: Column(
                            children: [
                              Text(
                                'Name: ${records[index].name}\nAge: ${records[index].age}',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: records.length,
                  );
                },
                error: (error, stackTrace) {
                  return Text('Oops! Somethin went wrong.');
                },
                loading: () {
                  return CircularProgressIndicator();
                },
              );
            },
          ),
          // ListView.builder(itemBuilder: (context, index) {}, itemCount: 0),
        )
        // Text(
        //   'Add prescription scren',
        // ),
        );
  }
}
