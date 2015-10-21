Sprintf = require("sprintf").sprintf
Timeago = require("timeago")

class Formatter
  constructor: (@deployment, @extras) ->

class WhereFormatter extends Formatter
  message: ->
    output  = "Environments for #{@deployment.name}\n"
    output += "-----------------------------------------------------------------\n"
    output += Sprintf "%-15s\n", "Environment"
    output += "-----------------------------------------------------------------\n"

    for environment in @deployment.environments
      output += "#{environment}\n"
    output += "-----------------------------------------------------------------\n"

    output

class LatestFormatter extends Formatter
  delimiter: ->
    "-----------------------------------------------------------------------------------\n"

  loginForDeployment: (deployment) ->
    result = null
    if deployment.payload?
      if deployment.payload.notify
        result or= deployment.payload.notify.user
      result or= deployment.payload.actor

    result or= deployment.creator.login

  message: ->
    output  = "Recent #{@deployment.env} Deployments for #{@deployment.name}\n"
    output += @delimiter()
    output += Sprintf "%-15s | %-21s | %-38s\n", "Who", "What", "When"
    output += @delimiter()

    if @extras?
      for deployment in @extras[0..10]
        if deployment.ref is deployment.sha[0..7]
          ref = deployment.ref
          if deployment.description.match(/auto deploy triggered by a commit status change/)
            ref += "(auto-deploy)"

        else
          ref = "#{deployment.ref}(#{deployment.sha[0..7]})"

        login = @loginForDeployment(deployment)
        timestamp = Sprintf "%18s / %-21s", Timeago(deployment.created_at), deployment.created_at

        output += Sprintf "%-15s | %-21s | %38s\n", login, ref, timestamp

      output += @delimiter()
    output

exports.WhereFormatter  = WhereFormatter
exports.LatestFormatter = LatestFormatter
