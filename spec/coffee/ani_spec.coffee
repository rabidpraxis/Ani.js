#===  Instructions  ======================================================={{{1
###
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
           .translate({tx:20})
        expect(ani.keyframe_rules[0].rules.translate.tx).toEqual 20

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
    it 'should output correct translate css animation', ->
      ani.translate({tx:230, ty:10})
         .keyframe(100)
         .translate({tx:100, ty:400})
         .keyframe(7)
         .translate({tx:7})
      expectant_str = /7% { translate3d\( 7px 0px 0px \); }/
      expect(ani.create_keyframe_block()).toMatch expectant_str

    it 'should be able to add single amount to animations', ->
      ani.rotate(12)
      expectant_str = /0% { rotate\( 12rad \); }/
      expect(ani.create_keyframe_block()).toMatch expectant_str
    
# }}}
  describe 'get_sheet', ->#{{{1
    it 'should create or return stylesheet node', ->
      expect(ani.sheet.id).toMatch /ani_stylesheet/
# }}}
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

    describe 'Translate Methods', ->
      it 'should work right'
# }}}

# vim:fdm=marker
