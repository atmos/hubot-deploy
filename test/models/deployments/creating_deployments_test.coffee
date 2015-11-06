VCR  = require "ys-vcr"
Path = require "path"

srcDir = Path.join(__dirname, "..", "..", "..", "src")

Version    = require(Path.join(srcDir, "version")).Version
Deployment = require(Path.join(srcDir, "models", "deployment")).Deployment

describe "Deployments", () ->
  beforeEach () ->
    VCR.playback()
  afterEach () ->
    VCR.stop()

  describe "#rawPost", () ->
    it "failed deployment due to bad authentication", (done) ->
      VCR.play '/repos-atmos-hubot-deploy-deployment-production-create-bad-auth'
      deployment = new Deployment("hubot-deploy", "master", "deploy", "production", "", "")
      deployment.rawPost (err, status, body, headers, message) ->
        unless err
          throw new Error("Should've thrown bad auth")

        assert.equal "Bad credentials", err.message
        assert.equal 401, err.statusCode
        done()

    it "successfully created deployment", (done) ->
      VCR.play '/repos-atmos-hubot-deploy-deployment-production-create-success'
      deployment = new Deployment("hubot-deploy", "master", "deploy", "production", "", "")
      deployment.rawPost (err, status, body, headers, message) ->
        throw err if err
        assert.equal 201, status
        assert.equal "deploy", body.deployment.task
        assert.equal "production", body.deployment.environment
        done()
