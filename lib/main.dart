import 'package:flutter/material.dart';
import 'package:flutter_multi_screen/screens/add_person_screen.dart';
//screens
import '../screens/login_screen.dart';
import '../screens/people_screen.dart';
import '../screens/gifts_screen.dart';
import '../screens/add_person_screen.dart';
import '../screens/add_gift_screen.dart';
//data and api classes

enum Screen { LOGIN, PEOPLE, GIFTS, ADDGIFT, ADDPERSON }

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

class MainPage extends StatefulWidget {
  //stateful widget for the main page container for all pages
  // we do this to keep track of current page at the top level
  // the state information can be passed to the BottomNav()
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var currentScreen = Screen.LOGIN;
  int currentPerson = 0; //use for selecting person for gifts pages.
  String currentPersonName = '';
  DateTime currentPersonDOB = DateTime.now(); //right now as default

  // to access variables from MainPage use `widget.`
  @override
  Widget build(BuildContext context) {
    return loadBody(currentScreen);
  }

  Widget loadBody(Enum screen) {
    switch (screen) {
      case Screen.LOGIN:
        return LoginScreen(nav: () {
          print('from login to people');
          setState(() => currentScreen = Screen.PEOPLE);
        });
        break;
      case Screen.PEOPLE:
        return PeopleScreen(
          goGifts: (int pid, String name) {
            //need another function for going to add/edit screen
            print('from people to gifts for person $pid');
            setState(() {
              currentPerson = pid;
              currentPersonName = name;
              currentScreen = Screen.GIFTS;
            });
          },
          goEdit: (int pid, String name, DateTime dob) {
            //edit the person
            print('go to the person edit screen');
            setState(() {
              currentPerson = pid;
              currentPersonName = name;
              currentPersonDOB = dob;
              currentScreen = Screen.ADDPERSON;
            });
          },
          logout: (Enum screen) {
            //back to people
            setState(() => currentScreen = Screen.LOGIN);
          },
        );
      case Screen.GIFTS:
        return GiftsScreen(
            goPeople: (Enum screen) {
              //back to people
              setState(() => currentScreen = Screen.PEOPLE);
            },
            logout: (Enum screen) {
              setState(() => currentScreen = Screen.LOGIN);
            },
            addGift: () {
              //delete gift idea and update state
              setState(() => currentScreen = Screen.ADDGIFT);
            },
            currentPerson: currentPerson,
            currentPersonName: currentPersonName);

      case Screen.ADDPERSON:
        return AddPersonScreen(
          nav: (Enum screen) {
            //back to people
            setState(() => currentScreen = Screen.PEOPLE);
          },
          currentPerson: currentPerson,
          currentPersonName: currentPersonName,
          personDOB: currentPersonDOB,
        );
      case Screen.ADDGIFT:
        return AddGiftScreen(
          nav: (Enum screen) {
            //save the gift idea
            //go back to list of gifts
            setState(() => currentScreen = Screen.GIFTS);
          },
          currentPerson: currentPerson,
          currentPersonName: currentPersonName,
        );
      default:
        return LoginScreen(nav: () {
          print('from login to people');
          setState(() => currentScreen = Screen.LOGIN);
        });
    }
  }
}
