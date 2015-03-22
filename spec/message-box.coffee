Box = require('../src/message-box').Box

describe "The message box", ->

  it "should expose a message for a user", ->
    box = new Box "walterdalmut"
    message = box.message()

    expect(message).toEqual jasmine.any String
    expect(message.length).toBeGreaterThan 1

  it "should select one message", ->
    box = new Box "walterdalmut"
    spyOn(box, "select").and.returnValue "a message"
    message = box.message()

    expect(message).toEqual "a message"

  it "should reply with an overrided messages", ->
    box = new Box "walterdalmut"
    box.messages = ["test message"]
    message = box.message()

    expect(message).toEqual "test message"


  it "should select the message at first position", ->
    box = new Box "walterdalmut"

    spyOn(box, "at").and.returnValue 0
    message = box.message()

    expect(message).toEqual "Hey, @walterdalmut here is your picture!"

