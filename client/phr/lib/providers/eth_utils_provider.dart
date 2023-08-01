// import 'dart:js_interop';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web3dart/web3dart.dart';
import '../modals/eth_utils.dart';
import '../modals/doctor.dart';

class EthereumUtilsProvider extends StateNotifier<AsyncValue<int>> {
  final EthereumUtils ethUtil = EthereumUtils();
  EthereumUtilsProvider() : super(AsyncValue.data(0)) {
    ethUtil.initialSetup();
  }

  Future getDoctor(String doctorAdd) async {
    state = const AsyncValue.loading();
    try {
      final result = await ethUtil.getDoctor(doctorAdd);
      if (result == null || result == false) {
        state = AsyncValue.data(1);
        return null;
      }
      state = AsyncValue.data(1);
      return result;
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error in getDoctor() in eth_utils_provider: ${err}');
      return null;
    }
  }

  Future getDoctorForPatient(String patientAddr) async {
    // state=const
    try {
      final result = await ethUtil.getDoctorForPatient(patientAddr);
      return result;
    } catch (err) {
      print('Error in getDoctorForPatient() in eth_utils_provider: ${err}');
    }
  }

  Future addNewDoctor(Doctor doctor, String publicKey) async {
    state = const AsyncValue.loading();
    try {
      final result = await ethUtil.addNewDoctor(doctor, publicKey);
      if (result == null || result == false) return false;
      print('Eth util: new doctor added...');
      return true;
    } catch (err) {
      print('Error in addNewDoctor() in eth_utils_provider: ${err}');
      return false;
    }
  }

  Future<bool> getIsDoctor(String doctorAddr) async {
    state = const AsyncValue.loading();
    try {
      final result =
          await ethUtil.getIsDoctor(EthereumAddress.fromHex(doctorAddr));
      if (result == null || result == false) return false;
      //returning false and not result because result can be null
      return true;
    } catch (err) {
      print('Error in hasDoctor() in eth_utils_provider: ${err}');
      return false;
    }
  }

  Future<bool> getIsPatient(String patientAddr) async {
    state = const AsyncValue.loading();
    print('INside the provider has record func ');
    try {
      final isPatient =
          await ethUtil.getIsPatient(EthereumAddress.fromHex(patientAddr));
      state = AsyncValue.data(1);
      return isPatient;
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error inside the EthProvider: ${err}');
      return false;
    }
    // return false;
  }

  Future<bool> addNewRecord(String patientAddr, String cid) async {
    state = const AsyncValue.loading();
    try {
      final result = await ethUtil.addNewPatient(patientAddr, cid);
      state = AsyncValue.data(1);
      return result;
    } catch (err) {
      print('Error inside the addNewRecord function of ethProvider:${err}');
      return false;
    }
  }

  Future getPatient(String patientAddr) async {
    state = const AsyncValue.loading();
    try {
      final cid = await ethUtil.getPatient(patientAddr);
      print('CId inside getPatient ethProvider ${cid}');
      if (cid == null) {
        print('CID returned is null');
        return '';
      }
      return cid;
    } catch (err) {
      print('Error insde ethProvider ${err}');
      return '';
    }
  }

  Future approveDoctor(String doctorAddr, String patientAddr) async {
    state = const AsyncValue.loading();
    try {
      final result = await ethUtil.approveDoctor(doctorAddr, patientAddr);
      print('approveDoctor() eth_utils_provider finished...:${result}');
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Erros inside the approveDoctor() of eth_util_provider:${err}');
    }
  }

  Future updateHealthRecord(String patientAddr, String cid) async {
    state = AsyncValue.loading();
    try {
      final result = await ethUtil.updateHealthRecord(patientAddr, cid);
      // print('')
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error in updateHealthRecord() eth_util_provider:${err}');
    }
  }
}

final ethUtilsNotifierProvider =
    StateNotifierProvider<EthereumUtilsProvider, AsyncValue<int>>(
  (ref) {
    return EthereumUtilsProvider();
  },
);
