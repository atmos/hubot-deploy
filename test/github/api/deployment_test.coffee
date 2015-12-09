Path = require "path"

Version    = require(Path.join(__dirname, "..", "..", "..", "src", "version")).Version
Deployment = require(Path.join(__dirname, "..", "..", "..", "src", "github", "api")).Deployment

describe "Deployment fixtures", () ->
  describe "#autoMerge", () ->
    it "works with auto-merging", () ->
      deployment = new Deployment("hubot", "master", "deploy", "production", "", "")
      assert.equal(false, deployment.autoMerge)

  describe "#api", () ->
    context "with no ca file", () ->
      it "doesnt set agentOptions", () ->
        deployment = new Deployment("hubot", "master", "deploy", "production", "", "")
        api = deployment.api()
        assert.equal(api.requestDefaults.agentOptions, null)

    context "with ca file", () ->
      it "sets agentOptions.ca", () ->
        process.env.HUBOT_CA_FILE = Path.join(__dirname, "..", "..", "fixtures", "cafile.txt")
        deployment = new Deployment("hubot", "master", "deploy", "production", "", "")
        api = deployment.api()
        assert(api.requestDefaults.agentOptions.ca)

  #describe "#latest()", () ->
  #  it "fetches the latest deployments", (done) ->
  #    deployment = new Deployment("hubot")
  #    deployment.latest (deployments) ->
  #      done()

  #describe "#post()", () ->
  #  it "404s with a handy message", (done) ->
  #    failureMessage = "Unable to create deployments for github/github. Check your scopes for this token."
  #    deployment = new Deployment("github", "master", "deploy", "garage", "", "")
  #    deployment.post (responseMessage) ->
  #      assert.equal(responseMessage, failureMessage)
  #      done()
