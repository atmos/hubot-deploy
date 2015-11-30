VCR           = require "ys-vcr"
Path          = require "path"
Robot         = require "hubot/src/robot"
TextMessage   = require("hubot/src/message").TextMessage
Verifiers     = require(Path.join(__dirname, "..", "..", "src", "models", "verifiers"))

describe "Deploying from chat", () ->
  user  = null
  robot = null
  adapter = null

  beforeEach (done) ->
    VCR.playback()
    process.env.HUBOT_FERNET_SECRETS or= "HSfTG4uWzw9whtlLEmNAzscHh96eHUFt3McvoWBXmHk="
    process.env.HUBOT_DEPLOY_EMIT_GITHUB_DEPLOYMENTS = true
    robot = new Robot(null, "mock-adapter", true, "Hubot")

    robot.adapter.on "connected", () ->
      require("hubot-vault")(robot)
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

  it "creates deployments when requested from chat", (done) ->
    VCR.play '/repos-atmos-hubot-deploy-deployment-production-create-success'
    robot.on "github_deployment", (msg, deployment) ->
      assert.equal "hubot-deploy", deployment.name
      assert.equal "production", deployment.env
      done()

    adapter.receive(new TextMessage(user, "Hubot deploy hubot-deploy"))

  it "allows for the default environment to be overridden by an env var", (done) ->
    process.env.HUBOT_DEPLOY_DEFAULT_ENVIRONMENT = "staging"
    VCR.play '/repos-atmos-hubot-deploy-deployment-staging-create-success'
    robot.on "github_deployment", (msg, deployment) ->
      assert.equal "hubot-deploy", deployment.name
      assert.equal "staging", deployment.env
      done()

    adapter.receive(new TextMessage(user, "Hubot deploy hubot-deploy"))
