# Description
#   Cut GitHub deployment from chat that deploy via hooks - https://github.com/tampopo/hubot-deploy
#
# Commands:
#   hubot deploy - show detailed deployment usage, including apps and environments
#   hubot deploy <app>/<branch> to <env>/<roles> - deploys <app>'s <branch> to the <env> environment's <roles> servers
#   hubot where can I deploy <app> - see what environments you can deploy app
#   hubot auto-deploy <enable|disable> <app> on <env> - enable or disable auto-deploy
#
supported_tasks = [ 'deploy' ]

Deployment    = require("./src/deployment").Deployment
DeployPattern = require("./src/patterns").DeployPattern

###########################################################################
module.exports = (robot) ->
  robot.respond /deploy\??$/i, (msg) ->
    msg.send("http://img.pandawhale.com/44817-SOON-polar-bear-gif-Jcdo.gif")
    msg.send DeployPattern.toString()

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

    deployment.room_id  = msg.message.user.room
    deployment.deployer = msg.envelope.user.name

    console.log JSON.stringify(deployment.requestBody())

    deployment.post (responseMessage) ->
      msg.reply responseMessage if responseMessage?

