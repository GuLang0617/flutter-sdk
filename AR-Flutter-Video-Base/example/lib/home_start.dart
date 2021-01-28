import 'dart:async';
import 'package:ar_rtc_engine_example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'main.dart';
import 'package:ar_rtc_engine/rtc_engine.dart';

void main() {
  runApp(HoMe());
}

class HoMe extends StatefulWidget {
  @override
  _HoMeState createState() => _HoMeState();
}
class _HoMeState extends State<HoMe> {

  TextEditingController _userEtController = TextEditingController();

  @override
  void destroy(){
    return destroy();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(top: 260),
                  child: TextField(
                    controller: _userEtController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      icon: Icon(Icons.link),
                      labelText: "输入频道ID",
                    ),
                    autofocus: false,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(top: 45),
                  child: RaisedButton(
                    child: Text("加入"),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_userEtController) => MyApp()));
                      return destroy();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}