(function() {
  var log;
  var __slice = Array.prototype.slice;
  log = function() {
    var msg;
    msg = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    if (typeof jasmine !== "undefined" && jasmine !== null) {
      if (debug) {
        return jasmine.log(msg);
      }
    } else {
      if (debug) {
        return console.log(msg);
      }
    }
  };
  window.Ani = (function() {
    function Ani(options) {
      this.options = options;
      this.init();
    }
    Ani.prototype.init = function() {};
    return Ani;
  })();
}).call(this);
