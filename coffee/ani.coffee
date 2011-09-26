log = (msg...) ->
  if jasmine?
    jasmine.log(msg) if debug
  else
    console.log(msg) if debug

class window.Ani
  #---  constructor()  ----------------------------------------------------{{{1
  constructor: (@options) ->
    @.init()

  init: ->


# vim:fdm=marker
