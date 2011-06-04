(function() {
  /*

  How it should work:
  ele = new Ani(); // Create Base Ani instance
  ele.keyframe(20)
       .translate3d({tX:200})
     .keyframe(100)
       .translate3d({tX:1000})
     .transition_delay(0)
     .transition_ease('ease-in')
     .transition_time(2)

  // Inherit ani properties
  ele2 = new Ani('#selector', ele)
  ele2.transition_time('+1') // + operator tells Ani to add a milisecond

  // Create Ani Chain
  new Ani('#selector2', ele2).transition_time('+1').run(true) // run inherited animations too

  */  var Ani, a, b, debug, log;
  var __slice = Array.prototype.slice, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  debug = true;
  log = function() {
    var msg;
    msg = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    if (debug) {
      return console.log(msg);
    }
  };
  Ani = (function() {
    var add_method, build_animation, get_ani_sheet;
    function Ani(ele) {
      this.ele = ele;
      this.ani_o = {
        0: []
      };
      this.current_keyframe = 0;
      this.sheet = get_ani_sheet();
      add_method('test', __bind(function() {
        return log('test_method_called');
      }, this));
    }
    Ani.prototype.keyframe = function(frame) {
      this.current_keyframe = frame;
      if (this.ani_o[frame] == null) {
        this.ani_o[frame] = [];
      }
      return this;
    };
    Ani.prototype.translate3d = function(opts) {
      var f_str, t_str;
      log('Ani.translate3d executed', opts);
      t_str = "";
      $.each(['tX', 'tY', 'tZ'], __bind(function(i, ele) {
        if (i !== 0) {
          t_str += ", ";
        }
        return t_str += opts[ele] != null ? opts[ele] : 0;
      }, this));
      f_str = "translate3d(" + t_str + ")";
      this.ani_o[this.current_keyframe].push(f_str);
      return this;
    };
    Ani.prototype.translate2d = function(opts) {
      log('Ani.translate2d executed', opts);
      return this;
    };
    Ani.prototype.run = function(opts) {
      log('Ani.run executed', this);
      log('Ani - KeyframeObj', this.ani_o);
      log('Ani - Sheet', this.sheet);
      return this;
    };
    Ani.prototype.stop = function() {
      return log('Ani.stop executed', this);
    };
    add_method = function(method_name, callback) {
      log(this);
      return this[method_name] = callback;
    };
    build_animation = function() {};
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
  a = new Ani('ani');
  a.keyframe(0).translate3d({
    tX: 0
  }).keyframe(100).translate3d({
    tX: 1200
  }).run();
  b = new Ani();
}).call(this);
