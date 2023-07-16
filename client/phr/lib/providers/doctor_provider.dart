import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phr/providers/eth_utils_provider.dart';
import 'package:phr/providers/rsa_provider.dart';
import '../modals/doctor.dart';

class DoctorProvider extends StateNotifier<AsyncValue<Doctor>> {
  late Doctor doctor;
  StateNotifierProviderRef ref;
  DoctorProvider(this.ref) : super(const AsyncValue.loading());

  Future getDoctor(String doctorAddr) async {
    state = AsyncValue.loading();
    try {
      final result = await ref
          .read(ethUtilsNotifierProvider.notifier)
          .getDoctor(doctorAddr);
      if (result == null) {
        throw Exception(['Not able to get the doctor']);
        // state = AsyncValue.error(Error., StackTrace.current);
        print('Sorry not able to get the doctor...');
        return false;
      }
      print('THis is the doctor${result}');
      doctor = Doctor(
        email: result[1],
        name: result[0],
        address: result[3].toString(),
        imageUrl: result[2],
      );
      print('This is the doctor object${doctor}');
      state = AsyncValue.data(doctor);
      return true;
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error in getDoctor() in doctorProvider: ${err}');
      return false;
    }
  }

  Future createDoctor(
    String name,
    String email,
    String imageUrl,
    String address,
  ) async {
    ref.read(rsaKeyNotifierProvider.notifier).createKeyPair(1);
    doctor = Doctor(
      name: name,
      email: email,
      imageUrl: imageUrl,
      address: address,
    );
    try {
      await ref.read(rsaKeyNotifierProvider.notifier).createKeyPair(1);
      var publicKey =
          await ref.read(rsaKeyNotifierProvider.notifier).getPublicKey;
      final result = await ref
          .read(ethUtilsNotifierProvider.notifier)
          .addNewDoctor(doctor, publicKey);
      if (result == null || result == false) return false;
      return true;
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error in createDoctor() in doctor_provider.dart: ${err}');
      return false;
    }
  }
}

final doctorNotifierProvider =
    StateNotifierProvider<DoctorProvider, AsyncValue<Doctor>>((ref) {
  return DoctorProvider(ref);
});
