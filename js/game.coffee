data.loadAssets = ->
  data.assets =
    background:
      tracks: P.loadImage('assets/tracks.png')
      transition1: P.loadImage('assets/transition1.png')
      transition2: P.loadImage('assets/transition2.png')
      station: P.loadImage('assets/station.png')

  t  = data.assets.background.tracks
  t1 = data.assets.background.transition1
  t2 = data.assets.background.transition2
  s  = data.assets.background.station

  game.track.current = [t,t,t]
  game.track.buffer = [t2,s,t1,t]

game.draw = ->
  game.renderBackground()


game.renderBackground = ->

  currentBgs = game.track.current
  game.renderImg(currentBgs[0],
    game.track.scroll - currentBgs[1].width, 0)
  game.renderImg(currentBgs[1],
    game.track.scroll, 0)
  game.renderImg(currentBgs[2],
    game.track.scroll + currentBgs[1].width, 0)

  game.track.scroll -= game.track.speed
  if game.track.scroll < -currentBgs[1].width
    game.track.scroll += currentBgs[1].width
    currentBgs.push(game.track.buffer[0])
    currentBgs.shift()
    if game.track.buffer.length > 1
      game.track.buffer.shift()
