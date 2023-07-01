import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:phr/providers/eth_utils_provider.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './filecoin_provider.dart';

import '../modals/healtrecord.dart';

class HealthRecordProvider extends StateNotifier<AsyncValue<int>> {
  String _name = '', _blood = '';
  double _height = 0, _weight = 0;
  int _age = 0;
  late HealthRecord healthRecord;
  late String cid;
  late var _keyPair;
  int counter = 0;
  // String _publicK
  StateNotifierProviderRef<HealthRecordProvider, AsyncValue<int>> ref;
  HealthRecordProvider(this.ref) : super(AsyncValue.loading()) {}

  Future _generateRSAKeyPairs() async {
    // final keyPair;
    var helper = RsaKeyHelper();
    // helper
    _keyPair = await helper.computeRSAKeyPair(helper.getSecureRandom());
    // keyPair.encodePrivateKeytoPemPKCS1();
    var publicKey =
        helper.encodePublicKeyToPemPKCS1(_keyPair.publicKey as RSAPublicKey);
    var privateKey =
        helper.encodePrivateKeyToPemPKCS1(_keyPair.privateKey as RSAPrivateKey);
    // print(helper.encodePublicKeyToPemPKCS1(keyPair.publicKey as RSAPublicKey));
    // print(
    // helper.encodePrivateKeyToPemPKCS1(keyPair.privateKey as RSAPrivateKey));
    // print('fdsfsd${keyPair.publicKey.toString()}');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // print('PAth is ${documentsDirectory.path}');
    File filePublic = File('${documentsDirectory.path}/my_file0.txt');
    File filePrivate = File('${documentsDirectory.path}/my_file1.txt');

    final writingPublicResponse = await filePublic.writeAsString(publicKey);
    // print('Writing response: ${writingPublicResponse}');
    // print(await file.readAsString());
    final writingPrivateResponse = await filePrivate.writeAsString(privateKey);
    // print('Writing privateResponse: ${writingPrivateResponse}');
    // return [publicKey, privateKey];
    return _keyPair;
  }

  String _encryptWithRSA(String message, RSAPublicKey publicKey) {
    return encrypt(message, publicKey);
  }

  String _decryptWithRSA(String cipher, RSAPrivateKey privateKey) {
    return decrypt(cipher, privateKey);
  }

  HealthRecord toRecord(Map data) {
    HealthRecord newRecord = HealthRecord(
      name: data['name'],
      bloodGroup: data['bloodGroup'],
      age: data['age'],
      weight: data['weight'],
      height: data['height'],
    );
    // data.forEach(
    //   (key, value) {},
    // );
    // print(test.runtimeType);
    return newRecord;
  }

  void retriveRecord(String cid) async {
    var message =
        await ref.read(filecoinNotifierProvider.notifier).retriveData(cid);
    // print('THis is the message: ${message}');
    var messageDecode = utf8.decode(message);
    // var message = cipher;
    var messageRetived = _decryptWithRSA(messageDecode, _keyPair.privateKey);
    print('THIs is after decryption : ${messageRetived}');
    // print(jsonDecode(messageRetived));
    var test = jsonDecode(messageRetived);
    print(test.runtimeType);
    // toRecord(test);
  }

  Future addNewRecord(
      name, String blood, double height, double weight, int age) async {
    _name = name;
    _blood = blood;
    _height = height;
    _weight = weight;
    _age = age;

    healthRecord = HealthRecord(
      name: _name,
      bloodGroup: _blood,
      age: _age.toString(),
      weight: _weight,
      height: _height,
    );

    String jsonHealthRecord = jsonEncode(healthRecord);
    print('THis is the josn record: $jsonHealthRecord');
    _keyPair = await _generateRSAKeyPairs();
    var cipher = _encryptWithRSA(jsonHealthRecord, _keyPair.publicKey);
    // print('THis is the original ciphper: ${cipher}');
    // var encod = utf8.encode(cipher);
    var cipherEncode = utf8.encode(cipher);
    // print('THis is the cipher : ${utf8.encode(cipher)}');
    // print('DEcodeed : ${utf8.decode(encod)}');
    cid = await ref
        .read(filecoinNotifierProvider.notifier)
        .postData(cipherEncode);

    ref
        .read(ethUtilsNotifierProvider.notifier)
        .addNewRecord(dotenv.env['ACCOUNT_ADDRESS']!, cid);
    // retriveRecord(cid);
    // HealthRecord
    // Converter();
    // var publicKey = Keys[0], privateKey = Keys[1];
    // crypto.AsymmetricKeyPair keyPair;
    // final keyPair;
    // // crypto.
    // //to store the KeyPair once we get data from our future
    // // crypto.AsymmetricKeyPair keyPair;
    // var helper = RsaKeyHelper();
    // keyPair = await helper.computeRSAKeyPair(helper.getSecureRandom());
    // // keyPair.encodePrivateKeytoPemPKCS1();
    // var publicKey =
    //     helper.encodePublicKeyToPemPKCS1(keyPair.publicKey as RSAPublicKey);
    // var privateKey =
    //     helper.encodePrivateKeyToPemPKCS1(keyPair.privateKey as RSAPrivateKey);
    // print(helper.encodePublicKeyToPemPKCS1(keyPair.publicKey as RSAPublicKey));
    // print(
    //     helper.encodePrivateKeyToPemPKCS1(keyPair.privateKey as RSAPrivateKey));
    // print('fdsfsd${keyPair.publicKey.toString()}');
    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // // print('PAth is ${documentsDirectory.path}');
    // File filePublic = File('${documentsDirectory.path}/my_file0.txt');
    // File filePrivate = File('${documentsDirectory.path}/my_file1.txt');

    // final writingPublicResponse = await filePublic.writeAsString(publicKey);
    // print('Writing response${writingPublicResponse}');
    // // print(await file.readAsString());
    // final writingPrivateResponse = await filePrivate.writeAsString(privateKey);
    // encr
    // filecoinNotifierProvider.
    // ref.filecoinNotifierProvider();
    // await ref.read(filecoinNotifierProvider.notifier).postData();

    // print(
    //     filecoinNotifierProvider == null ? 'It is null' : 'NOT NULL Provider');
    // print('HFslfsfsdfs THis si indication');
    // final response =
    //     await ref.read(filecoinNotifierProvider.notifier).postData();
    // print('FIlecoind called done........');
    // print('Response is : ${response}');
    // final cypher = encrypt('This is my message to encrypt something',
    // helper.parsePublicKeyFromPem(publicKey));
    // print('THis is the cypher${cypher}');
    // final decryptedMessage =
    // decrypt(cypher, helper.parsePrivateKeyFromPem(privateKey));
    // print('This is the decrypted message ${decryptedMessage}');

    // print(writingResponse1);
    // print(await file.readAsString());
    // final decodedPublic = helper.decodePEM(await file.readAsString());
    // print('This is decoding');
    // print(helper.encodePublicKeyToPemPKCS1(
    // helper.parsePublicKeyFromPem(await file.readAsString())));
    // print('Decoded ${decodedPublic}');
    // print(keyPair.privateKey.);
  }
}

final healthRecordNotifierProvider =
    StateNotifierProvider<HealthRecordProvider, AsyncValue<int>>(
  (ref) {
    return HealthRecordProvider(ref);
  },
);
