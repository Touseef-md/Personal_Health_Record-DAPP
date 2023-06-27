import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EthereumUtils {
  late http.Client httpClient;
  late Web3Client ethClient;
  final contractAddress = dotenv.env['CONTRACT_ADDRESS'];
  // late final _contract;
  void initialSetup() {
    httpClient = http.Client();
    String infura =
        'https://goerli.infura.io/v3/${dotenv.env['INFURA_API_KEY']}';
    ethClient = Web3Client(infura, httpClient);
  }

  Future<bool> hasRecord(EthereumAddress patientAddr) async {
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

  Future<DeployedContract> getDeployedContract() async {
    var abi = await rootBundle.loadString('assets/abi.json');
    final contract = DeployedContract(
      ContractAbi.fromJson(abi.toString(), 'HealthRecord'),
      EthereumAddress.fromHex(contractAddress!),
    );
    return contract;
  }
}
