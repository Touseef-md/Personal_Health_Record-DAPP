import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HealthRecordProvider extends StateNotifier<AsyncValue<int>> {
  String _name = '', _blood = '';
  double _height = 0, _weight = 0;
  int _age = 0;
  int counter = 0;
  HealthRecordProvider() : super(AsyncValue.loading()) {}

  void addNewRecord(
      name, String blood, double height, double weight, int age) async {
    _name = name;
    _blood = blood;
    _height = height;
    _weight = weight;
    _age = age;

    // crypto.AsymmetricKeyPair keyPair;
    final keyPair;
    // crypto.
    //to store the KeyPair once we get data from our future
    // crypto.AsymmetricKeyPair keyPair;
    var helper = RsaKeyHelper();
    keyPair = await helper.computeRSAKeyPair(helper.getSecureRandom());
    // keyPair.encodePrivateKeytoPemPKCS1();
    var publicKey =
        helper.encodePublicKeyToPemPKCS1(keyPair.publicKey as RSAPublicKey);
    var privateKey =
        helper.encodePrivateKeyToPemPKCS1(keyPair.privateKey as RSAPrivateKey);
    print(helper.encodePublicKeyToPemPKCS1(keyPair.publicKey as RSAPublicKey));
    print(
        helper.encodePrivateKeyToPemPKCS1(keyPair.privateKey as RSAPrivateKey));
    print('fdsfsd${keyPair.publicKey.toString()}');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // print('PAth is ${documentsDirectory.path}');
    File filePublic = File('${documentsDirectory.path}/my_file0.txt');
    File filePrivate = File('${documentsDirectory.path}/my_file1.txt');

    final writingPublicResponse = await filePublic.writeAsString(publicKey);
    // print('Writing response${writingResponse}');
    // print(await file.readAsString());
    final writingPrivateResponse = await filePrivate.writeAsString(privateKey);
    // encr
    final cypher = encrypt('This is my message to encrypt something',
        helper.parsePublicKeyFromPem(publicKey));
    print('THis is the cypher${cypher}');
    final decryptedMessage =
        decrypt(cypher, helper.parsePrivateKeyFromPem(privateKey));
    print('This is the decrypted message ${decryptedMessage}');

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
    return HealthRecordProvider();
  },
);
