# Description
#  Custom hubot-deploy scripts for slack
#
process.env.HUBOT_DEPLOY_EMIT_GITHUB_DEPLOYMENTS = "true"

module.exports = (robot) ->
  # This is what happens with a '/deploy' request is accepted.
  #
  # msg - The hubot message that triggered the deployment. msg.reply and msg.send post back immediately
  # deployment - The deployment captured from a chat interaction. You can modify it before it's passed on to the GitHub API.
  robot.on "github_deployment", (msg, deployment) ->
    user = robot.brain.userForId deployment.user

    vault = robot.vault.forUser(user)
    githubDeployToken = vault.get "hubot-deploy-github-secret"
    if githubDeployToken?
      deployment.setUserToken(githubDeployToken)


    deployment.post (err, status, body, headers, responseMessage) ->
      msg.send responseMessage if responseMessage?

  # Reply with the most recent deployments that the api is aware of
  #
  # msg - The hubot message that triggered the deployment. msg.reply and msg.send post back immediately
  # deployment - The deployed app that matched up with the request.
  # deployments - The list of the most recent deployments from the GitHub API.
  # formatter - A basic formatter for the deployments that should work everywhere even though it looks gross.
  robot.on "hubot_deploy_recent_deployments", (msg, deployment, deployments, formatter) ->
    msg.send formatter.message()

  # Reply with the environments that hubot-deploy knows about for a specific application.
  #
  # msg - The hubot message that triggered the deployment. msg.reply and msg.send post back immediately
  # deployment - The deployed app that matched up with the request.
  # formatter - A basic formatter for the deployments that should work everywhere even though it looks gross.
  robot.on "hubot_deploy_available_environments", (msg, deployment) ->
    msg.send "#{deployment.name} can be deployed to #{deployment.environments.join(', ')}."

  # An incoming webhook from GitHub for a deployment.
  #
  # deployment - A Deployment from github_events.coffee
  robot.on "github_deployment_event", (deployment) ->
    robot.logger.info JSON.stringify(deployment)

  # An incoming webhook from GitHub for a deployment status.
  #
  # status - A DeploymentStatus from github_events.coffee
  robot.on "github_deployment_status_event", (status) ->
    if status.notify
      user  = robot.brain.userForId status.notify.user
      status.actorName = user.name

    messageBody = status.toSimpleString().replace(/^hubot-deploy: /i, '')
    robot.logger.info messageBody
    if status?.notify?.room?
      robot.messageRoom status.notify.room, messageBody
