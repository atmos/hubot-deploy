###########################################################################
class Deployment
  constructor: (@id, @payload) ->
    @sha         = @payload.deployment.sha.substring(0,7)
    @ref         = @payload.deployment.ref
    @name        = @payload.repository.name
    @notify      = @payload.deployment.payload.notify
    @number      = @payload.deployment.id
    @repoName    = @payload.repository.full_name
    @environment = @payload.deployment.environment

    if @payload.deployment.sha is @ref
      @ref = @sha

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

    if @payload.deployment.sha is @ref
      @ref = @sha

exports.DeploymentStatus = DeploymentStatus
