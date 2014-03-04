Fs      = require "fs"
Path    = require "path"
Version = require(Path.join(__dirname, "version")).Version
###########################################################################

api = require("octonode").client(process.env.HUBOT_GITHUB_TOKEN or 'unknown')
api.requestDefaults.headers['Accept'] = 'application/vnd.github.cannonball-preview+json'
###########################################################################

class Deployment
  @APPS_FILE = "apps.json"

  constructor: (@name, @ref, @task, @env, @force, @hosts) ->
    @room     = 'unknown'
    @user     = 'unknown'
    @adapter  = 'unknown'

    applications = JSON.parse(Fs.readFileSync(@constructor.APPS_FILE).toString())

    @application = applications[@name]

    if @application?
      @repository = @application['repository']

    @normalize_environment()

  isValidApp: ->
    @application?

  isValidEnv: ->
    @env in @application['environments']

  requestBody: ->
    ref: @ref
    force: @force
    auto_merge: true
    description: "Deploying from hubot-deploy-v#{Version}"
    payload:
      task: @task
      hosts: @hosts
      branch: @ref
      notify:
        room: @room
        user: @user
        adapter: @adapter
      environment: @env
      config: @application

  post: (cb) ->
    path       = "repos/#{@repository}/deployments"
    repository = @repository

    api.post path, @requestBody(), (err, status, body, headers) ->
      data = body
      if err
        data = err
        console.log err unless process.env.NODE_ENV == 'test'

      if data['message']
        bodyMessage = data['message']

        if bodyMessage.match(/No successful commit statuses/)
          message = "I don't see a successful build for #{repository} that covers the latest \"#{@ref}\" branch."

        if bodyMessage.match(/Conflict merging ([-_\.0-9a-z]+)/)
          default_branch = data.message.match(/Conflict merging ([-_\.0-9a-z]+)/)[1]
          message = "There was a problem merging the #{default_branch} for #{repository} into #{@ref}. You'll need to merge it manually, or disable auto-merging."

        if bodyMessage.match(/Merged ([-_\.0-9a-z]+) into/)
          console.log "Successfully merged the default branch for #{deployment.repository} into #{@ref}. Normal push notifications should provide feedback."
        if bodyMessage == "Not Found"
          message = "Unable to create deployments for #{repository}. Check your scopes for this token."
        else
          message = bodyMessage

      cb(message)

  # Private Methods
  normalize_environment: ->
    @env = 'staging' if @env == 'stg'
    @env = 'production' if @env == 'prod'

  plainTextOutput: ->

exports.Deployment = Deployment
