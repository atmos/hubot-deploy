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
    msg.reply "I can't quite sync hooks yet, sorry."

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
  else
    robot.logger.error "You're using hubot-deploy without specifying the shared webhook secret"
    robot.logger.error "Take a second to learn about them: https://developer.github.com/webhooks/securing/"
    robot.logger.error "Then set the HUBOT_DEPLOY_WEBHOOK_SECRET variable in the robot environment"
