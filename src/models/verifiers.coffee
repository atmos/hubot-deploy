Path      = require "path"
Octonode  = require "octonode"
Address4  = require("ip-address").Address4
GitHubApi = require(Path.join(__dirname, "..", "github", "api")).Api
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
    gitHubSubnets = process.env.HUBOT_DEPLOY_GITHUB_SUBNETS || "192.30.252.0/22"
    @subnets = (new Address4(subnet.trim()) for subnet in gitHubSubnets.split(','))

  ipIsValid: (ipAddress) ->
    address = new Address4("#{ipAddress}/24")
    for subnet in @subnets
      return true if address.isInSubnet(subnet)
    false

class GitHubTokenVerifier
  constructor: (token) ->
    @token = token?.trim()

  valid: (cb) ->
    ScopedClient.create("https://api.github.com").
      header("User-Agent", "hubot-deploy/0.13.1").
      header("Authorization", "token #{@token}").
      path("/user").
      get() (err, res, body) ->
        scopes = res.headers?['x-oauth-scopes']
        if err
          cb(false)
        else if res.statusCode isnt 200
          cb(false)
        else if scopes?.indexOf("repo") < 0
          cb(false)
        else
          user = JSON.parse(body)
          cb(user)

class HerokuTokenVerifier
  constructor: (token) ->
    @token = token?.trim()

  valid: (cb) ->
    ScopedClient.create("https://api.heroku.com").
      header("Accept", "application/vnd.heroku+json; version=3").
      header("Authorization", "Bearer #{@token}").
      path("/account").
      get() (err, res, body) ->
        if err
          cb(false)
        else if res.statusCode isnt 200
          cb(false)
        else
          user = JSON.parse(body)
          cb(user)

exports.VaultKey                 = VaultKey
exports.ApiTokenVerifier         = ApiTokenVerifier
exports.GitHubTokenVerifier      = GitHubTokenVerifier
exports.HerokuTokenVerifier      = HerokuTokenVerifier
exports.GitHubWebHookIpVerifier  = GitHubWebHookIpVerifier
