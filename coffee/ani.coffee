#===  ani_methods  ========================================================{{{1
ani_methods = {
  border_top_width: ['border-top-width: %', ['px'],             ['px', '%']],
  border_width:     ['border-width: %',     ['px'],             ['px', '%']],
  translate:        ['translate3d( % )',    ['tx', 'ty', 'tz'], ['px', '%']],
  rotate:           ['rotate( % )',         ['rot'],            ['rad']]
}
#===========================================================================}}}

#===  transform_methods  =================================================={{{1
tranform_methods = [
  'matrix',
  'rotate',
  'scale',
  'scaleX',
  'scaleY',
  'skew',
  'skewX',
  'skewY',
  'translate',
  'translateX',
  'translateY'
]
#===========================================================================}}}
#===  trans_methods  ======================================================{{{1
# TODO: needs refactoring
trans_methods = [
  ['transition_delay',           'delay'],
  ['transition_duration',        'duration'],
  ['transition_iteration_count', 'iteration-count'],
  ['transition_timing_function', 'timing_function'],
  ['transition_time',            'time']
  ['transition_repeat',          'repeat']
]
#===========================================================================}}}

class Ani
  #---  constructor()  ----------------------------------------------------{{{1
  constructor: (@ele) ->
    @.init()
  #-------------------------------------------------------------------------}}}
  #---  init()  -----------------------------------------------------------{{{1
  init: ->
    @keyframe_rules   = {0:{rules:{} }}
    @transition       = {}
    @current_keyframe = 0
    @sheet            = get_ani_sheet()
    @.setup_animatable_methods()
    @.setup_transition_methods()
  #-------------------------------------------------------------------------}}}

  #---  keyframe()  -------------------------------------------------------{{{1
  keyframe: (frame) ->
    @current_keyframe = frame
    @keyframe_rules[frame] = {rules:{}} unless @keyframe_rules[frame]?
    @
  #-------------------------------------------------------------------------}}}
  #---  rotate() - test  --------------------------------------------------{{{1
  # rotate: (opts) ->
  #   switch typeof(opts)
  #     when 'object'
  #       log 'object'
  #       break
  #     when 'string'
  #       log 'string'
  #       break
  #     when 'number'
  #       log 'number'
  #       break
  #-------------------------------------------------------------------------}}}

  #---  Private Methods  ------------------------------------------------------
  #---  setup_transition_methods()  ---------------------------------------{{{1
  setup_transition_methods: ->
    for meth in trans_methods
      self = @
      do (self, meth) ->
        self.add_method meth[0], (opt) ->
          @transition[meth[1]] = opt
          self
  #-------------------------------------------------------------------------}}}
  #---  setup_animatable_methods()  ---------------------------------------{{{1
  setup_animatable_methods: ->
    for method_name, method_opts of ani_methods
      self = @
      do (self, method_name, method_opts) ->
        self.add_method method_name, (opt) ->
          @keyframe_rules[@current_keyframe].rules[method_name] = opt
          self
  #-------------------------------------------------------------------------}}}

  #---  add_method()  -----------------------------------------------------{{{1
  add_method: (method_name, callback) ->
    Ani.prototype[method_name] = callback
  #-------------------------------------------------------------------------}}}
  #---  create_keyframe_block()  ------------------------------------------{{{1
  create_keyframe_block: ->
    browser_type = 'webkit'
    rules = ""
    for keyframe, rule_obj of @keyframe_rules
      rules_str = ""
      for rule_type, properties of rule_obj.rules
        rules_str += format_css_rule(rule_type, properties) + ';'
      rules += "#{keyframe}% { #{rules_str} }"
    "@-#{browser_type}-keyframes 'testing' { #{rules} }"
  #-------------------------------------------------------------------------}}}
  #---  format_css_rule()  ------------------------------------------------{{{1
  format_css_rule = (prop, property_obj) ->
    input_options = ani_methods[prop][1]
    rule_opt_str = ""
    if input_options.length > 1
      # Multiple Values
      for prop_val, i in input_options
        rule = property_obj[prop_val] or 0
        rule += (ani_methods[prop][2])[0]
        rule += ' ' if i != input_options.length - 1
        rule_opt_str += rule
    else
      # Single Value
      rule_opt_str = property_obj + ani_methods[prop][2]
    ani_methods[prop][0].replace('%', rule_opt_str)
  #-------------------------------------------------------------------------}}}
  #---  get_ani_sheet()  --------------------------------------------------{{{1
  get_ani_sheet = ->
    if not sheet = document.querySelector('#ani_stylesheet')
      sheet = document.createElement("style")
      sheet.setAttribute("id","ani_stylesheet")
      document.documentElement.appendChild(sheet)
    sheet
  #-------------------------------------------------------------------------}}}

window.Ani = Ani
