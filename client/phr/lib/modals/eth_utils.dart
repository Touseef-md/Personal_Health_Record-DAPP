import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// import 'package:phr/providers/rsa_provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './doctor.dart';

class EthereumUtils {
  late http.Client httpClient;
  late Web3Client ethClient;
  final contractAddress = dotenv.env['CONTRACT_ADDRESS'];
  // late final _contract;
  void initialSetup() {
    httpClient = http.Client();
    String infura =
        'https://${dotenv.env['CHAIN_NAME']}.infura.io/v3/${dotenv.env['INFURA_API_KEY']}';
    ethClient = Web3Client(infura, httpClient);
  }

  Future waitForConfirmation(String txHash) async {
    try {
      TransactionReceipt? receipt;
      do {
        // Wait for some time before checking the status again (e.g., 5 seconds)
        await Future.delayed(Duration(seconds: 5));

        // Get the transaction receipt
        receipt = await ethClient.getTransactionReceipt(txHash);
      } while (receipt ==
          null); // Loop until receipt is not null (i.e., transaction is confirmed)

      if (receipt.status == true) {
        // The transaction has been successfully confirmed and included in a block
        print('Transaction confirmed');
        print('Block number: ${receipt.blockNumber}');

        // Call your function here after the transaction is confirmed
        // yourFunctionAfterConfirmation();
        return true;
      } else {
        // The transaction failed and was not included in a block
        print('Transaction failed');
        return false;
        // print('Error message: ${receipt.error}');

        // Handle the failure or retry if needed
      }
    } catch (e) {
      // Handle any errors that occurred during the request
      print('Error checking transaction status: $e');
      return false;
    }
  }

  Future getDoctor(String doctorAddr) async {
    try {
      // print("Called getDoctor");
      var contract = await getDeployedContract();
      // print('CHEck 1 ');
      final ethFunction = contract.function('getDoctor');
      // print('check 2');
      final result = await ethClient.call(
          contract: contract,
          function: ethFunction,
          params: [EthereumAddress.fromHex(doctorAddr)]);
      print('REsult : ${result}');
      if (result.isEmpty) {
        return result;
      }
      print('THis is the doctor after getting it :${result}');
      return result;
      // return true;
    } catch (err) {
      print('Error in getDoctor() ethUtils: ${err}');
      return null;
    }
  }

  Future getDoctorForPatient(String patientAddr) async {
    try {
      print(
          'THis is the input to the getDoctorForPatient() function:${patientAddr}');
      var contract = await getDeployedContract();
      final ethFunction = contract.function('getDoctorForPatient');
      final result = await ethClient.call(
          contract: contract,
          function: ethFunction,
          params: [EthereumAddress.fromHex(patientAddr)]);
      print('Result of getting doctors for patient: ${result}');
      return result[0];
    } catch (err) {
      print('Error in getDoctorForPatient() ethUtils:${err}');
    }
  }

  Future getIsDoctor(EthereumAddress doctorAddr) async {
    try {
      var contract = await getDeployedContract();
      final ethFunction = contract.function('getIsDoctor');
      final result = await ethClient.call(
          contract: contract, function: ethFunction, params: [doctorAddr]);
      if (result[0]) return true;
    } catch (err) {
      print('Error in getIsDoctor() ethUtils: ${err}');
      return false;
    }
  }

  Future<bool> getIsPatient(EthereumAddress patientAddr) async {
    print('inside the hasRecord func of ethutil');
    try {
      var contract = await getDeployedContract();
      final ethFunction = contract.function('getIsPatient');
      final result = await ethClient.call(
          contract: contract, function: ethFunction, params: [patientAddr]);
      print('HAs record \n${result[0]}');
      // if (result.isEmpty) {
      //   throw Exception(['hasRecord function of ethUtils returns empty list.']);
      // }
      if (result.isEmpty)
        throw Exception(['hasRecord function of ethUtils returns empty list.']);
      else
        return result[0] as bool;
      // return result[0];
    } catch (err) {
      print('Error inside the EthUtils hasRecord function: ${err}');
      // throw Exception(['hasRecord function of ethUtils returns empty list.']);
      return false;
    }
  }

