Path  = require 'path'
Vault = require('./src/hubot/vault.coffee').Vault

module.exports = (robot, scripts) ->
  robot.vault =
    forUser: (user) ->
      new Vault(user)

  robot.loadFile(Path.resolve(__dirname, "src", "scripts"), "http.coffee")
  robot.loadFile(Path.resolve(__dirname, "src", "scripts"), "token.coffee")
  robot.loadFile(Path.resolve(__dirname, "src", "scripts"), "deploy.coffee")

  adapter = process.env.HUBOT_DEPLOY_ADAPTER
  if adapter?
    robot.loadFile(Path.resolve(__dirname, "src", "adapters"), "#{adapter}.coffee")
