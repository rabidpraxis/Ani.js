(function() {
  var Ani, ani_methods, tranform_methods, trans_methods;
  ani_methods = {
    border_top_width: ['border-top-width: %', ['px'], ['px', '%']],
    border_width: ['border-width: %', ['px'], ['px', '%']],
    translate: ['translate3d( % )', ['tx', 'ty', 'tz'], ['px', '%']],
    rotate: ['rotate( % )', ['rot'], ['rad']]
  };
  tranform_methods = ['matrix', 'rotate', 'scale', 'scaleX', 'scaleY', 'skew', 'skewX', 'skewY', 'translate', 'translateX', 'translateY'];
  trans_methods = [['transition_delay', 'delay'], ['transition_duration', 'duration'], ['transition_iteration_count', 'iteration-count'], ['transition_timing_function', 'timing_function'], ['transition_time', 'time'], ['transition_repeat', 'repeat']];
  Ani = (function() {
    var format_css_rule, get_ani_sheet;
    function Ani(ele) {
      this.ele = ele;
      this.init();
    }
    Ani.prototype.init = function() {
      this.keyframe_rules = {
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
      if (this.keyframe_rules[frame] == null) {
        this.keyframe_rules[frame] = {
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
            this.keyframe_rules[this.current_keyframe].rules[method_name] = opt;
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
      _ref = this.keyframe_rules;
      for (keyframe in _ref) {
        rule_obj = _ref[keyframe];
        rules_str = "";
        _ref2 = rule_obj.rules;
        for (rule_type in _ref2) {
          properties = _ref2[rule_type];
          rules_str += format_css_rule(rule_type, properties) + ';';
        }
        rules += "" + keyframe + "% { " + rules_str + " }";
      }
      return "@-" + browser_type + "-keyframes 'testing' { " + rules + " }";
    };
    format_css_rule = function(prop, property_obj) {
      var i, input_options, prop_val, rule, rule_opt_str, _len;
      input_options = ani_methods[prop][1];
      rule_opt_str = "";
      if (input_options.length > 1) {
        for (i = 0, _len = input_options.length; i < _len; i++) {
          prop_val = input_options[i];
          rule = property_obj[prop_val] || 0;
          rule += ani_methods[prop][2][0];
          if (i !== input_options.length - 1) {
            rule += ' ';
          }
          rule_opt_str += rule;
        }
      } else {
        rule_opt_str = property_obj + ani_methods[prop][2];
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
