import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:path_provider/path_provider.dart';

class RSAProvider extends StateNotifier<AsyncValue<int>> {
  RSAProvider() : super(AsyncValue.loading());
  final helper = RsaKeyHelper();
  late String _publicKey;
  late String _privateKey;
  late String _status;

  String get getPublicKey {
    return _publicKey;
  }

  String get getPrivateKey {
    return _privateKey;
  }

  String encryptWithRSA(String message) {
    print('Message is :${message}');
    return encrypt(message, helper.parsePublicKeyFromPem(_publicKey));
  }

  String encryptWithRSAWithKey(String message, String publicKey) {
    return encrypt(message, helper.parsePublicKeyFromPem(publicKey));
  }

  String decryptWithRSA(String cipher) {
    return decrypt(cipher, helper.parsePrivateKeyFromPem(_privateKey));
  }

  Future writeKeys() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // print('PAth is ${documentsDirectory.path}');
    File filePublic = File('${documentsDirectory.path}/${_status}my_file0.txt');
    File filePrivate =
        File('${documentsDirectory.path}/${_status}my_file1.txt');

    final writingPublicResponse = await filePublic.writeAsString(_publicKey);
    final writingPrivateResponse = await filePrivate.writeAsString(_privateKey);
  }

  Future readKeys(int status) async {
    print('REad Keys called');
    if (status == 0) {
      _status = 'patient';
    } else if (status == 1) {
      _status = 'doctor';
    } else {
      throw Exception('Status sent to the readKeys(int status) is not valid.');
    }

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // print('PAth is ${documentsDirectory.path}');
    File filePublic = File('${documentsDirectory.path}/${_status}my_file0.txt');
    File filePrivate =
        File('${documentsDirectory.path}/${_status}my_file1.txt');
    _publicKey = await filePublic.readAsString();
    _privateKey = await filePrivate.readAsString();
    print('THiis is the PRIVATE KEY:${_privateKey}');
  }

  Future createKeyPair(int status) async {
    if (status == 0) {
      _status = 'patient';
      // Status.patient
      // return;
    } else if (status == 1) {
      _status = 'doctor';
    } else {
      return;
    }
    var _keypair = await helper.computeRSAKeyPair(helper.getSecureRandom());
    _publicKey =
        helper.encodePublicKeyToPemPKCS1(_keypair.publicKey as RSAPublicKey);
    _privateKey =
        helper.encodePrivateKeyToPemPKCS1(_keypair.privateKey as RSAPrivateKey);
    writeKeys();
  }
}

final rsaKeyNotifierProvider =
    StateNotifierProvider<RSAProvider, AsyncValue<int>>((ref) {
  return RSAProvider();
});
