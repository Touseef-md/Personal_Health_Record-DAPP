import 'package:flutter/material.dart';
import 'package:phr/providers/health_record_provider.dart';
import 'package:phr/widgets/patient_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateHealthRecordScreen extends ConsumerWidget {
  static const routeName = '/update_health_record';
  const UpdateHealthRecordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final record = ref.read(healthRecordNotifierProvider.notifier).healthRecord;
    String _systolic, _diastolic, _pulse;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Health Record',
        ),
      ),
      drawer: PatientDrawer(),
      body: Center(
        child: Column(
          children: [
            Form(
                child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(),
                )
              ],
            )),
            ElevatedButton(
              onPressed: () {
                // ref
                //     .read(healthRecordNotifierProvider.notifier)
                //     .updateRecord('Touseef new', 'O+', 56, 67, 78, [
                //   {
                //     'systolic': 56,
                //     'diastolic': 78,
                //     'pulse': 102,
                //   }
                // ]);
              },
              child: Text(
                'Submit',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
