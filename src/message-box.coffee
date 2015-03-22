
exports.Box = class Box
  constructor: (@user) ->
    @messages = [
      "Hey, @#{@user} here is your picture!"
      "Hey, @#{@user} check out your picture!"
      "@#{@user} just joined the cloud-side of the conference!"
      "@#{@user} -> Proud to be Cloud!"
    ]

  message: ->
    @select()

  select: ->
    @messages[@at()]

  at: ->
    parseInt((Math.random() * 1e9) % @messages.length)

