import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:phr/screens/appointments_screen.dart';
import 'package:phr/screens/approve_appointment_screen.dart';
import 'package:phr/screens/update_health_record_screen.dart';
import './screens/login_screen.dart';
import './screens/home_screen.dart';
import './screens/create_record.dart';
import './screens/create_doctor_record.dart';
import './screens/doctor_home_screen.dart';
import './screens/approve_doctor_screen.dart';
import './screens/condition_screen.dart';
import './screens/add_prescription.dart';
import './screens/prescriptions.dart';
import './screens/submit_prescription.dart';
import './screens/approve_prescription.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message${message.messageId}');
  print(message.data);
  print(message.notification?.title);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PHR',
      theme: ThemeData(
        primarySwatch: Colors.green, // Choose your primary color swatch

        // Define the default font family for the entire app
        fontFamily: 'Roboto',

        // Define the text theme for the app
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          headline2: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
          headline3: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
          headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          headline5: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          subtitle1: TextStyle(fontSize: 16.0),
          subtitle2: TextStyle(fontSize: 14.0),
          // bodyText1: TextStyle(fontSize: 16.0, color: Colors.white),
          bodyText2: TextStyle(fontSize: 14.0, color: Colors.white),
          caption: TextStyle(fontSize: 12.0),
          button: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),

        // Use colorScheme to define your color palette
        colorScheme: ColorScheme.light(
          primary: Colors
              .green, // Customize the primary color (same as primarySwatch)
          secondary: Colors.deepOrange, // Customize the secondary color
          background: Colors.white, // Customize the background color
          onPrimary:
              Colors.white, // Customize the color for elements on primary color
          onSecondary: Colors
              .white, // Customize the color for elements on secondary color
          onBackground:
              Colors.black, // Customize the color for elements on background
        ),

        // ... (Other theme properties remain the same)

