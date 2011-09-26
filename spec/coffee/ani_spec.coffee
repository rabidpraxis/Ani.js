#===  Goals and Ideas  ===================================================={{{1
###
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
###
#===========================================================================}}}
#===  Use Cases  =========================================================={{{1
###
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
###
#===========================================================================}}}

describe 'Ani', ->
  ani = ''
  beforeEach ->
    ani = new Ani()

  it 'should return an object', ->
    expect(ani).toBeDefined()

  describe '#keyframe', ->
    it 'should allow for keyframes to be set', ->
      ani.keyframe(10)
      expect(ani.current_keyframe).toEqual 10

    it 'should allow for 100 percent to be set', ->
      ani.keyframe(100)
      expect(ani.current_keyframe).toEqual 100

    it 'should start with 0', ->
      expect(ani.current_keyframe).toEqual 0

  #---  Solid Properties  -------------------------------------------------{{{1
  describe 'Solid Properties', ->
    it 'should store border width', ->
      ani.border_width(20)
      expect(ani.keyframe_group[0]['border_width'].value).toEqual 20

    it 'should store height', ->
      ani.height(9)
      expect(ani.keyframe_group[0]['height'].value).toEqual 9

    it 'should store colors', ->
      ani.color('#fff')
      expect(ani.keyframe_group[0]['color'].value).toMatch /fff/

    it 'should store functions', ->
      ani.colorRGB({r:155, g:255, b:120})
      expect(ani.keyframe_group[0]['color'].value.r).toEqual 155

    it 'should store multiple functions', ->
      ani.translateX(20)
         .rotateX(20)
      expect(ani.keyframe_group[0]['rotateX'].value).toEqual 20
  #-------------------------------------------------------------------------}}}

  describe 'String Properties', ->
    it 'should store border width', ->
      ani.border_width('20px')
      expect(ani.keyframe_group[0]['border_width'].value).toEqual 20
    
    it 'should store height', ->
      ani.height('800px')
      expect(ani.keyframe_group[0]['height'].value).toEqual 800
      
  
  
#
# vim:fdm=marker
