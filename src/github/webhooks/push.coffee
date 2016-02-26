class Push
  constructor: (@id, @payload) ->
    @actor = @payload.pusher.name
    @count = @payload.commits.length

    if @count > 1
      @commitMessage = "#{@count} commits"
    else
      @commitMessage = "a commit"

  toSimpleString: ->
    "hubot-deploy: #{@actor} pushed #{@commitMessage}"

exports.Push = Push
