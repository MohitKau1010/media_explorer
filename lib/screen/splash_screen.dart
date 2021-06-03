import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_explorer/model/photo_provider.dart';
import 'package:media_explorer/screen/gallery_list_page.dart';
import 'package:media_explorer/screen/home_page.dart';
import 'package:media_explorer/screen/image_list_page.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PhotoProvider get provider => Provider.of<PhotoProvider>(context);
  List<Color> _colors = [Colors.orange, Colors.pink];
  List<double> _stops = [0.0, 0.9];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide'); //hide keyboard
    initPref();
    startTime();
  }

  void initPref() async {
    //prefs = await SharedPreferences.getInstance();
  }

  startTime() async {
    var _duration = new Duration(seconds: 2); // splash timer = 2
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    await provider.refreshGalleryList();

    final item = provider.list[0];
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => GalleryContentListPage(path: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _colors,
                stops: _stops,
              )),
            ),
            /*Image(image: NetworkImage('https://i.pinimg.com/564x/53/5d/5a/535d5a3cb54b463057fc76c44ef56393.jpg'),
                  fit: BoxFit.fill,
                ),*/
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 50),
                      Padding(
                        padding: EdgeInsets.all(60.0),
                        child: Text(
                          "Media Explorer",
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Bal",
                              fontSize: 24.0,
                              color: Colors.black),
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 180.0),
                    ),
                    Text(
                      "CopyRight @2020",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: "Bal",
                          fontSize: 14.0,
                          color: Colors.black),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
