Fs   = require "fs"
Path = require "path"

DeploymentStatus = require(Path.join(__dirname, "..", "..", "src", "models", "deployment_status")).DeploymentStatus

describe "DeploymentStatus fixtures", () ->
  deploymentStatusFor = (fixtureName) ->
    fixtureData = Path.join __dirname, "..", "fixtures", "deployment_statuses", "#{fixtureName}.json"
    fixturePayload = JSON.parse(Fs.readFileSync(fixtureData))
    status = new DeploymentStatus "uuid", fixturePayload

  describe "pending", () ->
    it "knows the statue and repo", () ->
      status = deploymentStatusFor "pending"
      assert.equal status.status, "pending"
      assert.equal status.repoName, "atmos/my-robot"

  describe "failure", () ->
    it "knows the statue and repo", () ->
      status = deploymentStatusFor "failure"
      assert.equal status.status, "failure"
      assert.equal status.repoName, "atmos/my-robot"

  describe "success", () ->
    it "knows the statue and repo", () ->
      status = deploymentStatusFor "success"
      assert.equal status.status, "success"
      assert.equal status.repoName, "atmos/my-robot"
