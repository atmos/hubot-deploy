VCR           = require "ys-vcr"
Path          = require "path"
Robot         = require "hubot/src/robot"
TextMessage   = require("hubot/src/message").TextMessage
Verifiers     = require(Path.join(__dirname, "..", "..", "src", "models", "verifiers"))

describe "Setting tokens and such", () ->
  user  = null
  robot = null
  adapter = null

  beforeEach (done) ->
    VCR.playback()
    process.env.HUBOT_DEPLOY_PRIVATE_MESSAGE_TOKEN_MANAGEMENT = "true"
    process.env.HUBOT_DEPLOY_FERNET_SECRETS or= "HSfTG4uWzw9whtlLEmNAzscHh96eHUFt3McvoWBXmHk="
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

  it "tells you when your provided GitHub token is invalid", (done) ->
    VCR.play "/user-invalid-auth"
    adapter.on "send", (envelope, strings) ->
      assert.match strings[0], /Your GitHub token is invalid/
      done()
    adapter.receive(new TextMessage(user, "Hubot deploy-token:set:github 123456789"))

  it "tells you when your provided GitHub token is valid", (done) ->
    VCR.play "/user-valid"
    expectedResponse = /Your GitHub token is valid. I stored it for future use./
    adapter.on "send", (envelope, strings) ->
      assert.match strings[0], expectedResponse
      assert robot.vault.forUser(user).get(Verifiers.VaultKey)
      assert.equal robot.vault.forUser(user).get(Verifiers.VaultKey), "123456789"
      done()
    adapter.receive(new TextMessage(user, "Hubot deploy-token:set:github 123456789"))

  it "tells you when your stored GitHub token is invalid", (done) ->
    VCR.play "/user-invalid-auth"
    robot.vault.forUser(user).set(Verifiers.VaultKey, "123456789")
    adapter.on "send", (envelope, strings) ->
      assert.match strings[0], /Your GitHub token is invalid, verify that it has \'repo\' scope./
      done()
    adapter.receive(new TextMessage(user, "Hubot deploy-token:verify:github"))

  it "tells you when your stored GitHub token is valid", (done) ->
    VCR.play "/user-valid"
    robot.vault.forUser(user).set(Verifiers.VaultKey, "123456789")
    adapter.on "send", (envelope, strings) ->
      assert.match strings[0], /Your GitHub token is valid on api.github.com./
      done()
    adapter.receive(new TextMessage(user, "Hubot deploy-token:verify:github"))
