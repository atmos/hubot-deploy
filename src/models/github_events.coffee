###########################################################################
class Deployment
  constructor: (@id, @payload) ->
    @ref         = @payload.deployment.ref
    @sha         = @payload.deployment.sha.substring(0,7)
    @name        = @payload.repository.name
    @notify      = @payload.deployment.payload.notify
    @number      = @payload.deployment.id
    @repoName    = @payload.repository.full_name
    @environment = @payload.deployment.environment

exports.Deployment = Deployment

###########################################################################
class DeploymentStatus
  constructor: (@id, @payload) ->
    @ref         = @payload.deployment.ref
    @sha         = @payload.deployment.sha.substring(0,7)
    @name        = @payload.repository.name
    @state       = @payload.deployment_status.state
    @notify      = @payload.deployment.payload.notify
    @number      = @payload.deployment.id
    @repoName    = @payload.repository.full_name
    @targetUrl   = @payload.deployment_status.target_url
    @environment = @payload.deployment.environment

exports.DeploymentStatus = DeploymentStatus
