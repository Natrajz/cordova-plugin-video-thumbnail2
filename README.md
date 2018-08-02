[![npm version](https://badge.fury.io/js/cordova-plugin-video-thumbnail2.svg)](https://badge.fury.io/js/cordova-plugin-video-thumbnail2)

# cordova-plugin-video-thumbnail

This plugins can generate a thumbnail from a remote or local video file.

## Installation

    cordova plugin add cordova-plugin-video-thumbnail2

## Supported Platforms

- Android
- iOS

## Usage

```javascript
window.videoThumbnail
  .createThumb({
    videoPath: "/video1.mov",
    width: 100,
    height: 100,
    kind: 1 //android only
  })
  .then(
    thumb => {
      //base64 encoded thumbnail
    },
    error => {
      //deal with error
    }
  );
```

References:

https://github.com/lulee007/cordova-plugin-video-thumbnail by [@lulee007](https://github.com/lulee007)
