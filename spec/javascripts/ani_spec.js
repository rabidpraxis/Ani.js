(function() {
  /*
  Based on Blueprints (need a better term) that can be pulled and added to 
  other objects with deltas applied to the properties.
  
  - Allow for animatable functions:
    - matrix(m11, m12, m21, m22, tX, tY)
    - matrix3d(m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m31, m33)
    - perspective(depth)
    - translate3d(x, y, z)
    - scale3d(scaleX, scaleY, scaleZ)
    - rotate3d(x, y, z, angle)
    - skew(angleX [, angleY])
  
  - Allow for multi use functions:
    - color
      - rgb(r, g, b)
      - rgba(r, g, b, a) 
      - hsv(h, s, v)
    - gradient(type, start_point, end_point, / stop...)
    - gradient(type, inner_center, inner_radius, outer_center, outer_radius, / stop...)
    - color-stop(stop, color)
  
  - Should contain object values for multiple paramaters:
    .property({component:value})
    .property({component:'+value'}) - Delta Change
  or
  - if it accepts single value, object notation is unnessecary:
    .property(value)
    .property('value')
      
  * Delta Changes
  These changes are the key to the success of this pattern. This allows for nice
  quick animation tweaks on objects that inherit the blueprint of the other object.
  These delta changes are applied only once and immediatly after they are called.
  
  - Finished animation callback
    ani.finished ->
      do something
  */
  /*
    ani = new Ani(); // Create Base Ani instance
    ani.keyframe(20)
         .translate3d({tx:200})
       .keyframe(100)
         .translate3d({tx:1000})
       .transition_delay(0)
       .transition_ease('ease-in')
       .transition_time(2)
  
  - Inherit ani properties
    ani2 = new Ani('#selector', ani)
    ani2.transition_time('+1') // + operator tells Ani to add a milisecond
  
  - Integrated CSS functions into properties
    ani.border_color(Ani.rgba(255,255,255, 0.1))
    or
    ani.border_color({r:255, g:255, b:255, a: 0.1})
    which
    ani2.border_color({a: '+.2'})
  
  - Create Ani Chain
    new Ani('#selector2', ele2)
          .transition_time('+1')
          .run(true) // run inherited animations too
  */
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  describe('Ani', function() {
    var ani;
    ani = '';
    beforeEach(function() {
      return ani = new Ani('temp');
    });
    it('should return an object', function() {
      return expect(ani).toBeDefined();
    });
    describe('animating', function() {
      describe('global transition', function() {
        it('should have transition_delay function', function() {
          return expect(ani.transition_delay(1)).toBeDefined();
        });
        it('should change the instances delay value', function() {
          ani.transition_delay(1);
          return expect(ani.transition.delay).toEqual(1);
        });
        return it('should change the instances ease value', function() {
          ani.transition_timing_function('ease-in');
          return expect(ani.transition.timing_function).toEqual('ease-in');
        });
      });
      return describe('translate animation', function() {
        it('should have translate function', function() {
          return expect(ani.translate).toBeDefined();
        });
        it('should append translate to keyframe_rules at key 0', function() {
          ani.keyframe(0).translate({
            x: 20
          });
          log(ani.keyframe_rules[0].rules.translate.x);
          return expect(ani.keyframe_rules[0].rules.translate.x).toEqual(20);
        });
        it('should append translate to keyframe_rules at key 40', function() {
          ani.keyframe(40).translate({
            tx: 40,
            ty: 20
          });
          expect(ani.keyframe_rules[40].rules.translate.tx).toEqual(40);
          return expect(ani.keyframe_rules[40].rules.translate.ty).toEqual(20);
        });
        return it('should have its keyframe_rules object reflecting translation', function() {
          ani.translate({
            tx: 222
          });
          return expect(ani.keyframe_rules[0].rules.translate).toBeDefined();
        });
      });
    });
    describe('creating CSS animation', function() {
      return it('should be able to add single amount to animations', function() {
        var expectant_str;
        ani.rotate(12);
        expectant_str = /0% { rotate\( 12rad \); }/;
        return expect(ani.create_keyframe_block()).toMatch(expectant_str);
      });
    });
    describe('get_sheet', function() {
      return it('should create or return stylesheet node', function() {
        return expect(ani.sheet.id).toMatch(/ani_stylesheet/);
      });
    });
    describe('parse current keyframe objects', function() {});
    return describe('dynamic methods', function() {
      it('should have a new method created on the fly', function() {
        var method_return;
        method_return = 'awesome method called';
        ani.add_method('awesome', function() {
          return method_return;
        });
        return expect(ani.awesome()).toMatch(method_return);
      });
      return it('should have same method when inhreited', function() {
        var Ani2, ani2;
        ani.add_method('awesome', function() {
          return 'test';
        });
        Ani2 = (function() {
          __extends(Ani2, Ani);
          function Ani2() {
            Ani2.__super__.constructor.apply(this, arguments);
          }
          return Ani2;
        })();
        ani2 = new Ani2('test');
        return expect(ani2.awesome()).toMatch('test');
      });
    });
  });
}).call(this);
