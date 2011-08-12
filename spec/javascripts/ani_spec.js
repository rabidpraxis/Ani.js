(function() {
  /*
  - How it should work:
    ani = new Ani(); // Create Base Ani instance
    ani.keyframe(20)
         .translate3d({tx:200})
       .keyframe(100)
         .translate3d({tx:1000})
       .transition_delay(0)
       .transition_ease('ease-in')
       .transition_time(2)
  
  
  - Allow for componential properties:
    - Translate (x, y, z)
    - Color (r, g, b, a)
  
  - Should contain object values for multiple paramaters:
    .property({component:value})
    .property({component:'+value'})
  or
  - if it accepts single value, object notation is unnessecary:
    .property(value)
    .property('value')
      
  - Finished animation callback
    ani.finished ->
      do something
  
  - Inherit ani properties
    ele2 = new Ani('#selector', ele)
    ele2.transition_time('+1') // + operator tells Ani to add a milisecond
  
  - Create Ani Chain
    new Ani('#selector2', ele2)
          .transition_time('+1')
          .run(true) // run inherited animations too
  */  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
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
            tx: 20
          });
          return expect(ani.keyframe_rules[0].rules.translate.tx).toEqual(20);
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
      it('should output correct translate css animation', function() {
        var expectant_str;
        ani.translate({
          tx: 230,
          ty: 10
        }).keyframe(100).translate({
          tx: 100,
          ty: 400
        }).keyframe(7).translate({
          tx: 7
        });
        expectant_str = /7% { jtranslate3d\( 7px 0px 0px \); }/;
        log('string');
        return expect(ani.create_keyframe_block()).toMatch(expectant_str);
      });
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
    return describe('dynamic methods', function() {
      it('should have a new method created on the fly', function() {
        var method_return;
        method_return = 'awesome method called';
        ani.add_method('awesome', function() {
          return method_return;
        });
        return expect(ani.awesome()).toMatch(method_return);
      });
      it('should have same method when inhreited', function() {
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
      return describe('Translate Methods', function() {
        return it('should work right');
      });
    });
  });
}).call(this);
