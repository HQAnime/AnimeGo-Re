/// This interval is used to catch video tags to get the src
let interval = setInterval(() => {
    let videos = window.document.getElementsByTagName('video');
    if (videos.length > 0) {
        let player = videos[0].src;
        console.log(player);
        // Make sure the src is valid and not empty
        if (player != null && player.trim() !== '') {
            console.log(player);
            clearInterval(interval);
        } else {
            console.log('AnimeGo - video is not playing');
        }
    } else {
        console.log('AnimeGo - no videos found');
    }
}, 1000);
