var exec = require('cordova/exec');

var PLUGIN_NAME = 'MyCordovaPlugin';

var MyCordovaPlugin = {
      echo: function (phrase, cb) {
            cordova.exec(cb, null, PLUGIN_NAME, 'echo', [ phrase ]);
            
            //cordova.exec(onsucess, onfail, "NativeSettings", "open", settings);
            
            /*cordova.exec(callback, function(err) {
                  callback('Nothing to echo.');
            }, "Echo", "echo", [str]);*/
            
      },
      getDate: function (cb) {
            cordova.exec(cb, null, PLUGIN_NAME, 'getDate', []);
      },
      showMap: function(success, error, options) {
            cordova.exec(success, error, PLUGIN_NAME, 'showMap', [options]);
      },
      
};

module.exports = MyCordovaPlugin;
