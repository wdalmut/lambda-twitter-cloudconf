
exports.Box = class Box

  messageFor: (user)->
    @select(user)

  select: (user) ->
    @messages(user)[@at()]

  messages: (user) ->
    [
      "Hey, @#{user} here is your picture!"
      "Hey, @#{user} check out your picture!"
      "@#{user} just joined the cloud-side of the conference!"
      "@#{user} -> Proud to be Cloud!"
    ]

  at: ->
    parseInt((Math.random() * 1e9) % @messages.length)

