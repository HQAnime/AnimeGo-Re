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

        // Swallow clicks on links that would open a new tab or leave the
        // player's own site instead of letting the ad take over the frame.
        document.addEventListener('click', function (e) {
          var node = e.target;
          while (node && node.tagName !== 'A') node = node.parentElement;
          if (!node) return;

          var href = node.getAttribute('href') || '';
          var target = node.getAttribute('target') || '';
          var external = false;
          try {
            if (href.indexOf('http') === 0) {
              external = new URL(href).host !== location.host;
            }
          } catch (err) {}

          if (target === '_blank' || external) {
            e.preventDefault();
            e.stopPropagation();
          }
        }, true);

        // Middle click opens new tabs as well.
        document.addEventListener('auxclick', function (e) {
          e.preventDefault();
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

  /// Reports HTML5 fullscreen changes over the `Flutter` JavaScript channel.
  ///
  /// The host page listens for `fullscreen::true` / `fullscreen::false` and
  /// switches the device to landscape when a video goes fullscreen.
  static const fullscreenReporter = r'''
    (function () {
      function post(state) {
        try {
          if (window.Flutter && window.Flutter.postMessage) {
            Flutter.postMessage('fullscreen::' + state);
          }
        } catch (e) {}
      }
      function check() {
        var el = document.fullscreenElement || document.webkitFullscreenElement;
        post(!!el);
      }
      document.addEventListener('fullscreenchange', check);
      document.addEventListener('webkitfullscreenchange', check);
      document.addEventListener('webkitbeginfullscreen', function () { post(true); }, true);
      document.addEventListener('webkitendfullscreen', function () { post(false); }, true);
    })();
  ''';
}
