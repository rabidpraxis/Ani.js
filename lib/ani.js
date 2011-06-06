(function() {
  var Ani, ani_methods, debug, log;
  var __slice = Array.prototype.slice;
  debug = true;
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
  ani_methods = [['translate', 'translate3d', ['tX', 'tY', 'tZ']], ['rotate', 'rotate', ['rot']]];
  Ani = (function() {
    var get_ani_sheet;
    function Ani(ele) {
      this.ele = ele;
      this.init();
    }
    Ani.prototype.init = function() {
      this.ani_o = {
        0: {
          rules: []
        }
      };
      this.current_keyframe = 0;
      this.sheet = get_ani_sheet();
      return this.setup_animatable_methods();
    };
    Ani.prototype.keyframe = function(frame) {
      this.current_keyframe = frame;
      if (this.ani_o[frame] == null) {
        this.ani_o[frame] = {
          rules: [],
          ease: 'linear'
        };
      }
      return this;
    };
    Ani.prototype.setup_animatable_methods = function() {
      var meth, _i, _len;
      for (_i = 0, _len = ani_methods.length; _i < _len; _i++) {
        meth = ani_methods[_i];
        this.add_method(meth[0], function(opt) {
          return this.ani_o[this.current_keyframe].rules.push({
            type: meth[0],
            vals: opt
          });
        });
      }
      return this;
    };
    Ani.prototype.add_method = function(method_name, callback) {
      return Ani.prototype[method_name] = callback;
    };
    get_ani_sheet = function() {
      var sheet;
      if (!(sheet = document.querySelector('#ani_stylesheet'))) {
        sheet = document.createElement("style");
        sheet.setAttribute("id", "ani_stylesheet");
        document.documentElement.appendChild(sheet);
      }
      return sheet;
    };
    return Ani;
  })();
  window.Ani = Ani;
}).call(this);
