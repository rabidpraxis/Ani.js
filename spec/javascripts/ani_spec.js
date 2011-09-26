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
  */  describe('Ani', function() {
    var ani;
    ani = '';
    beforeEach(function() {
      return ani = new Ani();
    });
    return it('should return an object', function() {
      return expect(ani).toBeDefined();
    });
  });
}).call(this);
