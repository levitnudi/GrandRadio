import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'screens/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize without device test ids
  Admob.initialize();
  // Add a list of test ids.
  Admob.initialize(testDeviceIds: ['7D5AC2477D3CDC47DF7D8145F5553D6E']);
  // Run this before displaying any ad.
  Admob.requestTrackingAuthorization();
  runApp(RadioApp());
}

class RadioApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          // Radio subtitle
          bodyText1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          // Radio Title
          headline5: TextStyle(fontSize: 24.0),
        ),
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
