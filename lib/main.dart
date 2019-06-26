import 'package:flutter/material.dart';
import'package:mdq/pages/splashScreen.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Mdq App",
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new SplashScreen());
  }
}