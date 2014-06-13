# Description
#   Cut GitHub deployments from chat that deploy via hooks - https://github.com/atmos/hubot-deploy
#
# Commands:
#   hubot where can I deploy <app> - see what environments you can deploy app
#   hubot deploy:version - show the script version and node/environment info
#   hubot deploy <app>/<branch> to <env>/<roles> - deploys <app>'s <branch> to the <env> environment's <roles> servers
#   hubot deploy:lock <app> in <env> <reason> - lock the app in an environment with a reason
#   hubot deploy:unlock <app> in <env> - unlock an app in an environment
#   hubot auto-deploy:enable <app> in <env> - enable auto-deployment for the app in environment
#   hubot auto-deploy:disable <app> in <env> - disable auto-deployment for the app in environment
#
supported_tasks = [ DeployPrefix ]

Path          = require("path")
Deployment    = require(Path.join(__dirname, "deployment")).Deployment
DeployPrefix  = require(Path.join(__dirname, "patterns")).DeployPrefix
DeployPattern = require(Path.join(__dirname, "patterns")).DeployPattern
###########################################################################
module.exports = (robot) ->
  ###########################################################################
  # where can i deploy <app>
  #
  # Displays the available environments for an application
  robot.respond ///where\x20can\x20i\x20#{DeployPrefix}\x20([-_\.0-9a-z]+)\?*$///i, (msg) ->
    name = msg.match[1]

    deployment = new Deployment(name, "unknown", "q")

    output  = "Environments for #{deployment.name}\n"
    output += "----------------------------------------------------------\n"
    for environment in deployment.environments
      output += "#{environment}      | Unknown state :cry:\n"
      output += "----------------------------------------------------------\n"

    msg.send output

  ###########################################################################
  # deploy hubot/topic-branch to staging
  #
  # Actually dispatch deployment requests to GitHub
  robot.respond DeployPattern, (msg) ->
    task  = msg.match[1].replace(DeployPrefix, "deploy")
    force = msg.match[2] == '!'
    name  = msg.match[3]
    ref   = (msg.match[4]||'master')
    env   = (msg.match[5]||'production')
    hosts = (msg.match[6]||'')

    deployment = new Deployment(name, ref, task, env, force, hosts)

    unless deployment.isValidApp()
      msg.reply "#{name}? Never heard of it."
      return
    unless deployment.isValidEnv()
      msg.reply "#{name} doesn't seem to have an #{env} environment."
      return

    deployment.room = msg.message.user.room
    deployment.user = msg.envelope.user.name

    deployment.adapter = robot.adapterName

    console.log JSON.stringify(deployment.requestBody())

    deployment.post (responseMessage) ->
      msg.reply responseMessage if responseMessage?

  ###########################################################################
  # deploy:version
  #
  # Useful for debugging
  robot.respond ///#{DeployPrefix}\:version$///i, (msg) ->
    pkg = require Path.join __dirname, '..', 'package.json'
    msg.send "hubot-deploy v#{pkg.version}/hubot v#{robot.version}/node #{process.version}"
