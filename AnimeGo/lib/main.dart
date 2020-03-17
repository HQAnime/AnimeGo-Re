
import 'package:AnimeGo/core/Global.dart';
import 'package:AnimeGo/ui/page/LastestAnime.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
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
      home: FutureBuilder(
        future: Global().init(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // The data is simply a `true`
          if (snapshot.hasData) {
            return LastestAnime();
          } else {
            // A simple loading screen so that it is not that boring
            return Scaffold(
              appBar: AppBar(
                title: Text('Loading...'),
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
      }),
    );
  }
}
