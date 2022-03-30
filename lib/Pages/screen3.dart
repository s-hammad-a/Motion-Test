import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:ble_controller/services/DatabaseQueries.dart';

class Screen3 extends StatefulWidget {
  const Screen3({Key? key}) : super(key: key);

  @override
  _Screen3State createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  String str = '1';
  TextEditingController ssidController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  Color color = Colors.grey;
  late BluetoothCharacteristic sendData;
  late BluetoothCharacteristic recieveIP;
  late BluetoothCharacteristic recieveStr;
  late BluetoothCharacteristic recieveStatus;
  bool check = false;
  late String deviceName;
  String ipAddress = ' ';
  String ipStr = ' ';
  @override
  Widget build(BuildContext context) {
    String payload = ' ';
    String status = ' ';
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    BluetoothDevice device = args!['device'];
    deviceName = device.name;
    Future<void> readCharacteristics() async {
      List<BluetoothService> services = await device.discoverServices();
      services.forEach((element) async {
        if(element.uuid.toString() == "4401188a-1ad8-11ec-9621-0242ac130002") {
          var characteristics = element.characteristics;
          for (BluetoothCharacteristic c in characteristics ) {
            if(c.uuid.toString() == "44011a92-1ad8-11ec-9621-0242ac130002") {
              sendData = c;
              await sendData.write(utf8.encode("{'A':'K','K':'331308381b7f11ec96210242ac130002'}"));
            }
            else if (c.uuid.toString() == "44011eca-1ad8-11ec-9621-0242ac130002") {
              recieveIP = c;
              await recieveIP.setNotifyValue(true);
              recieveIP.value.listen((value) {
                ipAddress = 'http://${utf8.decode(value)}/';
                print('chawal $ipAddress');
              });
              //ipAddress = utf8.decode(await recieveIP.read());
            }
            else if (c.uuid.toString() == "44011fc5-1ad8-11ec-9621-0242ac130002") {
              recieveStr = c;
              await recieveStr.setNotifyValue(true);
              recieveStr.value.listen((value) {
                ipStr = utf8.decode(value);
                print('ipStr $ipStr');
                if (ipStr.length > 8){
                  showAlert(context, 'Device Connected to WiFi');
                  check = true;
                  color = Colors.blue;
                  setState(() {

                  });
                }
                else {
                  //showAlert(context, 'Device Failed to Connect to WiFi');
                  //color = Colors.grey;
                }
              });
              //ipAddress = utf8.decode(await recieveIP.read());
            }
            else if (c.uuid.toString() == "44011fc4-1ad8-11ec-9621-0242ac130002") {
              recieveStatus = c;
              status = utf8.decode(await recieveStatus.read());
            }
          }
        }
      });
    }
    if(str=='1')
      readCharacteristics();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        title: Text(
          'Motion App',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/watermark.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.stretch,
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  alignment: Alignment.topCenter,
                  child: Text(
                    device.name,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment(-0.9,-1),
                  child: Text(
                    'WiFi Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: SizedBox(
                    height: 10,
                    width: 300,
                    child: TextFormField(
                      controller: ssidController,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'SSID',
                          labelStyle: TextStyle(
                            fontSize: 20,
                          )
                      ),
                    ),
                  ),
                )
              ),
              SizedBox(),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: SizedBox(
                    height: 10,
                    width: 300,
                    child: TextFormField(
                      controller: passController,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontSize: 20,
                          )
                      ),
                    ),
                  ),
                )
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  height: 30,
                  width: 60,
                  alignment: Alignment(0,-1),
                  child: FittedBox(
                    child: FloatingActionButton(
                      elevation: 10,
                      child: Icon(
                        Icons.send,
                        semanticLabel : 'Send',
                      ),
                      onPressed: () async {
                        showAlert(context, 'Waiting for ${device.name} to connect to WiFi....');
                        str='2';
                        setState(() {

                        });
                        payload = "{'A':'W','S':'${ssidController.text}','P':'${passController.text}'}";
                        await sendData.write(utf8.encode(payload));
                        //await Future.delayed(Duration(seconds: 10));
                        /*if(check) {
                          showAlert(context, 'Device Connected to WiFi');
                          color = Colors.blue;
                        }
                        else {
                          showAlert(context, 'Device Failed to Connect to WiFi');
                          color = Colors.grey;
                        }*/
                        str='2';
                        setState(() {

                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 2,
                        child: FlatButton(
                          color: Colors.blue,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 2,
                        child: FlatButton(
                          color: color,
                          onPressed: () async {
                            if(check) {
                              await DatabaseConnection.instance.create(device.id.toString() ,deviceName,
                                  ['Open', 'Close', 'Manual', 'Default', 'PET Mode'], (ipAddress + ipStr + '/'));
                              Navigator.popUntil(
                                  context, ModalRoute.withName('/screen1'));
                              //device.disconnect();
                            }
                          },
                          child: Text(
                              'Okay',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                    ],
                  ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

Future<void> showAlert(BuildContext context, String message) async {
  showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                message,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            );
          }
      )
  );
}