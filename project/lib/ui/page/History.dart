import 'package:animego/core/Firebase.dart';
import 'package:animego/core/Global.dart';
import 'package:animego/core/Util.dart';
import 'package:animego/ui/interface/Embeddable.dart';
import 'package:animego/ui/page/EpisodePage.dart';
import 'package:animego/ui/page/tablet/TabletAnimePage.dart';
import 'package:animego/ui/page/tablet/TabletHomePage.dart';
import 'package:flutter/material.dart';

/// History class
class History extends StatelessWidget implements Embeddable {
  const History({
    Key? key,
    this.embedded = false,
  }) : super(key: key);

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    FirebaseEventService().logUseHistoryList();
    final list = Global().historyList;
    return Scaffold(
      appBar: embedded ? null : AppBar(title: Text('Watch History')),
      body: list.length > 0
          ? ListView.builder(
              itemCount: list.length,
              itemBuilder: (c, i) {
                final curr = list[i];
                return ListTile(
                  title: Text(curr?.name ?? 'Unknown'),
                  onTap: () {
                    Navigator.push(
                      context,
                      Util.platformPageRoute(
                        builder: (c) {
                          if (Util(context).isTablet())
                            return TabletAnimePage(info: curr);
                          return EpisodePage(info: curr);
                        },
                      ),
                    );
                  },
                );
              },
            )
          : Center(
              child: Text('No anime found'),
            ),
    );
  }
}
