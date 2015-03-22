q = require 'q'
aws = require 'aws-sdk'

exports.Me = class Me

  constructor: (@twitter, @messageBox, @watermarker) ->

  tweetAbout: (event) ->
    dfd = q.defer()

    [user, tweetId] = @getTweetDataFrom event
    imageUrl = @getImageUrlFrom event

    message = @messageBox.messageFor user

    @watermarker.prepare(imageUrl).toString().then(
      (imageData) =>
        @uploadImageToTwitter(imageData)
      (err) ->
        dfd.reject err
    ).then(
      (data) =>
        @replyWithData tweetId, message, data
      (err) ->
        dfd.reject err
    ).then(
      (message) ->
        dfd.resolve "OK"
      (err) ->
        dfd.reject err
    )

    return dfd.promise

  uploadImageToTwitter: (body) ->
    dfd = q.defer()

    @twitter.postMedia(
      {
        media: body
      }
      (err) ->
        dfd.reject err
      (data) ->
        data = JSON.parse(data)
        dfd.resolve data
    )

    dfd.promise

  replyWithData: (tweetId, message, data) ->
    dfd = q.defer()

    @twitter.postTweet {
        status: message
        media_ids: [data.media_id_string]
        in_reply_to_status_id: tweetId
      },
      (err) ->
        dfd.reject err
      () ->
        dfd.resolve true

    dfd.promise

  getImageUrlFrom: (event) ->
    "http://#{event.Records[0].s3.bucket.name}/#{event.Records[0].s3.object.key}"

  getTweetDataFrom: (event) ->
    bucket = event.Records[0].s3.bucket.name
    key = event.Records[0].s3.object.key
    [userId, filename] = key.split "/"

    [tweetId, ext] = filename.split "."

    return [userId, tweetId]



