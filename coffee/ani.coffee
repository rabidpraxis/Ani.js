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
    @value = @.parse_value @input[0]

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
  
class ColorRGB extends Property
  constructor: (@input) ->
    @value = @.parse_value
      r: @input[0]
      g: @input[1]
      b: @input[2]

do ->

  property_groups = [
  # ['Method Name',   'CSS name',      Property Class]
    ['height',        'height',        Property]
    ['border_width',  'border-width',  Property]
    ['color',         'color',         Property]
    ['colorRGB',      'color',         ColorRGB]
  ]

  class window.Ani
    constructor: (@options) ->
      @.init()

    init: ->
      @keyframe_group = []
      @.keyframe 0
      @.setup_methods()

    keyframe: (key) ->
      @current_keyframe = key
      @keyframe_group[key] = @keyframe_group[key] || []
      this

    setup_methods: ->
      for meth_props in property_groups
        @.wrap_prop_method meth_props[0], meth_props[2]
      this

    wrap_prop_method: (prop_name, func) ->
      @.add_method prop_name, (value...) =>
        @.add_property prop_name, new func(value)
        
    add_method: (method_name, callback) ->
      Ani.prototype[method_name] = callback
      this

    #---  prop methods  ---------------------------------------------------{{{1
    # translateX: (x) ->
    #   @.add_property 'translateX', new Property(x)

    # rotateX: (x) ->
    #   @.add_property 'rotateX', new Property(x)

    # translate3d: (pos) ->
    #   @.translateX(pos.x)
    #   @.translateY(pos.y)
    #   @.translateZ(pos.z)
    #-----------------------------------------------------------------------}}}

  #===  Private  ================================================================

    add_property: (name, content) ->
      @keyframe_group[@current_keyframe][name] = content
      this


# vim:fdm=marker
