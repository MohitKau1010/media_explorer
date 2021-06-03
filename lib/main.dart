import 'package:flutter/material.dart';
import 'package:media_explorer/model/photo_provider.dart';
import 'package:media_explorer/screen/home_page.dart';
import 'package:media_explorer/screen/splash_screen.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

final provider = PhotoProvider();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: ChangeNotifierProvider<PhotoProvider>.value(
        value: provider,
        child: MaterialApp(
          title: 'Media Explorer',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: SplashScreen(),
        ),
      ),
    );
  }
}