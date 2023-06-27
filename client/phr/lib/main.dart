import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:riverpod/riverpod.dart';
import './screens/login_screen.dart';
import './screens/home_screen.dart';
import './screens/create_record.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PHR',
      theme: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.light().copyWith(
            primary: Color(
              0xff004dea,
            ),
            // background: Color(0x0a1c1b1f),
            // background: Color(0xff17171b),
            background: Colors.black87,
            // background: Color.fromRGBO(0, 77, 234, 0.4),
            onBackground: Colors.white,
            surface: Color.fromARGB(255, 55, 50, 50),
            // surface: Color.fromARGB(157, 44, 44, 48),
            // surface: Color.fromARGB(110, 127, 126, 126),
            // onSurface: Colors.white,
            outline: Color(
              0xff767680,
            )
            // secondary: Color(
            //   0xff27272c,
            // ),
            // onBackground: Colors.red,
            ),
        // ColorScheme.fromSeed(
        //   seedColor: Color(0xFF004DEA),
        //   // brightness: Brightness.dark,
        //   // primary: Color.fromARGB(255, 0, 85, 255),
        //   // background: Color(
        //   //   0x181818,
        //   // ),
        //   // onBackground: Color(
        //   //   0x404040,
        //   // ),
        //   // inversePrimary: Colors.red,
        //   // secondary: Colors.red, tertiary: Colors.red,
        //   // inverseSurface: Colors.red,
        //   // onPrimary: Colors.red,
        //   // secondary: Color(
        //   //   0x27272c,
        //   // )
        //   // background: Color.fromARGB(
        //   //   255,
        //   //   28,
        //   //   28,
        //   //   28,
        //   // ),
        // ),
        textTheme: TextTheme().copyWith(
            bodyText1: TextStyle(
              color: Colors.white,
            ),
            bodyText2: TextStyle().copyWith(
              color: Colors.white,
            ),
            headline1: TextStyle(
              color: Colors.white,
            ),
            headline2: TextStyle(
              color: Colors.white,
            ),
            headline3: TextStyle(
              color: Colors.white,
            )
            // displaySmall: TextStyle(
            //   color: Colors.white,
            // ),
            ),
      ),
      home: LoginScreen(),
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        //   '/': (context) => LoginScreen(),
        CreateRecord.routeName: (context) => CreateRecord(),
      },
    );
  }
}
