import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web3dart/web3dart.dart';
import '../modals/eth_utils.dart';

class EthereumUtilsProvider extends StateNotifier<AsyncValue<int>> {
  final EthereumUtils ethUtil = EthereumUtils();
  EthereumUtilsProvider() : super(AsyncValue.data(0)) {
    ethUtil.initialSetup();
  }

  Future<bool> hasRecord(String patientAddr) async {
    state = const AsyncValue.loading();
    print('INside the provider has record func ');
    try {
      final isPatient =
          await ethUtil.hasRecord(EthereumAddress.fromHex(patientAddr));
      state = AsyncValue.data(1);
      return isPatient;
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error inside the EthProvider: ${err}');
      return false;
    }
    // return false;
  }
}

final ethUtilsNotifierProvider =
    StateNotifierProvider<EthereumUtilsProvider, AsyncValue<int>>(
  (ref) {
    return EthereumUtilsProvider();
  },
);
