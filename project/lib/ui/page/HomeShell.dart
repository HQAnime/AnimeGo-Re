import 'package:animego/core/source/AnimeSource.dart';
import 'package:animego/core/source/SourceManager.dart';
import 'package:animego/ui/page/LastestAnime.dart';
import 'package:animego/ui/page/SearchAnime.dart';
import 'package:animego/ui/page/WebSourcePage.dart';
import 'package:animego/ui/widget/AnimeGrid.dart';
import 'package:flutter/material.dart';

/// A single source destination in the bottom navigation.
class _TabSpec {
  const _TabSpec({
    required this.id,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String id;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// The mobile home: one bottom tab per content source.
///
/// Tapping a tab switches [SourceManager]'s active source, so the rest of the
/// app (History, Favourites, detail pages) keeps working unchanged. HiAnime
/// keeps the original native UI; the web sources embed their site and Nyaa
/// shows a torrent list.
class HomeShell extends StatefulWidget {
  const HomeShell({Key? key}) : super(key: key);

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  static const _tabs = <_TabSpec>[
    _TabSpec(
      id: 'hianime',
      label: 'HiAnime',
      icon: Icons.play_circle_outline,
      selectedIcon: Icons.play_circle,
    ),
    _TabSpec(
      id: 'aniwatch',
      label: 'AniWatch',
      icon: Icons.language_outlined,
      selectedIcon: Icons.language,
    ),
    _TabSpec(
      id: 'miruro',
      label: 'Miruro',
      icon: Icons.explore_outlined,
      selectedIcon: Icons.explore,
    ),
    _TabSpec(
      id: 'nyaa',
      label: 'Nyaa',
      icon: Icons.download_outlined,
      selectedIcon: Icons.download,
    ),
  ];

  int get _index {
    final active = SourceManager().activeId;
    final index = _tabs.indexWhere((tab) => tab.id == active);
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final index = _index;
    return Scaffold(
      body: _buildTab(_tabs[index].id),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (selected) {
          if (selected == index) return;
          SourceManager().select(_tabs[selected].id).then((_) {
            if (mounted) setState(() {});
          });
        },
        destinations: _tabs
            .map(
              (tab) => NavigationDestination(
                icon: Icon(tab.icon),
                selectedIcon: Icon(tab.selectedIcon),
                label: tab.label,
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  Widget _buildTab(String id) {
    switch (id) {
      case 'hianime':
        return const LastestAnime();
      case 'nyaa':
        return const _NyaaTab();
      default:
        return _WebTab(sourceId: id);
    }
  }
}

/// A torrent index tab: the standard browse grid rendered as a list.
class _NyaaTab extends StatelessWidget {
  const _NyaaTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final source = SourceManager().active;
    return Scaffold(
      appBar: AppBar(title: const Text('Nyaa')),
      body: AnimeGrid(
        key: const ValueKey('nyaa'),
        loadPage: (page) => source.browse(BrowseKind.latest, page: page),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchAnime(),
            fullscreenDialog: true,
          ),
        ),
      ),
    );
  }
}

/// A web-only source tab: embeds the site with ads blocked.
class _WebTab extends StatelessWidget {
  const _WebTab({Key? key, required this.sourceId}) : super(key: key);

  final String sourceId;

  @override
  Widget build(BuildContext context) {
    final source = SourceManager().byId(sourceId)!;
    return Scaffold(
      appBar: AppBar(title: Text(source.name)),
      body: WebSourcePage(key: ValueKey(sourceId), source: source),
    );
  }
}
