# Description
#   Enable deployment statuses from the GitHub API
#
# Commands:
#

Fs               = require "fs"
Path             = require "path"
Crypto           = require "crypto"

GitHubEvents     = require(Path.join(__dirname, "..", "github", "webhooks"))
Push             = GitHubEvents.Push
Deployment       = GitHubEvents.Deployment
PullRequest      = GitHubEvents.PullRequest
DeploymentStatus = GitHubEvents.DeploymentStatus
CommitStatus     = GitHubEvents.CommitStatus

DeployPrefix     = require(Path.join(__dirname, "..", "models", "patterns")).DeployPrefix

GitHubSecret     = process.env.HUBOT_DEPLOY_WEBHOOK_SECRET

WebhookPrefix    = process.env.HUBOT_DEPLOY_WEBHOOK_PREFIX or "/hubot-deploy"

supported_tasks       = [ "#{DeployPrefix}-hooks:sync" ]

Verifiers = require(Path.join(__dirname, "..", "models", "verifiers"))

AppsJsonFile = process.env['HUBOT_DEPLOY_APPS_JSON'] or "apps.json"
AppsJsonData = JSON.parse(Fs.readFileSync(AppsJsonFile))
###########################################################################
module.exports = (robot) ->
  ipVerifier = new Verifiers.GitHubWebHookIpVerifier

  process.env.HUBOT_DEPLOY_WEBHOOK_SECRET or= "459C1E17-AAA9-4ABF-9120-92E8385F9949"
  if GitHubSecret
    robot.router.get WebhookPrefix + "/apps", (req, res) ->
      token = req.headers['authorization']?.match(/Bearer (.+){1,256}/)?[1]
      if token is process.env["HUBOT_DEPLOY_WEBHOOK_SECRET"]
        res.writeHead 200, {'content-type': 'application/json' }
        return res.end(JSON.stringify(AppsJsonData))
      else
        res.writeHead 404, {'content-type': 'application/json' }
        return res.end(JSON.stringify({message: "Not Found"}))

    robot.router.post WebhookPrefix + "/repos/:owner/:repo/messages", (req, res) ->
      token = req.headers['authorization']?.match(/Bearer (.+){1,256}/)?[1]
      if token is process.env["HUBOT_DEPLOY_WEBHOOK_SECRET"]
        emission =
          body: req.body
          repo: req.params.repo
          owner: req.params.owner

        robot.emit "hubot_deploy_repo_message", emission
        res.writeHead 202, {'content-type': 'application/json' }
        return res.end("{}")
      else
        res.writeHead 404, {'content-type': 'application/json' }
        return res.end(JSON.stringify({message: "Not Found"}))

    robot.router.post WebhookPrefix + "/teams/:team/messages", (req, res) ->
      token = req.headers['authorization']?.match(/Bearer (.+){1,256}/)?[1]
      if token is process.env["HUBOT_DEPLOY_WEBHOOK_SECRET"]
        emission =
          team: req.params.team
          body: req.body

        robot.emit "hubot_deploy_team_message", emission
        res.writeHead 202, {'content-type': 'application/json' }
        return res.end("{}")
      else
        res.writeHead 404, {'content-type': 'application/json' }
        return res.end(JSON.stringify({message: "Not Found"}))

    robot.router.get WebhookPrefix + "/apps/:name", (req, res) ->
      try
        token = req.headers['authorization']?.match(/Bearer (.+){1,256}/)?[1]
        if token isnt process.env["HUBOT_DEPLOY_WEBHOOK_SECRET"]
          throw new Error("Bad auth headers")
        else
          app = AppsJsonData[req.params["name"]]
          if app?
            res.writeHead 200, {'content-type': 'application/json' }
            return res.end(JSON.stringify(app))
          else
            throw new Error("App not found")
      catch
        res.writeHead 404, {'content-type': 'application/json' }
        return res.end(JSON.stringify({message: "Not Found"}))

    robot.router.post WebhookPrefix, (req, res) ->
      try
        remoteIp = req.headers['x-forwarded-for'] or req.connection.remoteAddress
        unless ipVerifier.ipIsValid(remoteIp)
          res.writeHead 400, {'content-type': 'application/json' }
          return res.end(JSON.stringify({error: "Webhook requested from a non-GitHub IP address."}))

        payloadSignature = req.headers['x-hub-signature']
        unless payloadSignature?
          res.writeHead 400, {'content-type': 'application/json' }
          return res.end(JSON.stringify({error: "No GitHub payload signature headers present"}))

        expectedSignature = Crypto.createHmac("sha1", GitHubSecret).update(JSON.stringify(req.body)).digest("hex")
        if payloadSignature is not "sha1=#{expectedSignature}"
          res.writeHead 400, {'content-type': 'application/json' }
          return res.end(JSON.stringify({error: "X-Hub-Signature does not match blob signature"}))

        deliveryId = req.headers['x-github-delivery']

        # NOTE: On github.com the payload gets wrapped in a string somehow.
        #       This code is to remove the string before sending it further.
        if req.body.payload
          if typeof(req.body.payload) is 'string'
            req.body = JSON.parse(req.body.payload)

        switch req.headers['x-github-event']
          when "ping"
            res.writeHead 204, {'content-type': 'application/json' }
            return res.end(JSON.stringify({message: "Hello from #{robot.name}. :D"}))

          when "push"
            push = new Push deliveryId, req.body

            robot.emit "github_push_event", push

            res.writeHead 202, {'content-type': 'application/json' }
            return res.end(JSON.stringify({message: push.toSimpleString()}))

          when "deployment"
            deployment = new Deployment deliveryId, req.body

            robot.emit "github_deployment_event", deployment

            res.writeHead 202, {'content-type': 'application/json' }
            return res.end(JSON.stringify({message: deployment.toSimpleString()}))

          when "deployment_status"
            status = new DeploymentStatus deliveryId, req.body

            robot.emit "github_deployment_status_event", status

            res.writeHead 202, {'content-type': 'application/json' }
            return res.end(JSON.stringify({message: status.toSimpleString()}))

          when "status"
            status = new CommitStatus deliveryId, req.body

            robot.emit "github_commit_status_event", status

            res.writeHead 202, {'content-type': 'application/json' }
            return res.end(JSON.stringify({message: status.toSimpleString()}))

          when "pull_request"
            pullRequest = new PullRequest deliveryId, req.body

            robot.emit "github_pull_request", pullRequest

            res.writeHead 202, {'content-type': 'application/json' }
            return res.end(JSON.stringify({message: pullRequest.toSimpleString()}))

          else
            res.writeHead 204, {'content-type': 'application/json' }
            return res.end(JSON.stringify({message: "Received but not processed."}))

      catch err
        robot.logger.error err
        res.writeHead 500, {'content-type': 'application/json' }
        return res.end(JSON.stringify({error: "Something went crazy processing the request."}))

  else if process.env.NODE_ENV is not "test"
    robot.logger.error "You're using hubot-deploy without specifying the shared webhook secret"
    robot.logger.error "Take a second to learn about them: https://developer.github.com/webhooks/securing/"
    robot.logger.error "Then set the HUBOT_DEPLOY_WEBHOOK_SECRET variable in the robot environment"
