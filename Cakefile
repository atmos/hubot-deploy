# Cakefile

{exec} = require "child_process"

REPORTER = "min"

task "test", "run tests", ->
  exec "NODE_ENV=test ./node_modules/.bin/mocha test/**/*_test.coffee test/**/**/*_test.coffee test/**/**/**/*_test.coffee", (err, output) ->
    console.log output
    throw err if err
