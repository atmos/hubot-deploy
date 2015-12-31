Fs            = require "fs"
VCR           = require "ys-vcr"
Path          = require('path')
Robot         = require "hubot/src/robot"
TextMessage   = require("hubot/src/message").TextMessage
GitHubEvents  = require(Path.join(__dirname, "..", "..", "src", "github", "webhooks"))
Deployment    = GitHubEvents.Deployment

Handler = require(Path.join(__dirname, "..", "..", "src", "models", "handler"))

describe "Deployment Handlers", () ->
  user = null
  robot = null
  adapter = null
  deployment = null

  beforeEach (done) ->
    VCR.playback()
    process.env.HUBOT_DEPLOY_FERNET_SECRETS or= "HSfTG4uWzw9whtlLEmNAzscHh96eHUFt3McvoWBXmHk="
    process.env.HUBOT_DEPLOY_EMIT_GITHUB_DEPLOYMENTS = true
    robot = new Robot(null, "mock-adapter", true, "hubot")

    robot.adapter.on "connected", () ->
      require("../../index")(robot)

      userInfo =
        name: "atmos",
        room: "#my-room"

      user    = robot.brain.userForId "1", userInfo
      adapter = robot.adapter

      done()

    robot.run()

  afterEach () ->
    delete(process.env.HUBOT_DEPLOY_DEFAULT_ENVIRONMENT)
    VCR.stop()
    robot.server.close()
    robot.shutdown()

  deploymentFixtureFor = (fixtureName) ->
    fixtureData = Path.join __dirname, "..", "..", "test", "fixtures", "deployments", "#{fixtureName}.json"
    JSON.parse(Fs.readFileSync(fixtureData))

  it "only responds to the currently running bot name", (done) ->
    fixturePayload = deploymentFixtureFor "production"
    fixturePayload.deployment.payload.robotName = "evilbot"
    deployment = new Deployment "uuid", fixturePayload

    handler = new Handler.Handler robot, deployment
    handler.run (err, provider) ->
      assert.equal err.message, "Received request for unintended robot evilbot."
      done()

  it "ignores deployments that have no notify attrs in their payload", (done) ->
    fixturePayload = deploymentFixtureFor "production"
    delete fixturePayload.deployment.payload.notify
    deployment = new Deployment "uuid", fixturePayload

    handler = new Handler.Handler robot, deployment
    handler.run (err, provider) ->
      assert.equal err.message, "Not deploying atmos/my-robot/heroku to production. Not chat initiated."
      done()
#
#  it "blows up", (done) ->
#    fixturePayload = deploymentFixtureFor "production"
#    deployment = new Deployment "uuid", fixturePayload
#
#    handler = new Handler.Handler robot, deployment
#    handler.run (err, provider) ->
#      throw err if err
#      console.log err
#      switch provider
#        when "heroku" then @heroku()
#        else
#          throw new Error "Unknown provider: #{provider}"
#      done()
