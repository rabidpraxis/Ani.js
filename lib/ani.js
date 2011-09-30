(function() {
  var Property, debug, log;
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
  Property = (function() {
    function Property(input) {
      this.input = input;
      this.value = this.parse_value(this.input);
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
  (function() {
    var props;
    props = [['border_width', 'Property'], ['height', 'Property'], ['color', 'Property'], ['colorRGB', 'Property']];
    return window.Ani = (function() {
      function Ani(options) {
        this.options = options;
        this.keyframe_group = [];
        this.init();
      }
      Ani.prototype.init = function() {
        return this.keyframe(0);
      };
      Ani.prototype.keyframe = function(key) {
        this.current_keyframe = key;
        return this.keyframe_group[key] = this.keyframe_group[key] || [];
      };
      Ani.prototype.border_width = function(width) {
        return this.add_property('border_width', new Property(width));
      };
      Ani.prototype.height = function(height) {
        return this.add_property('height', new Property(height));
      };
      Ani.prototype.color = function(color) {
        return this.add_property('color', new Property(color));
      };
      Ani.prototype.colorRGB = function(color) {
        return this.add_property('color', new Property(color));
      };
      Ani.prototype.translateX = function(x) {
        return this.add_property('translateX', new Property(x));
      };
      Ani.prototype.rotateX = function(x) {
        return this.add_property('rotateX', new Property(x));
      };
      Ani.prototype.translate3d = function(pos) {
        this.translateX(pos.x);
        this.translateY(pos.y);
        return this.translateZ(pos.z);
      };
      Ani.prototype.add_property = function(name, content) {
        this.keyframe_group[this.current_keyframe][name] = content;
        return this;
      };
      return Ani;
    })();
  })();
}).call(this);
