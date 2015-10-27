Path      = require "path"
Octonode  = require "octonode"
ApiConfig = require(Path.join(__dirname, "api_config")).ApiConfig
###########################################################################

class TokenVerifier
  constructor: (token) ->
    @token = token.trim()

    config = new ApiConfig(@token, null)
    @api   = Octonode.client(config.apiToken(), {hostname: config.hostname })

  valid: (cb) ->
    @api.get "/user", (err, data, headers) ->
      scopes = headers? and headers['x-oauth-scopes']

      if err
        cb({message: 'error making get request to /user', err: err}, false)
        return

      if scopes
        if scopes.indexOf('repo') >= 0
          cb(true)
        else if scopes.indexOf('repo_deployment') >= 0
          cb(true)
        else
          cb({message: 'repo or repo_deployment not found in scopes', scopes: scopes}, false)
      else
        cb({message: 'scopes not found in headers', headers: headers}, false)

exports.TokenVerifier = TokenVerifier
