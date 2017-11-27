var exec = require('cordova/exec');

var PLUGIN_NAME = 'JTMWebViewer';

var JTMWebViewer = {
      show: function (success, error, options) {
            cordova.exec(success, error, PLUGIN_NAME, 'show', [ options ]);
      },
      hide: function (success, error, options) {
            cordova.exec(success, error, PLUGIN_NAME, 'hide', [ options ]);
      },
      onActionReceived: function (success, error, options) {
            cordova.exec(success, error, PLUGIN_NAME, 'onActionReceived', [ options ]);
      }
};

module.exports = JTMWebViewer;
