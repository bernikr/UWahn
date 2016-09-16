# render a picture in the scrollable environment
data.game.renderImg = (image, x, y) ->
  P.imageMode P.CENTER
  P.image image, x-data.game.scroll, y, image.width, image.height
