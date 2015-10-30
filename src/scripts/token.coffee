# Description
#   Enable deployments from chat that correctly attribute you as the creator - https://github.com/atmos/hubot-deploy
#
# Commands:
#   hubot deploy-token:set:github <token> - Sets your user's GitHub deployment token. Requires repo scope.
#   hubot deploy-token:reset:github - Resets your user's GitHub deployment token.
#   hubot deploy-token:verify:github - Verifies that your GitHub deployment token is valid.
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
    user  = robot.brain.userForId msg.envelope.user.id
    token = msg.match[1]

    # Versions of hubot-deploy < 0.9.0 stored things unencrypted, encrypt them.
    delete(user.githubDeployToken)

    verifier = new TokenVerifier(token)
    verifier.valid (err, result) ->
      unless err
        msg.reply "Your GitHub token is valid. I stored it for future use."
        robot.vault.forUser(user).set("hubot-deploy-github-secret", verifier.token)
      else
        robot.logger.info err
        msg.reply err.message

  robot.respond ///#{DeployPrefix}-token:reset:github$///i, (msg) ->
    user = robot.brain.userForId msg.envelope.user.id
    robot.vault.forUser(user).unset("hubot-deploy-github-secret")
    # Versions of hubot-deploy < 0.9.0 stored things unencrypted, encrypt them.
    delete(user.githubDeployToken)
    msg.reply "I nuked your GitHub token. I'll try to use my default token until you configure another."

  robot.respond ///#{DeployPrefix}-token:verify:github$///i, (msg) ->
    user = robot.brain.userForId msg.envelope.user.id
    # Versions of hubot-deploy < 0.9.0 stored things unencrypted, encrypt them.
    delete(user.githubDeployToken)
    token = robot.vault.forUser(user).get("hubot-deploy-github-secret")
    verifier = new TokenVerifier(token)
    verifier.valid (err, result) ->
      unless err
        msg.reply "Your GitHub token is valid on #{verifier.config.hostname}."
      else
        robot.logger.info err
        msg.reply err.message
