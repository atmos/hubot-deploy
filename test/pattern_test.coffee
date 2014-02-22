DeployPattern = require("#{process.cwd()}/src/patterns").DeployPattern

describe "Patterns", () ->
  describe "DeployPattern", () ->
    it "rejects things that don't start with deploy", () ->
      assert !"ping".match(DeployPattern)
      assert !"image me pugs".match(DeployPattern)

    it "handles simple deployment", () ->
      matches = "deploy hubot".match(DeployPattern)
      assert.equal "deploy",  matches[1], "incorrect task"
      assert.equal "hubot",   matches[3], "incorrect app name"
      assert.equal undefined, matches[4], "incorrect branch"
      assert.equal undefined, matches[5], "incorrect environment"
      assert.equal undefined, matches[6], "incorrect host specification"

    it "handles ! operations", () ->
      matches = "deploy! hubot".match(DeployPattern)
      assert.equal "deploy",  matches[1], "incorrect task"
      assert.equal "!",       matches[2], "incorrect task"
      assert.equal "hubot",   matches[3], "incorrect app name"
      assert.equal undefined, matches[4], "incorrect branch"
      assert.equal undefined, matches[5], "incorrect environment"
      assert.equal undefined, matches[6], "incorrect host specification"

    it "handles custom tasks", () ->
      matches = "deploy:migrate hubot".match(DeployPattern)
      assert.equal "deploy:migrate", matches[1], "incorrect task"
      assert.equal "hubot",          matches[3], "incorrect app name"
      assert.equal undefined,        matches[4], "incorrect branch"
      assert.equal undefined,        matches[5], "incorrect environment"
      assert.equal undefined,        matches[6], "incorrect host specification"

    it "handles deploying branches", () ->
      matches = "deploy hubot/mybranch to production".match(DeployPattern)
      assert.equal "deploy",      matches[1], "incorrect task"
      assert.equal "hubot",       matches[3], "incorrect app name"
      assert.equal "mybranch",    matches[4], "incorrect branch name"
      assert.equal "production",  matches[5], "incorrect environment name"
      assert.equal undefined,     matches[6], "incorrect branch name"

    it "handles deploying to environments", () ->
      matches = "deploy hubot to production".match(DeployPattern)
      assert.equal "deploy",      matches[1], "incorrect task"
      assert.equal "hubot",       matches[3], "incorrect app name"
      assert.equal undefined,     matches[4], "incorrect branch name"
      assert.equal "production",  matches[5], "incorrect environment name"
      assert.equal undefined,     matches[6], "incorrect branch name"

    it "handles environments with hosts", () ->
      matches = "deploy hubot to production/fe".match(DeployPattern)
      assert.equal "deploy",      matches[1], "incorrect task"
      assert.equal "hubot",       matches[3], "incorrect app name"
      assert.equal undefined,     matches[4], "incorrect branch name"
      assert.equal "production",  matches[5], "incorrect environment name"
      assert.equal "fe",          matches[6], "incorrect branch name"
