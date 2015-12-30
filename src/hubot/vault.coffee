fernet = require 'fernet'

class Vault
  constructor: (@user) ->
    @user?.vault or= {}
    @vault = @user.vault
    @secrets = @getSecrets()

  set: (key, value) ->
    token = new fernet.Token(secret: @currentSecret())
    @vault[key] = token.encode(JSON.stringify(value))

  get: (key) ->
    return undefined unless @vault[key]
    for secret in @secrets
      token = new fernet.Token
        secret: secret
        token: @vault[key]
        ttl: 0
      try
        value = JSON.parse(token.decode())
        return value
      catch error
        continue

  unset: (key) ->
    delete @vault[key]

  currentSecret: ->
    @secrets[0]

  getSecrets: ->
    unless process.env.HUBOT_DEPLOY_FERNET_SECRETS?
      throw new Error("Please set a HUBOT_DEPLOY_FERNET_SECRETS string in the environment")
    fernetSecrets = process.env.HUBOT_DEPLOY_FERNET_SECRETS.split(",")
    (new fernet.Secret(secret) for secret in fernetSecrets)

exports.Vault = Vault
