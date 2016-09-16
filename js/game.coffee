data.loadAssets = ->
  data.assets =
    background:
      tracks: P.loadImage('assets/tracks.png')


data.game.draw = ->
  data.game.renderImg(data.assets.background.tracks, 0, 0)