// With this update, we've changed the primary color from blue to green in the colorScheme, which will affect various UI elements throughout the app, such as app bars, buttons, and more. You can choose any color you like by using the appropriate Colors constant from Flutter.

        // Define the app bar theme
        appBarTheme: AppBarTheme(
          color: Colors
              .amber, // Use primary color from colorScheme as app bar color
          elevation: 0, // Remove the shadow from the app bar
          iconTheme:
              IconThemeData(color: Colors.black), // Customize the app bar icons
          titleTextStyle: TextStyle(
            color: Colors.black, // Customize the app bar text color
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Define the button theme
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(8.0), // Customize the button shape
          ),
          textTheme: ButtonTextTheme.primary,
        ),

        // Define the card theme
        cardTheme: CardTheme(
          color: Colors.black87,
          elevation: 2, // Customize the card elevation
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(35.0), // Customize the card shape
          ),
          surfaceTintColor: Colors.red,
        ),

        // Define the input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(8.0), // Customize the text field border
          ),
        ),

        // Define the floating action button theme
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor:
              Colors.greenAccent, // Use secondary color from colorScheme
          foregroundColor: Colors.white, // Customize the FAB icon color
        ),

        // Define the bottom navigation bar theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.blue, // Customize the selected item color
          unselectedItemColor:
              Colors.grey, // Customize the unselected item color
          showUnselectedLabels: true, // Show labels for unselected items
        ),
      ),

      //----------------------------------------------------------
      // ThemeData(
      // primarySwatch: Colors.blue, // Choose your primary color swatch
      // colorScheme: ,
      // Define the default font family for the entire app
      // fontFamily: 'Roboto',

      // Define the text theme for the app
      // textTheme:
      // TextTheme(
      //     headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      //     headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
      //     headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      //     headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      //     headline5: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      //     headline6: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      //     subtitle1: TextStyle(fontSize: 16.0),
      //     subtitle2: TextStyle(fontSize: 14.0),
      //     bodyText1: TextStyle(fontSize: 16.0),
      //     bodyText2: TextStyle(fontSize: 14.0),
      //     caption: TextStyle(fontSize: 12.0),
      //     button: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      //   ),

      //   // Define the app bar theme
      //   appBarTheme: AppBarTheme(
      //       color: Colors.blue, // Customize the app bar color
      //       elevation: 0, // Remove the shadow from the app bar
      //       iconTheme: IconThemeData(color: Colors.black),
      //       titleTextStyle: TextStyle(
      //         color: Colors.black,
      //         fontSize: 20,
      //         fontWeight: FontWeight.bold,
      //       ) // Customize the app bar icons
      //       // textTheme: TextTheme(
      //       //   headline6: TextStyle(
      //       //     color: Colors.white, // Customize the app bar text color
      //       //     fontSize: 20.0,
      //       //     fontWeight: FontWeight.bold,
      //       //   ),
      //       // ),
      //       ),

      //   // Define the button theme
      //   buttonTheme: ButtonThemeData(
      //     buttonColor: Colors.greenAccent, // Customize the button color
      //     shape: RoundedRectangleBorder(
      //       borderRadius:
      //           BorderRadius.circular(8.0), // Customize the button shape
      //     ),
      //     textTheme: ButtonTextTheme.primary,
      //   ),

      //   // Define the card theme
      //   cardTheme: CardTheme(
      //     surfaceTintColor: Colors.black,
      //     elevation: 2, // Customize the card elevation
      //     shape: RoundedRectangleBorder(
      //       borderRadius:
      //           BorderRadius.circular(8.0), // Customize the card shape
      //     ),
      //   ),

      //   // Define the input decoration theme
      //   inputDecorationTheme: InputDecorationTheme(
      //     border: OutlineInputBorder(
      //       borderRadius:
      //           BorderRadius.circular(8.0), // Customize the text field border
      //     ),
      //   ),

      //   // Define the floating action button theme
      //   floatingActionButtonTheme: FloatingActionButtonThemeData(
      //     backgroundColor:
      //         Colors.greenAccent, // Customize the FAB background color
      //     foregroundColor: Colors.white, // Customize the FAB icon color
      //   ),

      //   // Define the bottom navigation bar theme
      //   bottomNavigationBarTheme: BottomNavigationBarThemeData(
      //     selectedItemColor: Colors.blue, // Customize the selected item color
      //     unselectedItemColor:
      //         Colors.grey, // Customize the unselected item color
      //     showUnselectedLabels: true, // Show labels for unselected items
      //   ),
      // ),

      ///////////////////------------------------------------------
      // ThemeData.from(
      //   useMaterial3: true,
      //   colorScheme: ColorScheme.light().copyWith(
      //     primary: Color(
      //       0xff004dea,
      //     ),
      //     // background: Color(0x0a1c1b1f),
      //     // background: Color(0xff17171b),
      //     // background: Colors.black87,
      //     // background: Color.fromRGBO(0, 77, 234, 0.4),
      //     // onBackground: Colors.white,
      //     // surface: Color.fromARGB(255, 55, 50, 50),
      //     // surface: Color.fromARGB(157, 44, 44, 48),
      //     // surface: Color.fromARGB(110, 127, 126, 126),
      //     // onSurface: Colors.white,
      //     // outline: Color(
      //     // 0xff767680,
      //     // )
      //     // secondary: Color(
      //     //   0xff27272c,
      //     // ),
      //     // onBackground: Colors.red,
      //   ),
      //   // ColorScheme.fromSeed(
      //   //   seedColor: Color(0xFF004DEA),
      //   //   // brightness: Brightness.dark,
      //   //   // primary: Color.fromARGB(255, 0, 85, 255),
      //   //   // background: Color(
      //   //   //   0x181818,
      //   //   // ),
      //   //   // onBackground: Color(
      //   //   //   0x404040,
      //   //   // ),
      //   //   // inversePrimary: Colors.red,
      //   //   // secondary: Colors.red, tertiary: Colors.red,
      //   //   // inverseSurface: Colors.red,
      //   //   // onPrimary: Colors.red,
      //   //   // secondary: Color(
      //   //   //   0x27272c,
      //   //   // )
      //   //   // background: Color.fromARGB(
      //   //   //   255,
      //   //   //   28,
      //   //   //   28,
      //   //   //   28,
      //   //   // ),
      //   // // ),
      //   textTheme: TextTheme().copyWith(
      //       labelLarge: TextStyle(
      //         color: Colors.white,
      //       ),
      //       headlineSmall: TextStyle(
      //         color: Colors.white,
      //       )
      //       // bodyText2: TextStyle().copyWith(
      //       //   color: Colors.white,
      //       // ),
      //       //     headline1: TextStyle(
      //       //       color: Colors.white,
      //       //     ),
      //       //     headline2: TextStyle(
      //       //       color: Colors.white,
      //       //     ),
      //       //     headline3: TextStyle(
      //       //       color: Colors.white,
      //       //     )
      //       //     // displaySmall: TextStyle(
      //       //     //   color: Colors.white,
      //       //     // ),
      //       ),
      // ),
      home: const LoginScreen(),
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        //   '/': (context) => LoginScreen(),
        CreateRecord.routeName: (context) => CreateRecord(),
        DoctorHomeScreen.routeName: (context) => DoctorHomeScreen(),
        CreateDoctorRecord.routeName: (context) => const CreateDoctorRecord(),
        ApproveDoctorScreen.routeName: (context) => ApproveDoctorScreen(),
        UpdateHealthRecordScreen.routeName: (context) =>
            const UpdateHealthRecordScreen(),
        AppointmentsScreen.routeName: (context) => AppointmentsScreen(),
        ApproveAppointmentScreen.routeName: (context) =>
            ApproveAppointmentScreen(),
        ConditionScreen.routeName: (context) => ConditionScreen(),
        PrescriptionScreen.routeName: (context) => PrescriptionScreen(),
        AddPrescriptionScreen.routeName: (context) => AddPrescriptionScreen(),
        SubmitPrescriptionScreen.routeName: (context) =>
            SubmitPrescriptionScreen(),
        ApprovePrescription.routeName: (context) => ApprovePrescription(),
      },
    );
  }
}
