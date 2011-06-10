(function() {
  var Ani, ani_methods, debug, log, trans_methods;
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
  ani_methods = {
    translate: ['translate3d( % )', ['tX', 'tY', 'tZ'], ['px', '%']],
    rotate: ['rotate( % )', ['rot'], ['rad']]
  };
  trans_methods = [['transition_delay', 'delay'], ['transition_ease', 'ease'], ['transition_time', 'time']];
  Ani = (function() {
    var format_rule, get_ani_sheet;
    function Ani(ele) {
      this.ele = ele;
      this.init();
    }
    Ani.prototype.init = function() {
      this.ani_o = {
        0: {
          rules: {}
        }
      };
      this.transition = {};
      this.current_keyframe = 0;
      this.sheet = get_ani_sheet();
      this.setup_animatable_methods();
      return this.setup_transition_methods();
    };
    Ani.prototype.keyframe = function(frame) {
      this.current_keyframe = frame;
      if (this.ani_o[frame] == null) {
        this.ani_o[frame] = {
          rules: {}
        };
      }
      return this;
    };
    Ani.prototype.setup_transition_methods = function() {
      var meth, self, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = trans_methods.length; _i < _len; _i++) {
        meth = trans_methods[_i];
        self = this;
        _results.push((function(self, meth) {
          return self.add_method(meth[0], function(opt) {
            this.transition[meth[1]] = opt;
            return self;
          });
        })(self, meth));
      }
      return _results;
    };
    Ani.prototype.setup_animatable_methods = function() {
      var method_name, method_opts, self, _results;
      _results = [];
      for (method_name in ani_methods) {
        method_opts = ani_methods[method_name];
        self = this;
        _results.push((function(self, method_name, method_opts) {
          return self.add_method(method_name, function(opt) {
            this.ani_o[this.current_keyframe].rules[method_name] = opt;
            return self;
          });
        })(self, method_name, method_opts));
      }
      return _results;
    };
    Ani.prototype.add_method = function(method_name, callback) {
      return Ani.prototype[method_name] = callback;
    };
    Ani.prototype.create_keyframe_block = function() {
      var browser_type, keyframe, properties, rule_obj, rule_type, rules, rules_str, _ref, _ref2;
      browser_type = 'webkit';
      rules = "";
      _ref = this.ani_o;
      for (keyframe in _ref) {
        rule_obj = _ref[keyframe];
        rules_str = "";
        _ref2 = rule_obj.rules;
        for (rule_type in _ref2) {
          properties = _ref2[rule_type];
          rules_str += format_rule(rule_type, properties) + ';';
        }
        rules += "" + keyframe + "% { " + rules_str + " }";
      }
      return "@-" + browser_type + "-keyframes 'testing' { " + rules + " }";
    };
    format_rule = function(prop, property_obj) {
      var i, input_options, prop_val, rule, rule_opt_str, _len;
      input_options = ani_methods[prop][1];
      if (input_options.length > 1) {
        rule_opt_str = "";
        for (i = 0, _len = input_options.length; i < _len; i++) {
          prop_val = input_options[i];
          rule = property_obj[prop_val] || 0;
          rule += ani_methods[prop][2][0];
          if (i !== input_options.length - 1) {
            rule += ', ';
          }
          rule_opt_str += rule;
        }
      }
      return ani_methods[prop][0].replace('%', rule_opt_str);
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
