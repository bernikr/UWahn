---
---

$ => @P = new Processing('canvas', ready)

ready = (P) ->
  P.setup = ->
    P.size($(window).width(),$(window).height())
    setInterval P.redraw, 50 # I don't know, why this is needed...

  P.draw = ->
