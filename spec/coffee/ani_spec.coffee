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

  #---  Keyframes  --------------------------------------------------------{{{1
  describe '#keyframe', ->
    it 'should allow for keyframes to be set', ->
      ani.keyframe(10)
      expect(ani.current_keyframe).toEqual 10

    it 'should allow for 100 percent to be set', ->
      ani.keyframe(100)
      expect(ani.current_keyframe).toEqual 100

    it 'should start with 0', ->
      expect(ani.current_keyframe).toEqual 0
  #-------------------------------------------------------------------------}}}
  #---  Solid Starting Properties  ---------------------------------------------{{{1
  describe 'Solid Properties', ->
    it 'should store border width', ->
      ani.border_width(20)
      expect(ani.actions[0]['border_width'].value).toEqual 20

    it 'should store height', ->
      ani.height(9)
      expect(ani.actions[0]['height'].value).toEqual 9

    it 'should store colors', ->
      ani.color('#fff')
      expect(ani.actions[0]['color'].value).toMatch /fff/

    it 'should store functions', ->
      ani.colorRGB(155, 100, 100)
      expect(ani.actions[0]['color'].value.r).toEqual 155

    it 'should allow translate functions', ->
      ani.translateX(20)
      expect(ani.actions[0]['translate3d'].value.x).toEqual 20
      
    it 'should store multiple functions', ->
      ani.translateX(20)
         .rotateX(20)
      expect(ani.actions[0]['translate3d'].value.x).toEqual 20

    it 'should have multiple arguments for translate3d', ->
      ani.translate3d(100, 100, '10%')
      expect(ani.actions[0]['translate3d'].value.z).toEqual 10
      
  #-------------------------------------------------------------------------}}}
  #---  Solid Updating Properties  ----------------------------------------{{{1
    it 'should update translate property', ->
      ani.translateX(20)
         .translateY(300)
      expect(ani.actions[0]['translate3d'].value.x).toEqual 20

    it 'should update height value', ->
      ani.height(400)
         .height(10)
      expect(ani.actions[0]['height'].value).toEqual 10
  #-------------------------------------------------------------------------}}}
  #---  String Starting Properties  -------------------------------------------{{{1
  describe 'String Properties', ->
    it 'should store border width', ->
      ani.border_width('20px')
      expect(ani.actions[0]['border_width'].value).toEqual 20
    
    it 'should store height', ->
      ani.height('800px')
      expect(ani.actions[0]['height'].value).toEqual 800

    it 'should store single property translation', ->
      ani.translateY('30px')
      expect(ani.actions[0]['translate3d'].value.y).toEqual 30
  #-------------------------------------------------------------------------}}}
  #---  Object Starting Properties  ---------------------------------------{{{1
  describe 'Object properties', ->
    it 'should create translateX from object', ->
      ani.translate({x: 200, y: 100})
      expect(ani.actions[0]['translate3d'].value.x).toEqual 200
    it 'should create color from object', ->
      ani.color({r: 200})
      expect(ani.actions[0]['color'].value.r).toEqual 200
  #-------------------------------------------------------------------------}}}
  #---  Output Stylesheet  ------------------------------------------------{{{1
  describe 'Create css rules', ->
    describe 'Ani stylesheet', ->
      it 'should create a new sheet', ->
        sheet = Ani.get_sheet()
        expect(sheet.id).toEqual 'ani_stylesheet'
      it 'should should load an existing stylesheet', ->
        sheet1 = Ani.get_sheet()
        sheet2 = Ani.get_sheet()
        expect(sheet1).toBe sheet2

    describe 'style output', ->
      it 'should output height style rule', ->
        ani.height(20)
        expect(ani.actions[0]['height'].css()).toBe 'height: 20px;'

      it 'should output height percentage style rule', ->
        ani.height('20%')
        expect(ani.actions[0]['height'].css()).toBe 'height: 20%;'

      it 'should output border-width style', ->
        ani.border_width('5px')
        expect(ani.actions[0]['border_width'].css()).toBe 'border-width: 5px;'
        
        
      

      
        
    
  #-------------------------------------------------------------------------}}}

  #---  Import Current Keyframe Rules  ------------------------------------{{{1
  describe 'Parsing Keyframe Object', ->
    it 'should find keyframe object', ->
      ani = new Ani
        parent: 'testing'
      
    
  #-------------------------------------------------------------------------}}}
        
        
  
#
# vim:fdm=marker
