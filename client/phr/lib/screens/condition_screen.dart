// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:phr/providers/health_record_provider.dart';
import 'package:phr/widgets/patient_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConditionScreen extends ConsumerStatefulWidget {
  static const routeName = '/conditions';
  const ConditionScreen({super.key});

  @override
  ConsumerState<ConditionScreen> createState() => _ConditionScreenState();
}

class _ConditionScreenState extends ConsumerState<ConditionScreen> {
  int _imageCounter = 1;
  List imageUrls = [];
  String _condition = '';
  var _form = GlobalKey<FormState>();
  void _submit() {
    bool isValid = _form.currentState == null;
    if (!isValid) {
      _form.currentState!.save();
    }
    ref.read(healthRecordNotifierProvider.notifier).addCondition({
      'dateTime': DateTime.now().toIso8601String(),
      'description': _condition,
      // 'imageUrls': imageUrls.,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conditions',
        ),
      ),
      drawer: PatientDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _form,
              child: TextFormField(
                decoration: const InputDecoration(
                  label: Text(
                    'Describe the medical situation',
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _condition = newValue as String;
                },
              ),
            ),
            Container(
              height: 60.0 * _imageCounter,
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        label: Text(
                          'Add image Url',
                        ),
                      ),
                      validator: (value) {
                        if (_imageCounter > 1 &&
                            (value == null || value.isEmpty)) {
                          return 'This field cannot be empty';
                        }
                        // else if(_imageCounter==1){

                        // }
                        return null;
                      },
                      onSaved: (newValue) {
                        imageUrls.add(newValue!);
                      },
                    );
                  },
                  itemCount: _imageCounter),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.outlined(
                  onPressed: () {
                    setState(() {
                      _imageCounter++;
                    });
                  },
                  icon: Icon(
                    Icons.add,
                  ),
                ),
                IconButton.outlined(
                  onPressed: () {
                    setState(() {
                      if (_imageCounter > 1) _imageCounter--;
                    });
                  },
                  icon: Icon(
                    Icons.delete,
                  ),
                )
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _submit();
              },
              child: Text('Add Contition'),
            ),
            Text('Previous Conditions'),
            Container(
              height: 200,
              child: ref.watch(healthRecordNotifierProvider).when(
                data: (data) {
                  final previousConditions = ref
                      .read(healthRecordNotifierProvider.notifier)
                      .healthRecord
                      .conditions;
                  // print('These are the conditions in build method:${previousConditions}');
                  return ListView.builder(
                      itemBuilder: (context, index) {
                        return Card(
                          child: Text(
                            previousConditions[index].toString(),
                          ),
                        );
                      },
                      itemCount: previousConditions.length);
                },
                error: (error, stackTrace) {
                  return Text('Oops! error occured');
                },
                loading: () {
                  return CircularProgressIndicator();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
