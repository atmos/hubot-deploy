Path = require "path"

srcDir = Path.join(__dirname, "..", "..", "..", "src")

Version    = require(Path.join(srcDir, "version")).Version
Deployment = require(Path.join(srcDir, "models", "github", "outgoing", "deployment")).Deployment

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

  describe "#requiredContexts", () ->
    it "works with required contexts", () ->
      deployment = new Deployment("hubot", "master", "deploy", "production", "", "")
      expectedContexts = ["ci/janky", "ci/travis-ci"]

      assert.deepEqual(expectedContexts, deployment.requiredContexts)

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

  describe "#requestBody()", () ->
    it "shouldn't blow up", () ->
      deployment = new Deployment("hubot", "master", "deploy", "garage", "", "")
      deployment.requestBody()
      assert.equal(true, true)
    it "should have the right description", () ->
      deployment = new Deployment("hubot", "master", "deploy", "production", "", "")
      body = deployment.requestBody()
      assert.equal(body.description, "deploy on production from hubot-deploy-v#{Version}")


