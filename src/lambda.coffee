console.log "loading event"

aws = require 'aws-sdk'
Twitter = require('twitter-js-client').Twitter
s3 = new aws.S3 {apiVersion: '2006-03-01'}
request = require("request").defaults({ encoding: null })

config = require '../config.json'

exports.handler = (event, context) ->

  Me = class Me
    tweet: (event) ->
      user = this.getUserFrom event

      twitter = new Twitter config

      uploadError = (err) ->
        console.log err
        context.done "error", "unable to upload the image"

      uploadOk = (data) ->
        data = JSON.parse(data)
        console.log data.media_id_string
        twitter.postTweet {
            status: "Hey @" + user + " here is your picture: http://example.walterdalmut.com/" + event.Records[0].s3.object.key
            media_ids: [data.media_id_string]
          },
          (err) ->
            context.done "error", err
          () ->
            context.done null, ""

      request.get "http://example.walterdalmut.com/" + event.Records[0].s3.object.key, (err, res, body) ->
        twitter.postMedia {
          media: body.toString "base64"
        }, uploadError, uploadOk


    getUserFrom: (event) ->
      bucket = event.Records[0].s3.bucket.name
      key = event.Records[0].s3.object.key
      parts = key.split "/"

      return parts[0]

  twitter = new Me
  twitter.tweet event

