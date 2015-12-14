class PullRequest
  constructor: (@id, @payload) ->
    deployment   = @payload.deployment
    @name        = @payload.repository.name
    @state       = @payload.pull_request.state
    @number      = @payload.number
    @repoName    = @payload.repository.full_name

  toSimpleString: ->
    "hubot-deploy: https://#{github.com}/#{@repoName}/pull/#{@number}"

exports.PullRequest = PullRequest
