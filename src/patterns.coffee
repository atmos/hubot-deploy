repository = "([-_\.0-9a-z]+)"

scriptPrefix = process.env['HUBOT_DEPLOY_PREFIX'] || "deploy"

DEPLOY_SYNTAX = ///
  (#{scriptPrefix}(?:\:[^\s]+)?)  # / prefix
  (!)?\s+                         # Whether or not it was a forced deployment
  #{repository}                   # application name, from apps.json
  (?:\/([^\s]+))?                 # Branch or sha to deploy
  (?:\s+(?:to|in|on)\s+           # http://i.imgur.com/3KqMoRi.gif
  #{repository}                   # Environment to release to
  (?:\/([^\s]+))?)?               # Host filter to try
///i

exports.DeployPrefix  = scriptPrefix
exports.DeployPattern = DEPLOY_SYNTAX
