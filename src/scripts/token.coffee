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

TokenForBrain  = require(Path.join(__dirname, "..", "models", "token_verifier")).VaultKey
TokenVerifier  = require(Path.join(__dirname, "..", "models", "token_verifier")).TokenVerifier
###########################################################################
module.exports = (robot) ->
  robot.respond ///#{DeployPrefix}-token:set:github\s+(.*)///i, (msg) ->
    user  = robot.brain.userForId msg.envelope.user.id
    token = msg.match[1]

    # Versions of hubot-deploy < 0.9.0 stored things unencrypted, encrypt them.
    delete(user.githubDeployToken)

    verifier = new TokenVerifier(token)
    verifier.valid (result) ->
      if result
        robot.vault.forUser(user).set(TokenForBrain, verifier.token)
        msg.send "Your GitHub token is valid. I stored it for future use."
      else
        msg.send "Your GitHub token is invalid, verify that it has 'repo' scope."

  robot.respond ///#{DeployPrefix}-token:reset:github$///i, (msg) ->
    user = robot.brain.userForId msg.envelope.user.id
    robot.vault.forUser(user).unset(TokenForBrain)
    # Versions of hubot-deploy < 0.9.0 stored things unencrypted, encrypt them.
    delete(user.githubDeployToken)
    msg.reply "I nuked your GitHub token. I'll try to use my default token until you configure another."

  robot.respond ///#{DeployPrefix}-token:verify:github$///i, (msg) ->
    user = robot.brain.userForId msg.envelope.user.id
    # Versions of hubot-deploy < 0.9.0 stored things unencrypted, encrypt them.
    delete(user.githubDeployToken)
    token = robot.vault.forUser(user).get(TokenForBrain)
    verifier = new TokenVerifier(token)
    verifier.valid (result) ->
      if result
        msg.send "Your GitHub token is valid on #{verifier.config.hostname}."
      else
        msg.send "Your GitHub token is invalid, verify that it has 'repo' scope."
