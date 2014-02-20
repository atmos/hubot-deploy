# Description
#   Cut GitHub deployment from chat that deploy via hooks
#
# Commands:
#   hubot deploy - show detailed deployment usage, including apps and environments
#   hubot deploy <implied org|user>/<app>/<branch> to <env>/<roles> - releases <app>'s <branch> to the <env> environment's <roles> servers
#   hubot where can I deploy <app> - see what environments you can deploy app
#   hubot auto-deploy <enable|disable> <app> on <env> - enable or disable auto-deploy
#
octonode = require 'octonode'


supported_tasks = [ 'deploy' ]

api = octonode.client(process.env.HUBOT_GITHUB_TOKEN or 'unknown')
api.requestDefaults.headers['Accept'] = 'application/vnd.github.cannonball-preview+json'

repository_pattern = "([-_\.0-9a-z]+)"

DEPLOY_SYNTAX = ///
  deploy                       # / prefix
  (!)?\s+                      # Whether or not it was a forced deployment
  #{repository_pattern}        # Org owner, optional and implied
  \/#{repository_pattern}      # Repository name
  (?:\@#{repository_pattern})? # Branch or sha to cut a release for
  (?:\s+(to|in|on)\s+          # who cares
  #{repository_pattern}        # Environment to release to
  (?:\/([^\s]+)))?             # Host filter to try
///i

module.exports = (robot) ->
  robot.respond /release\??$/i, (msg) ->
    msg.send("http://img.pandawhale.com/44817-SOON-polar-bear-gif-Jcdo.gif")
    msg.send DEPLOY_SYNTAX.toString()

  robot.respond DEPLOY_SYNTAX, (msg) ->
    force       = (msg.match[1]|| false)
    owner       = (msg.match[2]|| process.env['DEFAULT_GITHUB_OWNER'] || 'github')
    name        =  msg.match[3]
    committish  = (msg.match[4]||'master')
    environment = (msg.match[6]||'production')
    hosts       = (msg.match[7]||'')

    nwo  = "#{owner}/#{name}"
    path = "repos/#{nwo}/deployments"

    request_input =
      nwo: nwo
      ref: committish
      force: force == '!'
      auto_merge: true # Coming Soon™
      description: "Deploying from hubot"
      payload:
        task: 'deploy'
        hosts: hosts
        branch: committish
        room_id: msg.message.user.room
        deployer: msg.envelope.user.name
        environment: environment

    console.log JSON.stringify(request_input)

    api.post path, request_input, (err, status, body, headers) ->
      if err
        console.log err
        data = JSON.parse err
        if data.message? and data.message.match(/No successful commit statuses/)
          msg.reply "I don't see a successful build for #{nwo} that covers the latest \"#{committish}\" branch."
        if data.message? and data.message.match(/Conflict merging ([-_\.0-9a-z]+)/)
          default_branch = data.message.match(/Conflict merging ([-_\.0-9a-z]+)/)[1]
          msg.reply "There was a problem merging the #{default_branch} for #{nwo} into #{committish}. You'll need to merge it manually, or disable auto-merging."
      else
        console.log body
        if body.message? and body.message.match(/Merged ([-_\.0-9a-z]+) into/)
          console.log "Successfully merged the default branch for #{nwo} into #{committish}. Normal push notifications should provide feedback."
        if body.message?
          msg.send body.message
