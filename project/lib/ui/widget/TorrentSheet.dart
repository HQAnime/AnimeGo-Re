import 'package:android_intent_plus/android_intent.dart';
import 'package:animego/core/Util.dart';
import 'package:animego/core/model/AnimeInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Explains a torrent result and hands the magnet link to an external client.
Future<void> showTorrentSheet(BuildContext context, AnimeInfo info) {
  final magnet = info.link;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              info.name ?? 'Unknown',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            if (info.episode != null && info.episode!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  info.episode!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Open with torrent app'),
              onPressed: magnet == null ? null : () => openMagnetLink(magnet),
            ),
            TextButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('Copy magnet link'),
              onPressed: magnet == null
                  ? null
                  : () async {
                      await Clipboard.setData(ClipboardData(text: magnet));
                      if (context.mounted) Navigator.pop(context);
                    },
            ),
          ],
        ),
      ),
    ),
  );
}

/// Opens a magnet URI with the platform's default torrent handler.
void openMagnetLink(String magnet) {
  if (Util.isAndroid()) {
    AndroidIntent(
      action: 'action_view',
      data: magnet,
      type: 'application/x-bittorrent',
    ).launch();
  } else {
    launchUrlString(magnet, mode: LaunchMode.externalApplication);
  }
}
