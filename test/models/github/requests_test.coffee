Fs   = require "fs"
Path = require "path"

GitHubRequests   = require(Path.join(__dirname, "..", "..", "..", "src", "models", "github", "requests"))
DeploymentStatus = GitHubRequests.GitHubDeploymentStatus

describe "GitHubRequests.GitHubDeploymentStatus", () ->
  describe "basic variables", () ->
    it "knows the state and repo", () ->
      status = new DeploymentStatus("token", "atmos/hubot-deploy", "42")
      status.targetUrl = "https://gist.github.com/my-sweet-gist"
      status.description = "Deploying from chat, wooo"
      status.state = "success"

      assert.equal "42", status.number
      assert.equal "token", status.apiToken
      assert.equal "atmos/hubot-deploy", status.repoName
      assert.equal "success", status.state

    it "posts well formed parameters", () ->
      status = new DeploymentStatus("token", "atmos/hubot-deploy", "42")
      status.targetUrl = "https://gist.github.com/my-sweet-gist"
      status.description = "Deploying from chat, wooo"
      status.state = "success"

      postParams =
        state: status.state
        target_url: status.targetUrl
        description: status.description

      assert.equal JSON.stringify(postParams), status.postParams()
