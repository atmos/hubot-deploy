###########################################################################
class DeploymentStatus
  constructor: (@id, @payload) ->
    @status   = @payload.state
    @repoName = @payload.repository.full_name

exports.DeploymentStatus = DeploymentStatus
