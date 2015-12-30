fernet = require 'fernet'

class Vault
  constructor: (@user) ->
    @user?.vault or= {}
    @vault = @user.vault

  set: (key, value) ->
    token = new fernet.Token(secret: @currentSecret())
    @vault[key] = token.encode(JSON.stringify(value))

  get: (key) ->
    return undefined unless @vault[key]
    for secret in @secrets()
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
    @secrets()[0]

  secrets: ->
    (new fernet.Secret(secret) for secret in process.env.HUBOT_FERNET_SECRETS.split(","))

exports.Vault = Vault
