import 'package:flutter/material.dart';

class Screen5 extends StatefulWidget {
  const Screen5({Key? key}) : super(key: key);

  @override
  _Screen5State createState() => _Screen5State();
}

class _Screen5State extends State<Screen5> {
  dynamic args;
  String str = 'e';
  bool bol = true;
  IconData icon = Icons.height;
  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments;
    String name;
    bool state = args['state'];
    if(str == 'e') {
      name = args['name'];
    }
    else {
      name = str;
    }
    if(!state && icon == Icons.height) {
      icon = Icons.power_off_rounded;
    }
    else if (state && icon == Icons.height){
      icon = Icons.power;
    }
    TextEditingController textControl = new TextEditingController(text: name);
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
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            name = textControl.text;
            Navigator.pop(context, {
              'name' : name,
              'state' : bol,
            });
          },
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  controller: textControl,
                  cursorColor: Colors.black,
                  focusNode: FocusNode(),
                ),
              ),
            ),
            SizedBox(),
            Expanded(
              flex: 30,
              child: SizedBox(
                height: 250,
                width: 250,
                child: FloatingActionButton(
                  elevation: 20,
                  onPressed: () {
                    if(icon == Icons.power_off_rounded) {
                      icon = Icons.power;
                      bol = true;
                    }
                    else {
                      icon = Icons.power_off_rounded;
                      bol = false;
                    }
                    str = textControl.text;
                    setState(() {

                    });
                  },
                  child: Icon(
                    icon,
                    size: 150,
                  ),
                  backgroundColor: Colors.indigo[800],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ]
        ),
      )
    );
  }
}
