###
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
###

describe 'Ani', ->
  ani = ''
  beforeEach ->
    ani = new Ani('temp')

  it 'should return an object', ->
    expect(ani).toBeDefined()

  describe 'animating', ->
    describe 'global transition', ->
      it 'should have transition_delay function', ->
        expect(ani.transition_delay(1)).toBeDefined()
      
      it 'should change the instances delay value', ->
        ani.transition_delay(1)
        expect(ani.transition.delay).toEqual 1

      it 'should change the instances ease value', ->
        ani.transition_ease('ease-in')
        expect(ani.transition.ease).toEqual 'ease-in'

    describe 'translate animation', ->
      it 'should have translate function', ->
        expect(ani.translate).toBeDefined()

      it 'should append translate to ani_o at key 0', ->
        ani.keyframe(0)
           .translate({tX:20})
        expect(ani.ani_o[0].rules.translate.tX).toEqual 20

      it 'should append translate to ani_o at key 40', ->
        ani.keyframe(40)
           .translate({tX:40, tY:20})
        expect(ani.ani_o[40].rules.translate.tX).toEqual 40
        expect(ani.ani_o[40].rules.translate.tY).toEqual 20

      it 'should have its ani_o object reflecting translation', ->
        ani.translate({tX:222})
        expect(ani.ani_o[0].rules.translate).toBeDefined()

  describe 'creating CSS animation', ->
    it 'should output correct translate css animation', ->
      ani.translate({tX:230, tY:10})
         .keyframe(100)
         .translate({tX:100, tY:400})
         .keyframe(7)
         .translate({tX:7})
      expectant_str = /7% { translate3d\( 7px, 0px, 0px \); }/
      expect(ani.create_keyframe_block()).toMatch expectant_str

  describe 'get_sheet', ->
    it 'should create or return stylesheet node', ->
      expect(ani.sheet.id).toMatch /ani_stylesheet/

  describe 'dynamic methods', ->
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


    
