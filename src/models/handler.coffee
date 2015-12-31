Crypto       = require "crypto"
Fernet       = require "fernet"

GitHubDeploymentStatus = require("../github/api").GitHubDeploymentStatus

class Handler
  constructor: (@robot, @deployment) ->
    @ref              = @deployment.ref
    @sha              = @deployment.sha
    @repoName         = @deployment.repoName
    @environment      = @deployment.environment
    @notify           = @deployment.notify
    @actualDeployment = @deployment.payload.deployment
    @provider         = @actualDeployment.payload?.config?.provider
    @number           = @actualDeployment.id
    @task             = @actualDeployment.task

  run: (callback) ->
    try
      unless @robot.name is @actualDeployment.payload.robotName
        throw new Error "Received request for unintended robot #{@actualDeployment.payload.robotName}."
      unless @notify?
        throw new Error("Not deploying #{@repoName}/#{@ref} to #{@environment}. Not chat initiated.")
      callback undefined, @
    catch err
      callback err, @

exports.Handler = Handler
