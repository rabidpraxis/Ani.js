#===  debug logging  ======================================================{{{1
debug = true
log = (msg...) ->
  if jasmine?
    jasmine.log(msg) if debug
  else
    console.log(msg) if debug
#===========================================================================}}}

class Property
  constructor: (@input) ->
    @value = @.parse_value @input

  parse_value: (value) ->
    if typeof(value) is 'string'
      @.parse_string(value)
    else if typeof(value) is 'number'
      value
    else if typeof(value) is 'object'
      value

  parse_string: (str) ->
    if @.str_is_type(str, 'px')
      @type = 'length'
      parseInt(str.substring(0, str.length-2))
    else if @.str_is_type(str, '#')
      @type = 'hex_color'
      str

  str_is_type: (str, type) ->
    str.indexOf(type) isnt -1
  
class window.Ani
  constructor: (@options) ->
    @keyframe_group = []
    @.init()

  init: ->
    @current_keyframe = 0

  keyframe: (key) ->
    @current_keyframe = key

  border_width: (width) ->
    @.current_keyframe_group {border_width: new Property(width)}

  height: (height) ->
    @.current_keyframe_group {height: new Property(height)}

  color: (color) ->
    @.current_keyframe_group {color: new Property(color)}

  colorRGB: (color) ->
    @.current_keyframe_group {color: new Property(color)}

  translateX: (x) ->
    @.current_keyframe_group {translateX: new Property(x)}

  rotateX: (x) ->
    @.current_keyframe_group {rotateX: new Property(x)}

#===  Private  ================================================================

  current_keyframe_group: (content) ->
    @keyframe_group[@current_keyframe] = content
    @



# vim:fdm=marker
