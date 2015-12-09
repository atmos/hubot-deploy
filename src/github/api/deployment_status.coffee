Path         = require "path"
Version      = require(Path.join(__dirname, "..", "..", "version")).Version
ScopedClient = require "scoped-http-client"

class DeploymentStatus
  constructor: (@apiToken, @repoName, @number) ->
    @state       = undefined
    @targetUrl   = undefined
    @description = undefined

  postParams: () ->
    data =
      state: @state
      target_url: @targetUrl
      description: @description
    JSON.stringify(data)

  create: (callback) ->
    ScopedClient.create("https://api.github.com").
      header("Accept", "application/vnd.github+json").
      header("User-Agent", "hubot-deploy-v#{Version}").
      header("Authorization", "token #{@apiToken}").
      path("/repos/#{@repoName}/deployments/#{@number}/statuses").
      post(@postParams()) (err, res, body) ->
        callback(err, res, body)

exports.DeploymentStatus = DeploymentStatus
