Path  = require("path")
Robot = require("hubot").Robot

User    = require("hubot/src/user")
Message = require("hubot/src/message").TextMessage

testAdapter = Path.join(__dirname, "adapters")

describe "The Hubot Script", () ->
  robot = null
  beforeEach () ->
    robot = new Robot testAdapter, "test", false, "hubot"
    robot.loadFile  Path.join(__dirname, "..", "src"), "script.coffee"
    robot.run()

  afterEach () ->
    robot.shutdown()

  it "displays deploy help", () ->
    robot.adapter.sendToRobot("hubot deploy")
    expected = ""
    assert.equal expected, robot.adapter.history

  it "displays the version", () ->
    robot.adapter.sendToRobot("hubot deploy:version")
    expected = "hubot-deploy v0.7.0/hubot v2.7.5/node v0.10.21"
    assert.equal expected, robot.adapter.history

  it "displays deployment environment help", () ->
    robot.adapter.sendToRobot("hubot where can i deploy github")
    result = robot.adapter.history
    assert.match result, /|production/i
    assert.match result, /|staging/i

  it "deploys hubot" #, () ->
    #robot.adapter.sendToRobot("hubot deploy hubot")
    #expected = ""
    #assert.equal expected, robot.adapter.history
