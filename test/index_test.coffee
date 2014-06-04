Path  = require("path")
Robot = require("hubot").Robot

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
    robot.adapter.receiveText("hubot deploy")
    expected = ""
    assert.equal expected, robot.adapter.history

  it "displays the version", () ->
    robot.adapter.receiveText("hubot deploy:version")
    expected = "hubot-deploy v0.6.7/hubot v2.7.5/node v0.10.21"
    assert.equal expected, robot.adapter.history

  it "displays deployment environment help", () ->
    robot.adapter.receiveText("hubot where can i deploy github")
    result = robot.adapter.history
    assert.match result, /|Environments for github/i
    assert.match result, /|production/i
    assert.match result, /|staging/i

    robot.adapter.history = [ ]
    robot.adapter.receiveText("hubot where can i deploy hubot?")
    result = robot.adapter.history
    assert.match result, /|Environments for hubot/i
    assert.match result, /|production/i

  it "deploys hubot"
