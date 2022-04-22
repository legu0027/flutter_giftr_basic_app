import 'package:flutter/material.dart';

class GiftrTheme {
  GiftrTheme();

  static ThemeData buildDark() {
    //final base = ThemeData.dark();

    //ThemeData.from( colorScheme: , textTheme: )
    final ThemeData darkBase = ThemeData.from(
      colorScheme: const ColorScheme(
        //base colour scheme that can be overridden for widgets
        primary: Color(0xFF004E8D),
        onPrimary: Colors.white,
        secondary: Color(0xFF32B095),
        onSecondary: Colors.lime,
        tertiary: Colors.amber,
        onTertiary: Colors.lime,

        primaryContainer: Colors.white,
        onPrimaryContainer: Colors.black,
        secondaryContainer: Colors.blueAccent,
        onSecondaryContainer: Colors.black,
        tertiaryContainer: Colors.blueAccent,
        onTertiaryContainer: Colors.black,

        background: Colors.white,
        onBackground: Color(0xFF003366),
        surface: Colors.lightGreen,
        onSurface: Colors.grey,
        error: Color(0xFFE22222),
        onError: Color(0xFFE22222),

        brightness: Brightness.light, // will switch text between dark/light
        //if colorScheme is light the text will be dark
      ),
      textTheme: const TextTheme(
        //base texttheme that can be overridden by widgets
        headline1: TextStyle(
          // letterSpacing: ,
          // fontFamily: ,
          fontSize: 60,
          fontWeight: FontWeight.w700,
        ),
        headline2: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w500,
        ),
        headline3: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w300,
          fontFamily: 'SendFlowers',
        ),
        headline4: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w300,
        ),
        headline5: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          fontFamily: 'SendFlowers',
        ),
        headline6: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        bodyText1: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w300,
        ),
        bodyText2: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
        subtitle1: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w300,
        ),
        subtitle2: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
        button: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    //then build on top of the colorScheme and textTheme
    //to style specific widgets
    ThemeData dark = darkBase.copyWith(
      //colours set in here will override the ColorScheme
      scaffoldBackgroundColor: Colors.white,
      shadowColor: Colors.grey[600],

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF004E8D),
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontFamily: 'SendFlowers',
          fontSize: 20,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        //this will override the iconThemeData
      ),

      iconTheme: const IconThemeData(
        //defaults for icons unless overridden
        color: Color(0xFF32B095),
        size: 36,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF32B095),
        foregroundColor: Colors.white, //for the icon
        elevation: 20, //for all FABs
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF32B095)),

          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          elevation: MaterialStateProperty.all(10), //for all ElevatedButtons
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF32B095)),
        ),
      ),

      listTileTheme: const ListTileThemeData(
        tileColor: Color(0xFF32B095),
        // textColor: Colors.black, //sets both title and subtitle
        style: ListTileStyle.list,
        //ListTileStyle.list means use subtitle1 for the title
        //ListTileStyle.drawer means use bodyText1 for the title
        dense: false,
        iconColor: Colors.red,
      ),
    );

    return dark;
  }
}
