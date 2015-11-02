Path      = require "path"
Octonode  = require "octonode"
ApiConfig = require(Path.join(__dirname, "api_config")).ApiConfig
###########################################################################

class TokenVerifier
  constructor: (token) ->
    @token = token?.trim()

    @config = new ApiConfig(@token, null)
    @api   = Octonode.client(@config.token, {hostname: @config.hostname})

  valid: (cb) ->
    @api.get "/user", (err, status, data, headers) ->
      scopes = headers? and headers['x-oauth-scopes']

      unless @token
        cb({message: 'Your GitHub token is invalid (empty), please set one.'}, false)
        return

      if err
        cb({message: 'Error occurred making get request to GitHub /user API endpoint.', err: err}, false)
        return

      if scopes
        if scopes.indexOf('repo') >= 0
          cb(null, true)
        else
          cb({message: "Your GitHub token is invalid, verify that it has 'repo' scope.", scopes: scopes}, false)
      else
        cb({message: 'No scopes listing was found in GitHub response headers.', scopes: JSON.stringify(scopes), headers: JSON.stringify(headers)}, false)

exports.TokenVerifier = TokenVerifier
