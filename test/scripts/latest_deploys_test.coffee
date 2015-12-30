VCR           = require "ys-vcr"
Path          = require "path"
Robot         = require "hubot/src/robot"
TextMessage   = require("hubot/src/message").TextMessage
Verifiers     = require(Path.join(__dirname, "..", "..", "src", "models", "verifiers"))

describe "Latest deployments", () ->
  user  = null
  robot = null
  adapter = null

  beforeEach (done) ->
    VCR.playback()
    process.env.HUBOT_FERNET_SECRETS or= "HSfTG4uWzw9whtlLEmNAzscHh96eHUFt3McvoWBXmHk="
    robot = new Robot(null, "mock-adapter", true, "Hubot")

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
    VCR.stop()
    robot.server.close()
    robot.shutdown()

  it "tells you the latest production deploys", (done) ->
    VCR.play '/github-deployments-latest-production-success'
    robot.on "hubot_deploy_recent_deployments", (msg, deployment, deployments, formatter) ->
      assert.equal "hubot-deploy", deployment.name
      assert.equal "production", deployment.env
      assert.equal 2, deployments.length
      done()

    adapter.receive(new TextMessage(user, "Hubot deploys hubot-deploy in production"))

  it "tells you the latest staging deploys", (done) ->
    VCR.play '/github-deployments-latest-staging-success'
    robot.on "hubot_deploy_recent_deployments", (msg, deployment, deployments, formatter) ->
      assert.equal "hubot-deploy", deployment.name
      assert.equal "staging", deployment.env
      assert.equal 2, deployments.length
      done()

    adapter.receive(new TextMessage(user, "Hubot deploys hubot-deploy in staging"))
