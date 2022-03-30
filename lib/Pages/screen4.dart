import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ble_controller/services/DatabaseQueries.dart';

class Screen4 extends StatefulWidget {
  const Screen4({Key? key}) : super(key: key);

  @override
  _Screen4State createState() => _Screen4State();
}

int time1 = 0;
int time2 = 0;
String name5 = "B5";

class _Screen4State extends State<Screen4> {
  dynamic details; /* = {
    'deviceId': 2,
    'deviceName': "ESP32",
    'button1': "Open",
    'button2': "Close",
    'button3': "Manual",
    'button4': "Default",
    'button5': "Pet",
    'ipAddress': "details['ipAddress']",
    'status' : "0000",
  };*/
  late String name1;
  late String name2;
  late String name3;
  late String name4;
  late String name5;
  late String deviceName;
  late String ip;
  late String status;
  bool button1 = false;
  bool button2 = false;
  bool button3 = false;
  bool button4 = false;
  String str = '1';
  late String id;
  var colors = new List<Color>.filled(5, Colors.red);
  var button = new List<bool>.filled(4, false, growable: false);
  late TextEditingController textControl1;
  late TextEditingController textControl2;
  late TextEditingController textControl3;
  late TextEditingController textControl4;
  late TextEditingController textControl5;
  late TextEditingController nameControl;

