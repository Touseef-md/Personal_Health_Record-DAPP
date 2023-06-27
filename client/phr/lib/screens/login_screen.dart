import 'package:flutter/material.dart';
// import 'package:phr/providers/normal_provider.dart';
// import 'package:phr/providers/normalprovider2.dart';
// import 'package:phr/providers/testprovider.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/eth_utils_provider.dart';

import './home_screen.dart';
import './create_record.dart';
import '../widgets/info.dart';
import '../widgets/button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  SessionStatus? _session;
  var _uri;
  var connector = WalletConnect(
    bridge: 'https://bridge.walletconnect.org',
    clientMeta: const PeerMeta(
      name: 'My App',
      description: 'An app for converting pictures to NFT',
      url: 'https://walletconnect.org',
      icons: [
        'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
      ],
    ),
  );

  // void normalFunc() {
  //   // ref.read(normalProvider.notifier).increment();
  //   // print(ref.read(normalProvider));
  //   print('normal func');
  //   print(ref.read(ethUtilsNotifierProvider));
  //   // print(ref.read(normal2StateNotifier));
  // }

  checkHealthRecord(String patientAddr) async {
    // connector.
    // final isPatient =
    // await ref.read(ethUtilsProvider.notifier).hasRecord(patientAddr);
    print('CHeck healt record');
    print(await ref
        .read(ethUtilsNotifierProvider.notifier)
        .hasRecord(patientAddr));
    if (await ref
        .read(ethUtilsNotifierProvider.notifier)
        .hasRecord(patientAddr)) {
      Navigator.pushNamed(context, HomeScreen.routeName);
    } else {
      Navigator.pushNamed(context, CreateRecord.routeName);
    }
    // final isPatient = await ref.read(ethUtilsProvider.notifier).hasRecord(patientAddr);
    // print('THis is teh patient in lgoin screen${isPatient}');
    // '0x13D8B8eCf020D746Df2B81edEC16Be3FB6d03b73'
    // connector
    // EthereumWalletConnectProvider provider =
    // EthereumWalletConnectProvider(connector);
    // connector.
    // provider.
    // provider.
  }

  loginUsingMetamask(BuildContext context) async {
    if (!connector.connected) {
      try {
        var session = await connector.createSession(
          onDisplayUri: (uri) async {
            _uri = uri;
            print('chsd');
            // if (
            await canLaunch(_uri);
            // ) {
            print('can launch successfull');
            await launch('$_uri&mode=external');
            print('launch successfull');
            // else {
            //   print('error occured');
            // }
            // }
            // else {
            //   print('error occured');
            // }
          },
        );
        print(session.accounts[0]);
        print(session.chainId);
        setState(() {
          _session = session;
        });
        checkHealthRecord(session.accounts[0]);
        // await checkHealthRecord(session.accounts[0], ref);
        // normalFunc();
      } catch (exp) {
        print(exp);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    connector.on(
        'connect',
        (session) => setState(
              () {
                _session = _session;
              },
            ));
    connector.on(
        'session_update',
        (payload) => setState(() {
              _session = payload as SessionStatus;
              print('THis is the payload');
              print(payload);
              // print(payload!.accounts[0]);
              // print(payload!.);
            }));
    connector.on(
        'disconnect',
        (payload) => setState(() {
              _session = null;
            }));
    return Scaffold(
        // backgroundColor: Theme.of(context).colorScheme.onBackground,
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).colorScheme.primary,
        // ),
        body: SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(
              10,
              60,
              10,
              10,
            ),
            child: Text(
              'Future of Health Care',
              style: Theme.of(context).textTheme.headline1!.copyWith(
                    // color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  // margin: EdgeInsets.symmetric(
                  //   horizontal: 10,
                  //   vertical: 10,
                  // ),
                  height: 500,
                  decoration: BoxDecoration(
                    // color: Colors.grey,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: AssetImage(
                        'assets/images/LoginImage.jpg',
                      ),
                    ),
                  ),
                  // child: Image.asset(
                  //   'assets/images/LoginImage.jpg',
                  // ),
                ),
                if (_session == null)
                  ButtonWidget(
                    text: 'Connect to Metamask',
                    onPress: () {
                      loginUsingMetamask(context);
                    },
                  ),
                if (_session != null)
                  Column(
                    children: [
                      InfoWidget(
                        text: ' Account Address :\n${_session!.accounts[0]}',
                      ),
                      InfoWidget(text: 'ChainId: ${_session!.chainId}')
                    ],
                  )
              ],
            ),
          ),
          if (_session != null)
            ButtonWidget(
              text: 'Press to Login',
              onPress: () {
                checkHealthRecord(_session!.accounts[0]);
                // normalFunc();
                // Navigator.pushNamed(context, HomeScreen.routeName);
              },
            ),
        ],
      ),
    ));
  }
}
