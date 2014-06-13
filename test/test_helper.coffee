global.assert = require("chai").assert
require("chai").Assertion.includeStack = true
process.env.HUBOT_DEPLOY_APPS_JSON = require("path").join(__dirname, "test_apps.json")
