# Description
#   Cut GitHub deployment from chat that deploy via hooks
#
# Commands:
#   hubot deploy - show detailed deployment usage, including apps and environments
#   hubot deploy <app>/<branch> to <env>/<roles> - deploys <app>'s <branch> to the <env> environment's <roles> servers
#   hubot where can I deploy <app> - see what environments you can deploy app
#   hubot auto-deploy <enable|disable> <app> on <env> - enable or disable auto-deploy
#
supported_tasks = [ 'deploy' ]

applications    = [ ]

###########################################################################
api = require("octonode").client(process.env.HUBOT_GITHUB_TOKEN or 'unknown')
api.requestDefaults.headers['Accept'] = 'application/vnd.github.cannonball-preview+json'

###########################################################################
applications = JSON.parse(require("fs").readFileSync("apps.json").toString())

console.log applications
###########################################################################
repository_pattern = "([-_\.0-9a-z]+)"

DEPLOY_SYNTAX = ///
  (deploy(?:\:\w+)?)           # / prefix
  (!)?\s+                      # Whether or not it was a forced deployment
  #{repository_pattern}        # Org owner, optional and implied
  (?:\/#{repository_pattern})? # Branch or sha to cut a release for
  (?:\s+(?:to|in|on)\s+        # chatopsy
  #{repository_pattern}        # Environment to release to
  (?:\/([^\s]+)))?             # Host filter to try
///i

class Deployment
  constructor: (@name, @ref, @task, @env, force, @hosts) ->
    @forced = force == '!'

    @room_id  = 'unknown'
    @deployer = 'unknown'

    @application = applications[@name]
    @repository  = @application['repository']

    @env = 'production' if @env == 'prod'

  isValidApp: ->
    @application?

  isValidEnv: ->
    @env in @application['environments']

  requestBody: ->
    ref: @ref
    force: @forced
    auto_merge: true
    description: "Deploying from hubot"
    payload:
      task: @task
      hosts: @hosts
      branch: @ref
      room_id: @room_id
      deployer: @deployer
      environment: @env
      heroku_name: @application['heroku_name']
      heroku_staging_name: @application['heroku_staging_name']

  post: (cb) ->
    path = "repos/#{@repository}/deployments"

    api.post path, @requestBody(), (err, status, body, headers) ->
      data = body
      if err
        data = err
        console.log err

      if data['message']
        bodyMessage = data['message']

        if bodyMessage.match(/No successful commit statuses/)
          message = "I don't see a successful build for #{@repository} that covers the latest \"#{@ref}\" branch."

        if bodyMessage.match(/Conflict merging ([-_\.0-9a-z]+)/)
          default_branch = data.message.match(/Conflict merging ([-_\.0-9a-z]+)/)[1]
          message = "There was a problem merging the #{default_branch} for #{@repository} into #{@ref}. You'll need to merge it manually, or disable auto-merging."

        if bodyMessage.match(/Merged ([-_\.0-9a-z]+) into/)
          console.log "Successfully merged the default branch for #{deployment.repository} into #{@ref}. Normal push notifications should provide feedback."
        else
          message = bodyMessage

      cb(message)

###########################################################################
module.exports = (robot) ->
  robot.respond /deploy\??$/i, (msg) ->
    msg.send("http://img.pandawhale.com/44817-SOON-polar-bear-gif-Jcdo.gif")
    msg.send DEPLOY_SYNTAX.toString()

  robot.respond DEPLOY_SYNTAX, (msg) ->
    task  = (msg.match[1])
    force = (msg.match[2]|| false)
    name  = (msg.match[3])
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

