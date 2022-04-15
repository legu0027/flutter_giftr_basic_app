import 'package:GIFTR/data/http_helper.dart';
import 'package:flutter/material.dart';
import 'package:GIFTR/shared/screen_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
//Screens
import '../screens/login_screen.dart';
import '../screens/people_screen.dart';
import '../screens/gifts_screen.dart';
import '../screens/add_person_screen.dart';
import '../screens/add_gift_screen.dart';

class MainPage extends StatefulWidget {
  //stateful widget for the main page container for all pages
  // we do this to keep track of current page at the top level
  // the state information can be passed to the BottomNav()
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? JWTtoken = null;
  var isLoggedIn;
  var prefs;
  var currentScreen = ScreenType.LOGIN;
  int currentPerson = 0; //use for selecting person for gifts pages.
  String currentPersonName = '';
  DateTime currentPersonDOB = DateTime.now(); //right now as default

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    () async {
      prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('JWTtoken');
      if (token != null) {
        setState(
          () {
            JWTtoken = token;
            isLoggedIn = true;
          },
          //MAKE an API call to see if the token is actually valid
        );
      } else {
        setState(
          () {
            JWTtoken = null;
            isLoggedIn = false;
          },
        );
      }
    }();
  }

  // to access variables from MainPage use `widget.`
  @override
  Widget build(BuildContext context) {
    return loadBody(currentScreen);
  }

  Widget loadBody(Enum screen) {
    switch (screen) {
      case ScreenType.LOGIN:
        return LoginScreen(nav: () {
          print('from login to people');
          setState(() => currentScreen = ScreenType.PEOPLE);
        }, login: (user) {
          HttpHelper helper = HttpHelper();
          setState(
            () {
              // JWTtoken = token;
              // isLoggedIn = true;
            },
            //MAKE an API call to see if the token is actually valid
          );
          Future<Map> response = helper.loginUser(user);
          response.then((obj) {
            print('on loginScreen: $obj');
          });
        });
        break;
      case ScreenType.PEOPLE:
        return PeopleScreen(
          goGifts: (int pid, String name) {
            //need another function for going to add/edit screen
            print('from people to gifts for person $pid');
            setState(() {
              currentPerson = pid;
              currentPersonName = name;
              currentScreen = ScreenType.GIFTS;
            });
          },
          goEdit: (int pid, String name, DateTime dob) {
            //edit the person
            print('go to the person edit screen');
            setState(() {
              currentPerson = pid;
              currentPersonName = name;
              currentPersonDOB = dob;
              currentScreen = ScreenType.ADDPERSON;
            });
          },
          logout: (Enum screen) {
            //back to people
            setState(() => currentScreen = ScreenType.LOGIN);
          },
        );
      case ScreenType.GIFTS:
        return GiftsScreen(
            goPeople: (Enum screen) {
              //back to people
              setState(() => currentScreen = ScreenType.PEOPLE);
            },
            logout: (Enum screen) {
              setState(() => currentScreen = ScreenType.LOGIN);
            },
            addGift: () {
              //delete gift idea and update state
              setState(() => currentScreen = ScreenType.ADDGIFT);
            },
            currentPerson: currentPerson,
            currentPersonName: currentPersonName);

      case ScreenType.ADDPERSON:
        return AddPersonScreen(
          nav: (Enum screen) {
            //back to people
            setState(() => currentScreen = ScreenType.PEOPLE);
          },
          currentPerson: currentPerson,
          currentPersonName: currentPersonName,
          personDOB: currentPersonDOB,
        );
      case ScreenType.ADDGIFT:
        return AddGiftScreen(
          nav: (Enum screen) {
            //save the gift idea
            //go back to list of gifts
            setState(() => currentScreen = ScreenType.GIFTS);
          },
          currentPerson: currentPerson,
          currentPersonName: currentPersonName,
        );
      default:
        return LoginScreen(nav: () {
          print('from login to people');
          setState(() => currentScreen = ScreenType.LOGIN);
        }, login: (user) {
          print("default $user");
        });
    }
  }
}
