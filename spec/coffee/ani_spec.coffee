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
    ani = new Ani('temp')

  it 'should return an object', ->
    expect(ani).toBeDefined()
  
  describe 'animating', -># {{{1
    describe 'global transition', -> # {{{2
      it 'should have transition_delay function', ->
        expect(ani.transition_delay(1)).toBeDefined()
      
      it 'should change the instances delay value', ->
        ani.transition_delay(1)
        expect(ani.transition.delay).toEqual 1

      it 'should change the instances ease value', ->
        ani.transition_timing_function('ease-in')
        expect(ani.transition.timing_function).toEqual 'ease-in'
    # }}}
    describe 'translate animation', -> # {{{2
      it 'should have translate function', ->
        expect(ani.translate).toBeDefined()

      it 'should append translate to keyframe_rules at key 0', ->
        ani.keyframe(0)
           .translate({x:20})
        log ani.keyframe_rules[0].rules.translate.x
        expect(ani.keyframe_rules[0].rules.translate.x).toEqual 20

      it 'should append translate to keyframe_rules at key 40', ->
        ani.keyframe(40)
           .translate({tx:40, ty:20})
        expect(ani.keyframe_rules[40].rules.translate.tx).toEqual 40
        expect(ani.keyframe_rules[40].rules.translate.ty).toEqual 20

      it 'should have its keyframe_rules object reflecting translation', ->
        ani.translate({tx:222})
        expect(ani.keyframe_rules[0].rules.translate).toBeDefined()
    # }}}
  # }}}
  describe 'creating CSS animation', -> #{{{1
    # it 'should output correct translate css animation', ->
    #   ani.translate({tx:230, ty:10})
    #      .keyframe(100)
    #      .translate({tx:100, ty:400})
    #      .keyframe(7)
    #      .translate({tx:7})
    #   expectant_str =
    #   # @-webkit-keyframes '.*' {
    #     '''
    #     0% {
    #       -webkit-transform: translate3d(230px, 10px 0px);
    #     }
    #     '''
    #   #   7% {
    #   #     -webkit-transform: translate3d(7px, 0px, 0px);
    #   #   }
    #   #   100% {
    #   #     -webkit-transform: translate3d(100px, 400px, 0px);
    #   #   }
    #   # }
    #   expect(ani.create_keyframe_block()).toMatch expectant_str

    it 'should be able to add single amount to animations', ->
      ani.rotate(12)
      expectant_str = /0% { rotate\( 12rad \); }/
      expect(ani.create_keyframe_block()).toMatch expectant_str
    
# }}}
  describe 'get_sheet', ->#{{{1
    it 'should create or return stylesheet node', ->
      expect(ani.sheet.id).toMatch /ani_stylesheet/
# }}}
  describe 'parse current keyframe objects', ->


  describe 'dynamic methods', ->#{{{1
    it 'should have a new method created on the fly', ->
      method_return = 'awesome method called'
      ani.add_method 'awesome', ->
        return method_return
      expect(ani.awesome()).toMatch method_return

    it 'should have same method when inhreited', ->
      ani.add_method 'awesome', ->
        return 'test'
      class Ani2 extends Ani
      ani2 = new Ani2('test')
      expect(ani2.awesome()).toMatch 'test'
      
# }}}
#
# vim:fdm=marker
