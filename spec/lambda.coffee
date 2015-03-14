handler = require '../src/lambda'

describe "Lambda callback", ->
  beforeEach ->
    @context = {}
    @context.done = () ->

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
              "name": "sourcebucket",
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
    [userId, tweetId] = me.getUserFrom @event

    expect(userId).toBe "walterdalmut"
    expect(tweetId).toBe "1924762"

  it "should expose the lambda handler", ->
    spyOn(handler, "handler").andReturn null

    handler.handler(@event, @context)

    expect(handler.handler).toHaveBeenCalled()

