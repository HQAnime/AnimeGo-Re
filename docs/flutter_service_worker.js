'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "/main.dart.js": "f057c3ef5360ed7e410389b55237d55a",
"/assets\lib\assets\placeholder.png": "3d424d2cd06cf2337528ee0cdf87d43e",
"/assets\packages\cupertino_icons\assets\CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"/assets\fonts\MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"/assets\AssetManifest.json": "02caffb4d083ff2083e02c916157e2dd",
"/assets\FontManifest.json": "01700ba55b08a6141f33e168c4a6c22f",
"/assets\LICENSE": "96bd2a38059d7edc68ed4d2112c50f9f",
"/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"/icons\Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"/icons\Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"/index.html": "57ea6e7b903db05929ac358f1a44775c",
"/manifest.json": "36b9716bf981f341a54fc93ae30fdb93"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request, {
          credentials: 'include'
        });
      })
  );
});
