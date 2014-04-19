# Description
#   Cut GitHub deployments from chat that deploy via hooks - https://github.com/atmos/hubot-deploy
#
# Commands:
#   hubot deploy - show detailed deployment usage, including apps and environments
#   hubot deploy <app>/<branch> to <env>/<roles> - deploys <app>'s <branch> to the <env> environment's <roles> servers
#   hubot where can I deploy <app> - see what environments you can deploy app
#   hubot deploy:lock <app> in <env> <reason> - lock the app in an environment with a reason
#   hubot deploy:unlock <app> in <env> - unlock an app in an environment
#   hubot auto-deploy:enable <app> in <env> - enable auto-deployment for the app in environment
#   hubot auto-deploy:disable <app> in <env> - disable auto-deployment for the app in environment
#
supported_tasks = [ "deploy" ]

Path          = require("path")
Deployment    = require(Path.join(__dirname, "deployment")).Deployment
DeployPattern = require(Path.join(__dirname, "patterns")).DeployPattern
###########################################################################
module.exports = (robot) ->
  robot.respond /deploy\?$/i, (msg) ->
    msg.send DeployPattern.toString()

  robot.respond /where can i deploy ([-_\.0-9a-z]+)$/i, (msg) ->
    name = msg.match[1]

    deployment = new Deployment(name, "unknown", "q")
    msg.send deployment.plainTextOutput()

  robot.respond /deploy:version$/i, (msg) ->
    pkg = require Path.join __dirname, 'package.json'
    msg.send "hubot-deploy v#{pkg.version}/hubot v#{robot.version}/node #{process.version}"

  robot.respond DeployPattern, (msg) ->
    task  = msg.match[1]
    force = msg.match[2] == '!'
    name  = msg.match[3]
    ref   = (msg.match[4]||'master')
    env   = (msg.match[5]||'production')
    hosts = (msg.match[6]||'')
    auto_merge = process.env.HUBOT_GITHUB_DEPLOYMENT_AUTO_MERGE != '0'

    deployment = new Deployment(name, ref, task, env, force, hosts, auto_merge)

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

