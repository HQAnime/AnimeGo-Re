import 'package:animego/core/Global.dart';
import 'package:animego/ui/page/EpisodePage.dart';
import 'package:flutter/material.dart';

/// History class
class History extends StatelessWidget {
  const History({
    Key? key,
    this.showAppBar = true,
  }) : super(key: key);

  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    final list = Global().historyList;
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: Text('Watch History'),
            )
          : null,
      body: list.length > 0
          ? ListView.builder(
              itemCount: list.length,
              itemBuilder: (c, i) {
                final curr = list[i]!;
                return ListTile(
                  title: Text(curr.name!),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => EpisodePage(info: curr),
                      ),
                    );
                  },
                );
              },
            )
          : Center(child: Text('No anime found')),
    );
  }
}
