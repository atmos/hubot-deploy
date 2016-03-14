Fernet = require "fernet"

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

    if process.env.HUBOT_DEPLOY_ENCRYPT_PAYLOAD and proccess.env.HUBOT_DEPLOY_FERNET_SECRETS
      fernetSecret = new Fernet.Secret(process.env.HUBOT_DEPLOY_FERNET_SECRETS)
      fernetToken  = new Fernet.Token(secret: fernetSecret, token: deployment.payload, ttl: 0)

      payload = deployment.payload
      deployment.payload = fernetToken.decode(payload)

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

