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

    # Versions of hubot-deploy < 0.9.0 stored things unencrypted, encrypt them.
    delete(user.githubDeployToken)

    verifier = new TokenVerifier(token)
    verifier.valid (result) ->
      if result
        msg.reply "Your token is valid. I stored it for future use."
        vault(user).set("hubot-deploy-token-github", verifier.token)
      else
        msg.reply "Your token is invalid, verify that it has 'repo_deployment' scope."

  robot.respond ///#{DeployPrefix}-token:reset:github$///i, (msg) ->
    user = robot.brain.userForId msg.envelope.user.id
    vault(user).unset("hubot-deploy-token-github")
    # Versions of hubot-deploy < 0.9.0 stored things unencrypted, encrypt them.
    delete(user.githubDeployToken)
    msg.reply "I nuked your deployment token. I'll use my default token until you configure another."
