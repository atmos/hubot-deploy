Deployment = require("#{process.cwd()}/src/deployment").Deployment

describe "Deployment fixtures", () ->
  Deployment.APPS_FILE = "./test/test_apps.json"

  describe "#isValidApp()", () ->
    it "is invalid if the app can't be found", () ->
      deployment = new Deployment("github", "master", "deploy", "production", "", "")
      assert.equal(deployment.isValidApp(), false)

    it "is valid if the app can be found", () ->
      deployment = new Deployment("hubot", "master", "deploy", "production", "", "")
      assert.equal(deployment.isValidApp(), true)

  describe "#isValidEnv()", () ->
    it "is invalid if the env can't be found", () ->
      deployment = new Deployment("hubot", "master", "deploy", "garage", "", "")
      assert.equal(deployment.isValidEnv(), false)

    it "is valid if the env can be found", () ->
      deployment = new Deployment("hubot", "master", "deploy", "production", "", "")
      assert.equal(deployment.isValidEnv(), true)
