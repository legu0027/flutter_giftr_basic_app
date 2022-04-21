import 'package:GIFTR/screens/login_screen.dart';
import 'package:GIFTR/screens/people_screen.dart';
import 'package:flutter/material.dart';
import 'package:GIFTR/screens/add_person_screen.dart';
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
      debugShowCheckedModeBanner: false,
      // home: MainPage(),
      initialRoute: '/',
      routes: {
        '/': ((context) => LoginScreen()),
        PeopleScreen.routeName: ((context) => const PeopleScreen()),
      },
    );
  }
}
