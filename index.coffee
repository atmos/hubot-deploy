# Description
#   Cut GitHub deployment from chat that deploy via hooks - https://github.com/tampopo/hubot-deploy
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
supported_tasks = [ 'deploy' ]

Path          = require 'path'
Deployment    = require("./src/deployment").Deployment
DeployPattern = require("./src/patterns").DeployPattern

###########################################################################
module.exports = (robot) ->
  robot.respond /deploy\?$/i, (msg) ->
    msg.send DeployPattern.toString()

  robot.respond /deploy:version$/i, (msg) ->
    pkg = require Path.join __dirname, 'package.json'
    msg.send "hubot-deploy:v#{pkg.version}"

  robot.respond DeployPattern, (msg) ->
    task  = msg.match[1]
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

    deployment.room    = msg.message.user.room
    deployment.user    = msg.envelope.user.name
    deployment.adapter = robot.adapter

    console.log JSON.stringify(deployment.requestBody())

    deployment.post (responseMessage) ->
      msg.reply responseMessage if responseMessage?

