import 'package:flutter/material.dart';

class AdaptiveHomePage extends StatefulWidget {
  const AdaptiveHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<AdaptiveHomePage> createState() => _AdaptiveHomePageState();
}

enum _PageCode {
  latest,
  seasonal,
  movie,
  popular,
  genre,
  history,
  favourite,
  setting,
}

class _AdaptiveHomePageState extends State<AdaptiveHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimeGo'),
      ),
      body: const Center(
        child: Text('AdaptiveHomePage'),
      ),
    );
  }
}
