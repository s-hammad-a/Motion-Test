import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ble_controller/services/DatabaseQueries.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<void> loadScreen() async {
    dynamic devices;
    int count = 0;
    Future<void> readDevice() async{
      devices = await DatabaseConnection.instance.readAllDevices();
      print(devices);
      count = devices.length;
    }
    await readDevice();
    await Future.delayed(Duration(seconds: 3));
    try {
      Navigator.pushReplacementNamed(context, '/screen1', arguments: {
        'count' : count,
        'devices' : devices,
      });
    }
    catch(e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    loadScreen();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Motion App',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SizedBox.expand(
            child: FittedBox(
              child: Image(
                image: AssetImage("assets/logo.jpg"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

