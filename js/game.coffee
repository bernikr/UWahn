game.setup = ->
  bg = data.assets.background
  game.track.current = [bg.t,bg.t,bg.t]
  game.track.buffer = [bg.t]

game.draw = ->
  game.renderBackground()


game.renderBackground = ->
  # render
  track = game.track
  game.renderImg(track.current[0],
    track.scroll - track.current[1].width, 0)
  game.renderImg(track.current[1],
    track.scroll, 0)
  game.renderImg(track.current[2],
    track.scroll + track.current[1].width, 0)

  # scroll logic
  track.scroll -= track.speed
  if track.scroll < -track.current[1].width
    track.scroll += track.current[1].width
    track.current.push(track.buffer[0])
    track.current.shift()
    if track.buffer.length > 1
      track.buffer.shift()