  Future addNewDoctor(Doctor doctor, String publicKey) async {
    try {
      var contract = await getDeployedContract();
      final ethFunction = contract.function('addNewDoctor');
      final credential = EthPrivateKey.fromHex(dotenv.env['PRIVATE_KEY']!);
      // print('doing tx...');

      var add = EthereumAddress.fromHex(doctor.address);
      // print('check');
      Transaction tx = Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: [
          add,
          publicKey,
          doctor.name,
          doctor.email,
          doctor.imageUrl
        ],
        from: EthereumAddress.fromHex(doctor.address),
        gasPrice: EtherAmount.inWei(
          BigInt.from(
            50000,
          ),
        ),
      );

      final result = await ethClient.sendTransaction(
        credential,
        tx,
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );
      print('Add new Doctor Transaction hash is: ${result}');
      if (result == null || result.isEmpty) {
        return false;
      }
      if (await waitForConfirmation(result)) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print('Error in addNewDoctor() in ethUtils.dart: ${err}');
      return false;
    }
  }

  Future<bool> addNewPatient(String patientAddr, String cid) async {
    try {
      var contract = await getDeployedContract();
      final ethFunction = contract.function('addNewPatient');
      // final data = ethFunction.encodeCall([patientAddr, cid]);
      // final privateKey = EthPrivateKey.fromHex(dotenv.env['PRIVATE_KEY']!);
      // final credentials = Credentials(EthereumAddress.fromHex(patientAddr), privateKey);
      final credentials =
          await ethClient.credentialsFromPrivateKey(dotenv.env['PRIVATE_KEY']!);
      print('Check 1...');
      // Transaction tx;
      Transaction tx = Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: [EthereumAddress.fromHex(patientAddr), cid],
        from: EthereumAddress.fromHex(patientAddr),
        gasPrice: EtherAmount.inWei(BigInt.from(50000)),
        // maxGas: 50000,
        // value: EtherAmount.fromInt(EtherUnit.wei, 0),
      );
      print('EthUtils addnew patient...');
      // CredentialsWithKnownAddress()
      // Credentials cred=;
      // Credentials(address,)
      // CustomTransactionSender();
      // CustomTransactionSender().sendTransaction(transaction);
      // ethClient.credentialsFromPrivateKey(privateKey);
      final result = await ethClient.sendTransaction(
        credentials,
        tx,
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );
      // print('After send transaction');
      // print('Transaction hash is.... : ${result}');
      // final result = await ethClient.call(
      //     contract: contract,
      //     function: ethFunction,
      //     params: [patientAddr, cid]);
      if (result.isEmpty) {
        throw Exception(
            'addNewPatient function of ethUtils returns empty list');
      }
      if (await waitForConfirmation(result)) {
        return true;
      } else {
        return false;
      }
      // return result[0];
      return false;
    } catch (err) {
      print('Error inside the addNewPatient function of EthUtils: ${err}');
      return false;
    }
  }

  Future getPatient(String patientAddr) async {
    try {
      var contract = await getDeployedContract();
      var ethFunction = contract.function('getPatient');
      final result = await ethClient.call(
          contract: contract,
          function: ethFunction,
          params: [EthereumAddress.fromHex(patientAddr)]);
      // print('Result of getPatient, ethUtils: ${result}');
      return result[0];
    } catch (err) {
      print('Error inside the EthUtils getPatient Function: ${err}');
    }
  }

  Future approveDoctor(String doctorAddr, String patientAddr) async {
    try {
      var contract = await getDeployedContract();
      final ethFunction = contract.function('addDoctorForPatient');
      final credentials = EthPrivateKey.fromHex(dotenv.env['PRIVATE_KEY']!);
      // dotenv.env['PRIVATE_KEY'];

      Transaction tx = Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: [
          EthereumAddress.fromHex(doctorAddr),
          EthereumAddress.fromHex(patientAddr),
        ],
        from: EthereumAddress.fromHex(patientAddr),
        gasPrice: EtherAmount.inWei(
          BigInt.from(50000000),
        ),
      );
      // print('Sending approve tx');
      final result = await ethClient.sendTransaction(
        credentials as Credentials,
        tx,
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );
      print('THis is the approveDoctor reuslt: ${result}');
      if (await waitForConfirmation(result)) {
        return true;
      } else {
        return false;
      }
      // await getDoctorForPatient(dotenv.env['ACCOUNT_ADDRESS']!);
      // print('GetDoctorForPatient called. just after approved finished');
    } catch (err) {
      print('Error in approveDoctor() in ethUtils.dart : ${err}');
      return false;
    }
  }

  Future updateHealthRecord(String patientAddr, String cid) async {
    try {
      var contract = await getDeployedContract();
      final ethFunction = contract.function('updateHealthRecord');
      final credentials = EthPrivateKey.fromHex(dotenv.env['PRIVATE_KEY']!);
      Transaction tx = Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: [EthereumAddress.fromHex(patientAddr), cid],
        from: EthereumAddress.fromHex(patientAddr),
        gasPrice: EtherAmount.inWei(
          BigInt.from(5000000),
        ),
      );
      print('Sending apprve tx');
      final result = await ethClient.sendTransaction(
        credentials as Credentials,
        tx,
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );
      print('This is the updateHealthRecord() ethUtil:${result}');
      if (await waitForConfirmation(result)) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print('Error in updateHealthRecord() ethUtil:${err}');
      return false;
    }
  }

  Future<DeployedContract> getDeployedContract() async {
    var abi = await rootBundle.loadString('assets/abi.json');
    final contract = DeployedContract(
      ContractAbi.fromJson(abi.toString(), 'HealthRecord'),
      EthereumAddress.fromHex(contractAddress!),
    );
    return contract;
  }
}
