// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_web3/flutter_web3.dart';

// class MetamaskProvider extends StateNotifier<AsyncValue<int>> {
//   MetamaskProvider() : super(AsyncValue.loading());
//   static const operatingChain = 5;
//   String currentAddress = '';
//   int currentChain = -1;
//   bool get isEnabled => ethereum != null;
//   bool get isOperatingChain => currentChain == operatingChain;
//   bool get isConnected => isEnabled && currentAddress.isNotEmpty;

//   Future<void> connect() async {
//     state = AsyncValue.loading();
//     final accs = await ethereum!.requestAccount();
//     if (accs.isNotEmpty) currentAddress = accs.first;
//     currentChain = await ethereum!.getChainId();
//     print('THis is the address${currentAddress} and chain id: ${currentChain}');
//     state = AsyncValue.data(1);
//     // notifyListeners();
//   }

//   void reset() {
//     state = AsyncValue.loading();
//     currentAddress = '';
//     currentChain = -1;
//     state = AsyncValue.data(1);
//     // notifyListeners();
//   }

//   void start() {
//     if (isEnabled) {
//       ethereum!.onAccountsChanged((accounts) {
//         reset();
//       });
//       ethereum!.onChainChanged((chainId) {
//         reset();
//       });
//     }
//   }
// }

// final metamaskNotiferProvider =
//     StateNotifierProvider<MetamaskProvider, AsyncValue<int>>(
//   (ref) {
//     return MetamaskProvider();
//   },
// );