  @override
  Widget build(BuildContext context) {
    if (str == '1') {
      details = ModalRoute.of(context)!.settings.arguments;
      print(details);
      name1 = details['button1'];
      name2 = details['button2'];
      name3 = details['button3'];
      name4 = details['button4'];
      name5 = details['button5'];
      textControl1 = new TextEditingController(text: name1);
      textControl2 = new TextEditingController(text: name2);
      textControl3 = new TextEditingController(text: name3);
      textControl4 = new TextEditingController(text: name4);
      textControl5 = new TextEditingController(text: name5);
      deviceName = details['deviceName'];
      nameControl = new TextEditingController(text: deviceName);
      ip = details['ipAddress'];
      status = details['status'];
      id = details['deviceId'];
      for (int i = 0; i < 4; i++) {
        if (status[i] == '0') {
          button[i] = false;
          colors[i] = Colors.red;
        } else {
          button[i] = true;
          colors[i] = Colors.green;
        }
      }
      str = '2';
      //status get karna hai ip se
    }
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
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
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, {
            "device" : deviceName,
          });
          return false;
        },
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/watermark.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
            child: Column (
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    onEditingComplete: () {
                      deviceName = nameControl.text;
                      DatabaseConnection.instance.update(id, deviceName, [name1,name2,name3,name4,name5], ip);
                      post(Uri.parse('${ip}Name'), body: deviceName);
                    },
                    textAlign: TextAlign.center,
                    controller: nameControl,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox()
                ),
                Expanded(
                  flex: 6,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 35,
                        child: Container(
                          child: Card(
                            elevation: 20,
                            shadowColor: Colors.lightBlue,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: colors[0],
                                width: 8.0,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.lightBlue,
                            child: ListTile(
                              autofocus: !button1,
                              onLongPress: () {
                                button1 = true;
                                setState(() {

                                });
                              },
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(1, 3, 1, 1),
                                      child: Text(
                                        name1,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: OverflowBox(
                                          minWidth: 0.0,
                                          minHeight: 0.0,
                                          child: new Image(
                                            color: Colors.green[700],
                                            image: new AssetImage('assets/B1.jpg'),
                                            fit: BoxFit.cover
                                          )
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                ],
                              ),
                              onTap: () async {
                                if(colors[0] == Colors.red) {
                                  Response response = await post(Uri.parse('${ip}B1'), body: "1");
                                  if (response.body == "Ok") {
                                    colors[0] = Colors.green;
                                    colors[1] = Colors.red;
                                    colors[2] = Colors.red;
                                    colors[3] = Colors.red;
                                    button[0] = true;
                                  }
                                  setState(() { });
                                }
                              },
                            ),
                          ),
                          /*decoration: new BoxDecoration(
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black,
                                blurRadius: 20.0,
                              ),
                            ],
                          ),*/
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 35,
                        child: Container(
                          child: Card(
                            elevation: 20,
                            shadowColor: Colors.lightBlue,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: colors[1],
                                width: 8.0,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.lightBlue,
                            child: ListTile(
                              autofocus: !button2,
                              onLongPress: () {
                                button2 = true;
                                setState(() {

                                });
                              },
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(1, 3, 1, 1),
                                      child: Text(
                                        name2,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: OverflowBox(
                                        minWidth: 0.0,
                                        minHeight: 0.0,
                                        child: new Image(
                                          color: Colors.red[900],
                                            image: new AssetImage('assets/B2.png'),
                                            fit: BoxFit.cover
                                        )
                                      ),
                                      /*decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/B2.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),*/
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                ],
                              ),
                              onTap: () async {
                                if(colors[1] == Colors.red) {
                                  Response response = await post(Uri.parse('${ip}B2'), body: "1");
                                  if (response.body == "Ok") {
                                    colors[0] = Colors.red;
                                    colors[1] = Colors.green;
                                    colors[2] = Colors.red;
                                    colors[3] = Colors.red;
                                    button[1] = true;
                                  }
                                  setState(() { });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: SizedBox()
                ),
                Expanded(
                  flex: 6,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 20,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 35,
                        child: Card(
                          elevation: 20,
                          shadowColor: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: colors[4],
                              width: 8.0,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.lightBlue,
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      name5,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: OverflowBox(
                                        minWidth: 0.0,
                                        minHeight: 0.0,
                                        child: new Image(
                                            image: new AssetImage('assets/B5.png'),
                                            fit: BoxFit.cover
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 14,
                                ),
                              ],
                            ),
                            onTap: () async {
                              String payload = "{'t1':'$time1','t2':'$time2'}";
                              Response response = await post(Uri.parse('${ip}B5'), body: payload);
                              if(response.body == 'Ok'){
                                colors[0] = Colors.red;
                                colors[1] = Colors.red;
                                colors[2] = Colors.red;
                                colors[3] = Colors.red;
                                colors[4] = Colors.green;
                                setState(() { });
                              }
                              await Future.delayed(Duration(seconds: (time1 + time2 + 3)));
                              colors[4] = Colors.red;
                              setState(() {});
                            },
                            onLongPress: () async {
                              await showAlert(context, ip);
                              await Future.delayed(Duration(seconds: 10));
                              //time1 = obj['t1'];
                              //time2 = obj['t2'];
                              setState(() {});
                            }
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 20,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: SizedBox()
                ),
                Expanded(
                  flex: 6,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 35,
                        child: Card(
                          elevation: 20,
                          shadowColor: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: colors[2],
                              width: 8.0,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.lightBlue,
                          child: ListTile(
                            autofocus: !button3,
                            onLongPress: () {
                              button3 = true;
                              setState(() {

                              });
                            },
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(1, 3, 1, 1),
                                    child: Text(
                                      name3,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: OverflowBox(
                                        minWidth: 0.0,
                                        minHeight: 0.0,
                                        child: new Image(
                                          color: Colors.blue[900],
                                          image: new AssetImage('assets/B3.png'),
                                          fit: BoxFit.cover
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 14,
                                ),
                              ],
                            ),
                            onTap: () async {
                              if(colors[2] == Colors.red) {
                                Response response = await post(Uri.parse('${ip}B3'), body: "1");
                                if (response.body == "Ok") {
                                  colors[0] = Colors.red;
                                  colors[1] = Colors.red;
                                  colors[2] = Colors.green;
                                  colors[3] = Colors.red;
                                  button[2] = true;
                                }
                                setState(() { });
                              }
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 35,
                        child: Card(
                          elevation: 20,
                          shadowColor: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: colors[3],
                              width: 8.0,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.lightBlue,
                          child: ListTile(
                            autofocus: !button4,
                            onLongPress: () {
                              button4 = true;
                              setState(() {

                              });
                            },
                            title: Center(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                onEditingComplete: () {
                                  button4 = false;
                                  name4 = textControl4.text;
                                  DatabaseConnection.instance.update(id, deviceName, [name1, name2, name3, name4, name5], ip);
                                  setState(() { });
                                },
                                enabled: button4,
                                autofocus: !button4,
                                controller: textControl4,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onTap: () async {
                              if(colors[3] == Colors.red) {
                                Response response = await post(Uri.parse('${ip}B4'), body: "1");
                                if (response.body == "Ok") {
                                  colors[0] = Colors.red;
                                  colors[1] = Colors.red;
                                  colors[2] = Colors.red;
                                  colors[3] = Colors.green;
                                  button[3] = true;
                                }
                                setState(() { });
                              }
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: SizedBox()
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}

Future<void> showAlert(BuildContext context, String ip) async {
  String text = ' ';
  TextEditingController textControl1 = new TextEditingController(text: name5);
  TextEditingController textControl2 = new TextEditingController();
  TextEditingController textControl3 = new TextEditingController();
  late Response response;
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Column(
            children: [
              TextFormField(
                controller: textControl1,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      fontSize: 20,
                    )
                ),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: textControl2,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Open Time',
                    labelStyle: TextStyle(
                      fontSize: 20,
                    )
                ),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: textControl3,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Hold Open Time',
                    labelStyle: TextStyle(
                      fontSize: 20,
                    )
                ),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red[900],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FlatButton(
                      color: Colors.grey,
                      onPressed: () async {
                        try {
                          name5 = textControl1.text;
                          time1 = int.parse(textControl2.text);
                          time2 = int.parse(textControl3.text);
                          if (!(time1 > time2) && (time1>0 && time1<11) && (time2>0 && time2<60)) {
                            Navigator.pop(context);
                          }
                          else {
                            setState(() => text = "Incorrect input");
                          }
                        }
                        catch (ex) {
                          setState(() => text = "Incorrect input");
                        }
                      },
                      child: Text(
                        'Okay',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    )
  );
}
