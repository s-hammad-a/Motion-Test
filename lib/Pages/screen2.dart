import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';

class Screen2 extends StatefulWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  String ble = " ";
  bool button = true;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  //String feedback = "Tap to connect";
  int x = -1;
  Future<void> chawal () async {
    flutterBlue.scanResults.listen((results) {
      for (ScanResult dev in results) {
        print(dev.device.name);
      }
    });
  }

  Widget widgets(BluetoothDevice e) {
    if(e.name != ble) {
      return Text(
        "Tap to connect",
        style: TextStyle(
          fontSize: 10,
          color: Colors.black,
        ),
      );
    }
    else {
      return Text(
        "Connecting...",
        style: TextStyle(
          fontSize: 10,
          color: Colors.black,
        ),
      );
    }
  }

  Future<void> getDevices() async {
    //Stream results;
    // Start scanning
    flutterBlue.stopScan();
    print('heloo');
    await flutterBlue.startScan(timeout: Duration(seconds: 4));
    print('heloo1');
    flutterBlue.stopScan();
    print('heloo2');
    await chawal();
    //Future<List> devices = results.toList();
  }

  @override
  Widget build(BuildContext context) {
    bool check2 = false;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[350],
        image: DecorationImage(
          image: AssetImage('assets/watermark.png'),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: BottomAppBar (
          color: Colors.blue[700],
          child: Container(
            height: 60.0,
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Motion App',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: StreamBuilder<List<ScanResult>> (
          stream: flutterBlue.scanResults,
          builder: (c, snapshot) {
            return Column(
              children: snapshot.data!.map((e) {
                List<String> list = e.advertisementData.serviceUuids;
                bool check = false;
                for (int i = 0; i < list.length; i++) {
                  if (list[i] == "4401188a-1ad8-11ec-9621-0242ac130002") {
                    x = i;
                    check = true;
                    check2 = true;
                    break;
                  }
                }
                if (check) {
                  return Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: ListTile(
                            subtitle: widgets(e.device),
                            isThreeLine: false,
                            minVerticalPadding: 25,
                            onTap: () async {
                              setState(() {
                                ble = e.device.name;
                              });
                              e.device.state.listen((event) {

                              });
                              await e.device.connect(autoConnect: false, timeout: Duration(seconds: 5));
                              List<BluetoothDevice> obj = await flutterBlue
                                  .connectedDevices;
                              if (obj[0] == e.device) {
                                setState(() {
                                  ble = "Connected";
                                });
                                await Navigator.pushNamed(
                                  context, '/screen3', arguments: {
                                    'device': obj[0],
                                  }
                                );
                                await e.device.disconnect();
                                setState(() {
                                  ble = " ";
                                });
                              }
                              else {
                                ble = " ";
                                print("not working");
                              }
                            },
                            title: Text(
                              e.device.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                /*else if (!check2) {
                  check2 = true;
                  return Center(
                    child: Text(
                      'No Device Found !!!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }*/
                else {
                  return SizedBox.shrink();
                }
              }
              ).toList(),
            );
          }
        ),

        floatingActionButton: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 5),
            //color: Colors.indigo[900],
            shape: BoxShape.circle,
          ),
          child: FittedBox(
            child: FloatingActionButton(
              elevation: 20,

              onPressed: () async {
                if (!(await flutterBlue.isAvailable)) {
                  showAlert(context, 'Bluetooth Not found');
                  setState(() {});
                }
                else if(!(await flutterBlue.isOn)) {
                  showAlert(context, 'Turn on Bluetooth');
                  setState(() {});
                }
                else if (button){
                  await getDevices();
                  setState(() {
                    button = false;
                  });
                  await Future.delayed(Duration(seconds: 4));
                  setState(() {
                    button = true;
                  });
                }
              },
              child: Icon(
                Icons.bluetooth,
                size: 40,
              ),
              backgroundColor: Colors.indigo[800],
              foregroundColor: Colors.white,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      ),
    );
  }
  void showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            message,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      )
    );
  }
}

