import 'package:animego/core/source/SourceManager.dart';
import 'package:animego/ui/widget/AnimeGrid.dart';
import 'package:flutter/material.dart';

/// CategoryPage class
class CategoryPage extends StatelessWidget {
  const CategoryPage({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  final String? url;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Unknown'),
      ),
      body: ValueListenableBuilder<String>(
        valueListenable: SourceManager.activeNotifier,
        builder: (context, activeId, child) {
          final source = SourceManager().active;
          return AnimeGrid(
            key: ValueKey(activeId),
            loadPage: (page) => source.category(url ?? '', page: page),
          );
        },
      ),
    );
  }
}
