Fs   = require "fs"
Path = require "path"

srcDir = Path.join(__dirname, "..", "..", "..", "src")

console.log srcDir

GitHubEvents     = require(Path.join(srcDir, "github", "webhooks"))
Deployment       = GitHubEvents.Deployment
DeploymentStatus = GitHubEvents.DeploymentStatus

describe "GitHubEvents.DeploymentStatus fixtures", () ->
  deploymentStatusFor = (fixtureName) ->
    fixtureData = Path.join __dirname, "..", "..", "fixtures", "deployment_statuses", "#{fixtureName}.json"
    fixturePayload = JSON.parse(Fs.readFileSync(fixtureData))
    status = new DeploymentStatus "uuid", fixturePayload

  describe "pending", () ->
    it "knows the statue and repo", () ->
      status = deploymentStatusFor "pending"
      assert.equal status.state, "pending"
      assert.equal status.repoName, "atmos/my-robot"
      assert.equal status.toSimpleString(), "hubot-deploy: atmos\'s deployment #123456 of my-robot/break-up-notifiers to production is running. https://gist.github.com/fa77d9fb1fe41c3bb3a3ffb2c"

  describe "failure", () ->
    it "knows the statue and repo", () ->
      status = deploymentStatusFor "failure"
      assert.equal status.state, "failure"
      assert.equal status.repoName, "atmos/my-robot"
      assert.equal status.toSimpleString(), "hubot-deploy: atmos\'s deployment #123456 of my-robot/break-up-notifiers to production failed. https://gist.github.com/fa77d9fb1fe41c3bb3a3ffb2c"

  describe "success", () ->
    it "knows the statue and repo", () ->
      status = deploymentStatusFor "success"
      assert.equal status.state, "success"
      assert.equal status.repoName, "atmos/my-robot"
      assert.equal status.toSimpleString(), "hubot-deploy: atmos\'s deployment #11627 of my-robot/break-up-notifiers to production was successful. https://gist.github.com/fa77d9fb1fe41c3bb3a3ffb2c"

describe "GitHubEvents.Deployment fixtures", () ->
  deploymentFor = (fixtureName) ->
    fixtureData = Path.join __dirname, "..", "..", "fixtures", "deployments", "#{fixtureName}.json"
    fixturePayload = JSON.parse(Fs.readFileSync(fixtureData))
    new Deployment "uuid", fixturePayload

  describe "production", () ->
    it "works", () ->
      deployment = deploymentFor "production"
      assert.equal deployment.number, 1875476
      assert.equal deployment.repoName, "atmos/my-robot"
      assert.equal deployment.ref, "heroku"
      assert.equal deployment.sha, "3c9f42c"
      assert.equal deployment.name, "my-robot"
      assert.equal deployment.environment, "production"
      assert.isDefined deployment.notify
      assert.isNotNull deployment.notify
      assert.equal deployment.toSimpleString(), "hubot-deploy: atmos\'s deployment #1875476 of my-robot/heroku to production requested."

  describe "staging", () ->
    it "works", () ->
      deployment = deploymentFor "staging"
      assert.equal deployment.number, 1875476
      assert.equal deployment.name, "heaven"
      assert.equal deployment.repoName, "atmos/heaven"
      assert.equal deployment.ref, "heroku"
      assert.equal deployment.sha, "3c9f42c"
      assert.equal deployment.environment, "staging"
      assert.isDefined deployment.notify
      assert.isNotNull deployment.notify
      assert.equal deployment.toSimpleString(), "hubot-deploy: atmos\'s deployment #1875476 of heaven/heroku to staging requested."
