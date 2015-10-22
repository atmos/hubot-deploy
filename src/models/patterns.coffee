Inflection = require "inflection"

repository = "([-_\.0-9a-z]+)"

scriptPrefix = process.env['HUBOT_DEPLOY_PREFIX'] || "deploy"

# The :hammer: regex that handles all /deploy requests
DEPLOY_SYNTAX = ///
  (#{scriptPrefix}(?:\:[^\s]+)?)  # / prefix
  (!)?\s+                         # Whether or not it was a forced deployment
  #{repository}                   # application name, from apps.json
  (?:\/([^\s]+))?                 # Branch or sha to deploy
  (?:\s+(?:to|in|on)\s+           # http://i.imgur.com/3KqMoRi.gif
  #{repository}                   # Environment to release to
  (?:\/([^\s]+))?)?               # Host filter to try
  \s*$                            # Prevent match if something does not match
///i


# Supports tasks like
# /deploys github
#
# and
#
# /deploys github in staging
inflectedScriptPrefix = Inflection.pluralize(scriptPrefix)
DEPLOYS_SYNTAX = ///
  (#{inflectedScriptPrefix})      # / prefix
  \s+                             # hwhitespace
  #{repository}                   # application name, from apps.json
  (?:\/([^\s]+))?                 # Branch or sha to deploy
  (?:\s+(?:to|in|on)\s+           # http://i.imgur.com/3KqMoRi.gif
  #{repository})?                 # Environment to release to
///i

exports.DeployPrefix   = scriptPrefix
exports.DeployPattern  = DEPLOY_SYNTAX
exports.DeploysPattern = DEPLOYS_SYNTAX
