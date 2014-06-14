Sprintf = require("sprintf").sprintf
Timeago = require("timeago")

class Formatter
  constructor: (@deployment, @extras) ->

class WhereFormatter extends Formatter
  message: ->
    output  = "Environments for #{@deployment.name}\n"
    output += "-----------------------------------------------------------------\n"
    output += Sprintf "%-15s | %-12s | %-12s\n", "Environment", "Last Deployed", "Branch"
    output += "-----------------------------------------------------------------\n"

    for environment in @deployment.environments
      output += "#{environment}      | Unknown state :cry:\n"
      output += Sprintf "%-15s | %-12s | %-12s\n", environment, "Unknown", "Unknown"
    output += "-----------------------------------------------------------------\n"

    output

class LatestFormatter extends Formatter
  delimiter: ->
    "----------------------------------------------------------------------------------\n"

  message: ->
    output  = "Recent #{@deployment.env} Deployments for #{@deployment.name}\n"
    output += @delimiter()
    output += Sprintf "%-15s | %-20s | %-38s\n", "Who", "What", "When"
    output += @delimiter()

    for deployment in @extras[0..10]
      if deployment.ref is deployment.sha[0..7]
        ref = deployment.ref
        if deployment.description.match(/auto deploy triggered by a commit status change/)
          ref += "(auto-deploy)"

      else
        ref = "#{deployment.ref}(#{deployment.sha[0..7]})"

      login = deployment.payload.notify.user || deployment.payload.actor || deployment.creator.login
      timestamp = Sprintf "%18s / %-20s", Timeago(deployment.created_at), deployment.created_at

      output += Sprintf "%-15s | %-20s | %38s\n", login, ref, timestamp

    output += @delimiter()
    output

exports.WhereFormatter  = WhereFormatter
exports.LatestFormatter = LatestFormatter
