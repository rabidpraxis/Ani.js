debug = true

log = (msg...) ->
  if jasmine?
    jasmine.log(msg) if debug
  else
    console.log(msg) if debug

ani_methods = [['translate', 'translate3d', ['tX', 'tY', 'tZ']],
               ['rotate', 'rotate', ['rot']]]

class Ani
  constructor: (@ele) ->
    @.init()

  init: ->
    @ani_o = {0:{rules:[]}}
    @current_keyframe = 0
    @sheet = get_ani_sheet()
    @.setup_animatable_methods()

  
  keyframe: (frame) ->
    @current_keyframe = frame
    @ani_o[frame] = {rules:[], ease:'linear'} unless @ani_o[frame]?
    this
  
  # Private Methods
  setup_animatable_methods: ->
    for meth in ani_methods
      @.add_method meth[0], (opt) ->
        @ani_o[@current_keyframe].rules.push({type: meth[0], vals: opt})
    this

  add_method: (method_name, callback) ->
    Ani.prototype[method_name] = callback

  get_ani_sheet = ->
    if not sheet = document.querySelector('#ani_stylesheet')
      sheet = document.createElement("style")
      sheet.setAttribute("id","ani_stylesheet")
      document.documentElement.appendChild(sheet)
    sheet

window.Ani = Ani
