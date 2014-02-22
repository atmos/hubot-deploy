class Patterns

repository = "([-_\.0-9a-z]+)"

DEPLOY_SYNTAX = ///
  (deploy(?:\:\w+)?)     # / prefix
  (!)?\s+                # Whether or not it was a forced deployment
  #{repository}          # application name, from apps.json
  (?:\/#{repository})?   # Branch or sha to deploy
  (?:\s+(?:to|in|on)\s+  # chatopsy
  #{repository}          # Environment to release to
  (?:\/([^\s]+)))?       # Host filter to try
///i

exports.DeployPattern = DEPLOY_SYNTAX
