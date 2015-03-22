config = require '../config.json'

Me = require('./me').Me
Box = require('./message-box').Box
Twitter = require('twitter-js-client').Twitter

box = new Box
client = new Twitter config
twitter = new Me client, box

exports.handler = (event, context) ->
  twitter.tweetAbout(event).then(
    () ->
      context.done null, ""
    (err) ->
      context.done err, "Unable to tweet!"
  )

