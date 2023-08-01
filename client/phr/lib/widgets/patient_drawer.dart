import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phr/providers/session_provider.dart';
import 'package:phr/screens/add_prescription.dart';
import 'package:phr/screens/appointments_screen.dart';
import 'package:phr/screens/approve_appointment_screen.dart';
import 'package:phr/screens/approve_doctor_screen.dart';
import 'package:phr/screens/approve_prescription.dart';
import 'package:phr/screens/condition_screen.dart';
import 'package:phr/screens/doctor_home_screen.dart';
import 'package:phr/screens/home_screen.dart';
import 'package:phr/screens/prescriptions.dart';
import '../screens/update_health_record_screen.dart';

class PatientDrawer extends ConsumerWidget {
  const PatientDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var session = ref.read(sessionControl.notifier).state;
    print('THis is the session${session}');
    return Drawer(
      // surfaceTintColor: Colors.black,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              color: Colors.grey,
            ),
            if (session == 'Doctor') ...[
              ListTile(
                leading: Icon(
                  Icons.home,
                ),
                title: Text('Home'),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, DoctorHomeScreen.routeName);
                },
              ),
              // if (session == 'Doctor')
              ListTile(
                leading: Icon(Icons.event),
                title: Text(
                  'Approve Appointment',
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, ApproveAppointmentScreen.routeName);
                },
              ),
              ListTile(
                leading: Icon(Icons.medication_liquid),
                title: Text(
                  'Add Prescription',
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, AddPrescriptionScreen.routeName);
                },
              )
            ],
            if (session == 'Patient') ...[
              ListTile(
                leading: Icon(
                  Icons.home,
                ),
                title: Text('Home'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                },
              ),
              // if (session == 'Patient')
              ListTile(
                leading: Icon(Icons.approval),
                title: Text(
                  'Approve Requests',
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, ApproveDoctorScreen.routeName);
                },
              ),
              // if (session == 'Patient')
              ListTile(
                leading: Icon(Icons.event),
                title: Text(
                  'Appointments',
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, AppointmentsScreen.routeName);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.medical_information,
                ),
                title: Text(
                  'Condition',
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, ConditionScreen.routeName);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.medication_liquid,
                ),
                title: Text(
                  'Prescriptions',
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, ApprovePrescription.routeName);
                },
              ),
              // if (session == 'Patient')
              ListTile(
                leading: Icon(
                  Icons.update,
                ),
                title: Text(
                  'Update Health Record',
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, UpdateHealthRecordScreen.routeName);
                },
              )
            ]
          ],
        ),
      ),
    );
  }
}
