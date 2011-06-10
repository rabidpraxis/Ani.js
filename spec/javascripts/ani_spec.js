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
          ani.transition_ease('ease-in');
          return expect(ani.transition.ease).toEqual('ease-in');
        });
      });
      return describe('translate animation', function() {
        it('should have translate function', function() {
          return expect(ani.translate).toBeDefined();
        });
        it('should append translate to ani_o at key 0', function() {
          ani.keyframe(0).translate({
            tX: 20
          });
          return expect(ani.ani_o[0].rules.translate.tX).toEqual(20);
        });
        it('should append translate to ani_o at key 40', function() {
          ani.keyframe(40).translate({
            tX: 40,
            tY: 20
          });
          expect(ani.ani_o[40].rules.translate.tX).toEqual(40);
          return expect(ani.ani_o[40].rules.translate.tY).toEqual(20);
        });
        return it('should have its ani_o object reflecting translation', function() {
          ani.translate({
            tX: 222
          });
          return expect(ani.ani_o[0].rules.translate).toBeDefined();
        });
      });
    });
    describe('creating CSS animation', function() {
      return it('should output correct translate css animation', function() {
        var expectant_str;
        ani.translate({
          tX: 230,
          tY: 10
        }).keyframe(100).translate({
          tX: 100,
          tY: 400
        }).keyframe(7).translate({
          tX: 7
        });
        expectant_str = /7% { translate3d\( 7px, 0px, 0px \); }/;
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
