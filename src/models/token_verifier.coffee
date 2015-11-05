Path      = require "path"
Octonode  = require "octonode"
ApiConfig = require(Path.join(__dirname, "api_config")).ApiConfig
###########################################################################

VaultKey = "hubot-deploy-github-secret"
class TokenVerifier
  constructor: (token) ->
    @token = token?.trim()

    @config = new ApiConfig(@token, null)
    @api   = Octonode.client(@config.token, {hostname: @config.hostname})

  valid: (cb) ->
    @api.get "/user", (err, status, data, headers) ->
      scopes = headers?['x-oauth-scopes']
      if scopes?.indexOf('repo') >= 0
        cb(true)
      else
        cb(false)

exports.VaultKey      = VaultKey
exports.TokenVerifier = TokenVerifier
