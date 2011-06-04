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
debug = true

log = (msg...) ->
  console.log(msg) if debug

class Ani
  constructor: (@ele) ->
    @ani_o = {0:[]}
    @current_keyframe = 0
    @sheet = get_ani_sheet()
    add_method 'test', =>
      log 'test_method_called'

  keyframe: (frame) ->
    @current_keyframe = frame
    @ani_o[frame] = [] unless @ani_o[frame]?
    this

  translate3d: (opts) ->
    log 'Ani.translate3d executed', opts

    t_str = ""
    $.each ['tX', 'tY', 'tZ'], (i, ele) =>
      t_str += ", " unless i is 0
      t_str += if opts[ele]? then opts[ele] else 0
      
    f_str = "translate3d(#{t_str})"

    @ani_o[@current_keyframe].push(f_str)
    this

  translate2d: (opts) ->
    log 'Ani.translate2d executed', opts
    this

  run: (opts) ->
    log 'Ani.run executed', @
    log 'Ani - KeyframeObj', @ani_o
    log 'Ani - Sheet', @sheet
    @

  stop: ->
    log 'Ani.stop executed', this
  
  # Private Methods
  add_method = (method_name, callback) ->
    log @
    @[method_name] = callback

  build_animation = ->

  get_ani_sheet = ->
    if not sheet = document.querySelector('#ani_stylesheet')
      sheet = document.createElement("style")
      sheet.setAttribute("id","ani_stylesheet")
      document.documentElement.appendChild(sheet)
    sheet

a = new Ani('ani')
a.keyframe(0)
   .translate3d({tX:0})
 .keyframe(100)
   .translate3d({tX:1200})
 .run()

b = new Ani()
