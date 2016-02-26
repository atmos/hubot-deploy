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
    it "knows the statue and repo", (done) ->
      commits = pushFor("single")
      message = "hubot-deploy: atmos pushed 1 commits"
      assert.equal message, commits.toSimpleString()
      done()
