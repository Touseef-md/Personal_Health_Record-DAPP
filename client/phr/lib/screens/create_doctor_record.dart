import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phr/providers/doctor_provider.dart';
import 'package:phr/providers/session_provider.dart';

import './doctor_home_screen.dart';

class CreateDoctorRecord extends ConsumerStatefulWidget {
  static const routeName = '/create_doctor';
  const CreateDoctorRecord({super.key});

  @override
  ConsumerState<CreateDoctorRecord> createState() => _CreateDoctorRecordState();
}

class _CreateDoctorRecordState extends ConsumerState<CreateDoctorRecord> {
  late String _name;
  late String _email;
  late String _imageUrl;
  late String _address = dotenv.env['ACCOUNT_ADDRESS']!;
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    void _submit() async {
      final _isValid = _form.currentState!.validate();
      if (!_isValid) {
        return;
      }
      _form.currentState!.save();
      var result = await ref
          .read(doctorNotifierProvider.notifier)
          .createDoctor(_name, _email, _imageUrl, _address);
      print('Create doctor finished');
      if (result) {
        await ref.read(doctorNotifierProvider.notifier).getDoctor(_address);
        ref.read(sessionControl.notifier).state = 'Doctor';
        Navigator.pushNamed(context, DoctorHomeScreen.routeName);
      } else {
        print('Doctor profile not created...');
      }
    }

    return Scaffold(
        body: Column(
      children: [
        Card(
          child: Form(
              key: _form,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text(
                        'Name',
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is empty';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      setState(() {
                        _name = newValue!;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text(
                        'Email',
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Not a valid email';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      setState(() {
                        _email = newValue!;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text(
                        'imageUrl',
                      ),
                    ),
                    onSaved: (newValue) {
                      _imageUrl = newValue!;
                    },
                  )
                ],
              )),
        ),
        ElevatedButton(
          onPressed: () {
            _submit();
          },
          child: Text(
            'Submit',
          ),
        )
      ],
    ));
  }
}
