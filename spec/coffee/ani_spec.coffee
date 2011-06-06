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
    it 'should have translate function', ->
      expect(ani.translate).toBeDefined()

    it 'should append translate to ani_o at key 0', ->
      ani.keyframe(0)
         .translate({tX:20})
      expect(ani.ani_o[0].rules[0].vals.tX).toEqual 20

    it 'should append translate to ani_o at key 40', ->
      ani.keyframe(40)
         .translate({tX:40, tY:20})
      expect(ani.ani_o[40].rules[0].vals.tX).toEqual 40
      expect(ani.ani_o[40].rules[0].vals.tY).toEqual 20

    it 'should have its ani_o object reflecting translation', ->
      ani.translate({tX:222})
      expect(ani.ani_o[0].rules[0].type).toMatch /translate/

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


    
