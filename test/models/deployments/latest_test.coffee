VCR  = require "ys-vcr"
Path = require "path"

srcDir = Path.join(__dirname, "..", "..", "..", "src")

Version    = require(Path.join(srcDir, "version")).Version
Deployment = require(Path.join(srcDir, "github", "api")).Deployment

describe "Deployment#latest", () ->
  beforeEach () ->
    VCR.playback()
  afterEach () ->
    VCR.stop()

  it "gets the latest deployments from the api", (done) ->
    VCR.play '/github-deployments-latest-production-success'
    deployment = new Deployment("hubot-deploy", "master", "deploy", "production", "", "")
    deployment.latest (err, deployments) ->
      throw err if err
      assert.equal "hubot-deploy", deployment.name
      assert.equal "production", deployment.env
      assert.equal 2, deployments.length
      done()

  it "gets the latest deployments from the api", (done) ->
    VCR.play '/github-deployments-latest-staging-success'
    deployment = new Deployment("hubot-deploy", "master", "deploy", "staging", "", "")
    deployment.latest (err, deployments) ->
      throw err if err
      assert.equal "hubot-deploy", deployment.name
      assert.equal "staging", deployment.env
      assert.equal 2, deployments.length
      done()

