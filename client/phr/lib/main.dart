import 'package:flutter/material.dart';
import './screens/login_screen.dart';
import './screens/home_screen.dart';

void main() {
  runApp(const MyApp());
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 0, 85, 255),
          // background: Color.fromARGB(
          //   255,
          //   28,
          //   28,
          //   28,
          // ),
        ),
        textTheme: TextTheme().copyWith(
            bodyText1: TextStyle(color: Colors.white),
            bodyText2: TextStyle().copyWith(
              color: Colors.white,
            )),
      ),
      home: LoginScreen(),
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        //   '/': (context) => LoginScreen(),
      },
    );
  }
}
