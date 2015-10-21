Path        = require("path")
Robot       = require("hubot/src/robot")
TextMessage = require("hubot/src/message").TextMessage

describe "Deployment Status HTTP Callbacks", () ->
  user  = null
  robot = null
  adapter = null

  beforeEach (done) ->
    robot = new Robot(null, "mock-adapter", false, "Eddie")

    robot.adapter.on "connected", () ->
      process.env.HUBOT_AUTH_ADMIN = "1"
      #robot.loadFile(
      #    Path.resolve(
      #        Path.join("node_modules/hubot/src/scripts")
      #    ),
      #    "auth.coffee"
      #)

      require("../../index")(robot)

      userInfo =
        name: "atmos",
        room: "#zf-promo"

      user    = robot.brain.userForId "1", userInfo
      adapter = robot.adapter

      done()

    robot.run()

  afterEach () ->
    robot.shutdown()

  it "responds when greeted", (done) ->
    adapter.on "reply", (envelope, strings) ->
      assert.match strings[0], /Why hello there/
      done()

    message = new TextMessage(user, "Computer!")
    adapter.receive(message)
