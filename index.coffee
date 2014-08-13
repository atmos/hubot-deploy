Path = require 'path'

module.exports = (robot, scripts) ->
  robot.loadFile(Path.resolve(__dirname, "src"), "script.coffee")
  robot.loadFile(Path.resolve(__dirname, "src", "scripts"), "token.coffee")
