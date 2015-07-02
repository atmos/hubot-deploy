# Description
#   Cut GitHub deployments from chat that deploy via hooks - https://github.com/atmos/hubot-deploy
#
# Commands:
#   hubot where can I deploy <app> - see what environments you can deploy app
#   hubot deploy:version - show the script version and node/environment info
#   hubot deploy <app>/<branch> to <env>/<roles> - deploys <app>'s <branch> to the <env> environment's <roles> servers
#   hubot deploys <app>/<branch> in <env> - Displays recent deployments for <app>'s <branch> in the <env> environment
#
supported_tasks = [ DeployPrefix ]

Path          = require("path")
Version       = require(Path.join(__dirname, "..", "version")).Version
Patterns      = require(Path.join(__dirname, "..", "patterns"))
Deployment    = require(Path.join(__dirname, "..", "deployment")).Deployment
Formatters    = require(Path.join(__dirname, "..", "formatters"))

DeployPrefix   = Patterns.DeployPrefix
DeployPattern  = Patterns.DeployPattern
DeploysPattern = Patterns.DeploysPattern

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

      user = robot.brain.userForId msg.envelope.user.id
      if user? and user.githubDeployToken?
        deployment.setUserToken(user.githubDeployToken)

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

    username = msg.envelope.user.githubLogin or msg.envelope.user.name

    deployment = new Deployment(name, ref, task, env, force, hosts)

    unless deployment.isValidApp()
      msg.reply "#{name}? Never heard of it."
      return
    unless deployment.isValidEnv()
      msg.reply "#{name} doesn't seem to have an #{env} environment."
      return
    unless deployment.isAllowedRoom(msg.message.user.room)
      msg.reply "#{name} is not allowed to be deployed from this room."
      return

    user = robot.brain.userForId msg.envelope.user.id
    if user? and user.githubDeployToken?
      deployment.setUserToken(user.githubDeployToken)

    deployment.user = username
    deployment.room = msg.message.user.room

    if robot.adapterName == 'flowdock'
      deployment.thread_id = msg.message.metadata.thread_id
      deployment.message_id = msg.message.id

    deployment.adapter = robot.adapterName

    console.log JSON.stringify(deployment.requestBody())

    deployment.post (responseMessage) ->
      msg.reply responseMessage if responseMessage?

  ###########################################################################
  # deploy:version
  #
  # Useful for debugging
  robot.respond ///#{DeployPrefix}\:version$///i, (msg) ->
    msg.send "hubot-deploy v#{Version}/hubot v#{robot.version}/node #{process.version}"
