import 'package:flutter/material.dart';
import 'package:ble_controller/services/DatabaseQueries.dart';
import 'package:http/http.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  dynamic devices;
  int count = 0;
  String str = '1';

  void data(BuildContext context) async {
    dynamic obj = await DatabaseConnection.instance.readDevice();
    int ids = obj['deviceId'];
    dynamic details = await DatabaseConnection.instance.readDevices(ids);
    str = '2';
    setState(() {
      count = 1;
      str = '2';
      devices = details;
    });
  }
  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    if(str == '1'){
      devices = args['devices'];
      print(devices);
      count = args['count'];
    }
    return Scaffold(
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
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: FloatingActionButton.extended(
                      onPressed: () async {
                        await Navigator.pushNamed(context, '/screen2');
                        devices = await DatabaseConnection.instance.readAllDevices();
                        str = '2';
                        count = devices.length;
                        setState(() {

                        });
                        //data(context);
                      },
                      label: Text(
                        'Add New Device',
                      ),
                      icon: Icon(Icons.add),
                      backgroundColor: Colors.grey[800],
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: ListView.builder(
                    itemCount: count,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.blue,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 9,
                              child: ListTile(
                                onTap: () async {
                                  String ip =
                                      '${devices[index]['ipAddress']}';
                                  try {
                                    Response response = await get(
                                        Uri.parse('${ip}status'));
                                    print(response.body);
                                    dynamic x = await Navigator.pushNamed(
                                        context, '/screen4',
                                        arguments: {
                                          'deviceId': devices[index]
                                              ['deviceId'],
                                          'deviceName': devices[index]
                                              ['deviceName'],
                                          'button1': devices[index]
                                              ['button1'],
                                          'button2': devices[index]
                                              ['button2'],
                                          'button3': devices[index]
                                              ['button3'],
                                          'button4': devices[index]
                                              ['button4'],
                                          'button5': devices[index]
                                              ['button5'],
                                          'ipAddress': devices[index]
                                              ['ipAddress'],
                                          'status': response.body,
                                        });
                                    print(x);
                                    str = '2';
                                    print(devices[index]['deviceName']);
                                    devices = await DatabaseConnection.instance.readAllDevices();
                                    setState(() {
                                    });
                                  } catch (ex) {
                                    print(ex);
                                  }
                                },
                                title: Center(
                                  child: Text(
                                    devices[index]['deviceName'],
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: FlatButton(
                                  color: Colors.transparent,
                                  onPressed: () async {
                                    await DatabaseConnection.instance.delete(
                                        devices[index]['deviceId']);
                                    devices = await DatabaseConnection.instance.readAllDevices();
                                    str = '2';
                                    count = devices.length;
                                    setState(() {

                                    });
                                  },
                                  child: Icon(
                                    Icons.cancel,
                                  )),
                            )
                          ],
                        ),
                      );
                    }
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
