console.log "loading event"

aws = require 'aws-sdk'
s3 = new aws.S3 {apiVersion: '2006-03-01'}
Twitter = require('twitter-js-client').Twitter
request = require("request").defaults({ encoding: null })

config = require '../config.json'

exports.Me = class Me
  tweet: (event, context) ->
    [user, tweetId] = this.getUserFrom event

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
          in_reply_to_status_id: tweetId
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
    [userId, filename] = key.split "/"

    [tweetId, ext] = filename.split "."

    return [userId, tweetId]


exports.handler = (event, context) ->
  twitter = new Me()
  twitter.tweet event, context

