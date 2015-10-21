# Description
#   Enable deployment statuses from the GitHub API
#
# Commands:
#   hubot deploy-hooks:sync - Sets your user's deployment token. Requires repo_deployment scope.
#

Path           = require("path")
Patterns       = require(Path.join(__dirname, "..", "patterns"))
Deployment     = require(Path.join(__dirname, "..", "deployment")).Deployment

DeployPrefix   = Patterns.DeployPrefix

GitHubSecret = process.env.HUBOT_DEPLOY_WEBHOOK_SECRET

supported_tasks = [ "#{DeployPrefix}-hooks:sync" ]
###########################################################################
module.exports = (robot) ->
  robot.respond ///#{DeployPrefix}-hooks:sync (.*)///i, (msg) ->
    msg.reply "Syncing hooks for"

  robot.hear /Computer!/, (msg) ->
    msg.reply("Why hello there! (ticker tape, ticker tape)")

  robot.handleHttpRequest = (body, headers) ->
    robot.logger.info "GitHubSecret is #{GitHubSecret}"
    console.log body
    console.log headers

  if GitHubSecret
    robot.router.post "/github/deployments", (req, res) ->
      try
        id    = req.headers['x-github-delivery']

        eventType = req.headers['x-github-event']
        unless eventType? and eventType is "deployment_status"
          res.writeHead 200, {'content-type': 'application/json' }
          res.end(JSON.stringify({message: "Received but not processed"}))

        payloadSignature = req.headers['x-hub-signature']
        unless payloadSignature?
          res.writeHead 400, {'content-type': 'application/json' }
          res.end(JSON.stringify({error: "No GitHub payload signature headers present"}))

        originalBody = req.body

        data = JSON.parse(originalBody)
      catch err
        robot.logger.error err

