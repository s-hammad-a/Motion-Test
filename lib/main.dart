import 'package:flutter/material.dart';
import 'package:ble_controller/Pages/screen1.dart';
import 'package:ble_controller/Pages/screen2.dart';
import 'package:ble_controller/Pages/screen3.dart';
import 'package:ble_controller/Pages/screen4.dart';
import 'package:ble_controller/Pages/loadingScreen.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/loadingScreen',
      routes: {
        '/screen1': (context) => Screen1(),
        '/screen2': (context) => Screen2(),
        '/screen3': (context) => Screen3(),
        '/screen4': (context) => Screen4(),
        '/loadingScreen': (context) => LoadingScreen(),
      },
    )
  );
}




