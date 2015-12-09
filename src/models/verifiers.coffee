Path      = require "path"
Octonode  = require "octonode"
Address4  = require("ip-address").Address4
GitHubApi = require(Path.join(__dirname, "github", "api")).Api
###########################################################################

VaultKey = "hubot-deploy-github-secret"

class ApiTokenVerifier
  constructor: (token) ->
    @token = token?.trim()

    @config = new GitHubApi(@token, null)
    @api   = Octonode.client(@config.token, {hostname: @config.hostname})

  valid: (cb) ->
    @api.get "/user", (err, status, data, headers) ->
      scopes = headers?['x-oauth-scopes']
      if scopes?.indexOf('repo') >= 0
        cb(true)
      else
        cb(false)

class GitHubWebHookIpVerifier
  constructor: () ->
    @subnets = [ new Address4("192.30.252.0/22") ]

  ipIsValid: (ipAddress) ->
    address = new Address4("#{ipAddress}/24")
    for subnet in @subnets
      return true if address.isInSubnet(subnet)
    false

exports.VaultKey                 = VaultKey
exports.ApiTokenVerifier         = ApiTokenVerifier
exports.GitHubWebHookIpVerifier  = GitHubWebHookIpVerifier
