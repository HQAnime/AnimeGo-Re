import 'package:animego/core/model/EpisodelInfo.dart';
import 'package:flutter/material.dart';

/// The wrap of episode buttons shown after a range has been selected.
class EpisodeButtonList extends StatelessWidget {
  const EpisodeButtonList({
    Key? key,
    required this.episodes,
    required this.onTap,
  }) : super(key: key);

  final List<EpisodeInfo> episodes;
  final void Function(EpisodeInfo episode) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        children: episodes
            .map(
              (episode) => ElevatedButton(
                style: ButtonStyle(
                  textStyle: WidgetStateProperty.all(
                    TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () => onTap(episode),
                child: Text(episode.name ?? '??'),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
