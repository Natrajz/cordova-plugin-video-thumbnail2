/**
 * Created by luxiaohui on 15/10/15.
 * Modified by Yossi Neiman
 */
/*
 According to apache license

 https://github.com/dride/cordova-plugin-video-thumbnail

 */

var exec = require("cordova/exec");

var videoThumbnail = {
  createThumb: function(config) {
    return new Promise(function(resolve, reject) {
      exec(resolve, reject, "VideoThumbnail", "buildThumbnail", [
        config.videoPath,
        config.width,
        config.height,
        config.kind
      ]);
    });
  }
};

/* @Deprecated */
window.plugins = window.plugins || {};
window.plugins.videoThumbnail = videoThumbnail;

module.exports = videoThumbnail;
