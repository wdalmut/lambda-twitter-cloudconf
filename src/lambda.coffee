config = require '../config.json'

Me = require('./me').Me
Twitter = require('twitter-js-client').Twitter
Box = require('./message-box').Box
Watermark = require('./watermark').Watermark

box = new Box
client = new Twitter config
watermarker = new Watermark "./cloud.png"
twitter = new Me client, box, watermarker

exports.handler = (event, context) ->
  twitter.tweetAbout(event).then(
    () ->
      context.done null, ""
    (err) ->
      context.done err, "Unable to tweet!"
  )
