import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileManagementProvider extends StateNotifier<AsyncValue<int>> {
  // late externalStorageDirectory;
  FileManagementProvider() : super(AsyncValue.data(1)) {
    //  externalStorageDirectory =await  getExternalStorageDirectories()![0];
  }
  Future getFile(String path) async {}
  Future addFileExternalStorageDirectories(String path) async {
    final directory = (await getExternalStorageDirectories())![0];
  }

  Future getFilesFromDirectory(String folderPath) async {
    final directory = (await getExternalStorageDirectories())![0];
  }

  Future deleteFileExternalStorageDirectories(String path) async {
    final directory = (await getExternalStorageDirectories())![0];
    var file = File('${directory.path}${path}');
    if (await file.exists()) {
      file.delete(recursive: true);
    }
  }
}

final filemanagementNotifierProvider =
    StateNotifierProvider<FileManagementProvider, AsyncValue<int>>(
        (ref) => FileManagementProvider());
