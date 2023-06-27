import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/health_record_provider.dart';

class CreateRecord extends ConsumerStatefulWidget {
  static const routeName = '/createRecord';

  CreateRecord({super.key});

  @override
  ConsumerState<CreateRecord> createState() => _CreateRecordState();
}

class _CreateRecordState extends ConsumerState<CreateRecord> {
  String name = '', blood = '';
  double height = 0, weight = 0;
  int age = 0;

  String? _dropDownValue = 'Select';
  final dropDownItems = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
    'Select'
  ];
  final _formKey = GlobalKey<FormState>();
  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    ref
        .read(healthRecordNotifierProvider.notifier)
        .addNewRecord(name, blood, height, weight, age);
    // healthRecordNotifierProvider.
    // _formKey.currentState.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            surfaceTintColor: Colors.white,
            // margin: EdgeInsets.symmetric(
            //   vertical: 100,
            //   horizontal: 50,
            // ),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text(
                          'Name',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      autocorrect: false,
                      enableSuggestions: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Length should be greater than 0';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        setState(() {
                          name = newValue!;
                        });
                      },
                    ),
                    DropdownButtonFormField(
                      value: 'Select',
                      decoration: InputDecoration(
                        label: Text(
                          'Blood Group',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      items: dropDownItems.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _dropDownValue = value;
                        });
                      },
                      validator: (value) {
                        if (value == 'Select') {
                          return 'Select a valid blood Group';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        setState(() {
                          blood = newValue!;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text(
                          'Age',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            int.parse(value) < 18) {
                          return 'Must be atleast 18 years';
                        }
                        return null;
                      },
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                        signed: true,
                      ),
                      onSaved: (newValue) {
                        setState(() {
                          age = int.parse(newValue!);
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text(
                          'Weight (Kgs)',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            double.parse(value) <= 0) {
                          return 'Enter a valid age';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        setState(() {
                          weight = double.parse(newValue!);
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text(
                          'Height (in feet)',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            double.parse(value) <= 0) {
                          return 'Value should be >0';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        setState(() {
                          height = double.parse(newValue!);
                        });
                      },
                    )
                  ],
                )),
          ),
          ElevatedButton(
            onPressed: () {
              _submit();
            },
            child: const Text(
              'Submit',
            ),
          )
        ],
      )),
    );
  }
}
