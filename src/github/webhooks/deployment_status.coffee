class DeploymentStatus
  constructor: (@id, @payload) ->
    deployment   = @payload.deployment
    @name        = deployment?.payload?.name or @payload.repository.name
    @repoName    = @payload.repository.full_name

    @number      = deployment.id
    @sha         = deployment.sha.substring(0,7)
    @ref         = deployment.ref
    @environment = deployment.environment
    @notify      = deployment.payload.notify
    if @notify? and @notify.user?
      @actorName = @notify.user
    else
      @actorName = deployment.creator.login

    @state       = @payload.deployment_status.state
    @targetUrl   = @payload.deployment_status.target_url

    if @payload.deployment.sha is @ref
      @ref = @sha

  toSimpleString: ->
    msg = "hubot-deploy: #{@actorName}'s deployment ##{@number} of #{@name}/#{@ref} to #{@environment} "
    switch @state
      when "success"
        msg += "was successful."
      when "failure", "error"
        msg += "failed."
      else
        msg += "is running."

    if @targetUrl?
      msg += " " + @targetUrl

    msg

exports.DeploymentStatus = DeploymentStatus
