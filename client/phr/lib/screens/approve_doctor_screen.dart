import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phr/providers/doctor_approve_requests_provider.dart';

class ApproveDoctorScreen extends ConsumerStatefulWidget {
  static const routeName = '/approve_doctor';
  ApproveDoctorScreen({super.key});

  @override
  ConsumerState<ApproveDoctorScreen> createState() =>
      _ApproveDoctorScreenState();
}

class _ApproveDoctorScreenState extends ConsumerState<ApproveDoctorScreen> {
  List requests = [];
  @override
  void initState() {
    super.initState();
    getRequest();
    // ref.read(provider)
  }

  Future getRequest() async {
    final result = (await ref
        .read(doctorApproveNotifierProvider.notifier)
        .getRequests()) as List<Future<dynamic>>;
    // setState(() {
    //   requests = result;
    // });
    // requests.forEach(
    //   (element) {
    //     element.
    //   },
    // );
    print('Req3us type is :${requests}');
    // (requests[0] as Future<dynamic>);
    for (var i = 0; i < result.length; i++) {
      result[i].then((value) {
        setState(() {
          requests.add(value);
        });
      });
    }
  }
  // requests =

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;

    print('THese are the args: ${args}');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Approve Requests',
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) {
            // final buildresult = (requests[index] as Future<dynamic>)
            //     .then((value) => Text(value));
            // print('THis is the build result${buildresult}');
            return Text(requests[index]);
          },
          itemCount: requests.length,
          //  FutureBuilder(builder: (context, snapshot) {
          //     return;
          // },future: ),
        ),
      ),
    );
  }
}
