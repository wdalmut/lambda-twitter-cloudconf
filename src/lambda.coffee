config = require '../config.json'

Me = require('./me').Me
Twitter = require('twitter-js-client').Twitter

client = new Twitter config
twitter = new Me client

exports.handler = (event, context) ->
  twitter.tweetAbout(event).then(
    () ->
      context.done null, ""
    (err) ->
      context.done err, "Unable to tweet!"
  )

