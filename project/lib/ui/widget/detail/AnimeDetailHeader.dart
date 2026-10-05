import 'dart:math';

import 'package:animego/core/model/AnimeDetailedInfo.dart';
import 'package:animego/ui/widget/AnimeFlatButton.dart';
import 'package:animego/ui/widget/CenteredListTile.dart';
import 'package:flutter/material.dart';

/// The top part of the anime detail page: title, mirrored cover and the
/// released / episode / category summary.
class AnimeDetailHeader extends StatelessWidget {
  const AnimeDetailHeader({
    Key? key,
    required this.info,
    required this.onCategoryTap,
  }) : super(key: key);

  final AnimeDetailedInfo? info;

  /// Called when the category button is pressed.
  final VoidCallback onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            info?.name ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(flex: 2, child: _cover(flip: false)),
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CenteredListTile(
                      title: 'Released',
                      subtitle: info?.released ?? 'Unkown',
                    ),
                    CenteredListTile(
                      title: 'Episode',
                      subtitle: info?.lastEpisode ?? 'Unkown',
                    ),
                    ListTile(
                      title: Text('Category', textAlign: TextAlign.center),
                      subtitle: AnimeFlatButton(
                        onPressed: onCategoryTap,
                        child: Text(
                          info?.category ?? 'Unknown',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(flex: 2, child: _cover(flip: true)),
            ],
          ),
        ),
      ],
    );
  }

  /// The cover image, flipped horizontally for the two side panels.
  Widget _cover({required bool flip}) {
    if (info?.image == null) return Container();
    final image = Image.network(info!.image!);
    if (!flip) return image;
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(pi),
      child: image,
    );
  }
}
