# Description
#   Enable deployment statuses from the GitHub API
#
# Commands:
#   hubot deploy-hooks:sync - Sets your user's deployment token. Requires repo_deployment scope.
#

Path             = require("path")
Deployment       = require(Path.join(__dirname, "..", "deployment")).Deployment
DeployPrefix     = require(Path.join(__dirname, "..", "patterns")).DeployPrefix
DeploymentStatus = require(Path.join(__dirname, "..", "deployment_status")).DeploymentStatus

GitHubSecret = process.env.HUBOT_DEPLOY_WEBHOOK_SECRET

supported_tasks = [ "#{DeployPrefix}-hooks:sync" ]
###########################################################################
module.exports = (robot) ->
  robot.respond ///#{DeployPrefix}-hooks:sync (.*)///i, (msg) ->
    msg.reply "Syncing hooks for"

  robot.hear /Computer!/, (msg) ->
    msg.reply("Why hello there! (ticker tape, ticker tape)")

  robot.handleHttpRequest = (deliveryId, parsedBody) ->
    robot.logger.info "GitHubSecret is #{GitHubSecret}"
    console.log body
    console.log headers

  if GitHubSecret
    robot.router.post "/github/deployments", (req, res) ->
      try
        eventType = req.headers['x-github-event']
        unless eventType? and eventType is "deployment_status"
          res.writeHead 200, {'content-type': 'application/json' }
          res.end(JSON.stringify({message: "Received but not processed"}))

        payloadSignature = req.headers['x-hub-signature']
        unless payloadSignature?
          res.writeHead 400, {'content-type': 'application/json' }
          res.end(JSON.stringify({error: "No GitHub payload signature headers present"}))

        expectedSignature = crypto.createHmac("sha1", GitHubSecret).update(req.body).digest("hex")
        if payloadSignature is not "sha1=#{expectedSignature}"
          res.writeHead 400, {'content-type': 'application/json' }
          res.end(JSON.stringify({error: "X-Hub-Signature does not match blob signature"}))

        deliveryId = req.headers['x-github-delivery']
        deploymentStatus = new DeploymentStatus deliveryId, JSON.parse(req.body)
        robot.emit "deploymentStatus", deploymentStatus

      catch err
        robot.logger.error err

