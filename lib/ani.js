(function() {
  var ColorRGB, Property, debug, log;
  var __slice = Array.prototype.slice, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
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
  Property = (function() {
    function Property(input) {
      this.input = input;
      this.value = this.parse_value(this.input[0]);
    }
    Property.prototype.property_types = function() {
      return ['length', 'percentage', 'number', 'integer', 'visibility', 'hexcolor'];
    };
    Property.prototype.function_types = function() {
      return ['gradient', 'rgbcolor', 'hsvcolor', 'rgbacolor', 'shadow'];
    };
    Property.prototype.parse_value = function(value) {
      if (typeof value === 'string') {
        return this.parse_value_from_string(value);
      } else if (typeof value === 'number') {
        return value;
      } else if (typeof value === 'object') {
        return value;
      }
    };
    Property.prototype.parse_value_from_string = function(str) {
      if (this.str_is_type(str, 'px')) {
        this.type = 'length';
        return parseInt(str.substring(0, str.length - 2));
      } else if (this.str_is_type(str, '#')) {
        this.type = 'hex_color';
        return str;
      }
    };
    Property.prototype.str_is_type = function(str, type) {
      return str.indexOf(type) !== -1;
    };
    return Property;
  })();
  ColorRGB = (function() {
    __extends(ColorRGB, Property);
    function ColorRGB(input) {
      this.input = input;
      this.value = this.parse_value({
        r: this.input[0],
        g: this.input[1],
        b: this.input[2]
      });
    }
    return ColorRGB;
  })();
  (function() {
    var property_groups;
    property_groups = [['height', 'height', Property], ['border_width', 'border-width', Property], ['color', 'color', Property], ['colorRGB', 'color', ColorRGB]];
    return window.Ani = (function() {
      function Ani(options) {
        this.options = options;
        this.init();
      }
      Ani.prototype.init = function() {
        this.keyframe_group = [];
        this.keyframe(0);
        return this.setup_methods();
      };
      Ani.prototype.keyframe = function(key) {
        this.current_keyframe = key;
        this.keyframe_group[key] = this.keyframe_group[key] || [];
        return this;
      };
      Ani.prototype.setup_methods = function() {
        var meth_props, _i, _len;
        for (_i = 0, _len = property_groups.length; _i < _len; _i++) {
          meth_props = property_groups[_i];
          this.wrap_prop_method(meth_props[0], meth_props[2]);
        }
        return this;
      };
      Ani.prototype.wrap_prop_method = function(prop_name, func) {
        return this.add_method(prop_name, __bind(function() {
          var value;
          value = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
          return this.add_property(prop_name, new func(value));
        }, this));
      };
      Ani.prototype.add_method = function(method_name, callback) {
        Ani.prototype[method_name] = callback;
        return this;
      };
      Ani.prototype.add_property = function(name, content) {
        this.keyframe_group[this.current_keyframe][name] = content;
        return this;
      };
      return Ani;
    })();
  })();
}).call(this);
