import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phr/providers/health_record_provider.dart';
import 'package:phr/widgets/patient_drawer.dart';

class PrescriptionScreen extends StatelessWidget {
  static const routeName = '/prescription';
  const PrescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Presciptions',
        ),
      ),
      drawer: PatientDrawer(),
      body: Container(
        height: double.maxFinite,
        child: Consumer(
          builder: (context, ref, child) {
            return ref.watch(healthRecordNotifierProvider).when(
              data: (data) {
                final prescriptions = ref
                    .read(healthRecordNotifierProvider.notifier)
                    .healthRecord
                    .prescriptions;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Text(prescriptions[index].toString());
                  },
                  itemCount: prescriptions.length,
                );
              },
              error: (error, stackTrace) {
                return Text('Oops! Something went wrong');
              },
              loading: () {
                return CircularProgressIndicator();
              },
            );
          },
        ),
      ),
    );
  }
}
