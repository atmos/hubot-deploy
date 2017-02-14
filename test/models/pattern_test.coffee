Path = require('path')

Patterns = require(Path.join(__dirname, "..", "..", "src", "models", "patterns"))

DeployPattern  = Patterns.DeployPattern
DeploysPattern = Patterns.DeploysPattern

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

    it "handles deploying to environments with aws config", () ->
      matches = "deploy hubot to production on t2.small".match(DeployPattern)
      assert.equal "deploy",      matches[1], "incorrect task"
      assert.equal "hubot",       matches[3], "incorrect app name"
      assert.equal undefined,     matches[4], "incorrect branch name"
      assert.equal "production",  matches[5], "incorrect environment name"
      assert.equal undefined,     matches[6], "incorrect branch name"
      assert.equal undefined,     matches[7], "incorrect authenticator token"
      assert.equal "t2.small",    matches[8], "incorrect aws config"

    it "handles deploying to environments with aws config large", () ->
      matches = "deploy hubot to production on m3.large".match(DeployPattern)
      assert.equal "deploy",      matches[1], "incorrect task"
      assert.equal "hubot",       matches[3], "incorrect app name"
      assert.equal undefined,     matches[4], "incorrect branch name"
      assert.equal "production",  matches[5], "incorrect environment name"
      assert.equal undefined,     matches[6], "incorrect branch name"
      assert.equal undefined,     matches[7], "incorrect authenticator token"
      assert.equal "m3.large",    matches[8], "incorrect aws config"

    it "handles environments with hosts", () ->
      matches = "deploy hubot to production/fe".match(DeployPattern)
      assert.equal "deploy",      matches[1], "incorrect task"
      assert.equal "hubot",       matches[3], "incorrect app name"
      assert.equal undefined,     matches[4], "incorrect branch name"
      assert.equal "production",  matches[5], "incorrect environment name"
      assert.equal "fe",          matches[6], "incorrect host name"
      assert.equal undefined,     matches[7], "incorrect yubikey pattern"

    it "handles branch deploys with slashes and environments with hosts", () ->
      matches = "deploy hubot/atmos/branch to production/fe".match(DeployPattern)
      assert.equal "deploy",       matches[1], "incorrect task"
      assert.equal "hubot",        matches[3], "incorrect app name"
      assert.equal "atmos/branch", matches[4], "incorrect branch name"
      assert.equal "production",   matches[5], "incorrect environment name"
      assert.equal "fe",           matches[6], "incorrect host name"
      assert.equal undefined,      matches[7], "incorrect yubikey pattern"

    it "handles branch deploys with slashes and environments with hosts plus yubikeys", () ->
      matches = "deploy hubot/atmos/branch to production/fe ccccccdlnncbtuevhdbctrccukdciveuclhbkvehbeve".match(DeployPattern)
      assert.equal "deploy",       matches[1], "incorrect task"
      assert.equal "hubot",        matches[3], "incorrect app name"
      assert.equal "atmos/branch", matches[4], "incorrect branch name"
      assert.equal "production",   matches[5], "incorrect environment name"
      assert.equal "fe",           matches[6], "incorrect host name"
      assert.equal "ccccccdlnncbtuevhdbctrccukdciveuclhbkvehbeve", matches[7], "incorrect yubikey pattern"

    it "handles branch deploys with slashes and environments with hosts plus 2fa keys", () ->
      matches = "deploy hubot/atmos/branch to production/fe 123456".match(DeployPattern)
      assert.equal "deploy",       matches[1], "incorrect task"
      assert.equal "hubot",        matches[3], "incorrect app name"
      assert.equal "atmos/branch", matches[4], "incorrect branch name"
      assert.equal "production",   matches[5], "incorrect environment name"
      assert.equal "fe",           matches[6], "incorrect host name"
      assert.equal "123456",       matches[7], "incorrect authenticator token"

    it "doesn't match on malformed yubikeys", () ->
      matches = "deploy hubot/atmos/branch to production/fe burgers".match(DeployPattern)
      assert.equal null, matches

    it "does not match typos", () ->
      matches = "deploy hubot/branch tos taging".match(DeployPattern)
      assert.equal matches, null

  describe "DeploysPattern", () ->
    it "rejects things that don't start with deploy", () ->
      assert !"ping".match(DeploysPattern)
      assert !"image me pugs".match(DeploysPattern)

    it "handles simple deploys listing", () ->
      matches = "deploys hubot".match(DeploysPattern)
      assert.equal "deploys", matches[1], "incorrect task"
      assert.equal "hubot",   matches[2], "incorrect app name"
      assert.equal undefined, matches[3], "incorrect branch"
      assert.equal undefined, matches[4], "incorrect environment"

    it "handles deploys with environments", () ->
      matches = "deploys hubot in production".match(DeploysPattern)
      assert.equal "deploys",     matches[1], "incorrect task"
      assert.equal "hubot",       matches[2], "incorrect app name"
      assert.equal undefined,     matches[3], "incorrect branch name"
      assert.equal "production",  matches[4], "incorrect environment name"

    it "handles deploys with branches", () ->
      matches = "deploys hubot/mybranch to production".match(DeploysPattern)
      assert.equal "deploys",     matches[1], "incorrect task"
      assert.equal "hubot",       matches[2], "incorrect app name"
      assert.equal "mybranch",    matches[3], "incorrect branch name"
      assert.equal "production",  matches[4], "incorrect environment name"
