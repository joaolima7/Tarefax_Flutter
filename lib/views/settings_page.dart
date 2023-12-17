import 'package:flutter/material.dart';

class Settings_Page extends StatefulWidget {
  const Settings_Page({super.key});

  @override 
  State<Settings_Page> createState() => _Settings_PageState();
}

class _Settings_PageState extends State<Settings_Page> {

bool _setSwitch = false;

  @override
  Widget build(BuildContext context) {
    var _sizeScreen = MediaQuery.of(context).size;
    var _sizeStatusBar = MediaQuery.of(context).padding.top;
    return Container(
        //width: _sizeScreen.width,
        //height: _sizeScreen.height,
        child: SingleChildScrollView(
         child: Column(
          children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: _sizeStatusBar),
            child: SwitchListTile(
              title: Text("Modo Noturno"),
              value: _setSwitch,
               onChanged: (value){ setState(() {
                 _setSwitch = value;
               }); },
               ),
          ),
          ],
         ), 
        ),
      );
  }
}