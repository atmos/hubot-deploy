Path  = require("path")
Robot = require("hubot").Robot

describe "The Hubot Script", () ->
  it "can be successfully loaded", () ->
    shellAdapter = Path.join(__dirname, "..", "node_modules", "hubot", "src", "adapters")

    robot = new Robot shellAdapter, "shell", false, "hubot"
    robot.loadFile Path.join(__dirname, "..", "src"), "script"
