import 'package:animego/core/model/EpisodeSection.dart';
import 'package:flutter/material.dart';

/// The row of episode ranges (1-100, 101-200, ...) shown above the episode
/// list. The currently selected range is underlined.
class EpisodeSectionChips extends StatelessWidget {
  const EpisodeSectionChips({
    Key? key,
    required this.sections,
    required this.selected,
    required this.enabled,
    required this.onTap,
  }) : super(key: key);

  final List<EpisodeSection> sections;
  final String? selected;
  final bool enabled;
  final void Function(EpisodeSection section) onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: sections
          .map(
            (section) => Padding(
              padding: const EdgeInsets.all(2),
              child: InkWell(
                onTap: enabled ? () => onTap(section) : null,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    '${section.episodeStart} - ${section.episodeEnd}',
                    style: TextStyle(
                      decoration: selected == section.episodeStart
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}
