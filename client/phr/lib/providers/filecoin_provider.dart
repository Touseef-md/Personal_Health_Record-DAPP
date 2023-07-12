import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:FilecoinStorage/api.dart';
// import 'package:file_picker/file_picker.dart' as f;
// import 'dart:io';
// import 'dart:html';
import 'package:http/http.dart' as http;

class FilecoinProvider extends StateNotifier<AsyncValue<int>> {
  final web3StorageToken = dotenv.env['WEB3STORAGE_API'];
  late final OAuth _oauth;
  late final ApiClient _apiClient;
  late final Web3StorageHTTPAPIApi _apiInstance;
  // ApiClient _apiClient=ApiClient(authentication: )
  FilecoinProvider() : super(AsyncValue.loading()) {
    print('Web3 storage token i s: ${web3StorageToken}');
    _oauth = OAuth(accessToken: web3StorageToken!);
    _apiClient = ApiClient(
      authentication: _oauth,
    );
    _apiInstance = Web3StorageHTTPAPIApi(_apiClient);

    // FilepickerRe
    // _apiInstance.postUpload(file: );
  }
  Future retriveData(String cid) async {
    state = const AsyncValue.loading();
    // if (cid. == null) return;
    var uri = Uri.parse('https://ipfs.io/ipfs/${cid}');
    http.Response gettingData = await http.get(uri = uri);
    // print('THis the retrived data: ${gettingData.bodyBytes}');
    return gettingData.bodyBytes;
  }

  Future postData(List<int> data) async {
    state = AsyncValue.loading();
    // data
    // var fileResult=await f.FilePicker.;
    // final streamData = await Stream.value(data.codeUnits);
    // final len = await streamData.length;
    var multiFile = http.MultipartFile.fromBytes('file', data);
    // var multiFile = http.MultipartFile.fromString(
    //   'file',
    //   data,
    //   filename: 'data.txt',
    //   // contentType: http.  MediaType('text', 'plain'),
    // );
    var result;
    UploadResponse? cid;
    var gettingData;
    try {
      cid = await _apiInstance.postUpload(file: multiFile);
      state = const AsyncValue.data(1);
      print('THe Cid for the data is : ${cid!.cid}');
      if (cid != null) {
        // gettingData = await _apiInstance.viewCarFilesCid(cid.cid!);
        return cid.cid!;
        // print('Just before getting the data');
        // await retriveData(cid.cid!);
        // gettingData = await _apiClient.httpClient();
        // var uri = Uri.parse('https://ipfs.io/ipfs/${cid.cid}');
        // http.Response gettingData = await http.get(uri = uri);
        // print('THIS is the dtaa returned: ${gettingData.body}');

        // var ans = jsonDecode(gettingData);
        // print(ans);
        // print('THis is teh data returned: ${jsonDecode(gettingData.body)}');
      } else {
        print('CId is null');
        throw Exception(
            'CID returned null while uploading data inside postData of filecoin_provider');
        // return
      }
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print(
          'Exveption while uploading the data, error in postData() function: ${err}');
    }
  }
}

final filecoinNotifierProvider =
    StateNotifierProvider<FilecoinProvider, AsyncValue<int>>(
  (ref) {
    return FilecoinProvider();
  },
);
