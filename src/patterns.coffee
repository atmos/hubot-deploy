class Patterns

repository_pattern = "([-_\.0-9a-z]+)"

DEPLOY_SYNTAX = ///
  (deploy(?:\:\w+)?)           # / prefix
  (!)?\s+                      # Whether or not it was a forced deployment
  #{repository_pattern}        # application name, from apps.json
  (?:\/#{repository_pattern})? # Branch or sha to deploy
  (?:\s+(?:to|in|on)\s+        # chatopsy
  #{repository_pattern}        # Environment to release to
  (?:\/([^\s]+)))?             # Host filter to try
///i

exports.DeployPattern = DEPLOY_SYNTAX
