Path                     = require "path"
exports.Deployment       = require(Path.join(__dirname, "webhooks", "deployment")).Deployment
exports.PullRequest      = require(Path.join(__dirname, "webhooks", "pull_request")).PullRequest
exports.DeploymentStatus = require(Path.join(__dirname, "webhooks", "deployment_status")).DeploymentStatus
exports.CommitStatus     = require(Path.join(__dirname, "webhooks", "commit_status")).CommitStatus
