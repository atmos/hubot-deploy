Path = require('path')

Deployment = require(Path.join(__dirname, "..", "src", "deployment")).Deployment

describe "Deployment fixtures", () ->
  Deployment.APPS_FILE = Path.join(__dirname, "test_apps.json")

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

  describe "#requestBody()", () ->
    it "shouldn't blow up", () ->
      deployment = new Deployment("hubot", "master", "deploy", "garage", "", "")
      deployment.requestBody()
      assert.equal(true, true)

  #describe "#post()", () ->
  #  it "404s with a handy message", (done) ->
  #    failureMessage = "Unable to create deployments for github/github. Check your scopes for this token."
  #    deployment = new Deployment("github", "master", "deploy", "garage", "", "")
  #    deployment.post (responseMessage) ->
  #      assert.equal(responseMessage, failureMessage)
  #      done()
