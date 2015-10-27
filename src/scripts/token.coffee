# Description
#   Enable deployments from chat that correctly attribute you as the creator - https://github.com/atmos/hubot-deploy
#
# Commands:
#   hubot deploy-token:set:github <token> - Sets your user's GitHub deployment token. Requires repo_deployment scope.
#   hubot deploy-token:reset:github - Resets your user's GitHub deployment token.
#
supported_tasks = [ "#{DeployPrefix}-token" ]

Path           = require("path")
Patterns       = require(Path.join(__dirname, "..", "models", "patterns"))
Deployment     = require(Path.join(__dirname, "..", "models", "deployment")).Deployment
DeployPrefix   = Patterns.DeployPrefix
DeployPattern  = Patterns.DeployPattern
DeploysPattern = Patterns.DeploysPattern

TokenVerifier  = require(Path.join(__dirname, "..", "models", "token_verifier")).TokenVerifier
###########################################################################
module.exports = (robot) ->
  robot.respond ///#{DeployPrefix}-token:set:github (.*)///i, (msg) ->
    token = msg.match[1]

    verifier = new TokenVerifier(token)
    verifier.valid (err, result) ->
      if result
        msg.reply "Your token is valid. I stored it for future use."
        user = robot.brain.userForId msg.envelope.user.id
        user.githubDeployToken = verifier.token
      else
        robot.logger.error err
        msg.reply "Your token is invalid, verify that it has 'repo_deployment' scope."

  robot.respond ///#{DeployPrefix}-token:reset:github$///i, (msg) ->
    user = robot.brain.userForId msg.envelope.user.id
    delete(user.githubDeployToken)
    msg.reply "I nuked your deployment token. I'll use my default token until you configure another."
