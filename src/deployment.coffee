Fs      = require "fs"
Path    = require "path"
Version = require(Path.join(__dirname, "version")).Version
###########################################################################

api = require("octonode").client(process.env.HUBOT_GITHUB_TOKEN or 'unknown')
api.requestDefaults.headers['Accept'] = 'application/vnd.github.cannonball-preview+json'
###########################################################################

class Deployment
  @APPS_FILE = process.env['HUBOT_DEPLOY_APPS_JSON'] or "apps.json"

  constructor: (@name, @ref, @task, @env, @force, @hosts) ->
    @room             = 'unknown'
    @user             = 'unknown'
    @adapter          = 'unknown'
    @autoMerge        = true
    @environments     = [ "production" ]
    @requiredContexts = null

    applications = JSON.parse(Fs.readFileSync(@constructor.APPS_FILE).toString())

    @application = applications[@name]

    if @application?
      @repository = @application['repository']

      @configureAutoMerge()
      @configureRequiredContexts()
      @configureEnvironments()

  isValidApp: ->
    @application?

  isValidEnv: ->
    @env in @environments

  requestBody: ->
    ref: @ref
    force: @force
    auto_merge: @autoMerge
    environment: @env
    required_contexts: @requiredContexts
    description: "Deploying from hubot-deploy-v#{Version}"
    payload:
      name: @name
      task: @task
      hosts: @hosts
      notify:
        room: @room
        user: @user
        adapter: @adapter
      config: @application

  latest: (cb) ->
    path       = "repos/#{@repository}/deployments"
    params     =
      environment: @env

    api.get path, params, (err, status, body, headers) ->
      if err
        body = err
        console.log err['message'] unless process.env.NODE_ENV == 'test'

      cb(body)

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

        if bodyMessage.match(/Conflict: Commit status checks/)
          errors = data['errors'][0]
          commitContexts = errors.contexts

          namedContexts  = (context.context for context in commitContexts)
          failedContexts = (context.context for context in commitContexts when context.state isnt 'success')
          if requiredContexts?
            failedContexts.push(context) for context in requiredContexts when context not in namedContexts

          bodyMessage = "Unmet required commit status contexts for #{name}: #{failedContexts.join(',')} failed."

        if bodyMessage == "Not Found"
          message = "Unable to create deployments for #{repository}. Check your scopes for this token."
        else
          message = bodyMessage

      cb(message)

  # Private Methods
  configureEnvironments: ->
    if @application['environments']?
      @environments = @application['environments']

    @env = 'staging' if @env == 'stg'
    @env = 'production' if @env == 'prod'

  configureAutoMerge: ->
    if @application['auto_merge']?
      @autoMerge = @application['auto_merge']
    if @force
      @autoMerge = false

  configureRequiredContexts: ->
    if @application['required_contexts']?
      @requiredContexts = @application['required_contexts']
    if @force
      @requiredContexts = [ ]

exports.Deployment = Deployment
