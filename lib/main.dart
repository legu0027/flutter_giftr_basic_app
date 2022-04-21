// import 'dart:html';
import 'dart:io';

import 'package:GIFTR/data/giftr_exception.dart';
import 'package:GIFTR/data/person.dart';
import 'package:GIFTR/screens/add_gift_screen.dart';
import 'package:GIFTR/screens/gifts_screen.dart';
import 'package:GIFTR/screens/login_screen.dart';
import 'package:GIFTR/screens/people_screen.dart';
import 'package:flutter/material.dart';
import 'package:GIFTR/screens/add_person_screen.dart';

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
      initialRoute: LoginScreen.routeName,
      // routes: {
      // LoginScreen.routeName: ((context) => LoginScreen()),
      // PeopleScreen.routeName: ((context) => const PeopleScreen()),
      // AddPersonScreen.routeName: ((context) => const AddPersonScreen()),
      // },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case LoginScreen.routeName:
            var error = settings.arguments as GiftrException?;
            return MaterialPageRoute(builder: (context) {
              return LoginScreen(
                manageExceptions: (error) => _manageExceptions(context, error),
              );
            });

          case PeopleScreen.routeName:
            return MaterialPageRoute(builder: (context) {
              return PeopleScreen(
                manageExceptions: (error) => _manageExceptions(context, error),
              );
            });

          case AddPersonScreen.routeName:
            final person = settings.arguments as Person;
            return MaterialPageRoute(builder: (context) {
              return AddPersonScreen(
                  person: person,
                  manageExceptions: (exception) =>
                      _manageExceptions(context, exception));
            });

          case GiftsScreen.routeName:
            var person = settings.arguments as Person;
            return MaterialPageRoute(builder: (context) {
              return GiftsScreen(
                person: person,
                manageExceptions: (error) => _manageExceptions(context, error),
              );
            });

          case AddGiftScreen.routeName:
            var person = settings.arguments as Person;
            return MaterialPageRoute(builder: (context) {
              return AddGiftScreen(
                person: person,
                manageExceptions: (error) => _manageExceptions(context, error),
              );
            });
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }

  void _logout(BuildContext context, [GiftrException? error]) {
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.routeName, ((route) => false),
        arguments: error);
  }

  void _manageExceptions(BuildContext context, Object e) {
    Text message = Text("Unknown error ocurred");

    if (e is GiftrException) {
      e.shouldLogout ? _logout(context, e) : null;
      message = Text(e.message);
    } else if (e is SocketException) {
      message = Text(e.message);
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: message));
  }
}
