debug = true

log = (msg...) ->
  if jasmine?
    jasmine.log(msg) if debug
  else
    console.log(msg) if debug

ani_methods = {
               translate: ['translate3d( % )', ['tX', 'tY', 'tZ'], ['px', '%']],
               rotate: ['rotate( % )', ['rot'], ['rad']]
              }

trans_methods = [
                  ['transition_delay', 'delay'],
                  ['transition_ease', 'ease'],
                  ['transition_time', 'time']
                ]
class Ani
  constructor: (@ele) ->
    @.init()

  init: ->
    @ani_o            = {0:{rules:{}}}
    @transition       = {}
    @current_keyframe = 0
    @sheet            = get_ani_sheet()
    @.setup_animatable_methods()
    @.setup_transition_methods()

  keyframe: (frame) ->
    @current_keyframe = frame
    @ani_o[frame]     = {rules:{}} unless @ani_o[frame]?
    this

  # Private Methods
  setup_transition_methods: ->
    for meth in trans_methods
      self = @
      do (self, meth) ->
        self.add_method meth[0], (opt) ->
          @transition[meth[1]] = opt
          return self

  setup_animatable_methods: ->
    for method_name, method_opts of ani_methods
      self = @
      do (self, method_name, method_opts) ->
        self.add_method method_name, (opt) ->
          @ani_o[@current_keyframe].rules[method_name] = opt
          return self

  add_method: (method_name, callback) ->
    Ani.prototype[method_name] = callback

  create_keyframe_block: ->
    browser_type = 'webkit'
    rules = ""
    for keyframe, rule_obj of @ani_o
      rules_str = ""
      for rule_type, properties of rule_obj.rules
        rules_str += format_rule(rule_type, properties) + ';'
      rules += "#{keyframe}% { #{rules_str} }"
    "@-#{browser_type}-keyframes 'testing' { #{rules} }"

  format_rule = (prop, property_obj) ->
    input_options = ani_methods[prop][1]
    if input_options.length > 1
      rule_opt_str = ""
      for prop_val, i in input_options
        rule = property_obj[prop_val] or 0
        rule += (ani_methods[prop][2])[0]
        rule += ', ' if i != input_options.length - 1
        rule_opt_str += rule
    ani_methods[prop][0].replace('%', rule_opt_str)

  get_ani_sheet = ->
    if not sheet = document.querySelector('#ani_stylesheet')
      sheet = document.createElement("style")
      sheet.setAttribute("id","ani_stylesheet")
      document.documentElement.appendChild(sheet)
    sheet

window.Ani = Ani
