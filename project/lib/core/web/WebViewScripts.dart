/// JavaScript snippets injected into the app's WebViews.
///
/// They exist so the embedded players and web-only sources behave like a
/// usable built-in browser instead of a page full of pop-ups and ads.
class WebViewScripts {
  WebViewScripts._();

  /// Blocks pop-ups, new tabs, right clicks and forces a dark page.
  ///
  /// Safe for pages that bring their own player (embed servers such as
  /// HiAnime's ZokoAnime and the Miruro website): it never removes the player
  /// elements, it only keeps unwanted overlays from taking over.
  static const adBlock = r'''
    (function () {
      try {
        // Pop-ups / new tabs are the most common ad vector.
        window.open = function () { return null; };

        // Make sure links cannot escape into an external browser tab.
        document.addEventListener('click', function (e) {
          var node = e.target;
          while (node && node.tagName !== 'A') node = node.parentElement;
          if (node && node.target === '_blank') node.target = '_self';
        }, true);

        // Remove the right click menu.
        document.addEventListener('contextmenu', function (e) {
          e.preventDefault();
        });

        // Keep the page dark so it blends with the app.
        var darken = function () {
          if (document.body) document.body.style.backgroundColor = 'black';
        };
        document.addEventListener('DOMContentLoaded', darken);
        darken();
      } catch (e) {}
    })();
  ''';
}
