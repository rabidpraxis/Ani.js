#===  Property  ==========================================================={{{1
# Base Property class and handler of common values (px, %, str)
class Property
  constructor: (@css_type, @input) ->
    @val_type = 'px' # the default
    @value = this.parse_value @input[0]

  property_types: ->
    [
      'length',
      'percentage',
      'number',
      'integer',
      'visibility'
    ]

  parse_value: (value) ->
    if typeof(value) is 'string'
      this.parse_value_from_string(value)
    else if typeof(value) is 'number'
      value
    else if typeof(value) is 'object'
      value

  parse_value_from_string: (str) ->
    if this.str_is_type(str, 'px')
      @val_type = 'px'
      parseInt(str.substring(0, str.length-2))
    else if this.str_is_type(str, '%')
      @val_type = '%'
      parseInt(str.substring(0, str.length-1))

  str_is_type: (str, type) ->
    str.indexOf(type) isnt -1

  css: ->
    "#{@css_type.replace(/_/, '-')}: #{@value + @val_type};"

  update: (name, input) ->
    @value = input[0]

#===========================================================================}}}
#===  Color < Property =================================================={{{1
class Color extends Property
  constructor: (@type, @input) ->
    if @type is 'colorRGB'
      @value = this.parse_value
        r: @input[0]
        g: @input[1]
        b: @input[2]
    else if @type is 'colorHSV'
      @value = this.parse_value
        h: @input[0]
        s: @input[1]
        v: @input[2]
    else
      @value = this.parse_value @input[0]

  parse_value_from_string: (str) ->
    if this.str_is_type(str, '#')
      @val_type = 'hex_color'
      str
    else
      @val_type = 'named'
      str


#===========================================================================}}}
#===  Translate < Property  ==============================================={{{1
class Translate extends Property
  constructor: (type, input) ->
    jasmine.log input
    if typeof(input[0]) is 'object'
      @value = input[0]
    else
      if type is 'translateX'
        @value = {x: this.parse_value input[0]}
      else if type is 'translateY'
        @value = {y: this.parse_value input[0]}
      else if type is 'translateZ'
        @value = {z: this.parse_value input[0]}
      else if type is 'translate3d'
        @value = {}
        @value.x = this.parse_value input[0]
        @value.y = this.parse_value input[1]
        @value.z = this.parse_value input[2]

  update: (type, input) ->
    if type is 'translateX'
      @value.x = this.parse_value input[0]
    else if type is 'translateY'
      @value.y = this.parse_value input[0]
    else if type is 'translateZ'
      @value.z = this.parse_value input[0]
    else if type is 'translate3d'
      @value.x = this.parse_value input[0]
      @value.y = this.parse_value input[1]
      @value.z = this.parse_value input[2]

#===========================================================================}}}
#===  Rotate < Property  ==============================================={{{1
class Rotate extends Property
  constructor: (@type, @input) ->
    if @type is 'rotateX'
      @value = {x: this.parse_value @input[0]}
    else if @type is 'rotateY'
      @value = {y: this.parse_value @input[0]}
    else if @type is 'rotateZ'
      @value = {z: this.parse_value @input[0]}

  # TODO: parse deg, rad or grad types

#===========================================================================}}}

do ->

  #---  Property Groups  --------------------------------------------------{{{1
  # The instruction set that Ani uses to construct its convenient animation
  # methods. This works by passing the (method name) to setup the prototype
  # method call and to tell Ani what to do with the value, the (CSS Name) is
  # used so Ani knows how to store or compare the value internally, and
  # lastly the (Property Class) which is the workhorse in determining what to
  # do with the passed in value.
  property_groups = [
    #Method_Name______CSS_name_________Property_Class#
    ['height',        'height',        Property]
    ['border_width',  'border_width',  Property]

    ['color',         'color',         Color]
    ['colorRGB',      'color',         Color]
    ['colorHSV',      'color',         Color]
    ['border_color',  'border_color',  Color]

    ['translate',     'translate3d',   Translate]
    ['translate2d',   'translate3d',   Translate]
    ['translate3d',   'translate3d',   Translate]
    ['translateX',    'translate3d',   Translate]
    ['translateY',    'translate3d',   Translate]
    ['translateZ',    'translate3d',   Translate]

    ['rotateX',       'rotate3d',      Rotate]
    ['rotateY',       'rotate3d',      Rotate]
    ['rotateZ',       'rotate3d',      Rotate]
    ['rotate3d',      'rotate3d',      Rotate]
  ]
  #-------------------------------------------------------------------------}}}

  class window.Ani
    constructor: (@options) ->
      this.init()

    init: ->
      # The object for all keyframe actions. The key represents the keyframe
      # (get it?) and the content should be stored the corrispoding  Property
      # object
      @actions = []
      # we default to 0% (starting) keyframe
      this.keyframe 0
      this.setup_methods()

    keyframe: (key) ->
      @current_keyframe = key
      @actions[key] = @actions[key] || []
      this

  #---  Private  --------------------------------------------------------------

    setup_methods: ->
      for meth_props in property_groups
        this.wrap_prop_method meth_props[0], meth_props[1], meth_props[2]

    wrap_prop_method: (method_name, prop_name, klass) ->
      this.add_prototype_method method_name, (value...) =>
        this.property prop_name, method_name, klass, value
        
    add_prototype_method: (method_name, callback) ->
      Ani.prototype[method_name] = callback

    # Determines if a property should be created or if it just needs to be
    # updated, the Property object will take care of the operations after
    # this point
    property: (prop_name, method_name, klass, value) ->
      if @actions[@current_keyframe][prop_name]?
        @actions[@current_keyframe][prop_name].update method_name, value
      else
        @actions[@current_keyframe][prop_name] = new klass(method_name, value)
      this

  #---  Class Methods  -------------------------------------------------------
  
    Ani.get_sheet = ->
      if not sheet = document.querySelector('#ani_stylesheet')
        sheet = document.createElement("style")
        sheet.setAttribute("id","ani_stylesheet")
        document.documentElement.appendChild(sheet)
      sheet

# vim:fdm=marker
