import 'package:AnimeGo/ui/page/LastestAnime.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

// This widget is the root of the application.
class MyApp extends StatelessWidget {
  final darkTheme = ThemeData.dark().copyWith(
    accentColor: Colors.deepOrange,
    indicatorColor: Colors.deepOrange,
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
