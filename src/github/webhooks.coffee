Path                     = require "path"

exports.Push             = require(Path.join(__dirname, "webhooks", "push")).Push
exports.Deployment       = require(Path.join(__dirname, "webhooks", "deployment")).Deployment
exports.PullRequest      = require(Path.join(__dirname, "webhooks", "pull_request")).PullRequest
exports.CommitStatus     = require(Path.join(__dirname, "webhooks", "commit_status")).CommitStatus
exports.DeploymentStatus = require(Path.join(__dirname, "webhooks", "deployment_status")).DeploymentStatus
