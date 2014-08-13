Octonode = require "octonode"
###########################################################################

class TokenVerifier
  constructor: (token) ->
    @token = token.trim()
    @api   = Octonode.client(@token)

  valid: (cb) ->
    @api.get "/user", (err, status, body, headers) ->
      scopes = headers? and headers['x-oauth-scopes']
      if scopes
        if scopes.indexOf('repo') >= 0
          cb(true)
        else if scopes.indexOf('repo_deployment') >= 0
          cb(true)
        else
          cb(false)
      else
        cb(false)

exports.TokenVerifier = TokenVerifier
