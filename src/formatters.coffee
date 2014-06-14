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
  message: ->
    output  = "Recent #{@deployment.env} Deployments for #{@deployment.name}\n"
    output += "-----------------------------------------------------------------\n"
    output += Sprintf "%-15s | %-12s | %-25s\n", "Who", "What", "When"
    output += "-----------------------------------------------------------------\n"

    for deployment in @extras[0..10]
      login = deployment.payload.notify.user || deployment.payload.actor || deployment.creator.login
      timestamp = Sprintf "%10s / %-15s", Timeago(deployment.created_at), deployment.created_at
      output += Sprintf "%-15s | %-12s | %-25s\n", login, deployment.ref, timestamp

    output += "-----------------------------------------------------------------\n"
    output

exports.WhereFormatter  = WhereFormatter
exports.LatestFormatter = LatestFormatter
