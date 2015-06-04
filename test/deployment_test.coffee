Path = require('path')

Deployment = require(Path.join(__dirname, "..", "src", "deployment")).Deployment

describe "Deployment fixtures", () ->
  describe "#isValidApp()", () ->
    it "is invalid if the app can't be found", () ->
      deployment = new Deployment("hubot-reloaded", "master", "deploy", "production", "", "")
      assert.equal(deployment.isValidApp(), false)

    it "is valid if the app can be found", () ->
      deployment = new Deployment("hubot-deploy", "master", "deploy", "production", "", "")
      assert.equal(deployment.isValidApp(), true)

  describe "#isValidEnv()", () ->
    it "is invalid if the env can't be found", () ->
      deployment = new Deployment("hubot", "master", "deploy", "garage", "", "")
      assert.equal(deployment.isValidEnv(), false)

    it "is valid if the env can be found", () ->
      deployment = new Deployment("hubot", "master", "deploy", "production", "", "")
      assert.equal(deployment.isValidEnv(), true)

  describe "#autoMerge", () ->
    it "works with auto-merging", () ->
      deployment = new Deployment("hubot", "master", "deploy", "production", "", "")
      assert.equal(false, deployment.autoMerge)

  describe "#requiredContexts", () ->
    it "works with required contexts", () ->
      deployment = new Deployment("hubot", "master", "deploy", "production", "", "")
      expectedContexts = ["ci/janky", "ci/travis-ci"]

      assert.deepEqual(expectedContexts, deployment.requiredContexts)

  describe "#requestBody()", () ->
    it "shouldn't blow up", () ->
      deployment = new Deployment("hubot", "master", "deploy", "garage", "", "")
      deployment.requestBody()
      assert.equal(true, true)

  describe "#isAllowedRoom()", () ->
    it "allows everything when there is no configuration", ->
      deployment = new Deployment("hubot", "master", "deploy", "production", "", "")
      assert.equal(deployment.isAllowedRoom('anything'), true)
    it "is allowed with room that is in configuration", ->
      deployment = new Deployment("restricted-app", "master", "deploy", "production", "", "")
      assert.equal(deployment.isAllowedRoom('ops'), true)
    it "is not allowed with room that is not in configuration", ->
      deployment = new Deployment("restricted-app", "master", "deploy", "production", "", "")
      assert.equal(deployment.isAllowedRoom('watercooler'), false)

  describe "#api", () ->
    context "with no ca file", () ->
      it "doesnt set agentOptions", () ->
        deployment = new Deployment("hubot", "master", "deploy", "production", "", "")
        api = deployment.api()
        assert.equal(api.requestDefaults.agentOptions, null)

    context "with ca file", () ->
      it "sets agentOptions.ca", () ->
        process.env.HUBOT_CA_FILE = Path.join(__dirname, "fixtures", "cafile.txt")
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
