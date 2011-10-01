(function() {
  var Color, Property, Rotate, Translate;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __slice = Array.prototype.slice, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Property = (function() {
    function Property(type, input) {
      this.type = type;
      this.input = input;
      this.value = this.parse_value(this.input[0]);
    }
    Property.prototype.property_types = function() {
      return ['length', 'percentage', 'number', 'integer', 'visibility'];
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
      }
    };
    Property.prototype.str_is_type = function(str, type) {
      return str.indexOf(type) !== -1;
    };
    return Property;
  })();
  Color = (function() {
    __extends(Color, Property);
    function Color(type, input) {
      this.type = type;
      this.input = input;
      if (this.type === 'colorRGB') {
        this.value = this.parse_value({
          r: this.input[0],
          g: this.input[1],
          b: this.input[2]
        });
      } else if (this.type === 'colorHSV') {
        this.value = this.parse_value({
          h: this.input[0],
          s: this.input[1],
          v: this.input[2]
        });
      } else {
        this.value = this.parse_value(this.input[0]);
      }
    }
    Color.prototype.parse_value_from_string = function(str) {
      if (this.str_is_type(str, '#')) {
        this.type = 'hex_color';
        return str;
      }
    };
    return Color;
  })();
  Translate = (function() {
    __extends(Translate, Property);
    function Translate(type, input) {
      this.type = type;
      this.input = input;
      if (this.type === 'translateX') {
        this.value = {
          x: this.parse_value(this.input[0])
        };
      } else if (this.type === 'translateY') {
        this.value = {
          y: this.parse_value(this.input[0])
        };
      } else if (this.type === 'translateZ') {
        this.value = {
          z: this.parse_value(this.input[0])
        };
      }
    }
    return Translate;
  })();
  Rotate = (function() {
    __extends(Rotate, Property);
    function Rotate(type, input) {
      this.type = type;
      this.input = input;
      if (this.type === 'rotateX') {
        this.value = {
          x: this.parse_value(this.input[0])
        };
      } else if (this.type === 'rotateY') {
        this.value = {
          y: this.parse_value(this.input[0])
        };
      } else if (this.type === 'rotateZ') {
        this.value = {
          z: this.parse_value(this.input[0])
        };
      }
    }
    return Rotate;
  })();
  (function() {
    var property_groups;
    property_groups = [['height', 'height', Property], ['border_width', 'border_width', Property], ['color', 'color', Color], ['colorRGB', 'color', Color], ['colorHSV', 'color', Color], ['translateX', 'translate3d', Translate], ['translateY', 'translate3d', Translate], ['translateZ', 'translate3d', Translate], ['translate3d', 'translate3d', Translate], ['rotateX', 'rotate3d', Rotate], ['rotateY', 'rotate3d', Rotate], ['rotateZ', 'rotate3d', Rotate], ['rotate3d', 'rotate3d', Rotate]];
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
        var meth_props, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = property_groups.length; _i < _len; _i++) {
          meth_props = property_groups[_i];
          _results.push(this.wrap_prop_method(meth_props[0], meth_props[1], meth_props[2]));
        }
        return _results;
      };
      Ani.prototype.wrap_prop_method = function(method_name, prop_name, klass) {
        return this.add_prototype_method(method_name, __bind(function() {
          var value;
          value = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
          return this.property(prop_name, new klass(method_name, value));
        }, this));
      };
      Ani.prototype.add_prototype_method = function(method_name, callback) {
        return Ani.prototype[method_name] = callback;
      };
      Ani.prototype.property = function(name, content) {
        this.keyframe_group[this.current_keyframe][name] = content;
        return this;
      };
      Ani.get_sheet = function() {
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
  })();
}).call(this);
