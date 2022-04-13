import 'package:flutter/material.dart';
import 'package:flutter_multi_screen/screens/add_person_screen.dart';
//Main page - screen with navigation logic
import 'main_screen.dart';

//screens

//data and api classes

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //put the things that are the same on every page here...
    return MaterialApp(
      home: MainPage(),
    );
  }
}
