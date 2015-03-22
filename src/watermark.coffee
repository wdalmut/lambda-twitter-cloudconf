q = require 'q'
gm = require('gm').subClass({ imageMagick: true })

exports.Watermark = class Watermark

  constructor: (@iconPath) ->

  prepare: (@picture) ->
    @prepared = gm()
      .subCommand('composite')
      .gravity('SouthEast')
      .in('-compose', 'Over', @iconPath, @picture)
    @

  toString: () ->
    dfd = q.defer()

    if not @prepared then throw new Error "missing prepared image"

    @prepared.toBuffer('png', (err, buffer) ->
      if not err then dfd.resolve(buffer.toString "base64") else dfd.reject(err)
    )

    dfd.promise
