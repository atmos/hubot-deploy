
class Formatter
  constructor: (@deployment) ->

class WhereFormatter extends Formatter
  message: ->
    output  = "Environments for #{@deployment.name}\n"
    output += "----------------------------------------------------------\n"

    for environment in @deployment.environments
      output += "#{environment}      | Unknown state :cry:\n"
      output += "----------------------------------------------------------\n"

    output

exports.WhereFormatter = WhereFormatter
