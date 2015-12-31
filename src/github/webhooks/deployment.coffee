class Deployment
  constructor: (@id, @payload) ->
    deployment   = @payload.deployment
    @name        = @payload.repository.name
    @repoName    = @payload.repository.full_name

    @number      = deployment.id
    @sha         = deployment.sha.substring(0,7)
    @ref         = deployment.ref
    @task        = deployment.task
    @environment = deployment.environment
    @notify      = deployment.payload.notify

    if @notify? and @notify.user?
      @actorName = @notify.user
    else
      @actorName = deployment.creator.login

    if deployment.payload.yubikey?
      @yubikey = deployment.payload.yubikey

    if @payload.deployment.sha is @ref
      @ref = @sha

  toSimpleString: ->
    "hubot-deploy: #{@actorName}'s deployment ##{@number} of #{@name}/#{@ref} to #{@environment} requested."

exports.Deployment = Deployment

