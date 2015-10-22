# Description
#   Enable deployment statuses from the GitHub API
#
# Commands:
#   hubot deploy-hooks:sync - Sets your user's deployment token. Requires repo_deployment scope.
#

Path             = require "path"
Crypto           = require "crypto"

GitHubEvents     = require(Path.join(__dirname, "..", "models", "github_events"))
Deployment       = GitHubEvents.Deployment
DeploymentStatus = GitHubEvents.DeploymentStatus

DeployPrefix     = require(Path.join(__dirname, "..", "models", "patterns")).DeployPrefix

GitHubSecret     = process.env.HUBOT_DEPLOY_WEBHOOK_SECRET

supported_tasks = [ "#{DeployPrefix}-hooks:sync" ]
###########################################################################
module.exports = (robot) ->
  robot.respond ///#{DeployPrefix}-hooks:sync (.*)///i, (msg) ->
    msg.reply "I can't quite sync hooks yet, sorry."

  process.env.HUBOT_DEPLOY_WEBHOOK_SECRET or= "459C1E17-AAA9-4ABF-9120-92E8385F9949"
  robot.hear ///#{process.env.HUBOT_DEPLOY_RANDOM_REPLY}///, (msg) ->
    msg.reply("Why hello there! (ticker tape, ticker tape)")

  if GitHubSecret
    robot.router.post "/hubot-deploy", (req, res) ->
      try
        payloadSignature = req.headers['x-hub-signature']
        unless payloadSignature?
          res.writeHead 400, {'content-type': 'application/json' }
          res.end(JSON.stringify({error: "No GitHub payload signature headers present"}))
        expectedSignature = Crypto.createHmac("sha1", GitHubSecret).update(JSON.stringify(req.body)).digest("hex")
        if payloadSignature is not "sha1=#{expectedSignature}"
          res.writeHead 400, {'content-type': 'application/json' }
          res.end(JSON.stringify({error: "X-Hub-Signature does not match blob signature"}))

        deliveryId = req.headers['x-github-delivery']
        switch req.headers['x-github-event']
          when "ping"
            res.writeHead 200, {'content-type': 'application/json' }
            res.end(JSON.stringify({message: "Hello from #{robot.name}. :D"}))

          when "deployment"
            deployment = new Deployment deliveryId, req.body

            robot.emit "github_deployment", deployment

            res.writeHead 200, {'content-type': 'application/json' }
            res.end(JSON.stringify({message: "#{deployment.repoName}: dispatched a deployment event"}))

          when "deployment_status"
            status = new DeploymentStatus deliveryId, req.body

            robot.emit "github_deployment_status", status

            res.writeHead 200, {'content-type': 'application/json' }
            res.end(JSON.stringify({message: "#{status.repoName}: dispatched a deployment status event."}))

          else
            res.writeHead 400, {'content-type': 'application/json' }
            res.end(JSON.stringify({message: "Received but not processed."}))

      catch err
        robot.logger.error err

  else if process.env.NODE_ENV is not "test"
    robot.logger.error "You're using hubot-deploy without specifying the shared webhook secret"
    robot.logger.error "Take a second to learn about them: https://developer.github.com/webhooks/securing/"
    robot.logger.error "Then set the HUBOT_DEPLOY_WEBHOOK_SECRET variable in the robot environment"
