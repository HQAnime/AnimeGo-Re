# Firebase hosting
- Run `flutter build web` and copy all assets into `public` folder
- `firebase login`
- `firebase init`
- `firebase serve` (testing)
- `firebase deploy`

Copy and paste these scripts into the bottom of your <body> tag
~~~html
<!-- The core Firebase JS SDK is always required and must be listed first -->
<script src="/__/firebase/7.13.1/firebase-app.js"></script>

<!-- TODO: Add SDKs for Firebase products that you want to use
     https://firebase.google.com/docs/web/setup#available-libraries -->

<!-- Initialize Firebase -->
<script src="/__/firebase/init.js"></script>
~~~