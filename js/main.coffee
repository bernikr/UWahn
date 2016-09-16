---
---
@P = null # global object to interact with Processing
@data =
  game:
    active: true
    scroll: 0

{% include_relative functions.coffee %}
{% include_relative game.coffee %}


$ -> new Processing('canvas', ready)

ready = (P) =>
  @P = P # Make Processing globaly avalible
  P.setup = ->
    resize()
    $('canvas').css('image-rendering', '') # remove the Anti-Aliasing inline-css
    data.loadAssets()
    setInterval P.redraw, 50 # I don't know, why this is needed...

  P.draw = ->
    P.translate(P.width/2 , P.height/2)
    P.background(0)
    data.game.draw() if data.game.active

resize = ->
  height = 400
  ratio = $(window).width()/$(window).height() # get ratio of the current window
  width = Math.round(height*ratio/2)*2 # round width to an even integer
  P.size(width, height)

$(window).resize -> resize()
