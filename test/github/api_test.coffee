Path = require('path')

GitHubApi = require(Path.join(__dirname, "..", "..", "src", "github", "api"))

describe "GitHubApi", () ->
  describe "defaults", () ->
    apiConfig = new GitHubApi.Api("xxx", null)

    it "fetches the GitHub API token provided", () ->
      assert.equal "xxx", apiConfig.token
    it "defaults to api.github.com", () ->
      assert.equal "api.github.com", apiConfig.hostname
    it "handles no path suffix requests", () ->
      assert.equal "/", apiConfig.path("")
    it "handles path suffixes", () ->
      assert.equal "/repos/atmos/heaven/deployments", apiConfig.path("repos/atmos/heaven/deployments")

  describe "custom application and enterprise url", () ->
    config =
      application =
        github_api:   "https://enterprise.mycompany.com/api/v3/"
        github_token: "yyy"
    apiConfig = new GitHubApi.Api("xxx", application)

    it "fetches the custom GitHub API token", () ->
      assert.equal "yyy", apiConfig.token
    it "uses the application api_url field for hostname", () ->
      assert.equal "enterprise.mycompany.com", apiConfig.hostname
    it "handles no path suffix requests", () ->
      assert.equal "/api/v3/", apiConfig.path("")
    it "handles path suffixes", () ->
      assert.equal "/api/v3/repos/atmos/heaven/deployments", apiConfig.path("repos/atmos/heaven/deployments")

