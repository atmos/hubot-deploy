Path   = require("path")
Helper = require('hubot-test-helper-pull-request-1')

pkg = require Path.join __dirname, "..", 'package.json'
pkgVersion = pkg.version

room   = null
helper = new Helper(Path.join(__dirname, "..", "src", "script.coffee"))

describe "The Hubot Script", () ->
  beforeEach () ->
    room = helper.createRoom()

  it "displays the version", () ->
    room.user.say 'atmos', 'hubot deploy:version'
    expected = "hubot-deploy v#{pkgVersion}/hubot v2.7.5/node #{process.version}"
    assert.deepEqual ['atmos', 'hubot deploy:version'], room.messages[0]
    assert.deepEqual ['hubot', expected], room.messages[1]

  it "displays deployment environment help", () ->
    room.user.say 'atmos', 'hubot where can i deploy github'

    result = room.messages[1][1]
    assert.match result, /Environments for github/im
    assert.match result, /production/im
    assert.match result, /staging/im

    room.user.say 'atmos', 'hubot where can i deploy hubot'
    result = room.messages[3][1]

    assert.match result, /Environments for hubot/im
    assert.match result, /production/im
    assert.notMatch result, /staging/im

  it "displays recent deployments", () ->
    room.user.say 'atmos', 'hubot deploys hubot'
    assert.equal 1, room.messages.length
    # TODO stub out the response or something?

  it "displays recent staging deployments", () ->
    room.user.say 'atmos', 'hubot deploys hubot to staging'
    assert.equal 1, room.messages.length
    # TODO stub out the response or something?

  it "deploys hubot"
