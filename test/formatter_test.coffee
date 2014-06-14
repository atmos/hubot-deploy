Path = require('path')

Deployment = require(Path.join(__dirname, "..", "src", "deployment")).Deployment
Formatter  = require(Path.join(__dirname, "..", "src", "formatters"))

describe "Formatter", () ->
  describe "LatestFormatter", () ->
    it "displays recent deployments", () ->
      deployment = new Deployment("hubot", null, null, "production")
      deployments = require(Path.join(__dirname, "fixtures", "deployments"))
      formatter = new Formatter.LatestFormatter(deployment, deployments)

      message = formatter.message()

      assert.match message, /Recent production Deployments for hubot/im
      assert.match message, /atmos           \| master\(8efb8c88\)\s+\| (.*) 2014-06-13T20:55:21Z/
      assert.match message, /atmos           \| 8efb8c88\(auto-deploy\)\s+\| (.*) 2014-06-13T20:52:13Z/
      assert.match message, /atmos           \| master\(ffcabfea\)\s+\| (.*) 2014-06-11T22:47:34Z/

  describe "WhereFormatter", () ->
    it "displays deployment environments", () ->
      deployment = new Deployment("hubot", null, null, "production")
      deployments = require(Path.join(__dirname, "fixtures", "deployments"))
      formatter = new Formatter.WhereFormatter(deployment)

      message = formatter.message()

      assert.match message, /Environments for hubot/im
      assert.match message, /production/im
      assert.notMatch message, /staging/im
