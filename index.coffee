Path = require 'path'

module.exports = (robot, scripts) ->
  robot.loadFile(Path.resolve(__dirname, "src", "scripts"), "http.coffee")
  robot.loadFile(Path.resolve(__dirname, "src", "scripts"), "token.coffee")
  robot.loadFile(Path.resolve(__dirname, "src", "scripts"), "deploy.coffee")
