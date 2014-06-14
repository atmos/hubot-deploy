# Description
#   Cut GitHub deployments from chat that deploy via hooks - https://github.com/atmos/hubot-deploy
#
# Commands:
#   hubot where can I deploy <app> - see what environments you can deploy app
#   hubot deploy:version - show the script version and node/environment info
#   hubot deploy <app>/<branch> to <env>/<roles> - deploys <app>'s <branch> to the <env> environment's <roles> servers
#   hubot deploys <app>/<branch> in <env> - Displays recent deployments for <app>'s <branch> in the <env> environment
#   hubot deploy:lock <app> in <env> <reason> - lock the app in an environment with a reason
#   hubot deploy:unlock <app> in <env> - unlock an app in an environment
#   hubot auto-deploy:enable <app> in <env> - enable auto-deployment for the app in environment
#   hubot auto-deploy:disable <app> in <env> - disable auto-deployment for the app in environment
#
supported_tasks = [ DeployPrefix ]

Path          = require("path")
Patterns      = require(Path.join(__dirname, "patterns"))
Deployment    = require(Path.join(__dirname, "deployment")).Deployment

DeployPrefix   = Patterns.DeployPrefix
DeployPattern  = Patterns.DeployPattern
DeploysPattern = Patterns.DeploysPattern

Formatters    = require(Path.join(__dirname, "formatters"))

###########################################################################
module.exports = (robot) ->
  ###########################################################################
  # where can i deploy <app>
  #
  # Displays the available environments for an application
  robot.respond ///where\s+can\s+i\s+#{DeployPrefix}\s+([-_\.0-9a-z]+)///i, (msg) ->
    name = msg.match[1]

    try
      deployment = new Deployment(name)
      formatter  = new Formatters.WhereFormatter(deployment)

      msg.send formatter.message()
    catch err
      console.log err

  ###########################################################################
  # deploys <app> in <env>
  #
  # Displays the available environments for an application
  robot.respond DeploysPattern, (msg) ->
    name        = msg.match[2]
    environment = msg.match[4] || 'production'

    try
      deployment = new Deployment(name, null, null, environment)
      deployment.latest (deployments) ->
        formatter = new Formatters.LatestFormatter(deployment, deployments)
        msg.send formatter.message()

    catch err
      console.log err

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
