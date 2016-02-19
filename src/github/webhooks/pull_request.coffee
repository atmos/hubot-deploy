class PullRequest
  constructor: (@id, @payload) ->
    @name        = @payload.repository.name
    @actor       = @payload.sender.login
    @title       = @payload.pull_request.title
    @branch      = @payload.pull_request.head.ref
    @state       = @payload.pull_request.state
    @merged      = @payload.pull_request.merged
    @action      = @payload.action
    @number      = @payload.number
    @repoName    = @payload.repository.full_name

  toSimpleString: ->
    "hubot-deploy: #{@actor} #{@action} pull request ##{@number}: #{@branch} " +
      "https://github.com/#{@repoName}/pull/#{@number}/files"

exports.PullRequest = PullRequest
