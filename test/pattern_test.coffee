DeployPattern = require("#{process.cwd()}/src/patterns").DeployPattern

describe "Patterns", () ->
  describe "DeployPattern", () ->
    it "rejects things that don't start with deploy", () ->
      assert !"ping".match(DeployPattern)
      assert !"image me pugs".match(DeployPattern)
    it "works for simple cases", () ->
      assert "deploy hubot".match(DeployPattern)
      assert "deploy hubot to production".match(DeployPattern)
