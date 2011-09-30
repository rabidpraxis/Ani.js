#===  debug logging  ======================================================{{{1
debug = true
log = (msg...) ->
  if jasmine?
    jasmine.log(msg) if debug
  else
    console.log(msg) if debug
#===========================================================================}}}
#===  Property  ==========================================================={{{1
class Property
  constructor: (@input) ->
    @value = @.parse_value @input

  property_types: ->
    [
      'length',
      'percentage',
      'number',
      'integer',
      'visibility',
      'hexcolor'
    ]

  function_types: ->
    [
      'gradient',
      'rgbcolor',
      'hsvcolor',
      'rgbacolor',
      'shadow'
    ]

  parse_value: (value) ->
    if typeof(value) is 'string'
      @.parse_value_from_string(value)
    else if typeof(value) is 'number'
      value
    else if typeof(value) is 'object'
      value

  parse_value_from_string: (str) ->
    if @.str_is_type(str, 'px')
      @type = 'length'
      parseInt(str.substring(0, str.length-2))
    else if @.str_is_type(str, '#')
      @type = 'hex_color'
      str

  str_is_type: (str, type) ->
    str.indexOf(type) isnt -1

#===========================================================================}}}
  
do ->

  props = [
    ['border_width', 'Property']
    ['height', 'Property']
    ['color', 'Property']
    ['colorRGB', 'Property']
  ]

  class window.Ani
    constructor: (@options) ->
      @keyframe_group = []
      @.init()

      # stArr = props[0]
      # @[stArr[0]] = (prop) =>
      #   @.add_property {"st": new Property(prop)}

    init: ->
      @.keyframe 0

    keyframe: (key) ->
      @current_keyframe = key
      @keyframe_group[key] = @keyframe_group[key] || []

    #---  Properties  -----------------------------------------------------------
    border_width: (width) ->
      @.add_property 'border_width', new Property(width)

    height: (height) ->
      @.add_property 'height', new Property(height)

    color: (color) ->
      @.add_property 'color', new Property(color)

    colorRGB: (color) ->
      @.add_property 'color', new Property(color)

    translateX: (x) ->
      @.add_property 'translateX', new Property(x)

    rotateX: (x) ->
      @.add_property 'rotateX', new Property(x)

    translate3d: (pos) ->
      @.translateX(pos.x)
      @.translateY(pos.y)
      @.translateZ(pos.z)
      

  #===  Private  ================================================================

    add_property: (name, content) ->
      @keyframe_group[@current_keyframe][name] = content
      @


# vim:fdm=marker
