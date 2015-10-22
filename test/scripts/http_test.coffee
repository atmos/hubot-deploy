Path        = require "path"
Robot       = require "hubot/src/robot"
TextMessage = require("hubot/src/message").TextMessage

describe "Deployment Status HTTP Callbacks", () ->
  user  = null
  robot = null
  adapter = null

  beforeEach (done) ->
    robot = new Robot(null, "mock-adapter", true, "Hubot")

    robot.adapter.on "connected", () ->
      process.env.HUBOT_DEPLOY_RANDOM_REPLY = "sup-dude"

      require("../../index")(robot)

      userInfo =
        name: "atmos",
        room: "#zf-promo"

      user    = robot.brain.userForId "1", userInfo
      adapter = robot.adapter

      done()

    robot.run()

  afterEach () ->
    robot.server.close()
    robot.shutdown()

  it "responds when greeted", (done) ->
    adapter.on "reply", (envelope, strings) ->
      assert.equal strings[0], "Why hello there! (ticker tape, ticker tape)"
      done()

    message = new TextMessage(user, process.env.HUBOT_DEPLOY_RANDOM_REPLY)
    adapter.receive(message)
