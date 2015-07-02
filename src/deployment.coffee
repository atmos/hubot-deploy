Fs        = require "fs"
Url       = require "url"
Path      = require "path"
Version   = require(Path.join(__dirname, "version")).Version
Octonode  = require("octonode")
ApiConfig = require(Path.join(__dirname, "api_config")).ApiConfig
###########################################################################

class Deployment
  @APPS_FILE = process.env['HUBOT_DEPLOY_APPS_JSON'] or "apps.json"

  constructor: (@name, @ref, @task, @env, @force, @hosts) ->
    @room             = 'unknown'
    @user             = 'unknown'
    @adapter          = 'unknown'
    @thread_id        = 'unknown'
    @message_id       = 'unknown'
    @autoMerge        = true
    @environments     = [ "production" ]
    @requiredContexts = null
    @caFile           = Fs.readFileSync(process.env['HUBOT_CA_FILE']) if process.env['HUBOT_CA_FILE']

    try
      applications = JSON.parse(Fs.readFileSync(@constructor.APPS_FILE).toString())
    catch
      throw new Error("Unable to parse your apps.json file in hubot-deploy")

    @application = applications[@name]

    if @application?
      @repository = @application['repository']

      @configureAutoMerge()
      @configureRequiredContexts()
      @configureEnvironments()

      @allowedRooms = @application['allowed_rooms']

  isValidApp: ->
    @application?

  isValidEnv: ->
    @env in @environments

  isAllowedRoom: (room) ->
    !@allowedRooms? || room in @allowedRooms

  # Retrieves a fully constructed request body and removes sensitive config info
  # A hash to be converted into the body of the post to create a GitHub Deployment
  requestBody: ->
    body = JSON.parse(JSON.stringify(@unfilteredRequestBody()))
    delete(body.payload.config.github_api)
    delete(body.payload.config.github_token)
    body

  unfilteredRequestBody: ->
    ref: @ref
    task: @task
    force: @force
    auto_merge: @autoMerge
    environment: @env
    required_contexts: @requiredContexts
    description: "Deploying from hubot-deploy-v#{Version}"
    payload:
      name: @name
      hosts: @hosts
      notify:
        room: @room
        user: @user
        adapter: @adapter
        message_id: @message_id
        thread_id: @thread_id
      config: @application

  setUserToken: (token) ->
    @userToken = token.trim()

  apiConfig: ->
    new ApiConfig(@userToken, @application)

  api: ->
    api = Octonode.client(@apiConfig().token, { hostname: @apiConfig().hostname })
    api.requestDefaults.headers['Accept'] = 'application/vnd.github.cannonball-preview+json'
    api.requestDefaults.agentOptions = { ca: @caFile } if @caFile
    api

  latest: (cb) ->
    path       = @apiConfig().path("repos/#{@repository}/deployments")
    params     =
      environment: @env

    @api().get path, params, (err, status, body, headers) ->
      if err
        body = err
        console.log err['message'] unless process.env.NODE_ENV == 'test'

      cb(body)

  post: (cb) ->
    path       = @apiConfig().path("repos/#{@repository}/deployments")
    name       = @name
    repository = @repository
    env        = @env
    ref        = @ref

    @api().post path, @requestBody(), (err, status, body, headers) ->
      data = body

      success = status == 201

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

      if success and not message
        message = "Deployment of #{name}/#{ref} to #{env} created"

      cb message

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
