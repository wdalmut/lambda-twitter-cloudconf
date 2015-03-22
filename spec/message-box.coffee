Box = require('../src/message-box').Box

describe "The message box", ->

  it "should expose a message for a user", ->
    box = new Box
    message = box.messageFor "walterdalmut"

    expect(message).toEqual jasmine.any String
    expect(message.length).toBeGreaterThan 1

  it "should select one message", ->
    box = new Box
    spyOn(box, "select").and.returnValue "a message"
    message = box.messageFor "walterdalmut"

    expect(message).toEqual "a message"

  it "should select the message at first position", ->
    box = new Box

    spyOn(box, "at").and.returnValue 0
    message = box.messageFor "walterdalmut"

    expect(message).toEqual "Hey, @walterdalmut here is your picture!"

