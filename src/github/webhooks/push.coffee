class Push
  constructor: (@id, @payload) ->
    @actor = "atmos"
    @count = 1

  toSimpleString: ->
    "hubot-deploy: #{@actor} pushed #{@count} commits"

exports.Push = Push
