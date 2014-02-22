class Patterns

repository = "([-_\.0-9a-z]+)"

DEPLOY_SYNTAX = ///
  (deploy(?:\:[^\s]+)?)  # / prefix
  (!)?\s+                # Whether or not it was a forced deployment
  #{repository}          # application name, from apps.json
  (?:\/#{repository})?   # Branch or sha to deploy
  (?:\s+(?:to|in|on)\s+  # http://i.imgur.com/3KqMoRi.gif
  #{repository}          # Environment to release to
  (?:\/([^\s]+))?)?      # Host filter to try
///i

exports.DeployPattern = DEPLOY_SYNTAX
