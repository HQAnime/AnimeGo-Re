import 'package:AnimeGo/core/Global.dart';
import 'package:AnimeGo/core/parser/DomainParser.dart';
import 'package:AnimeGo/ui/page/LastestAnime.dart';
import 'package:flutter/material.dart';

void main() {
  Global().init().then((_) {
    DomainParser('http://gogoanimes.ai/').getNewDomain().then((value) {
      runApp(MyApp());
    });
  });
}

// This widget is the root of the application.
class MyApp extends StatelessWidget {
  final darkTheme = ThemeData.dark().copyWith(
    accentColor: Colors.orange,
    indicatorColor: Colors.orange,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.orange,
    )
  );

  final lightTheme = ThemeData(
    primarySwatch: Colors.deepOrange,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimeGo Re',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: LastestAnime(), // New Release is the root of everything
    );
  }
}
