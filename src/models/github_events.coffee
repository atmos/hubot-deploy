###########################################################################
class Deployment
  constructor: (@id, @payload) ->
    @number   = @payload.deployment.id
    @repoName = @payload.repository.full_name

exports.Deployment = Deployment

###########################################################################
class DeploymentStatus
  constructor: (@id, @payload) ->
    @status   = @payload.state
    @number   = @payload.deployment.id
    @repoName = @payload.repository.full_name

exports.DeploymentStatus = DeploymentStatus
