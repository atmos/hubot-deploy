class PullRequest
  constructor: (@id, @payload) ->
    deployment   = @payload.deployment
    @name        = @payload.repository.name
    @state       = @payload.pull_request.state
    @number      = @payload.number
    @repoName    = @payload.repository.full_name

  toSimpleString: ->
    "hubot-deploy: #{@actorName}'s deployment ##{@number} of #{@name}/#{@ref} to #{@environment} requested."

exports.PullRequest = PullRequest
