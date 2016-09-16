data.loadAssets = ->
  assetsPath = staticFiles.filter (x) -> x.lastIndexOf('/assets/', 0) == 0

  for asset in assetsPath
    [filepath, ext] = asset.split('.')
    switch ext
      when 'png'
        path = filepath.split('/').splice(2)
        [folder..., file] = path
        index = (o,i,p,a) ->
          o[i] = {} if o[i] == undefined
          return o[i]
        f = folder.reduce(index, data.assets) # create folders as objects
        f[file] = P.loadImage(asset)
  console.log data.assets
