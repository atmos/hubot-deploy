Fs   = require "fs"
Path = require "path"

srcDir = Path.join(__dirname, "..", "..", "..", "src")

GitHubEvents = require(Path.join(srcDir, "github", "webhooks"))
PullRequest  = GitHubEvents.PullRequest

describe "GitHubEvents.PullRequest fixtures", () ->
  pullRequestFor = (fixtureName) ->
    fixtureData = Path.join __dirname, "..", "..", "fixtures", "pull_requests", "pull_request_#{fixtureName}.json"
    fixturePayload = JSON.parse(Fs.readFileSync(fixtureData))
    status = new PullRequest "uuid", fixturePayload

  describe "opened", () ->
    it "knows the state, number, and repo", () ->
      pullRequest = pullRequestFor("opened")
      assert.equal 32, pullRequest.number
      assert.equal "open", pullRequest.state
      assert.equal "hubot-deploy", pullRequest.name
      assert.equal "atmos/hubot-deploy", pullRequest.repoName

  describe "merged", () ->
    it "knows the state, number, and repo", () ->
      pullRequest = pullRequestFor("merged")
      assert.equal 32, pullRequest.number
      assert.equal "closed", pullRequest.state
      assert.equal "hubot-deploy", pullRequest.name
      assert.equal "atmos/hubot-deploy", pullRequest.repoName

  describe "closed", () ->
    it "knows the state, number, and repo", () ->
      pullRequest = pullRequestFor("closed")
      assert.equal 32, pullRequest.number
      assert.equal "closed", pullRequest.state
      assert.equal "hubot-deploy", pullRequest.name
      assert.equal "atmos/hubot-deploy", pullRequest.repoName

  describe "reopened", () ->
    it "knows the state, number, and repo", () ->
      pullRequest = pullRequestFor("reopened")
      assert.equal 32, pullRequest.number
      assert.equal "open", pullRequest.state
      assert.equal "hubot-deploy", pullRequest.name
      assert.equal "atmos/hubot-deploy", pullRequest.repoName

  describe "synchronize", () ->
    it "knows the state, number, and repo", () ->
      pullRequest = pullRequestFor("reopened")
      assert.equal 32, pullRequest.number
      assert.equal "open", pullRequest.state
      assert.equal "hubot-deploy", pullRequest.name
      assert.equal "atmos/hubot-deploy", pullRequest.repoName

  describe "toSimpleString", () ->
    it "works", () ->
      pullRequest = pullRequestFor("reopened")
      assert.equal 32, pullRequest.number
      assert.equal "open", pullRequest.state
      assert.equal "hubot-deploy", pullRequest.name
      assert.equal "atmos/hubot-deploy", pullRequest.repoName
      assert.equal "hubot-deploy: https://github.com/atmos/hubot-deploy/pull/32", pullRequest.toSimpleString()
