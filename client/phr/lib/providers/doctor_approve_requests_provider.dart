import 'dart:io';
import 'package:FilecoinStorage/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phr/modals/doctor.dart';

class DoctorApproveRequests extends StateNotifier<AsyncValue<int>> {
  DoctorApproveRequests() : super(AsyncValue.loading());
  // late var File fileList;

  getFile(String path) async {
    var file = File(path);
    if ((await file.exists())) {
      return await file.readAsString();
    }
    return null;
  }

  getRequests() async {
    // state = AsyncValue.loading();
    final lists = await getExternalStorageDirectories();
    final requests = Directory(lists![0].path).listSync().map((item) async {
      var fileData = await getFile(item.path);
      print('THis is the file data: ${fileData}');
      return fileData;
      // return file;
    }).toList();
    print('THese are the requests:${requests}');
    return requests;
    // state = AsyncValue.data(1);
    // return requests.map((item) {
    //   print("This is the item${item.path}");
    //   var file = File(item.path);
    //   file.exists().then(
    //     (value) async {
    //       print('sghteargsf');
    //       if (value) {
    //         print('EXISTS..........');
    //         file.readAsString().then((value) {
    //           print('THisis the data:${value}');
    //           return value;
    //         });
    //       } else {
    //         print('Null executed');
    //         return null;
    //       }
    //     },
    //   );
    //   print('execution afte the exists()');

    // if ((await file.exists())) {
    //   var readFile = await file.readAsString();

    //   return readFile;
    // }
    // return null;
    // return item.
    // }).toList();
  }

  void addRequests() async {
    state = AsyncValue.loading();

    state = AsyncValue.data(1);
  }
}

final doctorApproveNotifierProvider =
    StateNotifierProvider<DoctorApproveRequests, AsyncValue<int>>(
        (ref) => DoctorApproveRequests());
