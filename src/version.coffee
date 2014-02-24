Path = require "path"

pkg = require Path.join __dirname, "..", 'package.json'

exports.Version = pkg.version
