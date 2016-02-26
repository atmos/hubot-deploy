Fs   = require "fs"
Path = require "path"

srcDir = Path.join(__dirname, "..", "..", "..", "src")

GitHubEvents     = require(Path.join(srcDir, "github", "webhooks"))

describe "GitHubEvents.Push fixtures", () ->
  pushFor = (fixtureName) ->
    fixtureData = Path.join __dirname, "..", "..", "fixtures", "pushes", "#{fixtureName}.json"
    fixturePayload = JSON.parse(Fs.readFileSync(fixtureData))
    push = new GitHubEvents.Push "uuid", fixturePayload

  describe "single commit", () ->
    it "knows the state and repo", (done) ->
      push = pushFor("single")
      message = "hubot-deploy: atmos pushed a commit"
      assert.equal message, push.toSimpleString()
      summaryMessage = "[hubot-deploy] atmos pushed 1 new commit to changes"
      assert.equal summaryMessage, push.summaryMessage()
      summaryUrl = "https://github.com/atmos/hubot-deploy/commit/0d1a26e67d8f5eaf1f6ba5c57fc3c7d91ac0fd1c"
      assert.equal summaryUrl, push.summaryUrl()
      done()

  describe "multiple commits", () ->
    it "knows the state and repo", (done) ->
      push = pushFor("multiple")
      message = "hubot-deploy: atmos pushed 3 commits"
      assert.equal message, push.toSimpleString()
      summaryMessage = "[hubot-deploy] atmos pushed 3 new commits to master"
      assert.equal summaryMessage, push.summaryMessage()
      summaryUrl = "http://github.com/atmos/hubot-deploy/compare/4c8124f...a47fd41"
      assert.equal summaryUrl, push.summaryUrl()
      done()
