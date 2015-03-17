handler = require '../src/me'

q = require 'q'

describe "Twitter wrapper", ->
  beforeEach ->
    @event = {
      "Records": [
        {
          "eventVersion": "2.0",
          "eventSource": "aws:s3",
          "awsRegion": "us-east-1",
          "eventTime": "1970-01-01T00:00:00.000Z",
          "eventName": "ObjectCreated:Put",
          "userIdentity": {
            "principalId": "AAAAAAAAAAAAAAAAAAAAA"
          },
          "requestParameters": {
            "sourceIPAddress": "127.0.0.1"
          },
          "responseElements": {
            "x-amz-request-id": "zzzzzzzzzzzzzzzz",
            "x-amz-id-2": "xxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxx"
          },
          "s3": {
            "s3SchemaVersion": "1.0",
            "configurationId": "testConfigRule",
            "bucket": {
              "name": "example.walterdalmut.com",
              "ownerIdentity": {
                "principalId": "XXXXXXXXXXXXXXXXX"
              },
              "arn": "arn:aws:s3:::example.walterdalmut.com"
            },
            "object": {
              "key": "walterdalmut/1924762.jpg",
              "size": 1024,
              "eTag": "11111111111111111111111111111111"
            }
          }
        }
      ]
    }

  it "should extract the tweet id and the user screen name", ->
    me = new handler.Me
    [userId, tweetId] = me.getTweetDataFrom @event

    expect(userId).toBe "walterdalmut"
    expect(tweetId).toBe "1924762"

  it "should compose the right image url from the event", ->
    me = new handler.Me
    url = me.getImageUrlFrom @event

    expect(url).toEqual("http://example.walterdalmut.com/walterdalmut/1924762.jpg")

  it "should upload images to twitter and reply to a message", (done) ->

    upload = q.defer()
    upload.resolve {
      media_id_string: "1234356746784359353"
    }

    tweet = q.defer()
    tweet.resolve "OK"

    me = new handler.Me {}

    spyOn(me, "uploadImageToTwitter").and.returnValue upload.promise
    spyOn(me, "replyWithData").and.returnValue tweet.promise

    me.tweetAbout(@event).then(() ->
      expect(me.uploadImageToTwitter).toHaveBeenCalled()
      expect(me.replyWithData).toHaveBeenCalled()
      done()
    )

  it "should not reply to a tweet when we are not able to upload a picture", (done) ->
    upload = q.defer()
    upload.reject "test upload fails"

    tweet = q.defer()
    tweet.resolve "OK"

    me = new handler.Me {}

    spyOn(me, "uploadImageToTwitter").and.returnValue upload.promise
    spyOn(me, "replyWithData").and.returnValue tweet.promise

    me.tweetAbout(@event).then(
      () ->
      () ->
        expect(me.uploadImageToTwitter).toHaveBeenCalled()
        expect(me.replyWithData).not.toHaveBeenCalled()
        done()
    )


